extends OptionButton

signal selected_task_changed(file_path)

func _ready():
	load_tasks()

func load_tasks():
	clear()
	var dir = Directory.new()
	dir.open('user://tasks')
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			add_item(file.trim_suffix('.json'))

	dir.list_dir_end()
	emit_signal("selected_task_changed", 'user://tasks/' + get_item_text(0) + '.json')


func _on_TaskSelector_item_selected(index):
	var file_path = 'user://tasks/' + get_item_text(index) + '.json'
	emit_signal("selected_task_changed", file_path)


func _on_Chemixer_reload_tasks():
	load_tasks()
