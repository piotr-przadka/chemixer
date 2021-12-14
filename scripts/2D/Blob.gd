extends RigidBody2D

var compound
var volume = 10
var type = "blob"
var color

func _ready():
	pass


func _draw():
	draw_circle(Vector2(0, 0), $CollisionShape2D.shape.radius * 2, color)


func set_compound(init_compound):
	compound = init_compound
	color = GHelper.compounds[compound]["color"]
	add_to_group(compound)
