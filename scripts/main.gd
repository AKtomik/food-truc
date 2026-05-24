class_name GameManager
extends Node3D

@export var typewriter_label : TypeWriter

func _ready() -> void:
	randomize()
	typewriter_label.display("Eh, c'est moi. Écoute bien.")

func _process(_delta: float) -> void:
	pass
