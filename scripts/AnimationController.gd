extends Node

onready var move_twin = $MoveTwin
onready var rotate_twin = $RotateTwin

onready var vial_spawn_point = $SmallVialSpawnPoint.position

onready var stir_rest_point = $StirringRodRestPoint.position
onready var stir_before_point = $StirringRodBeforeMix.position
onready var stir_mix_1_point = $StirringRodMixPoint1.position
onready var stir_mix_2_point = $StirringRodMixPoint2.position

onready var rest_timer = $RestTimer

onready var main_vial = get_parent().get_node("MainVial")
onready var stirring_rod = get_parent().get_node("StirringRod")
var small_vial = null

const MAX_POUR_VOLUME = 250

signal spawn_blob(compound)
signal step_animation_finished()
signal animation_completed()

func _ready():
	pass


func _on_TaskController_task_loaded(steps):
	rest_timer.start()
	yield(rest_timer, "timeout")
	for step in steps:
#		print(step)
		if step['step_type'] == GHelper.STEP_TYPES.POUR_IN:
			animate_pour_in(step['compound'], step['volume'])
		elif step['step_type'] == GHelper.STEP_TYPES.POUR_OUT:
			animate_pour_out(step['volume'])
		elif step['step_type'] == GHelper.STEP_TYPES.MIX:
			animate_mix()
		yield(self, "step_animation_finished")
	emit_signal('animation_completed')


func animate_pour_in(compound, volume):
	for _pour_round in range((volume / MAX_POUR_VOLUME) + 1):
		var pour_amount
		if volume / MAX_POUR_VOLUME > 1:
			pour_amount = MAX_POUR_VOLUME
			volume -= MAX_POUR_VOLUME
		else:
			pour_amount = volume
		
		var blobs = pour_amount / 10
		print(blobs)
		
		for _blob in range(blobs):
			emit_signal("spawn_blob", compound)
			yield(get_tree().create_timer(0.1), "timeout")
		
		rest_timer.start(1)
		yield(rest_timer, "timeout")

		rotate_twin.interpolate_property(small_vial, "rotation_degrees", small_vial.rotation_degrees, -120, 4, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
		rotate_twin.start()
		yield(rotate_twin, "tween_completed")
		
#		rest_timer.start(5)
#		yield(rest_timer, "timeout")
		
		rotate_twin.interpolate_property(small_vial, "rotation_degrees", small_vial.rotation_degrees, 0, 4, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
		yield(rotate_twin, "tween_completed")
		
#		rest_timer.start(5)
#		yield(rest_timer, "timeout")
		
#		rotate_twin.stop()
	emit_signal("step_animation_finished")
#	print(range())
#	for


func animate_pour_out(volume):
	var pour_out_tween = Tween.new()
	add_child(pour_out_tween)
	pour_out_tween.interpolate_property(main_vial, "rotation_degrees", main_vial.rotation_degrees, 107, 4, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	pour_out_tween.start()
	yield(pour_out_tween, "tween_completed")
	
	rest_timer.start(1.5 * volume / 100.0)
	yield(rest_timer, "timeout")
	
	pour_out_tween.interpolate_property(main_vial, "rotation_degrees", main_vial.rotation_degrees, 0, 4, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	pour_out_tween.start()
	yield(pour_out_tween, "tween_completed")
	emit_signal("step_animation_finished")
	pour_out_tween.queue_free()


func animate_mix():
	rotate_twin.interpolate_property(stirring_rod, "rotation_degrees", stirring_rod.rotation_degrees, 190, 3, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	rotate_twin.start()
	move_twin.interpolate_property(stirring_rod, 'position', stir_rest_point, stir_before_point, 3, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	move_twin.start()
	yield(move_twin, "tween_completed")
	
	move_twin.interpolate_property(stirring_rod, 'position', stir_before_point, stir_mix_1_point, 2, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	yield(move_twin, "tween_completed")

	for i in range(3):
		move_twin.interpolate_property(stirring_rod, 'position', stir_mix_1_point, stir_mix_2_point, 0.7, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
		yield(move_twin, "tween_completed")
		move_twin.interpolate_property(stirring_rod, 'position', stir_mix_2_point, stir_mix_1_point, 0.7, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
		yield(move_twin, "tween_completed")

	move_twin.interpolate_property(stirring_rod, 'position', stir_mix_1_point, stir_before_point, 2, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	yield(move_twin, "tween_completed")
	
	move_twin.interpolate_property(stirring_rod, 'position', stir_before_point, stir_rest_point, 3, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	rotate_twin.interpolate_property(stirring_rod, "rotation_degrees", stirring_rod.rotation_degrees, 0, 3, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	rotate_twin.start()
	yield(move_twin, "tween_completed")

	emit_signal("step_animation_finished")


func _on_Chemixer_animation_vial_spawned(vial):
	small_vial = vial
