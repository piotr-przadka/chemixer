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


func set_collision_plane(layer):
	for layer_index in range(0, 4):
		print(layer)
		if layer == layer_index:
			set_collision_layer_bit(layer_index, true)
			set_collision_mask_bit(layer_index, true)
		else:
			set_collision_layer_bit(layer_index, false)
			set_collision_mask_bit(layer_index, false)
			
	for i in range(0, 4):
		print(i, get_collision_layer_bit(i))
		print(i, get_collision_mask_bit(i))
#	print(get_collision_layer_bit(3))
#	print(get_collision_layer_bit(2))
#	print(get_collision_layer_bit())


func reset_collision_plane():
	for layer_index in range(0, 4):
#		print(layer_index)
		set_collision_layer_bit(layer_index, true)
		set_collision_mask_bit(layer_index, true)
