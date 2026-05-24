extends Button

@export var camera: Camera3D

var _is_right: bool = true  # commence à droite

func _ready() -> void:
	_update_position()
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	if _is_right:
		Input.action_press("sidestep_right")
		Input.action_release("sidestep_right")
	else:
		Input.action_press("sidestep_left")
		Input.action_release("sidestep_left")

func notify_move_done() -> void:
	_is_right = !_is_right
	_update_position()
	visible = true

func notify_started_moving() -> void:
	visible = false


func _update_position() -> void:
	if _is_right:
		anchor_left = 1.0
		anchor_right = 1.0
		anchor_top = 0.5
		anchor_bottom = 0.5
		offset_left = -size.x
		offset_right = 0.0
	else:
		anchor_left = 0.0
		anchor_right = 0.0
		anchor_top = 0.5
		anchor_bottom = 0.5
		offset_left = 0.0
		offset_right = size.x
