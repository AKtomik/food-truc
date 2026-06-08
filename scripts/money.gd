class_name money

# for now, money is fully managed on cash_machine.gd
static var _value = 0

static func get_money() -> int:
	return _value
	
static func set_money(value: int):
	_value = value
	
static func reset() -> void:
	_value = 0
