class_name CashMachine
extends Node3D

@export_category("values")
@export var starting_money: int = 100
@export var lose_amount : int = 0
@export var win_amount : int = 1000

@export_category("links")
@export var label : Label3D
@export var mana : GameManager

@export_category("makeup")
@export var happy_color : Color
@export var angry_color : Color
@export var netral_color : Color
@export var default_color : Color

var _money: int = 100
var _max_digits : int = 15

func _ready() -> void:
	_money = starting_money
	refresh()
	satisfaction(MoneySatisfaction.NETRAL_COOKING)

func refresh():
	money.set_money(_money)
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

func satisfaction(value: MoneySatisfaction):
	match value:
		MoneySatisfaction.ANGRY_CLIENT:
			label.modulate = angry_color
		MoneySatisfaction.HAPPY_CLIENT:
			label.modulate = happy_color
		MoneySatisfaction.NETRAL_COOKING:
			label.modulate = netral_color
		_:
			label.modulate = default_color

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

enum MoneySatisfaction {
	HAPPY_CLIENT,
	ANGRY_CLIENT,
	NETRAL_COOKING,
}