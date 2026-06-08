extends Button

@export var mana : GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(on_click)

func on_click() -> void:
	mana.start()
