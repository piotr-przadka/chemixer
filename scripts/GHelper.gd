extends Node

var compounds = {
	"water": {
		"index": 0,
		"name": "water",
		"formula": "H2O",
		"color": Color("#34cfeb"),
		# maybe add some special interactions or sth
	},
	"oil": {
		"index": 1,
		"name": "oil",
		"formula": "Oil",
		"color": Color("#f0d662")
	},
	"salt": {
		"index": 2,
		"name": "salt",
		"formula": "NaCl",
		"color": Color("#becacc")
	}
}

func _ready():
	pass # Replace with function body.

func sum(list):
	var sum = 0
	for item in list:
		sum += item
	return sum
