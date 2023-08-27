extends Control

@onready var inventory_item: PackedScene = preload("res://src/uis/InventoryItem/InventoryItem.tscn")

@onready var item_description: Label = $ItemDescription
@onready var inventory_slots: GridContainer = $InventorySlots
@onready var inventory_selector_move: AudioStreamPlayer = $InventorySelectorMove
@onready var inventory_selector_select: AudioStreamPlayer = $InventorySelectorSelect
@onready var inventory_add_item: AudioStreamPlayer = $InventoryAddItem
@onready var inventory_open: AudioStreamPlayer = $InventoryOpen
@onready var inventory_close: AudioStreamPlayer = $InventoryClose

@onready var local_niko_inventory: Array;


func _ready() -> void:
	
	for item_name in Global.niko_inventory:
		var inventory_item_instanced = inventory_item.instantiate()
		inventory_item_instanced.item_name = item_name
		
		inventory_slots.add_child(inventory_item_instanced)
	
	local_niko_inventory = inventory_slots.get_children()
	
	if Global.niko_equipped_item_index != -1:
		local_niko_inventory[Global.niko_equipped_item_index].is_equipped = true

func rebuild_inventory() -> void:
	Global.niko_equipped_item_index = -1
	Global.niko_inventory_selector_index = 0
	
	for inventory_slot in inventory_slots.get_children():
		inventory_slot.queue_free()
	
	for item_name in Global.niko_inventory:
		var inventory_item_instanced = inventory_item.instantiate()
		inventory_item_instanced.item_name = item_name
		
		inventory_slots.add_child(inventory_item_instanced)
	
	local_niko_inventory = inventory_slots.get_children()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	Global.niko_inventory_ui = self
	local_niko_inventory = inventory_slots.get_children()
	
	_get_input()
	
	visible = Global.niko_inventory_opened
	
	if !local_niko_inventory.is_empty():
		var item_name: String = local_niko_inventory[Global.niko_inventory_selector_index].item_name
		
		item_description.text = AllItems.items[item_name]["description"]
	
	if Global.niko_equipped_item_index == -1:
		Global.niko_selected_item_ui.item_icon.texture = null
	else:
		Global.niko_selected_item_ui.item_icon.texture = load(AllItems.items[local_niko_inventory[Global.niko_equipped_item_index].item_name]["icon_path"])
	
	if !local_niko_inventory.is_empty():
		local_niko_inventory[Global.niko_inventory_selector_index].is_selected = true

# change what the item selector is selecting
func _change_selector_index(index: int) -> void:
	if !local_niko_inventory.is_empty():
		index = Global.niko_inventory_selector_index if index < 0 else index 
		index = Global.niko_inventory_selector_index if index > len(Global.niko_inventory) - 1 else index
		
		if index != Global.niko_inventory_selector_index:
			inventory_selector_move.play()
		
		for value in local_niko_inventory:
			value.is_selected = false
		
		Global.niko_inventory_selector_index = index

func is_full() -> bool:
	return len(Global.niko_inventory) == 8

# add item to the inventory
func add_item(item_name: String) -> void:
	if !is_full():
		var inventory_item_instanced = inventory_item.instantiate()
		inventory_item_instanced.item_name = item_name
		
		inventory_slots.add_child(inventory_item_instanced)
		inventory_add_item.play()
		Global.niko_inventory.append(item_name)
	else:
		print("Inventory full!!!")

# equip and item base on niko inventory index
func equip_item(index: int):
	if index == Global.niko_equipped_item_index:
		local_niko_inventory[Global.niko_equipped_item_index].is_equipped = false
		Global.niko_equipped_item_index = -1
		return
	
	local_niko_inventory[Global.niko_equipped_item_index].is_equipped = false
	
	Global.niko_equipped_item_index = index
	
	local_niko_inventory[Global.niko_equipped_item_index].is_equipped = true

func _filter_null(item: String) -> bool:
	return item != null

func _combine_item():
	for item_name in AllItems.items:
		if "recipe" in AllItems.items[item_name]:
			if (AllItems.items[item_name]["recipe"][0] == Global.niko_inventory[Global.niko_equipped_item_index] && \
				AllItems.items[item_name]["recipe"][1] == Global.niko_inventory[Global.niko_inventory_selector_index]) || \
				(AllItems.items[item_name]["recipe"][1] == Global.niko_inventory[Global.niko_equipped_item_index] && \
				AllItems.items[item_name]["recipe"][0] == Global.niko_inventory[Global.niko_inventory_selector_index]):
				
				
				Global.niko_inventory[Global.niko_equipped_item_index] = ""
				Global.niko_inventory[Global.niko_inventory_selector_index] = ""
				
				Global.niko_inventory = Global.niko_inventory.filter(func(item): return item != "")

				
				add_item(item_name)
				
				rebuild_inventory()
				return
	
	print("can't combine item")


func _get_input() -> void:
	if Input.is_action_just_pressed("inventory_open") && Global.dialog_finished:
		if !Global.niko_inventory_opened:
			get_tree().paused = true
			inventory_open.play()
		else:
			get_tree().paused = false
			inventory_close.play()
		
		Global.niko_inventory_opened = !Global.niko_inventory_opened
	
	if Input.is_key_pressed(KEY_SPACE):
		add_item(["lightbulb", "floppy disk"][randi() % 2])
	
	if Global.niko_inventory_opened && !Global.niko_inventory.is_empty():
		if Input.is_action_just_pressed("inventory_select"):
			inventory_selector_select.play()
			# combining items
			if Global.niko_inventory_selector_index != Global.niko_equipped_item_index && \
			   Global.niko_equipped_item_index != -1:
				_combine_item()
			else:
				equip_item(Global.niko_inventory_selector_index)
		
		if Input.is_action_just_pressed("inventory_right"):
			_change_selector_index(Global.niko_inventory_selector_index + 1)
			
		elif Input.is_action_just_pressed("inventory_left"):
			_change_selector_index(Global.niko_inventory_selector_index - 1)
			
		elif Input.is_action_just_pressed("inventory_up"):
			_change_selector_index(Global.niko_inventory_selector_index - 2)
			
		elif Input.is_action_just_pressed("inventory_down"):
			_change_selector_index(Global.niko_inventory_selector_index + 2)
