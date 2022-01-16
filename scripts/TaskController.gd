extends Node

var current_compound = null
var current_step_type = null
var current_volume = 0
var steps = []

var file_to_load = null
var step_nodes = []

var task_to_solve = null

onready var step_entry_scene = preload("res://scenes/GUI/StepEntry.tscn")
onready var answer_entry_scene = preload("res://scenes/GUI/TaskAnswerEntry.tscn")
onready var answer_entry_list = $AnswerPanel/VBoxContainer
onready var task_label = $AnswerPanel/VBoxContainer/TaskLabel
onready var answer_panel = $AnswerPanel

signal task_loaded(steps)
signal step_entries_loaded(entries)
signal attempt_answer()
signal replay()
signal answer_declined()

func _ready():
	pass


func _on_MainVial_blob_poured_in(blob):
	if not current_compound:
		current_compound = blob.compound
	if not current_compound == blob.compound or not current_step_type == GHelper.STEP_TYPES.POUR_IN:
		if not current_step_type == null:
			save_step()
		current_compound = blob.compound
		current_step_type = GHelper.STEP_TYPES.POUR_IN
		current_volume = blob.volume
	else:
		current_volume += blob.volume
 

func _on_MainVial_blob_poured_out(blob):
	if not current_step_type == GHelper.STEP_TYPES.POUR_OUT:
		save_step()
		current_step_type = GHelper.STEP_TYPES.POUR_OUT
		current_volume = blob.volume
	else:
		current_volume += blob.volume


func _on_MainVial_mix():
	if current_step_type == GHelper.STEP_TYPES.MIX or current_volume == 0:
		return
	else:
		save_step()
		current_step_type = GHelper.STEP_TYPES.MIX


func save_step():
	var step = {
		'step_type': current_step_type,
	}
	if current_step_type == GHelper.STEP_TYPES.POUR_OUT:
		step['volume'] = current_volume
	elif current_step_type == GHelper.STEP_TYPES.POUR_IN:
		step['volume'] = current_volume
		step['compound'] = current_compound
	steps.append(step)




func _on_Chemixer_task_ready(mixture_contents, mixture_volume, task_file_name):
	save_step()
	var content_percentage = {}
	for compound in mixture_contents.keys():
		content_percentage[compound] = stepify(float(mixture_contents[compound]) / mixture_volume * 100, 0.001)
	
	var task = {
		'steps': steps,
		'mixture_stats': {
			'content_percentage': content_percentage,
			'total_volume': mixture_volume
		}
	}
	save_task(task, task_file_name)


func save_task(task, task_file_name):
	var file = File.new()
#	var task_name = 'task' + str(task['mixture_stats']['total_volume'])
	var file_name = 'user://tasks/' + task_file_name + '.json'
	
	file.open(file_name, File.WRITE)
	file.store_line(to_json(task))
	file.close()


func _on_TaskListButton_pressed():
	var files = []
	var dir = Directory.new()
	dir.open('user://tasks')
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	print(files)
	$Label.text = str(files)


func _on_TaskSelector_selected_task_changed(file_path):
	file_to_load = file_path


func _on_SolveTaskButton_pressed():
	var file = File.new()
	file.open(file_to_load, File.READ)
	var task = parse_json(file.get_as_text())
	file.close()
	emit_signal('task_loaded', task['steps'])
	
	task_to_solve = task
	
	for step in task['steps']:
		var step_entry = step_entry_scene.instance()
		step_entry.init_step(step)
		step_nodes.append(step_entry)
	
	emit_signal('step_entries_loaded', step_nodes)


func _on_AnimationController_animation_completed():
	prepare_answer_entries()
	answer_panel.show()


func prepare_answer_entries():
	var percentages = task_to_solve['mixture_stats']['content_percentage']
	for compound in percentages.keys():
		var answer_entry = answer_entry_scene.instance()
		answer_entry.init_answer(compound, percentages[compound])
		connect('attempt_answer', answer_entry, 'check_answer')
		answer_entry_list.add_child_below_node(task_label, answer_entry)


func _on_CheckButton_pressed():
	emit_signal("attempt_answer")


func _on_ReplayButton_pressed():
	answer_panel.hide()
	for entry in get_tree().get_nodes_in_group('answer_entries'):
		entry.queue_free()
	emit_signal('replay')
	emit_signal("task_loaded", task_to_solve['steps'])


func _on_MenuButton_pressed():
	answer_panel.hide()
	emit_signal('answer_declined')
