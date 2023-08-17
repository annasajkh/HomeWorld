extends Resource

class_name SavePlayerData

var position: Vector2
var current_scene_name: String

func _init(position: Vector2, current_scene_name: String):
	self.position = position
	self.current_scene_name = current_scene_name
