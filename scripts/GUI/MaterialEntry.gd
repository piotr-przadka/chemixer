extends HBoxContainer

var compound

func _ready():
	add_to_group("entries")


func init_material(name):
	compound = name
	$Material.text = compound
	$Volume/Value.text = "0"
	$Percent/Value.text = "0"


func _on_mixture_changed(target_compound, volume, percent):
	if compound == target_compound:
		$Volume/Value.text = str(volume)
		$Percent/Value.text = str(percent)
