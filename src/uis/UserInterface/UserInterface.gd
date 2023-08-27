extends CanvasLayer

@onready var fade_animation: AnimationPlayer = $FadeAnimation
@onready var fade_texture: TextureRect = $FadeTexture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fade_texture.texture = load("res://assets/textures/uis/fade_texture.png")
	fade_animation.play("fade_out")
	
	Global.fade_animation = fade_animation
