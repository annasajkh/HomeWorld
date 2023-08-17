extends Control


@onready var item_icon: TextureRect = $ItemIcon


# Called when the node enters the scene tree for the first time.
func _process(_delta: float) -> void:
	Global.niko_selected_item_ui = self
