extends Control

class_name card_holder

export (Global.Target) var Type

export (float) var Hide_y_pos = 730
export (float) var Hide_y_size = 350
export (float) var Show_y_pos = 730
export (float) var Show_y_size = 350

export (NodePath) var _HolderNode
export (NodePath) var _EnergyNode
export (NodePath) var _EnergyValue
export (NodePath) var _EnergyResult
export (NodePath) var _HolderPanel
export (NodePath) var _CountersNode
export (NodePath) var _DeckNode
export (String, FILE, "*.tscn") var CardClassPath

onready var HolderNode    = get_node(_HolderNode)
onready var EnergyNode    = get_node(_EnergyNode)
onready var EnergyTXT     = get_node(_EnergyValue)
onready var EnergyResult  = get_node(_EnergyResult)
onready var HolderPanel   = get_node(_HolderPanel)
onready var CountersNode  = get_node(_CountersNode)
onready var DeckNode      = get_node(_DeckNode) if _DeckNode != "" else null
onready var ResultTXT  = EnergyResult.get_node("TXT")
onready var ResultIMG  = EnergyResult.get_node("IMG")
onready var PlayerCardClass = load(CardClassPath)

var SelfTween = Tween.new()
var TweenNode = Tween.new()
var TweenEnergy = Tween.new()
var EnergyValue = 7
var selected_card = null
var active = false
var selected = false

func _ready():
	add_child(SelfTween)
	add_child(TweenNode)
	add_child(TweenEnergy)
	
	add_to_group("Holders")
	
	SignalsScript.connect("damage", self, "set_damage")
	SignalsScript.connect("heal", self, "set_heal")
	
	ResultTXT.font_outline_color = Color.white
	ResultIMG.self_modulate = Color.white
	
	Hide()
	
	pass # Replace with function body.

func SelectCard(card):
	if active && HolderNode.get_children().has(card):
		selected_card = card
	#	print("Select")
		TweenEnergy.remove_all()
	#	TweenEnergy.stop_all()
		ShowResult(EnergyValue - card.card_params.cost)
		SetCardsPosition(card.get_index())
		TweenEnergy.interpolate_callback(self, 0.2, "MoveEnergyCounter")
		TweenEnergy.start()
	pass

func UnselectCard(card):
	if active && HolderNode.get_children().has(card):
		selected_card = null
		TweenEnergy.remove_all()
	#	TweenEnergy.stop_all()
		HideResult()
		SetCardsPosition()
		TweenEnergy.interpolate_callback(self, 0.2, "MoveEnergyCounter")
		TweenEnergy.start()
		if !selected:
			Hide()
	pass

func MoveEnergyCounter():
#	print("MoveEnergyCounter")
	var tweenTime = 0.2
	var trans = Tween.TRANS_BACK
	var easing = Tween.EASE_OUT
	var selectedCard = null
	var CenterPoint = Vector2.ZERO
	CenterPoint.x = EnergyNode.get_parent().rect_global_position.x + HolderNode.rect_size.x/2
	CenterPoint.y = EnergyNode.rect_global_position.y
#	print(CenterPoint)
	for card in HolderNode.get_children():
		var side_step = 30
		var card_has_energy_node =     (card.CardBody.get_global_rect().has_point(EnergyNode.rect_global_position) ||
										card.CardBody.get_global_rect().has_point(Vector2(EnergyNode.rect_global_position.x - side_step, EnergyNode.rect_global_position.y)) ||
										card.CardBody.get_global_rect().has_point(Vector2(EnergyNode.rect_global_position.x + side_step, EnergyNode.rect_global_position.y)))
		var card_has_central_point =   (card.CardBody.get_global_rect().has_point(CenterPoint) ||
										card.CardBody.get_global_rect().has_point(Vector2(CenterPoint.x - side_step, CenterPoint.y)) ||
										card.CardBody.get_global_rect().has_point(Vector2(CenterPoint.x + side_step, CenterPoint.y)))
		if  (card_has_energy_node || card_has_central_point):
			if card_has_central_point:
				selectedCard = card
			else:
				selectedCard = null
			break
	
	if selectedCard == null:
		TweenEnergy.interpolate_property(EnergyNode, "rect_position:x", EnergyNode.rect_position.x, HolderNode.rect_size.x/2, tweenTime, trans, easing)
	elif selectedCard.rect_position.x >= HolderNode.rect_size.x/2:
		TweenEnergy.interpolate_property(EnergyNode, "rect_position:x", EnergyNode.rect_position.x, HolderNode.rect_size.x/4, tweenTime, trans, easing)
	else:
		TweenEnergy.interpolate_property(EnergyNode, "rect_position:x", EnergyNode.rect_position.x, HolderNode.rect_size.x/4*3, tweenTime, trans, easing)
	TweenEnergy.start()
	pass

