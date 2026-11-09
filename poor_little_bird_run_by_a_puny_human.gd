extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var GRAVITY = 300

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta

	
	if Input.is_action_just_pressed("cyberbird_jump"):
		velocity.y = JUMP_VELOCITY
	move_and_slide()
