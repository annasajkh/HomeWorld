extends Node


var door_trigger_already_triggered: bool = false

var niko_selected_item_ui: Control
var niko_inventory_ui: Control

var niko_inventory: Array[String]

var niko_equipped_item_index: int = -1
var niko_inventory_selector_index: int = 0
var niko_inventory_opened: bool = false
var dialog_finished: bool = true

var saved_player_data: Array[SavePlayerData] = []

var niko_inital_position: Vector2 = Vector2.ZERO
var niko_inital_move_direction: Vector2 = Vector2.ZERO
var niko_go_back: bool = false
