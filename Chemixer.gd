extends Node2D

onready var blob_scene = preload("res://scenes/2D/Blob.tscn")
onready var small_vial_scene = preload("res://scenes/2D/SmallVial.tscn")
onready var compound_entry_scene = preload("res://scenes/GUI/MaterialEntry.tscn")

onready var main_menu = $MainMenu
onready var main_vial = $MainVial
onready var stirring_rod = $StirringRod
onready var gui = $GUI
onready var stats_gui = $GUI/CurrentStats
onready var step_entries_list = $GUI/StepList/VBoxContainer
onready var step_list_container = $GUI/StepList
onready var control_panel = $GUI/ControlPanel
onready var tamp = $TAMP
onready var save_dialog = $GUI/SaveDialog
onready var spawn_blob_button = $GUI/SpawnBlobButton
onready var save_task_button = $GUI/ControlPanel/HBoxContainer/SaveTaskButton

var current_compound = "H20"
var current_color = GHelper.compounds[current_compound]['color']
var mixture_volume = 0
var mixture_contents = {}
var MAX_SMALL_VIAL_COUNT = 3

var state

signal update_entry(compound, volume, percent)
signal mixture_color_changed(color)
signal task_ready(mixture_contents, mixture_volume, task_file_name)
signal toggle_input(disabled)
signal animation_vial_spawned(vial)
signal reload_tasks()
signal reset_recorded_steps()

func _ready():
	change_state(GHelper.STATES.MAIN_MENU)
	var dir = Directory.new()
	dir.open("user://")
	dir.make_dir("tasks")
	$TaskController.save_task(GHelper.example_task, 'Example Task')
	emit_signal("reload_tasks")
	print(OS.get_data_dir())
#	print(range(0, 310))


#func _unhandled_input(event):
#	if event is InputEventScreenTouch or event is InputEventMouseButton:
#		if event.pressed:
#			var new_blob = blob_scene.instance()
#			new_blob.set_compound(current_compound)
#			add_child(new_blob)
#			new_blob.position = $BlobSpawnPoint.position
#	pass


func _on_NewVialButton_pressed():
	spawn_small_vial()


func spawn_small_vial(for_animation=false):
	if get_small_vial_count() < MAX_SMALL_VIAL_COUNT:
		var new_small_vial = small_vial_scene.instance()
		new_small_vial.init(get_small_vial_count())
		add_child(new_small_vial)
		new_small_vial.position = $SmallVialSpawnPoint.position
		connect('toggle_input', new_small_vial, 'request_disable_input')
		if for_animation:
			emit_signal('animation_vial_spawned', new_small_vial)


func _on_ClearVialsButton_pressed():
	for vial in get_tree().get_nodes_in_group("vials"):
		vial.queue_free()
	


func _on_MainVial_blob_poured_in(blob):
	mixture_volume += blob.volume
	if blob.compound in mixture_contents:
		mixture_contents[blob.compound] += blob.volume
	else:
		mixture_contents[blob.compound] = blob.volume
		var new_entry = compound_entry_scene.instance()
		new_entry.init_material(blob.compound)
		$GUI/CurrentStats/VBoxContainer.add_child(new_entry)
		connect('update_entry', new_entry, "_on_mixture_changed")
	recalculate_mixture_contents()
		

func _on_MainVial_blob_poured_out(blob):
	for compound in mixture_contents.keys():
		mixture_contents[compound] -= stepify(float(mixture_contents[compound]) / mixture_volume, 0.001) * blob.volume
		if int(mixture_contents[compound]) <= 0:
			mixture_contents.erase(compound)
			for entry in get_tree().get_nodes_in_group("entries"):
				if entry.compound == compound:
					entry.queue_free()

	mixture_volume -= blob.volume
	if mixture_volume > 0:
		recalculate_mixture_contents()


func recalculate_mixture_contents():
	if mixture_contents.keys().empty():
		save_task_button.disabled = true
		return
	else:
		save_task_button.disabled = false
	
	for compound in mixture_contents.keys():
		var percent = stepify(float(mixture_contents[compound]) / mixture_volume * 100, 0.001)
		emit_signal('update_entry', compound, mixture_contents[compound], percent)


func _on_CompoundSelect_item_selected(index):
	current_compound = GHelper.compounds.keys()[index]


func _on_SpawnBlobButton_pressed():
	var new_blob = blob_scene.instance()
	new_blob.set_compound(current_compound)
	add_child(new_blob)
	new_blob.position = Vector2($BlobSpawnPoint.position.x + randi() % 10, $BlobSpawnPoint.position.y + randi() % 10)


func spawn_blob(compound):
	var new_blob = blob_scene.instance()
	new_blob.set_compound(compound)
	add_child(new_blob)
	new_blob.position = Vector2($BlobSpawnPoint.position.x + randi() % 10, $BlobSpawnPoint.position.y + randi() % 10)


