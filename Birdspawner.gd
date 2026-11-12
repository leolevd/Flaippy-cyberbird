extends Node
const CYBERBIRD: PackedScene = preload("uid://buhfre50u7ae2")


func create_birds(population: Array):
	for brain in population:
		var brid = CYBERBIRD.instantiate()
		brid.brain = brain
		brid.braindead = false
		get_parent().add_child.call_deferred(brid)
		brid.global_position = Vector2(0, 0)
