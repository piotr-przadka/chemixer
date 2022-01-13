extends Node2D

onready var blob_scene = preload("res://scenes/2D/Blob.tscn")
onready var small_vial_scene = preload("res://scenes/2D/SmallVial.tscn")
onready var compound_entry_scene = preload("res://scenes/GUI/MaterialEntry.tscn")

var current_compound = "water"
var current_color = GHelper.compounds[current_compound]['color']
var mixture_volume = 0
var mixture_contents = {}
var MAX_SMALL_VIAL_COUNT = 3

signal update_entry(compound, volume, percent)
signal mixture_color_changed(color)
signal task_ready(mixture_contents, mixture_volume)


func _ready():
	var new_blob = blob_scene.instance()
	new_blob.set_compound(current_compound)
	add_child(new_blob)
	new_blob = blob_scene.instance()
	new_blob.set_compound(current_compound)
	add_child(new_blob)
	var dir = Directory.new()
	dir.open("user://")
	dir.make_dir("tasks")


func _unhandled_input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			var new_blob = blob_scene.instance()
			new_blob.set_compound(current_compound)
			add_child(new_blob)


func _on_NewVialButton_pressed():
	if get_small_vial_count() <= MAX_SMALL_VIAL_COUNT:
		var new_small_vial = small_vial_scene.instance()
		new_small_vial.init(get_small_vial_count())
		add_child(new_small_vial)
		new_small_vial.position = $SmallVialSpawnPoint.position


func _on_ClearVialsButton_pressed():
	for vial in get_tree().get_nodes_in_group("vials"):
		vial.queue_free()
		
		
		
		
		
		
		#TODO remove line below
		
		
		
		
	emit_signal("task_ready", mixture_contents, mixture_volume)


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
	
	for compound in mixture_contents.keys():
		mixture_contents[compound] -= stepify(float(mixture_contents[compound]) / mixture_volume, 0.01) * blob.volume
		if int(mixture_contents[compound]) <= 0:
			mixture_contents.erase(compound)
			for entry in get_tree().get_nodes_in_group("entries"):
				if entry.compound == compound:
					entry.queue_free()

	mixture_volume -= blob.volume
	if mixture_volume > 0:
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


func get_small_vial_count():
	return get_tree().get_nodes_in_group('vials').size()


func _on_MainVial_mix():
	if mixture_contents.keys().size() < 2:
		return
	var avg_color = calculate_avg_color()
	for compound in mixture_contents.keys():
		for blob in get_tree().get_nodes_in_group(compound):
			blob.set_color(avg_color)
	emit_signal("mixture_color_changed", avg_color)


func calculate_avg_color():
	var compound_blob_count
	var compound_blob_color
	var colors = {
		'r': [],
		'g': [],
		'b': []
	}
	var blob_sum = 0

	for compound in mixture_contents.keys():
		compound_blob_count = get_tree().get_nodes_in_group(compound).size()
		compound_blob_color = GHelper.compounds[compound]['color']
		colors['r'].append(compound_blob_color.r8 * compound_blob_count)
		colors['g'].append(compound_blob_color.g8 * compound_blob_count)
		colors['b'].append(compound_blob_color.b8 * compound_blob_count)
		blob_sum += compound_blob_count
	colors['r'] = GHelper.average(colors['r'], blob_sum)
	colors['g'] = GHelper.average(colors['g'], blob_sum)
	colors['b'] = GHelper.average(colors['b'], blob_sum)
	
	return Color8(colors['r'], colors['g'], colors['b'])











