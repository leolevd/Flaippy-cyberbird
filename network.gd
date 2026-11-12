class_name AI
extends RefCounted

var weights_ih = []
var weights_ho = []
var bias_h = []
var bias_o = 0.0
var brain_cells = 8
var inputs = 3
func _init() -> void:
	for i in range(brain_cells):
		var row = []
		for ii in range(inputs):
			row.append(randf_range(-1.0, 1.0))
		weights_ih.append(row)
		bias_h.append(randf_range(0.0, 1.0))
		for iii in range(brain_cells):
			weights_ho.append(randf_range(-1.0, 1.0))
	bias_o = randf_range(-1.0, 1.0)

func sigmoid(x: float) -> float:
	return 1.0 / (1.0 + exp(-x))


func prediction(inputscount: Array):
	var hidden = []
	for i in range(brain_cells):
		var sum = bias_h[i]
		for j in range(inputs):
			sum += inputscount[j] * weights_ih[i][j]
		hidden.append(sigmoid(sum))
	var output = bias_o
	for i in range(brain_cells):
		output += hidden[i] * weights_ho[i]
	return sigmoid(output) > 0.5

func mutate(chance = 0.1, strength = 0.3):
	for i in range(brain_cells):
		for j in range(inputs):
			if randf() < chance:
				weights_ih[i][j] += randf_range(-strength, strength)
		if randf() < chance:
			bias_h[i] += randf_range(-strength, strength)
		if randf() < chance:
			weights_ho[i] += randf_range(-strength, strength)
	if randf() < chance:
		bias_o += randf_range(-strength, strength)
