extends Node

enum AreaType {Card, Holder}
enum Target {NONE = -1, Player, Enemy}

var delayAttackTime = 0.1
var rng = RandomNumberGenerator.new()

# В зависимости от веса даёт рандомный предмет из массива
func GetRandomByWeight(weightKey, arrayObjects):
	var TotalWeight = 0
	
	for obj in arrayObjects:
		TotalWeight += int(obj[weightKey])
	
	rng.randomize()
	var randomResult = rng.randi()%TotalWeight
	var weightCount = 0
	for obj in arrayObjects:
		if randomResult < weightCount + obj[weightKey]:
			return obj
		else:
			weightCount += obj[weightKey]
	pass

func get_holder_by_index_and_type(index, type):
	var all_holders = get_tree().get_nodes_in_group("field_holders")
	yield(get_tree(), "idle_frame")
	for holder in all_holders:
		if holder.index == index && holder.Type == type:
			return holder
	pass

func check_open_holders_by_type():
	pass
