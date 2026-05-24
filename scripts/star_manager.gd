class_name StarManager
extends Control

@export var p_bar: ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	p_bar.value = 5.0
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func remove_star(remove: float) -> void:
	p_bar.value -= remove
	# TODO: lose condition
