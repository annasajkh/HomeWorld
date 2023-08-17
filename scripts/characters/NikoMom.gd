extends CharacterBody2D

@export var speed: int = 50

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

var _move_direction: Vector2 = Vector2()

var all_directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]

func _ready() -> void:
	randomize()

func reset_animation() -> void:
	animation.stop()
	animation.frame = 0

func _get_input() -> void:
	if _move_direction.y == -1:
		animation.play("walk_up")
	elif _move_direction.x == - 1:
		animation.play("walk_left")
	elif _move_direction.x == 1:
		animation.play("walk_right")
	elif _move_direction.y == 1:
		animation.play("walk_down")
	else:
		reset_animation()

func _physics_process(delta: float) -> void:
	_get_input()
	
	_move_direction = _move_direction.normalized()
	
	var result: KinematicCollision2D = move_and_collide(_move_direction * speed * delta)
	
	if result:
		reset_animation()


func _on_Timer_timeout() -> void:
	var random_direction = all_directions[randi() % len(all_directions)]
	
	_move_direction = Vector2(random_direction[0], random_direction[1])
	pass
