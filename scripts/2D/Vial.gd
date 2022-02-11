extends KinematicBody2D

var rotation_factor = 4
var touching : bool = false
var dragged_position_delta
var touch_offset
var collision_layer_index
var input_disabled = false

var type = "small_vial"

func _ready():
	add_to_group("vials")
	$MixParticles.emitting = true


func init(layer_index):
	collision_layer_index = layer_index
	set_collision_layer_bit(layer_index, true)
	set_collision_mask_bit(layer_index, true)
	$Area2D.	set_collision_layer_bit(layer_index, true)
	$Area2D.set_collision_mask_bit(layer_index, true)


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


func _on_Area2D_body_entered(body):
	if body.type == 'blob':
		body.set_collision_plane(collision_layer_index)


func _on_Area2D_body_exited(body):
	if body.type == 'blob':
		body.reset_collision_plane()


func request_disable_input(disabled):
	input_disabled = disabled
