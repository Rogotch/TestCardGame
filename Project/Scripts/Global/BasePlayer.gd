extends Node

signal defeat(type)
signal update_energy

class_name base_player

var EnergyValue = 10 setget energy_change
var Type
var holder : card_holder
var draw_time = 0.1

func _ready():
	add_to_group("Players")
	BattleProcess.connect("next_turn", self, "next_turn")
	pass

func next_turn():
	if BattleProcess.turn == Type:
		start_turn()
	pass

func start_turn():
	self.EnergyValue += 1
	get_top_card()
	pass

func energy_change(value):
	if EnergyValue == 0:
		emit_signal("defeat", Type)
		defeat_func()
	emit_signal("update_energy")
	EnergyValue = value
	pass

func update():
	pass

func set_holder():
	var holders = get_tree().get_nodes_in_group("Holders")
	yield(get_tree(), "idle_frame")
	for _holder in holders:
		if _holder.Type == Type:
			holder = _holder
			break
	if holder == null:
		push_error("Holder not was set")
	pass

func add_card(params):
	holder.AddCard(params)
	pass

func get_top_card():
	add_card(null)
	pass

func get_num_cards(num : int):
	for i in num:
		get_top_card()
		yield(get_tree().create_timer(draw_time), "timeout")
	pass

func change_active_holder(flag):
	holder.active = flag
	pass

func set_cards_position():
	holder.SetCardsPosition()
	pass

func defeat_func():
	pass
