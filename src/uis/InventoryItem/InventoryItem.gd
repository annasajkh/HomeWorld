extends Control

@onready var item_selector: TextureRect = $Selector
@onready var icon: TextureRect = $Icon
@onready var display_name: Label = $Name

var is_selected: bool = false
var is_equipped: bool = false
var item_name: String


func _ready() -> void:
	var item_config = AllItems.items[item_name]
	
	display_name.text = item_name
	icon.texture = load(item_config["icon_path"])


func _process(_delta: float) -> void:
	$Selector.visible = is_selected
	
	if is_equipped:
		display_name.add_theme_color_override("font_color", Color.ORANGE)
	else:
		display_name.add_theme_color_override("font_color", Color.BLACK)
