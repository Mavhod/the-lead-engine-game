class_name GameUtils
extends Node

'''
## Randomly distributes `total` into `count` elements
static func rand_sum_int(count: int, total: int) -> Array:
	if (count <= 0): return [];
	var arr = []
	for i in range(count - 1):
		var n = randi_range(0, total)
		arr.append(n)
		total -= n
	arr.append(total)
	return arr
'''

static func rand_sum_int(count: int, total: int) -> Array:
	if count <= 0: return []
	if count == 1: return [total]
	var weights = []
	var sum_weights = 0.0
	# 1. Generate random weights
	for i in range(count):
		var w = randf()
		weights.append(w)
		sum_weights += w
	#
	var arr = []
	var current_sum = 0
	# 2. Distribute values using floor
	for i in range(count):
		var val = floori((weights[i] / sum_weights) * total)
		arr.append(val)
		current_sum += val
	# 3. Handle the difference
	# Since we used floor, the sum will be less than or equal to the total.
	var diff = total - current_sum
	# Randomly distribute the remaining points (+1) to indices until diff is reached.
	# This ensures the total is exact while maintaining fair randomness.
	var indices = range(count)
	indices.shuffle() # Shuffle indices for fairness
	for i in range(diff): arr[indices[i]] += 1;
	#
	return arr
