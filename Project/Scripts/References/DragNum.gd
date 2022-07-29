extends Node2D

export (NodePath) var _Nums
export (NodePath) var _Area
export (NodePath) var _HoldButton
export (NodePath) var _NumPanel
export (NodePath) var _DragNodeTween
export (NodePath) var _Owner

onready var Nums           = get_node(_Nums)
onready var AreaNode       = get_node(_Area)
onready var HoldButton     = get_node(_HoldButton)
onready var NumPanel       = get_node(_NumPanel)
onready var TweenNode      = get_node(_DragNodeTween)
onready var OwnerNode      = get_node(_Owner) if _Owner != "" else null

var holders = []

var holded = false
var startPosition
var value = 20 setget SetValue
var selectedHolder = null
var innerTimer = null
var shader_material
#var centerPos

var Holder = null

func _ready():
	add_to_group("Drag_nums")
#	shader_material = 
	Nums.SetNumber(value)
	yield(get_tree(), "idle_frame")
	startPosition = global_position
	selectedHolder = OwnerNode
#	print(Roll._rollAbility())
	pass # Replace with function body.

#func _physics_process(delta):
#	if Holder != null && !holded:
#		global_position = centerPos
#	pass

#func GetCenterPosition():
#	if Holder != null:
#		Holder.GetCenterPosition()
#	pass

func SetValue(new_value):
	value = new_value
	Nums.SetNumber(value)
	pass

func _input(event):
	if event is InputEventMouseMotion && holded:
#		if NumPanel.get_global_rect().has_point(event.position):
		global_position = get_global_mouse_position()
	pass



func _on_HoldButton_button_down():
#	if !blocked:
	z_index = 1
	holded = true
	Nums.DownVisibility = false
	Nums.value = value
	TweenNode.stop_all()
	pass # Replace with function body.


func _on_HoldButton_button_up():
	holded = false
#	prints("holders.size() > 0", holders.size() > 0, " holders[-1] != null",  holders[-1] != null if holders.size() > 0 else false)
	if holders.size() > 0 && holders[-1] != null:
		if Holder != null && holders[-1].selectedHolder != null:
			holders[-1].selectedHolder.SlideToNode(Holder)
		elif Holder == null && holders[-1].selectedHolder != null:
			holders[-1].selectedHolder.SlideToOwner()
		
		
		if Holder == holders[-1]:
			SlideToCurrentHolder()
		else:
			SlideToNode(holders[-1])
	else:
#		selectedHolder = OwnerNode\
		SlideToOwner()
	pass # Replace with function body.

func SlideToNode(node):
	
	Holder = node
#	Character.SetAbilityByID(node.AttributeAbilities, value)
#	Nums.value = Character.GetAbilityByID(node.AttributeAbilities)
	Nums.DownVisibility = true
	
	var centerPos = node.GetCenterPosition()
	var tweenTime = 0.5
	
	z_index = 1
	
	createTimer("BecomeHoldersChild", tweenTime)
	#TweenNode.interpolate_method(self, "testprint", false, true, 0.01, Tween.TRANS_SINE, Tween.EASE_OUT)
	TweenNode.interpolate_property(self, "global_position", global_position, centerPos, tweenTime, Tween.TRANS_QUART, Tween.EASE_OUT)
	TweenNode.interpolate_property(self, "z_index", z_index, 0, 0.1, Tween.TRANS_QUART, Tween.EASE_OUT, tweenTime)
	#holders = []
	TweenNode.start()
	pass

func SlideToCurrentHolder():
	
#	Holder = node
#	Character.SetAbilityByID(node.AttributeAbilities, value)
#	Nums.value = Character.GetAbilityByID(Holder.AttributeAbilities)
	Nums.DownVisibility = true
	
	var centerPos = Holder.GetCenterPosition()
	var tweenTime = 0.5
	
	z_index = 1
	
