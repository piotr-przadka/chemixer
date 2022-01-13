extends RigidBody2D

var compound
var volume = 10
var type = "blob"
var color
var size_factor

func _ready():
	pass


func _draw():
	draw_circle(Vector2(0, 0), $CollisionShape2D.shape.radius * 1.8, color)


func set_compound(init_compound):
	compound = init_compound
	color = GHelper.compounds[compound]["color"]
	size_factor = GHelper.compounds[compound]["size_factor"]
	$CollisionShape2D.shape = CircleShape2D.new()
	$CollisionShape2D.shape.radius = 20 * size_factor
	add_to_group(compound)


func set_collision_plane(layer):
	for layer_index in range(0, 5):
		if layer == layer_index:
			set_collision_layer_bit(layer_index, true)
			set_collision_mask_bit(layer_index, true)
		else:
			set_collision_layer_bit(layer_index, false)
			set_collision_mask_bit(layer_index, false)


func reset_collision_plane():
	for layer_index in range(0, 5):
		set_collision_layer_bit(layer_index, true)
		set_collision_mask_bit(layer_index, true)

func set_color(new_color):
	color = new_color
	update()
