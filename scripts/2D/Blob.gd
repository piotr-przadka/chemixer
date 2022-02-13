extends RigidBody2D

var compound
var volume = 10
var type = "blob"
var color
var size_factor

func _ready():
	add_to_group('blobs')
	

func _draw():
	draw_circle(Vector2(0, 0), $CollisionShape2D.shape.radius * 1.8, color)


func set_compound(init_compound):
	compound = init_compound
	color = GHelper.compounds[compound]["color"]
	size_factor = GHelper.compounds[compound]["size_factor"]
	$CollisionShape2D.shape = CircleShape2D.new()
	$CollisionShape2D.shape.radius = 20 * size_factor
	add_to_group(compound)
	$Particles.process_material.color = color


func set_collision_plane(layer):
	for layer_index in range(0, 5):
		if layer == layer_index:
			set_collision_layer_bit(layer_index, true)
			set_collision_mask_bit(layer_index, true)
		else:
			set_collision_layer_bit(layer_index, false)
			set_collision_mask_bit(layer_index, false)
	
	if layer == 3:
		set_collision_layer_bit(5, true)
		set_collision_mask_bit(5, true)
	else:
		set_collision_layer_bit(5, false)
		set_collision_mask_bit(5, false)
	
	print(collision_layer)


func reset_collision_plane():
	for layer_index in range(0, 6):
		set_collision_layer_bit(layer_index, true)
		set_collision_mask_bit(layer_index, true)


func set_color(new_color):
	color = new_color
	$Particles.process_material.color = color
	update()
