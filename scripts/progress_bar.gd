extends Control

@export var p_bar: ProgressBar
@export var money_text : RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	p_bar.value = 5.0
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func remove_star(remove: float) -> void:
	p_bar.value -= remove

func add_money(money : float) -> void:
	money_text.value += money
	money_text.update_text()
