extends Area2D

@export var dialog_name: String
@export var auto_triggered: bool = false
@export var one_shot: bool = false

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var dialog_trigger_delay: Timer = $DialogTriggerDelay
@onready var dialog_box: Control

func _ready() -> void:
	dialog_box = get_tree().get_root().get_children()[-1].get_node("UserInterface/DialogBox")


var niko: CharacterBody2D
var already_executed: bool = false


func _process(_delta: float) -> void:
	if !collision_shape.disabled && !already_executed:
		if Input.is_action_just_pressed("ui_accept") || auto_triggered:
			if niko != null && Global.dialog_finished:
				dialog_box.play(dialog_name)
				
				if one_shot:
					collision_shape.disabled = true
				
				already_executed = true
	
	if !Global.dialog_finished:
		dialog_trigger_delay.start()


func _on_DialogTrigger_body_entered(body: Node) -> void:
	if body.name == "Niko" && body is CharacterBody2D:
		niko = body


func _on_DialogTrigger_body_exited(body: Node) -> void:
	if body.name == "Niko" && body is CharacterBody2D:
		niko = null


func _on_DialogTriggerDelay_timeout():
	already_executed = false
