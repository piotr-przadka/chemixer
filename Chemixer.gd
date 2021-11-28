extends Node2D

onready var blob = preload("res://scenes/2D/Blob.tscn")
onready var small_vial = preload("res://scenes/2D/SmallVial.tscn")

func _ready():
	pass


func _unhandled_input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			add_child(blob.instance())


func _on_NewVialButton_pressed():
	var new_small_vial = small_vial.instance()
	add_child(new_small_vial)
	new_small_vial.position = $SmallVialSpawnPoint.position


func _on_ClearVialsButton_pressed():
	for vial in get_tree().get_nodes_in_group("vials"):
		vial.queue_free()


func _on_ClearFluidsButton_pressed():
	for fluid_blob in get_tree().get_nodes_in_group("water"):
		fluid_blob.queue_free()
