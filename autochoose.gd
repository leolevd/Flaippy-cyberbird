extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var anim = str(randi_range(1, 3))
	play(anim)
