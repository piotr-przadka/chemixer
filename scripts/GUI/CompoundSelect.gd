extends OptionButton

var compounds = GHelper.compounds

func _ready():
	for compound in compounds.values():
		add_item(compound["formula"], compound["index"])
