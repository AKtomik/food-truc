class_name PaintPot
extends ItemTool

@export var inkable_item: ItemResource
@export var inked_item: ItemResource
@export var hand: Hand

func can_put(item: Item) -> bool:
	return inkable_item.is_scene(item)

func can_take(_item: Item) -> bool:
	return false

func put(item: Item) -> bool:
	if (inkable_item.is_scene(item)):
		hand.switch_hand_to(inked_item)
		#item.queue_free()
	return false

func take() -> Item:
	push_error("can't take anything in trash")
	return Item.new()
