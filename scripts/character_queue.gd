class_name CharacterQueue
extends Node3D

@export var mesh_library: CharacterMeshLibrary
@export var face_picker: FacePicker

var hat_chance : int = 25
var hair_chance : int = 80
var eyes_chance : int = 25
var mouth_chance : int = 25
var neck_chance : int = 25
var jacket_chance : int = 80
var face_hair_chance : int = 100

func generate_random_character(order_resource : OrderResource, critique : bool) -> CharacterBody:
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
	if (random.randi_range(1, 100) <= face_hair_chance) :
		def.face_hair_mesh = mesh_library.face_hair_meshes.pick_random()
	return CharResourcesSpawner.spawn(def, self, critique, face_picker, order_resource) # TODO gérer false ou true 
