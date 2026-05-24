class_name StartPhone
extends ItemTool

@export var game_manager: GameManager
@export var collision: CollisionShape3D

func can_put(_item: Item) -> bool:
	clicked()
	return false#dont touch!

func can_take(_item: Item) -> bool:
	clicked()
	return false#dont touch!
	
func clicked():
	print("i clicked on the phone WOW")
	collision.disabled = true# works once
	game_manager.start_game()
