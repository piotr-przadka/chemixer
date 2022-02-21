extends KinematicBody2D

var type = 'stirring_rod'
var rotation_factor = 2
var touching : bool = false
var dragged_position_delta
var touch_offset

var input_disabled = false

onready var reposition_timer = $RepositionTimer
onready var reposition_tween = $RepositionTween

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
		reposition_timer.start()
		if event.index > 0:
			return
		touch_offset = position - event.position
	elif event is InputEventScreenDrag and touching:
		if event.index > 0:
			return

		reposition_timer.stop()
		
		if reposition_tween.is_active():
			reposition_tween.stop(reposition_tween)

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


func _on_RepositionTimer_timeout():
	if touching:
		return
	elif not reposition_tween.is_active() or rotation_degrees == 0:
		reposition_tween.interpolate_property(self, "rotation_degrees", rotation_degrees, 0, 1, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
		reposition_tween.start()
