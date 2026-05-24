extends Camera3D

@export var speed: float = 5
@export var point_a: Node3D
@export var point_b: Node3D

@onready var progress_bar = %StarManager
@onready var sidestep_button = %SidestepButton
var _velocity: Vector3 = Vector3.ZERO
var _timer: float = 0.0
var _hasmoved: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	 # Replace with function body.
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("sidestep_left") and _timer <= 0.0 and _hasmoved :
		sidestep_button.notify_started_moving()
		_move()
		
	if Input.is_action_just_pressed("sidestep_right") and _timer <= 0.0 and !_hasmoved :
		sidestep_button.notify_started_moving()
		_move()
	
	if (Input.is_action_just_pressed("ui_down")) :
		progress_bar.remove_star(1)
	if (Input.is_action_just_pressed("ui_up")) :
		progress_bar.remove_star(-1)
	
	if _timer > 0.0:
		_timer -= _delta
		global_position += _velocity * _delta
		if _timer <= 0.0:
			sidestep_button.notify_move_done()

func _move() -> void:
	var direction: Vector3
	var distance: float = point_a.global_position.distance_to(point_b.global_position)

	if (_hasmoved):
		direction = (point_a.global_position - point_b.global_position).normalized()
	else :
		direction = (point_b.global_position - point_a.global_position).normalized()
	_velocity = direction * speed
	_timer = distance / speed
	_hasmoved = !_hasmoved
