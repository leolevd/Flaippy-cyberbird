extends Node2D


const SPEED = -50.0
func _process(delta: float) -> void:
	global_position.x += SPEED * delta
	if global_position.x < -50:
		queue_free()
