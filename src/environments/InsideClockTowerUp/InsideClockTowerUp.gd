extends Node2D

@onready var niko: CharacterBody2D = $Ysort/Niko
@onready var camera: Camera2D = $Ysort/Niko/Camera2D


func _ready() -> void:
	camera.limit_left = -125
	camera.limit_right = 125
	camera.limit_top = -110
	camera.limit_bottom = 125
