extends Node


var items: Dictionary = {
	"lightbulb": {
		"description": "why you always believe everything you see?",
		"icon_path": "res://assets/textures/items/lightbulb.png",
		"recipe": ["floppy disk", "floppy disk"]
	},
	
	"floppy disk": {
		"description": "the entire world of oneshot is inside this",
		"icon_path": "res://assets/textures/items/floppy_disk.png",
		"recipe": ["lightbulb", "lightbulb"]
	}
	
}
