extends Control

export (Global.Target) var Type

signal added_child(index)

export (NodePath) var _HolderPoint

onready var HolderPoint = get_node(_HolderPoint)
onready var index = get_index()

var card = null

func _ready():
	add_to_group("field_holders")
	SignalsScript.connect("card_attack", self, "check_attack")
	SignalsScript.connect("card_death", self, "card_death")
	pass

func GetCenterPosition() -> Vector2:
	return HolderPoint.rect_global_position
	pass

func AddedChild(new_card):
	card = new_card
	card.set_meta("index", index)
	card.card_condition = Card_class.ON_FIELD
	card.field_position = self
	emit_signal("added_child", index)
	pass

func Attack(type):
	if type == Type && card != null:
		get_tree().create_timer(Global.delayAttackTime * index).connect("timeout", card, "Attack")
	pass

func check_attack(type, idx, params):
	if type != Type && idx == index:
		if card != null:
			card.deal_damage(params.attack)
			pass
		else:
			SignalsScript.emit_signal("damage", Type, params.attack)
			SignalsScript.emit_signal("heal", type, params.attack)
		PlayerScript.emit_signal("update_energy")
		EnemyScript.emit_signal("update_energy")
	pass

func card_death(type, idx):
	if type == Type && idx == index:
		if card != null:
			card.card_condition = Card_class.DEAD
		card = null
	pass

func get_attack() -> int:
	return 0 if card == null else card.card_params.attack
	pass
