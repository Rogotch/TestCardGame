extends Control

class_name Card_class

signal button_down
signal button_up
signal pressed
signal move_end
signal hovered
signal card_focused_on
signal card_focused_off
signal end_dragable
signal grow_timeout

enum {NONE = -1, IN_HAND, ON_FIELD, DEAD}

export (bool) var GrowOffset = true
export (bool) var _face = true
export (bool) var DragableExportFlag
export (Global.Target) var card_type

export (Vector2) var FullScale  = Vector2.ONE
export (Vector2) var SmallScale = Vector2.ONE/2

export (NodePath) var _Title
export (NodePath) var _ImageRect
export (NodePath) var _Description
export (NodePath) var _CardFace
export (NodePath) var _DownCard
export (NodePath) var _DownCardIMG
export (NodePath) var _CardButton
export (NodePath) var _CardAttack
export (NodePath) var _CardHealth
export (NodePath) var _CardBody
export (NodePath) var _CardCost
export (NodePath) var _CardArea
export (NodePath) var _SelectNode
export (NodePath) var _IndexNode

onready var Title         = get_node(_Title)
onready var ImageRect     = get_node(_ImageRect)
onready var Description   = get_node(_Description)
onready var CardFace      = get_node(_CardFace)
onready var DownCard      = get_node(_DownCard)
onready var DownCardIMG   = get_node(_DownCardIMG)
onready var CardButton    = get_node(_CardButton)
onready var CardAttack    = get_node(_CardAttack)
onready var CardHealth    = get_node(_CardHealth)
onready var CardBody      = get_node(_CardBody)
onready var CardCost      = get_node(_CardCost)
onready var SelectNode    = get_node(_SelectNode)
onready var CardArea      = get_node(_CardArea)
onready var IndexNode     = get_node(_IndexNode)

var TweenNode = Tween.new()

var holders = []

var card_condition = NONE
var card_params
var rng = RandomNumberGenerator.new()
var face = true setget SetFace
var dragable_flag = true
var block_flag = false
var lock = false
var on_field = false
var Dragable = false
var start_tap = Vector2.ZERO
var drag_offset = Vector2.ZERO
var field_position = null

var _shader_disolve_material
var _shader_selected_material

var grow_timer = Timer.new()
var grow_timer_time = 0.1
var selected = false

func _ready():
	add_child(TweenNode)
	add_child(grow_timer)
	grow_timer.one_shot = true
	grow_timer.connect("timeout", self, "_grow_timer_timeout")
	add_to_group("Cards")
	_shader_disolve_material  = CardBody.get_material()
	_shader_selected_material = SelectNode.get_material()
	_shader_selected_material.set_shader_param("border_color", Color.transparent)
	CardBody.rect_pivot_offset = CardBody.rect_size/2
	SetParams()
	self.face = _face
	CardBody.rect_scale = SmallScale
	pass # Replace with function body.

func set_disolve_effect(value):
	_shader_disolve_material.set_shader_param("dissolve_amount", value)
	pass

func _physics_process(_delta):
	if Dragable && dragable_flag:
		Drag()
		pass
	pass

func SetParams(params = null):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	params = Database.GetObjectByIDFromArr(rng.randi()%Database.cards.size(), Database.cards)
#	params = Database.GetObjectByIDFromArr(params if params != null else 0, Database.cards)
#	params = {description = "", attack = 2, health = 3, cost = 4, title = "testCard", image_path = "path"}
	card_params = params
	rng.randomize()
#	params.cost = rng.randi()%10 + 1
	Title.Text = params.title
	Description.Text = params.description
	CardAttack.Text = params.attack
	CardHealth.Text = params.health
	CardCost.Text = params.cost
	pass

