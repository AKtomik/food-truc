class_name GameManager
extends Node3D

@export var typewriter_label : TypeWriter

func _ready() -> void:
	_stop_time()
	typewriter_label.display("Test..........", load("res://assets/2019-10-03-16-47-21.mp3"))

func _process(_delta: float) -> void:
	pass

func _stop_time():
	Engine.time_scale = 0

func _start_time():
	Engine.time_scale = 1

func start_game():
	# other game launch instructions
	_start_time()
