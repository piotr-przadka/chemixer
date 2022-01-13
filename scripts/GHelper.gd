extends Node

var compounds = {
	"water": {
		"index": 0,
		"name": "water",
		"formula": "H2O",
		"color": Color("#34cfeb"),
		"size_factor": 1
		# maybe add some special interactions or sth
	},
	"oil": {
		"index": 1,
		"name": "oil",
		"formula": "Oil",
		"color": Color("#f0d662"),
		"size_factor": 1
	},
	"salt": {
		"index": 2,
		"name": "salt",
		"formula": "NaCl",
		"color": Color("#becacc"),
		"size_factor": 1
	},
	"water_red": {
		"index": 0,
		"name": "water",
		"formula": "H2O",
		"color": Color("#d4393c"),
		"size_factor": 1
		# maybe add some special interactions or sth
	},
	"water_green": {
		"index": 0,
		"name": "water",
		"formula": "H2O",
		"color": Color("#39d449"),
		"size_factor": 1
		# maybe add some special interactions or sth
	},
	"water_yellow": {
		"index": 0,
		"name": "water",
		"formula": "H2O",
		"color": Color("#dbdb27"),
		"size_factor": 1
		# maybe add some special interactions or sth
	},
	"water_purple": {
		"index": 0,
		"name": "water",
		"formula": "H2O",
		"color": Color("#a827db"),
		"size_factor": 1
		# maybe add some special interactions or sth
	},
	"water_orange": {
		"index": 0,
		"name": "water",
		"formula": "H2O",
		"color": Color("#db9027"),
		"size_factor": 1
		# maybe add some special interactions or sth
	},
	"water_pink": {
		"index": 0,
		"name": "water",
		"formula": "H2O",
		"color": Color("#db27cc"),
		"size_factor": 1
		# maybe add some special interactions or sth
	},
	"water_black": {
		"index": 0,
		"name": "water",
		"formula": "H2O",
		"color": Color("#121111"),
		"size_factor": 1
		# maybe add some special interactions or sth
	},
	"water_brown": {
		"index": 0,
		"name": "water",
		"formula": "H2O",
		"color": Color("#6b4c28"),
		"size_factor": 1
		# maybe add some special interactions or sth
	},
	"water_white": {
		"index": 0,
		"name": "water",
		"formula": "H2O",
		"color": Color("#f7f6f5"),
		"size_factor": 1
		# maybe add some special interactions or sth
	},
}

enum STEP_TYPES { POUR_IN, POUR_OUT, MIX }
enum STATES { MAIN_MENU, INTERACTIVE, ANIMATION, SANDBOX }

func _ready():
	pass # Replace with function body.

func sum(list):
	var sum = 0
	for item in list:
		sum += item
	return sum


func average(list, item_no=null):
	if not item_no:
		item_no = list.size()
	return sum(list) / item_no
