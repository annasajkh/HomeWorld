extends CharacterBody2D

@export var speed: int = 10

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = $Camera2D
@onready var dialog_box: Node = $"../../UserInterface/DialogBox"
@onready var door_trigger_delay: Timer = $DoorTriggerDelay

var freezed: bool = false

var move_direction: Vector2 = Vector2()

func _ready() -> void:
	if Global.niko_go_back:
		position = Global.niko_inital_position
		move_direction = Global.niko_inital_move_direction 
		
		if move_direction.x == -1:
			animation.play("walk_left")
		elif move_direction.x == 1:
			animation.play("walk_right")
		elif move_direction.y == -1:
			animation.play("walk_up")
		elif move_direction.y == 1:
			animation.play("walk_down")

func reset_animation() -> void:
	animation.stop()
	animation.frame = 0

func _get_input() -> void:
	if Input.is_action_pressed("walk_left"):
		animation.play("walk_left")
		move_direction.x = -1
	elif Input.is_action_pressed("walk_right"):
		animation.play("walk_right")
		move_direction.x = 1
	elif Input.is_action_pressed("walk_up"):
		animation.play("walk_up")
		move_direction.y = -1
	elif Input.is_action_pressed("walk_down"):
		animation.play("walk_down")
		move_direction.y = 1
	else:
		reset_animation()

func _physics_process(delta: float) -> void:
	if !freezed:
		move_direction.x = 0
		move_direction.y = 0
		
		if Global.dialog_finished:
			_get_input()
			
			if door_trigger_delay.is_stopped():
				door_trigger_delay.start()
		
		move_direction = move_direction.normalized()
		
		var result: KinematicCollision2D = move_and_collide(move_direction * speed * delta)
		
		if result || !Global.dialog_finished:
			reset_animation()
	else:
		reset_animation()


func _on_DoorTriggerDelay_timeout() -> void:
	Global.door_trigger_already_triggered = false
