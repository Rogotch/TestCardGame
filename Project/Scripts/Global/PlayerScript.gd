extends base_player

func _ready():
	Type = Global.Target.Player
	pass

func defeat_func():
	BattleResult.Defeat()
	pass
