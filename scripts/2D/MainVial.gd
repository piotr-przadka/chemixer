extends KinematicBody2D

var rotation_factor = 4
var touching : bool = false
var dragged_position_delta
var touch_offset

var type = "main_vial"

signal blob_poured_in(blob)
signal blob_poured_out(blob)

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
	print("entered")
	if body.type == 'blob':
		body.set_collision_plane(3)
		emit_signal('blob_poured_in', body)


func _on_Area2D_body_exited(body):
	print("exited")
	if body.type == 'blob':
		body.reset_collision_plane()
		emit_signal("blob_poured_out", body)
