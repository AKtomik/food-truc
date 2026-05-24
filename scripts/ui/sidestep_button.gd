extends Button

var _is_right: bool = true  # commence à droite
var image = load("res://assets/Icons/ui_fleche.png") as Texture2D
var flipped : Texture2D

func _ready() -> void:
	var img = image.get_image()
	img.flip_x()
	flipped = ImageTexture.create_from_image(img)
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
		offset_left = -(size.x * scale.x)  # tient compte du scale
		offset_top = -(size.y * scale.y) / 2.0
		offset_bottom = (size.y * scale.y) / 2.0
		icon = image
	else:
		anchor_left = 0.0
		anchor_right = 0.0
		anchor_top = 0.5
		anchor_bottom = 0.5
		offset_left = 0.0
		offset_right = size.x * scale.x
		offset_top = -(size.y * scale.y) / 2.0
		offset_bottom = (size.y * scale.y) / 2.0
		icon = flipped
