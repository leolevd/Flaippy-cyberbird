extends CharacterBody2D

const SAFETIME = 2
const JUMP_VELOCITY = -80.0
const GRAVITY = 300.0
var lifetime = 0
var timer2 = 0
func die():
	queue_free()
func _physics_process(delta: float) -> void:
	timer2 += delta
	velocity.y += GRAVITY * delta
	lifetime += delta
	$"../CanvasLayer/HUD/Tohide/Punyscore".text = str(round(lifetime * 100) / 100)
	
	if Input.is_action_just_pressed("cyberbird_jump"):
		velocity.y = JUMP_VELOCITY
	move_and_slide()
