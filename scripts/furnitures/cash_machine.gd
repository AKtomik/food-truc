class_name CashMachine
extends Node3D

@export var starting_money: int = 100
@export var lose_amount : int = 0
@export var win_amount : int = 1000
@export var label : Label3D
@export var mana : GameManager
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
	
	if (_money < lose_amount):
		mana.to_bad_ending()
		return

	if (_money >= win_amount):
		mana.to_good_ending()
		return

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
