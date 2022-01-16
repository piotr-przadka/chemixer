extends PanelContainer

var task_name_regex = RegEx.new()
onready var save_button = $VBoxContainer/SaveControl/SaveButton
onready var task_input = $VBoxContainer/SaveHBox/TaskNameInput

signal save_task(task_file_name)
signal request_main_menu()

func _ready():
	task_name_regex.compile('^[A-Za-z0-9]+$')


func _on_SaveButton_pressed():
	emit_signal("save_task", task_input.text)
	task_input.text = ''
	emit_signal('request_main_menu')
	hide()


func _on_ContinueButton_pressed():
	task_input.text = ''
	hide()


func _on_DiscardButton_pressed():
	emit_signal('request_main_menu')
	hide()


func _on_TaskNameInput_text_changed(new_text):
	var result = task_name_regex.search(new_text)
	if not result:
		save_button.disabled = true
		task_input.add_color_override("font_color", Color('#ff0000'))
	else:
		save_button.disabled = false
		task_input.add_color_override("font_color", Color('#ffffff'))
