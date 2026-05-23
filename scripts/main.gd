extends Node3D

@export var chara_scene : Node3D
@export var mesh_library: CharacterMeshLibrary
@export var face_picker: FacePicker
var hat_chance : int = 25
var hair_chance : int = 80
var eyes_chance : int = 25
var mouth_chance : int = 25
var neck_chance : int = 25
var jacket_chance : int = 80

func _ready() -> void:
	randomize()
	generate_random_character(self, false)

func _process(delta: float) -> void:
	pass


func generate_food_queue() -> void :
		pass

func generate_random_character(parent: Node3D, critique : bool) -> Node3D:
	var def = CharacterResource.new()
	var random : RandomNumberGenerator = RandomNumberGenerator.new() 
	
	if (random.randi_range(1, 100) <= hat_chance) :
		def.hat_mesh = mesh_library.hat_meshes.pick_random()
	if (random.randi_range(1, 100) <= hair_chance) :
		def.hair_mesh = mesh_library.hair_meshes.pick_random()
	if (random.randi_range(1, 100) <= eyes_chance) :
		def.eyes_mesh = mesh_library.eyes_meshes.pick_random()
	if (random.randi_range(1, 100) <= mouth_chance) :
		def.mouth_mesh = mesh_library.mouth_meshes.pick_random()
	if (random.randi_range(1, 100) <= neck_chance) :
		def.neck_mesh = mesh_library.neck_meshes.pick_random()
	if (random.randi_range(1, 100) <= jacket_chance) :
		def.jacket_mesh = mesh_library.jacket_meshes.pick_random()
	return CharResourcesSpawner.spawn(def, parent, critique, face_picker) # TODO gérer false ou true 
