class_name OrdersManager
extends Node

@export_category("pointers")
@export var star_manager: StarManager
@export var character_queue: CharacterQueue
@export var face_picker: FacePicker
@export var money_manager: CashMachine
@export var packed_order: PackedScene
@export var ticket_container: Control

@export_category("resources")
@export var inital_resources: Array[OrderResource]
@export var unlock_turn_resources: Dictionary[int, OrderResource]

@export_category("orders")
@export var order_generate_delay: float = 20
@export var order_never_empty: bool = true

@export_category("inspection")
@export var INSPECTION_TURN_DELAY_MIN_INC: int = 4
@export var INSPECTION_TURN_DELAY_MAX_INC: int = 9
@export var INSPECTION_FIRST_DELAY: int = 3

@export_category("stars")
@export var FAIL_NORMAL_UNSTAR: float = .25
@export var FAIL_INSPECTOR_UNSTAR: float = 1

# -- store --

var aviable_resources: Array[OrderResource]

var order_list: Array[Order] = []
var moved_order_last: Order = null

var total_client_count: int = 0
var total_inspection_count: int = 0

var next_client_time: float = -1
var next_inspection_turn_count: int

func last_order() -> Order:
	if (order_list.is_empty()): return null
	return order_list[0]

# call that each time you edit order_list
func check_move_next():
	if (order_list.is_empty()): return
	var now_order_last = last_order()
	if (moved_order_last == now_order_last): return
	moved_order_last = now_order_last
	moved_order_last.character_body.play_arrive()

# -- difficulty --

# get an aoppropriated random resource
# TODO: is affected by turns count
func get_random_resource() -> OrderResource:
	return aviable_resources.pick_random()

func check_turn_unlock_resource(turn: int):
	var resource = unlock_turn_resources.get(turn)
	if (!resource): return
	aviable_resources.append(resource)

# check if should trigger inspection
func is_inspection_turn() -> bool:
	return next_inspection_turn_count <= 0
	# dont forget to call count_client(true) just after!

# called when client is going in, return if is an insp
func count_client(inspection: bool = false):
	total_client_count += 1
	check_turn_unlock_resource(total_client_count)

	next_inspection_turn_count -= 1
	if (inspection):
		total_inspection_count += 1
		next_inspection_turn_count = randi_range(INSPECTION_TURN_DELAY_MIN_INC, INSPECTION_TURN_DELAY_MAX_INC)

# called when client is going out
func count_service(success: bool = false):#inspection: bool = false
	if (!success):
		return
	
# -- loop --

func _ready() -> void:
	aviable_resources = inital_resources
	next_inspection_turn_count = INSPECTION_FIRST_DELAY
	generate_order()
	next_client_time = order_generate_delay * 2

func _process(delta: float) -> void:
	# expiration
	var expired_order = []
	for order in order_list:
		order.time_remain -= delta
		if (order.time_remain <= 0):
			expired_order.append(order)
	if (!expired_order.is_empty()):
		for order in expired_order:
			finish_order(order, false)
		check_move_next()
	
	# creation
	next_client_time -= delta
	if (next_client_time < 0 || order_never_empty && order_list.is_empty()):
		generate_order()
		next_client_time = order_generate_delay
	

# -- create --

# legit order (do that if not in cinematic)
func generate_order() -> void:
	print("generate an order, aviable:", aviable_resources.size(), " next_inspection:", next_inspection_turn_count)
	call_order(get_random_resource(), is_inspection_turn())

# special function if you want an order to never expire
func call_infinite_order(new_order_resource: OrderResource, inspection: bool = false) -> void:
	call_order(new_order_resource, inspection, 1.79769e308)

# build your own order on order
func call_order(new_order_resource: OrderResource, inspection: bool = false, time_scale: float = 1) -> void:
	print("add a new order!", new_order_resource)
	var new_order_instance = packed_order.instantiate() as Order
	var new_character = character_queue.generate_random_character(new_order_resource, inspection)
	new_order_instance.setup(new_order_resource, new_character, inspection, time_scale)

	ticket_container.add_child(new_order_instance)
	ticket_container.move_child(new_order_instance, 0)
	order_list.append(new_order_instance)
	check_move_next()

	count_client(inspection)

# -- finish --

func given_food(item: Item) -> void:
	print("given food to first order:", item)
	var order = last_order()
	var happy = order.given_happy(item)
	finish_order(order, happy)

func finish_order(order: Order, success: bool) -> void:
	if (success):
		_successful_order(order)
	else:
		_fail_order(order)

	order.character_body.play_quit()
	#order.character_body = null
	order_list.remove_at(order_list.find(order))
	order.queue_free()
	check_move_next()

	count_service(success)

func _successful_order(order: Order) -> void:
	print("successful order:", order)
	money_manager.pay(order.resource.price)

func _fail_order(order: Order) -> void:
	print("fail order:", order)
	var tige = FAIL_INSPECTOR_UNSTAR if (order.is_inspector) else FAIL_NORMAL_UNSTAR
	star_manager.remove_star(tige)
