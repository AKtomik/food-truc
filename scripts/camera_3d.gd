extends Camera3D

@export var impulse_duration: float = 0.2
@export var speed: float = 5
@export var point_a: Node3D
@export var point_b: Node3D

@onready
var progress_bar = %ProgressBar
var _velocity: Vector3 = Vector3.ZERO
var _timer: float = 0.0
var _hasmoved: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	 # Replace with function body.
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("sidestep") and _timer <= 0.0 :  # Barre espace par défaut
		_move()
	
	if (Input.is_action_just_pressed("ui_down")) :
		progress_bar.remove_star(1)
	if (Input.is_action_just_pressed("ui_up")) :
		progress_bar.remove_star(-1)
	
	if _timer > 0.0:
		_timer -= delta
		global_position += _velocity * delta

func _move() -> void:
	var direction: Vector3
	
	if (_hasmoved):
		direction = (point_a.position - point_b.position).normalized()
	else :
		direction = (point_b.position - point_a.position).normalized()
	_velocity = direction * speed
	_timer = impulse_duration
	_hasmoved = !_hasmoved
