class_name GameManager
extends Node3D

@export var cam : SlideCamera
@export var hand : Hand
@export var typewriter_label : TypeWriter

func _ready() -> void:
	_stop_time()

func _process(_delta: float) -> void:
	pass

func _stop_time():
	Engine.time_scale = 0

func _start_time():
	Engine.time_scale = 1

func start_game():
	cam.set_enable_move(true)# can be delayed in anim
	hand.set_enable_click(true)# can be delayed in anim
	_start_time()