func ShowResult(resultValue = 5):
#	yield(get_tree(), "idle_frame")
	var tweenTime = 0.2
	var trans = Tween.TRANS_BACK
	var easing = Tween.EASE_OUT
	var arrow_color       = Color.skyblue   if resultValue > 0 else Color.tomato
	var num_outline_color = Color.steelblue if resultValue > 0 else Color.webmaroon
	ResultTXT.Text = resultValue
#	TweenEnergy.stop_all()
#	TweenEnergy.remove_all()
	TweenEnergy.interpolate_property(CountersNode, "rect_position:y", CountersNode.rect_position.y, -30, tweenTime, trans, easing)
	TweenEnergy.interpolate_property(EnergyResult, "rect_position:y", EnergyResult.rect_position.y, 30, tweenTime, trans, easing)
	TweenEnergy.interpolate_property(ResultTXT, "rect_position:y", ResultTXT.rect_position.y, 5, tweenTime, trans, easing)
	TweenEnergy.interpolate_property(EnergyResult, "modulate:a", EnergyResult.modulate.a, 1, tweenTime, trans, easing)
	TweenEnergy.interpolate_property(ResultTXT, "font_outline_color", ResultTXT.font_outline_color, num_outline_color, tweenTime, trans, easing)
	TweenEnergy.interpolate_property(ResultIMG, "self_modulate", ResultIMG.self_modulate, arrow_color, 1, trans, easing)
#	TweenEnergy.interpolate_callback(self, tweenTime, "MoveEnergyCounter")
	TweenEnergy.start()
	pass

func HideResult():
#	print("Unselect")
	var tweenTime = 0.2
	var trans = Tween.TRANS_BACK
	var easing = Tween.EASE_OUT
	var arrow_color = Color.white
#	var num_outline_color = Color.white
#	TweenEnergy.stop_all()
	TweenEnergy.interpolate_property(CountersNode, "rect_position:y", CountersNode.rect_position.y, 0, tweenTime, trans, easing)
	TweenEnergy.interpolate_property(EnergyResult, "rect_position:y", EnergyResult.rect_position.y, 0, tweenTime, trans, easing)
	TweenEnergy.interpolate_property(ResultTXT, "rect_position:y", ResultTXT.rect_position.y, -6, tweenTime, trans, easing)
	TweenEnergy.interpolate_property(EnergyResult, "modulate:a", EnergyResult.modulate.a, 0, tweenTime, trans, easing)
#	TweenNode.interpolate_property(ResultTXT, "font_outline_color", ResultTXT.font_outline_color, num_outline_color, tweenTime, trans, easing)
	TweenEnergy.interpolate_property(ResultIMG, "self_modulate", ResultIMG.self_modulate, arrow_color, 1, trans, easing)
	TweenEnergy.start()
	pass

func AddCard(params, show_flag = false):
	var newCard = PlayerCardClass.instance()
	HolderNode.add_child(newCard)
	if DeckNode:
		newCard.rect_global_position = DeckNode.rect_global_position
	newCard.card_condition = Card_class.IN_HAND
	newCard.face = false
#	newCard.Show()
	newCard.SetParams(params)
#	newCard.connect("card_focused_on", self, "SetCardsPosition", [newCard.get_index()])
	newCard.connect("card_focused_on", self, "SelectCard", [newCard])
#	newCard.connect("card_focused_off", self, "SetCardsPosition", [null])
	newCard.connect("card_focused_off", self, "UnselectCard", [newCard])
	newCard.connect("end_dragable", self, "end_card_drag")
	for card in HolderNode.get_children():
		SetCardPositionByIndex(card.get_index(), HolderNode.get_child_count())
	if show_flag:
		get_tree().create_timer(0.2).connect("timeout", newCard, "Show")
	
