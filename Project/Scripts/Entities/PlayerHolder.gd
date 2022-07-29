extends card_holder

func _ready():
#	._ready()
	PlayerScript.connect("update_energy", self, "ChangeEnergyValue")
	EnergyValue = PlayerScript.EnergyValue
	Type = Global.Target.Player
	EnergyTXT.Text = EnergyValue
	ChangeEnergyValue()

	pass

func ChangeEnergyValue():
	.ChangeEnergyValue()
	EnergyValue = PlayerScript.EnergyValue
	EnergyTXT.Text = PlayerScript.EnergyValue
	pass

func set_damage(target, value):
	if target == Type:
		PlayerScript.EnergyValue -= value
	ChangeEnergyValue()
	pass

func set_heal(target, value):
	if target == Type:
		PlayerScript.EnergyValue += value
	ChangeEnergyValue()
	pass

func AddCard(params, show_flag = false):
	.AddCard(params, true)
	pass

