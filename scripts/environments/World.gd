extends Node2D

#onready var dialog_box: Node = $DialogBox
#onready var niko: KinematicBody2D = $YSort/Niko
#onready var camera: Camera2D = $YSort/Niko/Camera2D

#func _process(_delta: float) -> void:
#	dialog_box.global_position.x = camera.get_camera_screen_center().x
#	dialog_box.global_position.y = camera.get_camera_screen_center().y + 64