func RevertCard(tween_time = 0.2, flag = null):
	TweenNode.interpolate_property(self, "rect_scale:x", 1, 0, tween_time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenNode.interpolate_property(self, "rect_scale:x", 0, 1, tween_time, Tween.TRANS_LINEAR, Tween.EASE_OUT, tween_time)
	TweenNode.interpolate_callback(self, tween_time, "ChangeFace", flag)
	TweenNode.start()
	pass

func Attack():
	SignalsScript.emit_signal("card_attack", card_type, get_meta("index"), card_params)
	pass

func Damage(value = 0):
	var tween_time = 0.1
	TweenNode.interpolate_property(self, "rect_rotation",  0, -20, tween_time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenNode.interpolate_property(self, "rect_rotation", -20, 20, tween_time, Tween.TRANS_LINEAR, Tween.EASE_OUT, tween_time)
	TweenNode.interpolate_property(self, "rect_rotation",  20,  0, tween_time*5, Tween.TRANS_ELASTIC, Tween.EASE_OUT, tween_time * 2)
	TweenNode.start()
	pass

func Death():
	TweenNode.interpolate_method(self, "set_disolve_effect", -0.01, 1.01, 1.5, Tween.TRANS_CIRC, Tween.EASE_OUT)
	SignalsScript.emit_signal("card_death", card_type, get_meta("index"))
	TweenNode.interpolate_callback(self, 1.5, "queue_free")
	TweenNode.start()
	pass

func Move(global_position, tween_time = 0.4):
	var start_position = rect_global_position - (rect_size - rect_pivot_offset) * rect_scale
	var end_position = global_position - (rect_size) * rect_scale
	TweenNode.interpolate_property(self, "rect_global_position", start_position, end_position, tween_time, Tween.TRANS_QUART, Tween.EASE_OUT)
	TweenNode.interpolate_callback(self, tween_time, "emit_signal", "move_end")
	TweenNode.start()
	pass

func Grow(tween_time = 0.3, new_z_index = 2):
	TweenNode.interpolate_property(CardBody, "rect_scale", CardBody.rect_scale, FullScale, tween_time, Tween.TRANS_QUART, Tween.EASE_OUT)
	TweenNode.start()
	pass

func Decrease(tween_time = 0.3, new_z_index = 0):
#	IndexNode.z_index = 0
	TweenNode.interpolate_property(CardBody, "rect_scale", CardBody.rect_scale, SmallScale, tween_time, Tween.TRANS_QUART, Tween.EASE_OUT)
	TweenNode.start()
	pass

func Set_Z_Index(value):
	IndexNode.z_index = value
	pass

func ChangeFace(flag = null):
	SetFace(!face if flag == null else flag)
	pass

func SetFace(value):
	face = value
	DownCard.visible = !face
	CardFace.visible = face
	pass

func _on_CardButton_button_down():
	emit_signal("button_down")
#	Decrease()
	pass # Replace with function body.

func _on_CardButton_button_up():
	emit_signal("button_up")
	pass # Replace with function body.

func _on_CardButton_pressed():
#	RevertCard()
	emit_signal("pressed")
	pass # Replace with function body.

func _on_CardBody_gui_input(event):
	if event is InputEventMouseMotion && CardBody.get_global_rect().has_point(get_global_mouse_position()):
		emit_signal("hovered")
		if !Dragable && start_tap != Vector2.ZERO && start_tap.distance_to(get_local_mouse_position()) > 20:
#			drag_offset = rect_global_position - CardBody.rect_global_position + start_tap
			drag_offset = start_tap
			SetDragable(true)
			CardArea.monitoring = true
			Decrease(0.3, 2)
			pass
	pass # Replace with function body.

func _on_CardBody_mouse_entered():
	emit_signal("card_focused_on")
	selected = true
	grow_timer.start(grow_timer_time)
	pass # Replace with function body.

func _on_CardBody_mouse_exited():
	selected = false
	grow_timer.stop()
	start_tap = Vector2.ZERO
	emit_signal("card_focused_off")
	pass # Replace with function body.

func _grow_timer_timeout():
	emit_signal("grow_timeout")
	pass

func Show():
	if !face:
		SetFace(true)
	pass

func Hide():
	if face:
		SetFace(false)
	pass

func SetDragable(value : bool):
	if DragableExportFlag:
		Dragable = value
	pass

func Drag():
	rect_global_position = get_global_mouse_position()
	pass

func _on_CardArea_area_entered(area):
	if area.Type == Global.AreaType.Holder && Dragable:
#		prints("Found new Area!")
		holders.append(area.Owner)
	pass # Replace with function body.


func _on_CardArea_area_exited(area):
	if holders.has(area.Owner):
		holders.erase(area.Owner)
	pass # Replace with function body.

func GoToHome():
	if holders.size() > 0 && !holders[-1].HolderPoint.get_child_count() > 0 && holders[-1].Type == card_type:
		print("Start moving")
		var tween_time = 0.2
#		var PositionHolder = global_position
		Set_Z_Index(2)
		var centerPos = holders[-1].GetCenterPosition()
		var actualPosition = rect_global_position
		BecomeOwnersChild()
		get_tree().create_timer(tween_time).connect("timeout", self, "ChangeBlock", [false])
		get_tree().create_timer(tween_time).connect("timeout", self, "PayCost")
		rect_global_position = actualPosition
		TweenNode.interpolate_callback(self, tween_time, "Set_Z_Index", 0)
		Move(centerPos, tween_time)
	pass

func BecomeOwnersChild():
	if holders.size() > 0 && !holders[-1].HolderPoint.get_child_count() > 0:
		grow_timer_time = 0.3
		var holder_node = holders[-1]
		var target = holders[-1].HolderPoint
		get_parent().remove_child(self)
		holder_node.AddedChild(self)
		target.add_child(self)
		dragable_flag = false
		block_flag = true
		on_field = true
		rect_position = Vector2.ZERO
		set_owner(target)
		holders.clear()
	pass


func set_card_to_holder(holder_num):
	var selected_holder
	var all_holders = get_tree().get_nodes_in_group("field_holders")
	yield(get_tree(), "idle_frame")

	for holder in all_holders:
		if holder.Type == card_type && holder.index == holder_num:
			selected_holder = holder
	
#	print("Start moving")
	var tween_time = 0.4
	var target = selected_holder.HolderPoint
	var centerPos = selected_holder.GetCenterPosition()
	var actualPosition = rect_global_position
	grow_timer_time = 0.3
	
	dragable_flag = false
	block_flag = true
	on_field = true
	lock = true
	
	Set_Z_Index(2)
	get_tree().create_timer(tween_time).connect("timeout", self, "ChangeBlock", [false])
	get_tree().create_timer(tween_time).connect("timeout", self, "PayCost")
	rect_global_position = actualPosition
	RevertCard(tween_time/2, true)
	TweenNode.interpolate_callback(self, tween_time, "Set_Z_Index", 0)
	TweenNode.interpolate_property(self, "rect_position", rect_position, Vector2.ZERO, tween_time, Tween.TRANS_QUART, Tween.EASE_OUT)
	Move(centerPos, tween_time)
	yield(get_tree().create_timer(tween_time), "timeout")
	get_tree().call_group("Holders", "SetCardsPosition")
	get_parent().remove_child(self)
	selected_holder.AddedChild(self)
	target.add_child(self)
	rect_position = Vector2.ZERO
	set_owner(target)
	pass

func ChangeBlock(_value):
	block_flag = _value
	pass

func _start_dragable():
	start_tap = get_local_mouse_position()
	pass # Replace with function body.

func _end_dragable():
	start_tap = Vector2.ZERO
	GoToHome()
	Dragable = false
	CardArea.monitoring = false
	emit_signal("end_dragable")
	pass # Replace with function body.

func PayCost():
	SignalsScript.emit_signal("damage", card_type, card_params.cost)
	pass

func deal_damage(value):
	card_params.health -= value
	if card_params.health <= 0:
		Death()
		CardHealth.Text = card_params.health
	else:
		Damage(value)
		CardAttack.Text = card_params.attack
		CardHealth.Text = card_params.health
	pass

func focused_on():
#	_shader_selected_material.set_shader_param("border_color", Color.white)
	pass # Replace with function body.

func focused_off():
	_shader_selected_material.set_shader_param("border_color", Color.transparent)
	pass # Replace with function body.

func set_card_by_type_and_index_to_holder(type, index, holder_num):
	if card_type == type && card_condition == IN_HAND:
		if get_index() == index:
			set_card_to_holder(holder_num)
	pass