#	yield(get_tree().create_timer(2), "timeout")
#	SetCardsPosition()
	pass

func SetCardsPosition(target = null):
	var HolderChildren = HolderNode.get_children()
	var step = HolderNode.rect_size.x / (HolderNode.get_children().size() + 1)
#	prints("step", step)
	var count = 0
	TweenNode.remove_all()
	for card in HolderChildren:
		if card.lock:
			continue
		var yieldTime = 0
		var card_body = card.CardBody
#		var finalPosition = Vector2((count + 1) * step - (card_body.rect_size.x * card_body.rect_scale.x), 0 - (card_body.rect_size.y * card_body.rect_scale.y))
		var finalPosition = Vector2((count + 1) * step, 0)
#		prints("finalPosition", finalPosition)
		
		if target != null:
			if count < target:
				finalPosition.x -= card_body.rect_size.x / (HolderNode.get_children().size()-1)
			elif count > target:
				finalPosition.x += card_body.rect_size.x / (HolderNode.get_children().size()-1)
#			else:
#				finalPosition.x = (count + 1) * step - (card_body.rect_size.x * card_body.rect_scale.x)
		else:
			yieldTime = 0.07
#			yield(get_tree().create_timer(0.1), "timeout")
		TweenNode.interpolate_property(card, "rect_position", card.rect_position, finalPosition, 0.3, Tween.TRANS_QUART, Tween.EASE_OUT, yieldTime)
		count += 1
	TweenNode.start()
	pass

func SetCardPositionByIndex(index : int, max_index : int, pos_index = null):
	pos_index = index if pos_index == null else pos_index
	var card = HolderNode.get_child(index)
	var step = HolderNode.rect_size.x / (max_index + 1)
	var card_body = card.CardBody
	var finalPosition = Vector2((pos_index + 1) * step, 0)
	TweenNode.interpolate_property(card, "rect_position", card.rect_position, finalPosition, 0.3, Tween.TRANS_QUART, Tween.EASE_OUT)
	TweenNode.start()
	pass

func Hide(flag = false):
	if selected_card == null || flag:
		SelfTween.interpolate_property(HolderPanel, "rect_position:y", HolderPanel.rect_position.y, Hide_y_pos, 0.3, Tween.TRANS_QUART, Tween.EASE_OUT)
		SelfTween.interpolate_property(HolderPanel, "rect_size:y", HolderPanel.rect_size.y, Hide_y_size, 0.3, Tween.TRANS_QUART, Tween.EASE_OUT)
		SelfTween.start()
	pass

func Show():
	SelfTween.interpolate_property(HolderPanel, "rect_position:y", HolderPanel.rect_position.y, Show_y_pos, 0.3, Tween.TRANS_QUART, Tween.EASE_OUT)
	SelfTween.interpolate_property(HolderPanel, "rect_size:y", HolderPanel.rect_size.y, Show_y_size, 0.3, Tween.TRANS_QUART, Tween.EASE_OUT)
	SelfTween.start()
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func end_card_drag():
	SetCardsPosition()
	TweenEnergy.interpolate_callback(self, 0.2, "MoveEnergyCounter")
#		TweenEnergy.start()
	HideResult()
	call_deferred("Hide", true)
#	Hide(true)
	pass

func _on_Panel_mouse_entered():
#	if selected_card:
#	selected = true
#	print("MouseEntered")
	Show()
	pass # Replace with function body.


func _on_Panel_mouse_exited():
#	yield(get_tree(), "idle_frame")
#	print("MouseEnxited")
	if selected_card == null:
#		selected = false
#		Hide()
		call_deferred("Hide")
	else:
		call_deferred("Show")
	pass # Replace with function body.

func ChangeEnergyValue():
	pass

func set_damage(target, value):
	ChangeEnergyValue()
	pass

func set_heal(target, value):
	ChangeEnergyValue()
	pass

func _input(event):
	if event is InputEventMouseMotion:
		selected = HolderPanel.get_global_rect().has_point(get_global_mouse_position())
	pass
