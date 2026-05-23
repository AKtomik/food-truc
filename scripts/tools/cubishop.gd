class_name Cubishop
extends ItemTool

@export var item_resource: ItemResource
@export var price: int
@export var money_manager: CashMachine

func can_put(_item: Item) -> bool:
	return false

func can_take(_item: Item) -> bool:
	return money_manager.get_money()

func put(_item: Item) -> bool:
	push_error("can't put anything in cubishop")
	return false

func take() -> Item:
	money_manager.pay(price)
	var item = item_resource.model_scene.instantiate()
	add_child(item)
	return item
