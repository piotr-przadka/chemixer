extends RigidBody2D

func _ready():
	pass


func _draw():
	draw_circle(Vector2(0, 0), $CollisionShape2D.shape.radius * 3, Color(255, 0, 0))

