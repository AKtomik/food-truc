extends RichTextLabel

@export var value: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = 1000
	update_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_text() -> void:
	text = 	str(value) + "$"
