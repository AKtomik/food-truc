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
	if (game_manager.tuto_order_count != 3) :
		return
	collision.disabled = true# works once
	game_manager.tutorial_critique()
