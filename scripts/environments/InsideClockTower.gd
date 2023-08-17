extends Node

@onready var niko: CharacterBody2D = $Node2D/Niko
@onready var camera: Camera2D = $Node2D/Niko/Camera2D


func _ready() -> void:
	camera.limit_left = -367
	camera.limit_right = 367
	camera.limit_top = -110
	camera.limit_bottom = 125