func get_small_vial_count():
	return get_tree().get_nodes_in_group('vials').size()


func _on_MainVial_mix():
	if mixture_contents.keys().size() < 2:
		return
	var avg_color = calculate_avg_color()
	for compound in mixture_contents.keys():
		for blob in get_tree().get_nodes_in_group(compound):
			blob.set_color(avg_color)
	emit_signal("mixture_color_changed", avg_color)


func calculate_avg_color():
	var compound_blob_count
	var compound_blob_color
	var colors = {
		'r': [],
		'g': [],
		'b': []
	}
	var blob_sum = 0

	for compound in mixture_contents.keys():
		compound_blob_count = get_tree().get_nodes_in_group(compound).size()
		compound_blob_color = GHelper.compounds[compound]['color']
		colors['r'].append(compound_blob_color.r8 * compound_blob_count)
		colors['g'].append(compound_blob_color.g8 * compound_blob_count)
		colors['b'].append(compound_blob_color.b8 * compound_blob_count)
		blob_sum += compound_blob_count
	colors['r'] = GHelper.average(colors['r'], blob_sum)
	colors['g'] = GHelper.average(colors['g'], blob_sum)
	colors['b'] = GHelper.average(colors['b'], blob_sum)
	
	return Color8(colors['r'], colors['g'], colors['b'])


func _on_CreateTaskButton_pressed():
	change_state(GHelper.STATES.INTERACTIVE)


func _on_SandboxButton_pressed():
	change_state(GHelper.STATES.SANDBOX)


func change_state(new_state):
	cleanup_game_objects()
	if new_state == GHelper.STATES.INTERACTIVE:
		print("Changing state to INTERACTIVE")
		main_menu.hide()
		main_vial.show()
		gui.show()
		stats_gui.show()
		stirring_rod.show()
		step_list_container.hide()
		tamp.show()
		control_panel.show()
		spawn_blob_button.show()		
		emit_signal('toggle_input', false)
	elif new_state == GHelper.STATES.SANDBOX:
		print("Changing state to SANDBOX")
		main_menu.hide()
		main_vial.show()
		gui.show()
		stats_gui.show()
		stirring_rod.show()
		step_list_container.hide()
		tamp.show()
		control_panel.show()
		spawn_blob_button.show()		
		emit_signal('toggle_input', false)
	elif new_state == GHelper.STATES.MAIN_MENU:
		print("Changing state to MAIN_MENU")
		main_menu.show()
		main_vial.hide()
		gui.hide()
		stats_gui.hide()
		stirring_rod.hide()
		tamp.hide()
		emit_signal('toggle_input', true)
	elif new_state == GHelper.STATES.ANIMATION:
		print("Changing state to ANIMATION")
		main_menu.hide()
		main_vial.show()
		gui.show()
		control_panel.hide()
		stats_gui.hide()
		stirring_rod.show()
		step_list_container.show()
		tamp.show()
		spawn_blob_button.hide()
		spawn_small_vial(true)
		emit_signal('toggle_input', true)
	state = new_state


func _on_ExperimentButton_pressed():
	change_state(GHelper.STATES.ANIMATION)


func _on_TaskController_step_entries_loaded(entries):
	for entry in get_tree().get_nodes_in_group('step_entries'):
		entry.queue_free()
	change_state(GHelper.STATES.ANIMATION)
	for entry in entries:
		step_entries_list.add_child(entry)


func _on_AnimationController_spawn_blob(compound):
	spawn_blob(compound)


func _on_TaskController_replay():
	clean_blobs()


func _on_TaskController_answer_declined():
	change_state(GHelper.STATES.MAIN_MENU)


func cleanup_game_objects():
	clean_blobs()
	clean_vials()
	clean_compound_entries()
	main_vial.position = $MainVialRestPoint.position
	main_vial.rotation_degrees = 0
	stirring_rod.position = $StirringRodRestPoint.position
	stirring_rod.rotation_degrees = 0
	mixture_volume = 0
	mixture_contents = {}
	emit_signal('reset_recorded_steps')


func clean_blobs():
	for blob in get_tree().get_nodes_in_group('blobs'):
		blob.queue_free()


func clean_vials():
	for vial in get_tree().get_nodes_in_group('vials'):
		vial.queue_free()


func clean_compound_entries():
	for entry in get_tree().get_nodes_in_group('entries'):
		entry.queue_free()


func _on_MainMenuButton_pressed():
	change_state(GHelper.STATES.MAIN_MENU)


func _on_SaveTaskButton_pressed():
	save_dialog.show()


func _on_SaveDialog_request_main_menu():
	change_state(GHelper.STATES.MAIN_MENU)


func _on_SaveDialog_save_task(task_file_name):
	emit_signal("task_ready", mixture_contents, mixture_volume, task_file_name)
	emit_signal("reload_tasks")


func _on_ExitButton_pressed():
	get_tree().quit()
