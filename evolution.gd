extends Node

const POPULATION_SIZE = 150
const ELITE_COUNT = 10
@onready var populationNode: Node = $"../population"
@onready var pipe_emitter: Node = $"../Node2D"
var population: Array = []
var generation := 1
var bestfitnesses = []

func _ready():
	print("1. Evolution ready")
	for i in range(POPULATION_SIZE):
		population.append(AI.new())

	print("2. Brains: ", population.size())
	print("3. Population node: ", populationNode)

	populationNode.create_birds(population)

	print("4. Creation function called")
var dead_birds: Array = []


func bird_died(bird):
	dead_birds.append(bird)
	if dead_birds.size() >= POPULATION_SIZE:
		evolve(dead_birds)

func evolve(previous_generation: Array):
	previous_generation.sort_custom(func(left, right): return left.fitness > right.fitness)
	var best_brain: AI = previous_generation[0].brain
	print("Generation %d | best survival: %.2f seconds" % [generation, previous_generation[0].fitness])
	for bird in previous_generation:
		bird.queue_free()
	bestfitnesses.append(round(previous_generation[0].fitness*100)/100)
	print(bestfitnesses)
	$"../CanvasLayer/HUD/Cyberscore".text = str(round(previous_generation[0].fitness * 100) / 100)
	var elite_brains: Array[AI] = []
	for i in range(min(ELITE_COUNT, previous_generation.size())):
		elite_brains.append(previous_generation[i].brain)
	
	if previous_generation[0].fitness > 60 * 60:
		var file = FileAccess.open("user://top_ai.ai", FileAccess.WRITE)
		if file:
			file.store_var(elite_brains[0], true)
			file.close()
			get_tree().quit(3)
	elif generation % 25 == 0:
		var file = FileAccess.open("user://top_ai.ai", FileAccess.WRITE)
		if file:
			file.store_var(elite_brains[0], true)
			file.close()

	var new_population: Array = []
	
	# Elite preservation
	for i in range(ELITE_COUNT):
		var elite_copy = AI.new()
		elite_copy.weights_ih = elite_brains[i].weights_ih.duplicate(true)
		elite_copy.weights_ho = elite_brains[i].weights_ho.duplicate(true)
		elite_copy.bias_h = elite_brains[i].bias_h.duplicate(true)
		elite_copy.bias_o = elite_brains[i].bias_o
		new_population.append(elite_copy)
	
	# Rest of the population
	while new_population.size() < POPULATION_SIZE:
		var parent_brain: AI = elite_brains.pick_random()
		var brain = AI.new()
		brain.weights_ih = parent_brain.weights_ih.duplicate(true)
		brain.weights_ho = parent_brain.weights_ho.duplicate(true)
		brain.bias_h = parent_brain.bias_h.duplicate(true)
		brain.bias_o = parent_brain.bias_o

		brain.mutate(0.2, 0.40)
		new_population.append(brain)

	population = new_population
	dead_birds.clear()
	generation += 1
	pipe_emitter.call("reset_for_generation")
	populationNode.create_birds(population)
