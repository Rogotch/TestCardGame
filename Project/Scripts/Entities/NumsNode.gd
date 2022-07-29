extends Control

export (NodePath) var _IndexNode
export (NodePath) var _NumsNode

onready var IndexNode = get_node(_IndexNode)
onready var NumsNode  = get_node(_NumsNode)

var value = 0 setget SetNewValue
var z_index = 0 setget set_z_index

func _ready():
	add_to_group("nums")
	self.value = value
	SignalsScript.connect("card_death", self, "update_nums")
	pass

func SetNewValue(new_value):
	value = new_value
	var prefix = ""
	if new_value > 0:
		prefix = "+"
		NumsNode.font_outline_color = Color.webgreen
	elif new_value < 0:
		NumsNode.font_outline_color = Color.webmaroon
	else:
		NumsNode.font_outline_color = Color.steelblue
	NumsNode.Text = prefix + str(new_value)
	pass

func set_z_index(new_value):
	z_index = new_value
	IndexNode.z_index = new_value
	pass

func update_nums(_type, index):
	prints("Index", index)
	if get_index() != index:
		return
	var holders = get_tree().get_nodes_in_group("field_holders")
	var final_value = 0
	yield(get_tree(), "idle_frame")
	for holder in holders:
		if holder.index == index:
			final_value += holder.get_attack() * (1 if holder.Type == Global.Target.Player else -1)
	SetNewValue(final_value)
	pass
