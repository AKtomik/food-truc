class_name GameManager
extends Node3D

@export var cam : SlideCamera
@export var hand : Hand
@export var typewriter_label : TypeWriter
@export var face_picker : FacePicker

@onready var audio_player : AudioStreamPlayer = %PhoneAudioStream

func _ready() -> void:
	face_picker.setup()
	_stop_time()
	audio_player.stream = load("res://assets/sounds/ringtone.mp3")
	audio_player.stream.loop = true
	audio_player.play()

func _process(_delta: float) -> void:
	pass

func _stop_time():
	Engine.time_scale = 0

func _start_time():
	Engine.time_scale = 1

func start_game():
	audio_player.stop()	
	audio_player.stream =  load("res://assets/sounds/Main_theme.mp3")
	audio_player.stream.loop = true
	audio_player.play()
	cam.set_enable_move(true)# can be delayed in anim
	hand.set_enable_click(true)# can be delayed in anim
	_start_time()
