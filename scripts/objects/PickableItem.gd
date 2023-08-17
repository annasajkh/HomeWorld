extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D

@export var item_name: String

func _ready() -> void:
	sprite.texture = load(AllItems.items[item_name].icon_path)


func _on_pick_area_body_entered(body: Node2D) -> void:
	if body.name == "Niko" && !Global.niko_inventory_ui.is_full():
		Global.niko_inventory_ui.add_item(item_name)
		queue_free()
