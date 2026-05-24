class_name TypeWriter
extends Label

@export var type_speed: float = 0.05
@export var erase_speed: float = 0.03
@export var hold_duration: float = 2.0

var _full_text: String = ""
var _tween: Tween

func display(message: String) -> void:
	_full_text = message
	text = ""
	visible = true
	
	if _tween:
		_tween.kill()
	
	_tween = create_tween()
	
	# Affiche lettre par lettre
	for i in _full_text.length():
		_tween.tween_callback(func(): text = _full_text.substr(0, text.length() + 1))
		_tween.tween_interval(type_speed)
	
	# Attend
	_tween.tween_interval(hold_duration)
	
	# Efface lettre par lettre
	_tween.tween_callback(func(): _erase_step())
	
func _erase_step() -> void:
	if text.length() == 0:
		visible = false
		return
	text = text.substr(0, text.length() - 1)
	await get_tree().create_timer(erase_speed).timeout
	_erase_step()
