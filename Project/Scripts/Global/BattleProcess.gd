extends Node


signal next_turn

var turn = Global.Target.Player
var Round = 0
var _counter = 0

func _ready():
	pass

func EndTurn():
	get_tree().call_group("field_holders", "Attack", turn)
	yield(get_tree().create_timer(Global.delayAttackTime * 5), "timeout")
	turn = Global.Target.Enemy if turn == Global.Target.Player else Global.Target.Player
	_counter += 1
	Round = int(floor(_counter / 2.0))
	prints("Round", Round)
	emit_signal("next_turn")
	pass
