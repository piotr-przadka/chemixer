extends Particles2D


func _ready():
	pass

func _process(delta):
	var parent_rotation = get_parent().rotation
	set_rotation(-parent_rotation)
