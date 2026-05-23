class_name CashMachine
extends Node3D

@export var starting_money: int = 100
var _money: int = 100

func _ready() -> void:
	_money = starting_money
	refresh()

func refresh():
	# update the 3D label
	pass

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
