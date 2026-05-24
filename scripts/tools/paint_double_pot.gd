class_name PaintDoublePot
extends ItemTool

@export var inkable_item1: ItemResource
@export var inked_item1: ItemResource

@export var inkable_item2: ItemResource
@export var inked_item2: ItemResource

@export var hand: Hand

func can_put(item: Item) -> bool:
	return inkable_item1.is_scene(item) || inkable_item2.is_scene(item)

func can_take(_item: Item) -> bool:
	return false

func put(item: Item) -> bool:
	if (inkable_item1.is_scene(item)):
		hand.switch_hand_to(inked_item1)
	if (inkable_item2.is_scene(item)):
		hand.switch_hand_to(inked_item2)
		#item.queue_free()
	return false

func take() -> Item:
	push_error("can't take anything in trash")
	return Item.new()