#	createTimer("BecomeHoldersChild", tweenTime)
	#TweenNode.interpolate_method(self, "testprint", false, true, 0.01, Tween.TRANS_SINE, Tween.EASE_OUT)
	TweenNode.interpolate_property(self, "global_position", global_position, centerPos, tweenTime, Tween.TRANS_QUART, Tween.EASE_OUT)
	TweenNode.interpolate_property(self, "z_index", z_index, 0, 0.1, Tween.TRANS_QUART, Tween.EASE_OUT, tweenTime)
	#holders = []
	TweenNode.start()
	pass

func SlideToOwner():
	var tweenTime = 0.5
	
	var centerPos = OwnerNode.GetCenterPosition()
	createTimer("BecomeOwnersChild", tweenTime)
	z_index = 1
	TweenNode.interpolate_property(self, "global_position", global_position, centerPos, tweenTime, Tween.TRANS_QUART, Tween.EASE_OUT)
	TweenNode.interpolate_property(self, "z_index", z_index, 0, 0.1, Tween.TRANS_QUART, Tween.EASE_OUT, tweenTime)
	TweenNode.start()
	pass

func GoToHome():
	if Holder != null:
		var tweenTime = 0.5
		var PositionHolder = global_position
		var centerPos = OwnerNode.GetCenterPosition()
		BecomeOwnersChild()
		global_position = PositionHolder
#		createTimer("BecomeOwnersChild", tweenTime)
		z_index = 1
		
		TweenNode.interpolate_property(self, "position", position, Vector2.ZERO, tweenTime, Tween.TRANS_QUART, Tween.EASE_OUT)
		TweenNode.interpolate_property(self, "z_index", z_index, 0, 0.1, Tween.TRANS_QUART, Tween.EASE_OUT, tweenTime)
		TweenNode.start()
	pass

func _on_NumsArea_area_entered(area):
#	prints("Found new Area!")
#	if area.Type == Scripts.AreaTypes.NumsHolder:
#		holders.append(area.Owner)
#		print("It is holder!")
	pass # Replace with function body.

func _on_NumsArea_area_exited(area):
#	selectedHolder = null
	if holders.has(area.Owner):
		if area.Owner.selectedHolder == self:
#			Character.SetAbilityByID(area.Owner.AttributeAbilities, 10)
			area.Owner.selectedHolder = null
		holders.erase(area.Owner)
#		if !holded:
#			_on_HoldButton_button_up()
	pass # Replace with function body.

func BecomeHoldersChild():
#	print(selectedHolder)
	if !holded:
		var source = selectedHolder.DragNumHolder.get_child(0)
		var target = Holder.DragNumHolder
		selectedHolder.DragNumHolder.remove_child(source)
		target.add_child(source)
		source.set_owner(target)
		position = Vector2.ZERO
		yield(get_tree(), "idle_frame")
		Holder.selectedHolder = self
		selectedHolder = Holder
	pass

func BecomeOwnersChild():
	if Holder != null && Holder.DragNumHolder.get_child_count() > 0 && !holded:
#		prints("Holder.DragNumHolder,get_child_count()", Holder.DragNumHolder.get_child_count())
		var source = Holder.DragNumHolder.get_child(0)
		var target = OwnerNode.DragNumHolder
		Holder.DragNumHolder.remove_child(source)
		target.add_child(source)
		position = Vector2.ZERO
		source.set_owner(target)
		Holder = null
		selectedHolder = OwnerNode
	pass

func createTimer(nameFunction : String, time : float):
	if innerTimer != null:
		innerTimer.queue_free()
	innerTimer = Timer.new()
	add_child(innerTimer)
	innerTimer.one_shot = true
	innerTimer.connect("timeout", self, nameFunction)
	innerTimer.start(time)
	pass


func _on_HoldButton_button_down_2():
	print()
	print("ButtonDown")
	pass # Replace with function body.


func _on_HoldButton_button_up_2():
	print("ButtonUp")
	pass # Replace with function body.


func _on_HoldButton_pressed():
	print("Pressed")
	pass # Replace with function body.
