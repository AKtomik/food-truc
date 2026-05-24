class_name GameManager
extends Node3D

@export var cam : SlideCamera
@export var hand : Hand
@export var typewriter_label : TypeWriter

@onready var phone_stream : AudioStreamPlayer = %PhoneAudioStream

func _ready() -> void:
	_stop_time()
	phone_stream.stream = load("res://assets/sounds/ringtone.mp3")
	phone_stream.stream.loop = true
	phone_stream.play()

func _process(_delta: float) -> void:
	pass

func _stop_time():
	Engine.time_scale = 0

func _start_time():
	Engine.time_scale = 1

func start_game():
	phone_stream.stop()	
	cam.set_enable_move(true)# can be delayed in anim
	hand.set_enable_click(true)# can be delayed in anim
	_start_time()
