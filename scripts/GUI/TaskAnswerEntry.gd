extends HBoxContainer

var answer

func _ready():
	add_to_group('answer_entries')

func init_answer(compound, percentage):
	$CompoundLabel.text = compound
	answer = percentage
	
	#TODO: remove this
#	$CompoundInput.text = str(percentage)


func check_answer():
	var user_input = $CompoundInput.text

	if not user_input.is_valid_float():
		$CompoundInput.add_color_override("font_color", Color('#ff0000'))
		return

	if abs(float(user_input) - answer) < 0.5:
		$CompoundInput.add_color_override("font_color", Color('#44d210'))
	else:
		$CompoundInput.add_color_override("font_color", Color('#ff0000'))
