extends Node2D

onready var blob = preload("res://scenes/2D/Blob.tscn")

func _ready():
	pass


func _unhandled_input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			add_child(blob.instance())
