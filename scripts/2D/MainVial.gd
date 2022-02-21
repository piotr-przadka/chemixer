extends KinematicBody2D

var rotation_factor = 2
var touching : bool = false
var dragged_position_delta
var touch_offset
var input_disabled = false

var old_rotation_degrees = rotation_degrees

var type = "main_vial"

onready var mix_timer = $MixTimer
onready var mix_particles = $MixParticles
onready var reposition_timer = $RepositionTimer
onready var reposition_tween = $RepositionTween

signal blob_poured_in(blob)
signal blob_poured_out(blob)
signal mix()

func _ready():
	mix_particles.emitting = true

func _process(delta):
	if touching and not input_disabled:
		var gyro_rotation = Input.get_gyroscope().z
		
#		print("rotation_degrees: ", rotation_degrees)
#		print("calculated: ", -gyro_rotation * delta * rotation_factor)
		
		rotate(-gyro_rotation * delta * rotation_factor)
		
	if abs(rotation_degrees) > 80:
		$SpillGuard.disabled = true
	else:
		$SpillGuard.disabled = false


func _input(event):
	if input_disabled:
		return
	
	if event is InputEventScreenTouch and touching:
		reposition_timer.start()
		if event.index > 0:
			return
		touch_offset = position - event.position
	elif event is InputEventScreenDrag and touching:
		reposition_timer.stop()
		
		if reposition_tween.is_active():
			reposition_tween.stop(reposition_tween)
		
		if event.index > 0:
			return
		position = event.position + touch_offset
	elif event is InputEventKey and touching:
		if event.pressed:
			if event.scancode == KEY_LEFT:
				rotate(-0.05)
			elif event.scancode == KEY_RIGHT:
				rotate(0.05)



func _on_TouchScreenButton_pressed():
	touching = true


func _on_TouchScreenButton_released():
	touching = false
	touch_offset = Vector2(0, 0)


func _on_Area2D_body_entered(body):
	if body.type == 'blob' and not body.is_in_group('in_main_vial'):
		print('entered')	
#		mix_timer.start(7)
		body.add_to_group('in_main_vial')
		body.set_collision_plane(3)
		emit_signal('blob_poured_in', body)
	elif body.type == 'stirring_rod':
		body.toggle_particles(true)
		mix_timer.start(2.5)


func _on_Area2D_body_exited(body):
	if body.type == 'blob' and body.is_in_group('in_main_vial'):
		print('exited')	
		body.remove_from_group('in_main_vial')
		body.reset_collision_plane()
		emit_signal("blob_poured_out", body)
	elif body.type == 'stirring_rod':
		body.toggle_particles(false)
		mix_timer.stop()


func _on_MixTimer_timeout():
	emit_signal('mix')


func _on_Chemixer_mixture_color_changed(color):
	mix_particles.process_material.color = color
	mix_particles.emitting = true


func _on_Chemixer_toggle_input(enabled):
	input_disabled = enabled


func _on_RepositionTimer_timeout():
	if touching:
		return
	elif not reposition_tween.is_active() or rotation_degrees == 0:
		reposition_tween.interpolate_property(self, "rotation_degrees", rotation_degrees, 0, 1, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
		reposition_tween.start()

