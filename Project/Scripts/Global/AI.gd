extends Node

onready var rng = RandomNumberGenerator.new()

var cards_arr = []

func get_cards():
	var all_cards   = get_tree().get_nodes_in_group("Cards")
	yield(get_tree(), "idle_frame")
	var final_cards = {}
	for card in all_cards:
		if card.card_type == Global.Target.Enemy:
			var params = card.card_params
			var prior = EnemyScript.EnergyValue - params.cost
			if prior > 0:
				if !final_cards.has(prior):
					final_cards[prior] = []
				final_cards[prior].append(card.get_index())
	if final_cards.size() == 0:
		return null
	var cards_keys = final_cards.keys()
	cards_keys.sort()
	
#	var indexes_arr = []
#	for card in final_cards[cards_keys[0]]:
#		indexes_arr.append(card.get_index())
	
	return final_cards[cards_keys[0]]
	pass

func get_field_holder_num():
	var all_holders = get_tree().get_nodes_in_group("field_holders")
	yield(get_tree(), "idle_frame")
	var holders_agr = {}
	var blocked_holders = []
	for holder in all_holders:
		if holder.Type == Global.Target.Player:
			if holder.card != null:
				var params = holder.card.card_params
				holders_agr[params.attack] = holder
		elif holder.card != null:
			blocked_holders.append(holder.index)
	
	if blocked_holders.size() == 4:
		return null
	else:
		var final_index
		if holders_agr.size() == 0:
			while true:
				rng.randomize()
				final_index = rng.randi()%4
				if !blocked_holders.has(final_index):
					break
		else:
			var holders_keys = holders_agr.keys()
			holders_keys.sort()
			holders_keys.invert()
			for key in holders_keys:
				var ind = holders_agr[key].index
				if !blocked_holders.has(ind):
					final_index = ind
					break
		return final_index

func turn():
	var counter = 0
#	yield(get_tree().create_timer(1.5), "timeout")
#	var q = get_cards()
#	var qq = q.resume()
	while true:
		yield(get_tree().create_timer(1.5), "timeout")
		var allCards_func = get_cards()
		var allCards = allCards_func.resume()
#		yield(allCards_func, "completed")
		var holder_num_func = get_field_holder_num()
#		var holder_num = holder_num_func.resume()
		var holder_num = holder_num_func.resume()
#		yield(holder_num_func, "completed")
#		yield(get_tree().create_timer(0.1), "timeout")
#		yield(get_tree(), "idle_frame")
		
		if allCards == null || holder_num == null:
			prints("allCards", allCards)
			prints("holder_num", holder_num)
			break
		
		rng.randomize()
		var card_index = allCards[rng.randi()%allCards.size()]
		get_tree().call_group("Cards", "set_card_by_type_and_index_to_holder", Global.Target.Enemy, card_index, holder_num)
		counter += 1
#		break
	print("EndTurn")
	BattleProcess.EndTurn()
	pass
