extends Node3D

@export var camera: Camera3D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("take"):
		print("click")
	return
