extends Node2D

onready var blob_scene = preload("res://scenes/2D/Blob.tscn")
onready var small_vial_scene = preload("res://scenes/2D/SmallVial.tscn")
onready var compound_entry_scene = preload("res://scenes/GUI/MaterialEntry.tscn")

var current_compound = "water"
var mixture_volume = 0
var mixture_contents = {}

signal update_entry(compound, volume, percent)


func _ready():
	pass


func _unhandled_input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			var new_blob = blob_scene.instance()
			new_blob.set_compound(current_compound)
			add_child(new_blob)


func _on_NewVialButton_pressed():
	var new_small_vial = small_vial_scene.instance()
	add_child(new_small_vial)
	new_small_vial.position = $SmallVialSpawnPoint.position


func _on_ClearVialsButton_pressed():
	for vial in get_tree().get_nodes_in_group("vials"):
		vial.queue_free()


func _on_ClearFluidsButton_pressed():
	for blob in get_tree().get_nodes_in_group(current_compound):
		blob.queue_free()


func _on_MainVial_blob_poured_in(blob):
	mixture_volume += blob.volume
	if blob.compound in mixture_contents:
		mixture_contents[blob.compound] += blob.volume
	else:
		mixture_contents[blob.compound] = blob.volume
		var new_entry = compound_entry_scene.instance()
		new_entry.init_material(blob.compound)
		$GUI/CurrentStats/VBoxContainer.add_child(new_entry)
		connect('update_entry', new_entry, "_on_mixture_changed")
	recalculate_mixture_contents()
		

func _on_MainVial_blob_poured_out(blob):
	mixture_volume -= blob.volume
	mixture_contents[blob.compound] -= blob.volume
	if mixture_contents[blob.compound] <= 0:
		mixture_contents.erase(blob.compound)
		for entry in get_tree().get_nodes_in_group("entries"):
			if entry.compound == blob.compound:
				entry.queue_free()
	else:
		recalculate_mixture_contents()


func recalculate_mixture_contents():
	for compound in mixture_contents.keys():
		var percent = stepify(float(mixture_contents[compound]) / mixture_volume * 100, 0.01)
		emit_signal('update_entry', compound, mixture_contents[compound], percent)


func _on_CompoundSelect_item_selected(index):
	current_compound = GHelper.compounds.keys()[index]


func _on_SpawnBlobButton_pressed():
	var new_blob = blob_scene.instance()
	new_blob.set_compound(current_compound)
	add_child(new_blob)
