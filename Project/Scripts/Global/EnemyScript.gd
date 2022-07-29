extends base_player

func _ready():
	Type = Global.Target.Enemy
	pass

func start_turn():
	.start_turn()
	print("Enemy turn!")
	AI.turn()
	pass

func defeat_func():
	BattleResult.Victory()
	pass
