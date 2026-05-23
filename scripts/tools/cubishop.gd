class_name Cubishop
extends ItemTool

@export var item_scene: PackedScene
@export var price: int
@export var money_manager: CashMachine

func can_put(_item: Item) -> bool:
	return false

func can_take(_item: Item) -> bool:
	return money_manager.get_money()

func put(_item: Item) -> bool:
	push_error("should not be called here")
	return false

func take() -> Item:
	money_manager.pay(price)
	var item = item_scene.instantiate()
	add_child(item)
	return item