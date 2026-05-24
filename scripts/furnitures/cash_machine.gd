class_name CashMachine
extends Node3D

@export var starting_money: int = 100
@export var label : Label3D
var _money: int = 100
var _max_digits : int = 15

func _ready() -> void:
	_money = starting_money
	refresh()

func refresh():
	var str_amount = "%d" % _money

	if str_amount.length() > _max_digits:
		label.text = str_amount.substr(0, _max_digits) + "..." + "$"
	else:
		label.text = "%.2f$" % _money 

func get_money() -> int:
	return _money
	
func _set_money(value: int):
	_money = value
	refresh()
	
func earn(value: int):
	_money += value
	refresh()
	
func pay(value: int):
	_money -= value
	refresh()
