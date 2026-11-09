extends Node2D
var pipetimer = 2.0
const PIPE_RESET = 1.2
const PIPESET: PackedScene = preload("uid://ba78a5gx317ju")

func _ready() -> void:
	emit_pipe()

func reset_for_generation() -> void:
	for pipe_set in get_tree().get_nodes_in_group("pipeset"):
		pipe_set.remove_from_group("pipeset")
		pipe_set.queue_free()
	pipetimer = 0.0
	emit_pipe()

func _physics_process(delta: float) -> void:
	if pipetimer < PIPE_RESET:
		pipetimer += delta
	else:
		pipetimer = 0
		emit_pipe()
func emit_pipe():
	var pipes: Node2D = PIPESET.instantiate()
	get_parent().add_child(pipes)
	pipes.global_position.x = global_position.x
	pipes.global_position.y = global_position.y + randi_range(-10, 10)
