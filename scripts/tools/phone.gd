class_name ItemTool
extends Area3D

@export var game_manager: GameManager

func can_put(_item: Item) -> bool:
	clicked()
	return false#dont touch!

func can_take(_item: Item) -> bool:
	clicked()
	return false#dont touch!
	
func clicked():
	print("i clicked on the phone WOW")
