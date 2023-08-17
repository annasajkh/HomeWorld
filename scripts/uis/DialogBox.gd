extends Control

@export var char_per_seconds: float = 30

@onready var text_entry: Label = $TextEntry
@onready var speak_delay: Timer = $SpeakDelay
@onready var face_icon: TextureRect = $FaceIcon
@onready var dialog_sound: AudioStreamPlayer = $DialogSound
@onready var dialog: Array = []

var _current_dialog_index: int = 0
var _conversation_finished: bool = false
var _dialog_paused: bool  = false


func play(dialog_name: String) -> void:
	Global.dialog_finished = false
	
	_current_dialog_index = 0
	
	dialog = AllDialogs.dialogs[dialog_name]
	
	visible = true
	_set_next_text()


func _set_next_text() -> void:
	if _current_dialog_index > len(dialog) - 1:
		speak_delay.stop()
		visible = false
		Global.dialog_finished = true

		return
	
	text_entry.visible_characters = 0
	text_entry.text = dialog[_current_dialog_index][1]
	
	face_icon.texture = load("res://assets/textures/faces/%s.png" % dialog[_current_dialog_index][0])
	_current_dialog_index += 1
	
	speak_delay.wait_time = text_entry.text.length() / (text_entry.text.length() * char_per_seconds)
	speak_delay.start()


func _on_SpeakDelay_timeout() -> void:
	text_entry.visible_characters += 1
	
	if text_entry.visible_characters < text_entry.text.length() - 4:
		if !dialog_sound.playing:
			dialog_sound.play()
	
	if text_entry.visible_characters == text_entry.text.length():
		speak_delay.stop()
		_conversation_finished = true
		return

func _ready() -> void:
	visible = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") && _conversation_finished:
		_set_next_text()
		_conversation_finished = false
	
	if Input.is_action_just_pressed("ui_accept") && _dialog_paused:
		speak_delay.start()
		_dialog_paused = false
