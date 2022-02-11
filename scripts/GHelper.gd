extends Node

var compounds = {
	"H20": {
		"index": 0,
		"name": "water",
		"formula": "H2O",
		"color": Color("#34cfeb"),
		"size_factor": 1
	},
	"Sulfuric Acid": {
		"index": 0,
		"name": "acid",
		"formula": "H2 S04",
		"color": Color("#ffddba"),
		"size_factor": 1
	},
	"Nitric Acid": {
		"index": 0,
		"name": "acid",
		"formula": "HNO3",
		"color": Color("#d69200"),
		"size_factor": 1
	},
	"Phosporic Acid": {
		"index": 0,
		"name": "acid",
		"formula": "H3 PO4",
		"color": Color("#a3c7c5"),
		"size_factor": 1
	},
	"Hydrochloric Acid": {
		"index": 0,
		"name": "acid",
		"formula": "HCl",
		"color": Color("#adffa6"),
		"size_factor": 1
	},
	"Sodium Hydroxide": {
		"index": 0,
		"name": "",
		"formula": "NaOH",
		"color": Color("#ffe8eb"),
		"size_factor": 1
	},
	"Aluminum Hydroxide": {
		"index": 0,
		"name": "",
		"formula": "Al(OH)3",
		"color": Color('#f5e8ff'),
		"size_factor": 1
	},
	"Table Sugar": {
		"index": 0,
		"name": "sugar",
		"formula": "C12 H22 O11",
		"color": Color("#e4e9f2"),
		"size_factor": 1
	},
#	"oil": {
#		"index": 1,
#		"name": "oil",
#		"formula": "Oil",
#		"color": Color("#f0d662"),
#		"size_factor": 1
#	},
	"NaCl": {
		"index": 2,
		"name": "Table Salt",
		"formula": "NaCl",
		"color": Color("#becacc"),
		"size_factor": 1
	},
	"Red H20": {
		"index": 0,
		"name": "water",
		"formula": "Red H2O",
		"color": Color("#d4393c"),
		"size_factor": 1
	},
	"Green H20": {
		"index": 0,
		"name": "water",
		"formula": "Green H2O",
		"color": Color("#39d449"),
		"size_factor": 1
	},
	"Yellow H2O": {
		"index": 0,
		"name": "water",
		"formula": "Yellow H2O",
		"color": Color("#dbdb27"),
		"size_factor": 1
	},
#	"Purple H20": {
#		"index": 0,
#		"name": "water",
#		"formula": "Purple H2O",
#		"color": Color("#a827db"),
#		"size_factor": 1
#	},
#	"Orange H20": {
#		"index": 0,
#		"name": "water",
#		"formula": "Orange H2O",
#		"color": Color("#db9027"),
#		"size_factor": 1
#	},
#	"Pink H20": {
#		"index": 0,
#		"name": "water",
#		"formula": "Pink H2O",
#		"color": Color("#db27cc"),
#		"size_factor": 1
#	},
#	"Black H20": {
#		"index": 0,
#		"name": "water",
#		"formula": "Black H2O",
#		"color": Color("#121111"),
#		"size_factor": 1
#	},
#	"Brown H2O": {
#		"index": 0,
#		"name": "water",
#		"formula": "Brown H2O",
#		"color": Color("#6b4c28"),
#		"size_factor": 1
#	},
#	"White H2O": {
#		"index": 0,
#		"name": "water",
#		"formula": "White H2O",
#		"color": Color("#f7f6f5"),
#		"size_factor": 1
#	},
}

const example_task = {
	"mixture_stats":{
		"content_percentage":{
			"Yellow H2O": 50,
			"Aluminum Hydroxide": 50
			},
		"total_volume": 240
	},
	"steps": [
		{
			"compound":"Yellow H2O",
			"step_type": 0,
			"volume": 120,
		},
		{
			"compound":"Aluminum Hydroxide",
			"step_type": 0,
			"volume": 120,
		},
		{
			"step_type": 2
		}
	]
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
