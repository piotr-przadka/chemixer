extends KinematicBody2D

var rotation_factor = 4
var touching : bool = false
var dragged_position_delta
var touch_offset

func _ready():
	pass

func _process(delta):
	if touching:
		var gyro_rotation = Input.get_gyroscope().z
		rotate(-gyro_rotation * delta * rotation_factor)


func _input(event):
	if event is InputEventScreenTouch and touching:
		touch_offset = position - event.position
	elif event is InputEventScreenDrag and touching:
		position = event.position + touch_offset
		


func _on_TouchScreenButton_pressed():
	touching = true


func _on_TouchScreenButton_released():
	touching = false
	touch_offset = Vector2(0, 0)
