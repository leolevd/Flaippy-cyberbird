extends CharacterBody2D

@onready var evolution: Node = get_tree().current_scene.get_node("Evolution")
const JUMP_VELOCITY = -80.0
const GRAVITY = 300.0
var braindead = true
var brain: AI
func _ready() -> void:
	if braindead:
		print("BRAINDEAD")

var alive = true
var was_flapping := false

var fitness: float = 0.0
var lifetime: float = 0.0


func die():
	if not alive:
		return
	alive = false
	fitness = lifetime
	velocity = Vector2.ZERO
	set_physics_process(false)
	evolution.bird_died(self)
	$Sprite2D.visible = false

func decide():
	var next_pipe_set: Node2D
	var shortest_distance := INF
	for pipe_set in get_tree().get_nodes_in_group("pipeset"):
		if pipe_set is Node2D:
			var distance_to_pipe = pipe_set.global_position.x - global_position.x
			if distance_to_pipe >= 0.0 and distance_to_pipe < shortest_distance:
				next_pipe_set = pipe_set
				shortest_distance = distance_to_pipe

	if next_pipe_set == null:
		return

	var inputs = [
		(next_pipe_set.global_position.x - global_position.x) / 200.0,
		global_position.y / 50.0,
		next_pipe_set.global_position.y / 50.0,
		velocity.y / 100.0,
	]
	if braindead:
		return
	var should_flap: bool = brain.prediction(inputs)
	if should_flap and not was_flapping:
		velocity.y = JUMP_VELOCITY
	was_flapping = should_flap

func _physics_process(delta: float) -> void:
	lifetime += delta
	if not braindead:
		decide()

	velocity.y += GRAVITY * delta

	
	if Input.is_action_just_pressed("cyberbird_jump") and braindead:
		velocity.y = JUMP_VELOCITY
	move_and_slide()
