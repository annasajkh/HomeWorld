extends Node2D


@export var target_scene_path: String

func _on_DoorTrigger_body_entered(body) -> void:
	if body.name == "Niko" && body is CharacterBody2D:
		get_tree().change_scene_to_file(target_scene_path)
		
		if Global.saved_player_data.is_empty():
			var save_player_data: SavePlayerData = SavePlayerData.new(body.position + Vector2(0, 10), get_tree().get_root().get_children()[-1].name)
			Global.saved_player_data.append(save_player_data)
			Global.niko_go_back = false
			
		elif target_scene_path.split("/")[-1].split(".")[0] == Global.saved_player_data[-1].current_scene_name:
			var player_data: SavePlayerData = Global.saved_player_data.pop_back()
			
			Global.niko_inital_position = player_data.position
			Global.niko_inital_move_direction = body.move_direction
			Global.niko_go_back = true
		else:
			var save_player_data: SavePlayerData = SavePlayerData.new(body.position + Vector2(0, 10), get_tree().get_root().get_children()[-1].name)
			
			Global.saved_player_data.append(save_player_data)
			Global.niko_go_back = false
