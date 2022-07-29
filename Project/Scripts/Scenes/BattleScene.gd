extends Control

export (float, 0.1, 1.0, 0.01) var DelayTime = 0.1
export (NodePath) var _player_card_holder
export (NodePath) var _player_front
export (NodePath) var _enemy_front
export (NodePath) var _numbers
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player_card_holder = get_node(_player_card_holder)
onready var player_front       = get_node(_player_front)
onready var enemy_front        = get_node(_enemy_front)
onready var numbers            = get_node(_numbers)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	for i in numbers.get_child_count():
		player_front.get_child(i).connect("added_child", self, "check_field")
		enemy_front.get_child(i).connect("added_child", self, "check_field")
	
	get_tree().call_group("Players", "set_holder")
	yield(get_tree().create_timer(0.5), "timeout")
#	for i in 9:
#		player_card_holder.AddCard(null)
#		player_card_holder.SetCardPositionByIndex(i, 9)
#		yield(get_tree().create_timer(DelayTime), "timeout")
	get_tree().call_group("Players", "get_num_cards", 6)
	get_tree().call_group("Players", "change_active_holder", true)
	
	pass # Replace with function body.

func check_all_fields():
	for i in numbers.get_child_count():
		check_field(i)
	pass

func check_field(idx):
	var final_value = 0
	if player_front.get_child(idx).card != null:
		final_value += player_front.get_child(idx).card.card_params.attack
	if  enemy_front.get_child(idx).card != null:
		final_value -=  enemy_front.get_child(idx).card.card_params.attack
	numbers.get_child(idx).value = final_value
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NextTurnButton_pressed():
	BattleProcess.EndTurn()
	pass # Replace with function body.
