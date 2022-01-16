extends KinematicBody2D

var rotation_factor = 4
var touching : bool = false
var dragged_position_delta
var touch_offset
var input_disabled = false

var type = "main_vial"

onready var mix_timer = $MixTimer
onready var mix_particles = $MixParticles

signal blob_poured_in(blob)
signal blob_poured_out(blob)
signal mix()

func _ready():
	mix_particles.emitting = true

func _process(delta):
	if touching:
		var gyro_rotation = Input.get_gyroscope().z
		rotate(-gyro_rotation * delta * rotation_factor)


func _input(event):
	if input_disabled:
		return
	
	if event is InputEventScreenTouch and touching:
		touch_offset = position - event.position
	elif event is InputEventScreenDrag and touching:
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
	if body.type == 'blob':
		print('entered')	
		mix_timer.start(15)
		body.set_collision_plane(3)
		emit_signal('blob_poured_in', body)
	elif body.type == 'stirring_rod':
		print('stirring_rod detected')
		mix_timer.start(7)


func _on_Area2D_body_exited(body):
	if body.type == 'blob':
		print('exited')	
		body.reset_collision_plane()
		emit_signal("blob_poured_out", body)
	elif body.type == 'stirring_rod':
		print('stirring_rod exited')
		mix_timer.stop()


func _on_MixTimer_timeout():
	print('mixing!')
	emit_signal('mix')


func _on_Chemixer_mixture_color_changed(color):
	mix_particles.process_material.color = color
	mix_particles.emitting = true


func _on_Chemixer_disable_input():
	input_disabled = true
