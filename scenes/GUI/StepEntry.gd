extends HBoxContainer

var compound

func _ready():
	add_to_group('step_entries')

func init_step(step):
	if step['step_type'] == GHelper.STEP_TYPES.MIX:
		$StepType.text = 'Mix'
		$Volume.queue_free()
		$Of.queue_free()
		$Compound.text = 'the mixture'
	elif step['step_type'] == GHelper.STEP_TYPES.POUR_OUT:
		$StepType.text = 'Pour out'
		$Volume/Value.text = str(step['volume'])
	elif step['step_type'] == GHelper.STEP_TYPES.POUR_IN:
		$StepType.text = 'Pour in'
		$Volume/Value.text = str(step['volume'])
		$Compound.text = step['compound']
