extends KinematicBody2D

var type = 'stirring_rod'
var rotation_factor = 4
var touching : bool = false
var dragged_position_delta
var touch_offset

var input_disabled = false

func _ready():
	$Particles.emitting = false


func _process(delta):
	if touching and not input_disabled:
		var gyro_rotation = Input.get_gyroscope().z
		rotate(-gyro_rotation * delta * rotation_factor)


func _input(event):
	if input_disabled:
		return
	
	if event is InputEventScreenTouch and touching:
		if event.index > 0:
			return
		touch_offset = position - event.position
	elif event is InputEventScreenDrag and touching:
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


func _on_Chemixer_toggle_input(enabled):
	input_disabled = enabled


func toggle_particles(emitting):
	$Particles.emitting = emitting
