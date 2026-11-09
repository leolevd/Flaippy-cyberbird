extends Node

const POPULATION_SIZE = 50
const ELITE_COUNT = 5
@onready var populationNode: Node = $"../population"
@onready var pipe_emitter: Node = $"../Node2D"
var population: Array = []
var generation := 1


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

	var elite_brains: Array[AI] = []
	for i in range(min(ELITE_COUNT, previous_generation.size())):
		elite_brains.append(previous_generation[i].brain)

	var new_population: Array = elite_brains.duplicate()
	var parent_braintop: AI = elite_brains[0]
	var braintop = AI.new()
	braintop.weights_ih = parent_braintop.weights_ih.duplicate(true)
	braintop.weights_ho = parent_braintop.weights_ho.duplicate(true)
	braintop.bias_h = parent_braintop.bias_h.duplicate(true)
	braintop.bias_o = parent_braintop.bias_o
	new_population.append(braintop)
	while new_population.size() < POPULATION_SIZE:
		var parent_brain: AI = elite_brains.pick_random()
		var brain = AI.new()
		brain.weights_ih = parent_brain.weights_ih.duplicate(true)
		brain.weights_ho = parent_brain.weights_ho.duplicate(true)
		brain.bias_h = parent_brain.bias_h.duplicate(true)
		brain.bias_o = parent_brain.bias_o

		brain.mutate(0.2, 0.45)
		new_population.append(brain)

	population = new_population
	dead_birds.clear()
	generation += 1
	pipe_emitter.call("reset_for_generation")
	populationNode.create_birds(population)
