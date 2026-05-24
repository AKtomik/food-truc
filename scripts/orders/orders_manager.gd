class_name OrdersManager
extends Node

@export var star_manager: StarManager
@export var character_queue: CharacterQueue
@export var face_picker : FacePicker
@export var money_manager: CashMachine
@export var order_resources: Array[OrderResource]
@export var order_container: Control
@export var packed_order: PackedScene

@export var order_wait_time: float = 20
@export var order_never_empty: bool = true

@export var FAIL_NORMAL_UNSTAR: float = .25
@export var FAIL_INSPECTOR_UNSTAR: float = 1

# store
var order_list: Array[Order] = []
var moved_order_last: Order = null
var next_order: float = -1

func last_order() -> Order:
	if (order_list.is_empty()): return null
	return order_list[0]

# loop
func _ready() -> void:
	new_order(order_resources.pick_random())
	next_order = order_wait_time * 2

func _process(delta: float) -> void:
	# expiration
	var expired_order = []
	for order in order_list:
		order.time_remain -= delta
		if (order.time_remain <= 0):
			expired_order.append(order)
	if (!expired_order.is_empty()):
		for order in expired_order:
			fail_order(order)
			remove_order(order)
		check_move_next()
	
	# creation
	next_order -= delta
	if (next_order < 0 || order_never_empty && order_list.is_empty()):
		new_order(order_resources.pick_random())
		next_order = order_wait_time
	

# create
func new_order(new_order_resource: OrderResource) -> void:
	print("add a new order!", new_order_resource)
	var new_order_instance = packed_order.instantiate() as Order
	var inspection = false
	var new_character = character_queue.generate_random_character(new_order_resource, inspection)
	new_order_instance.setup(new_order_resource, new_character, inspection)

	order_container.add_child(new_order_instance)
	order_container.move_child(new_order_instance, 0)
	order_list.append(new_order_instance)
	check_move_next()

func check_move_next():# do that each time you edit order_list
	if (order_list.is_empty()): return
	var now_order_last = last_order()
	if (moved_order_last == now_order_last): return
	moved_order_last = now_order_last
	moved_order_last.character_body.play_arrive()

# finish
func given_food(item: Item) -> void:
	print("given food to first order:", item)
	var order = last_order()
	var happy = order.given_happy(item)
	if (happy):
		successful_order(order)
	else:
		fail_order(order)
	remove_order(order)

func successful_order(order: Order) -> void:
	print("successful order:", order)
	money_manager.pay(order.resource.price)

func fail_order(order: Order) -> void:
	print("fail order:", order)
	var tige = FAIL_INSPECTOR_UNSTAR if (order.is_inspector) else FAIL_NORMAL_UNSTAR
	star_manager.remove_star(tige)

func remove_order(order: Order) -> void:
	order.character_body.play_go()
	#order.character_body = null
	order_list.remove_at(order_list.find(order))
	order.queue_free()
	check_move_next()
