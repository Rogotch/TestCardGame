extends card_holder

var hided = false

func _ready():
#	._ready()
	EnergyValue = EnemyScript.EnergyValue
	Type = Global.Target.Enemy
	EnergyTXT.Text = EnergyValue
	ChangeEnergyValue()
	EnemyScript.connect("update_energy", self, "ChangeEnergyValue")
#	yield(get_tree().create_timer(5), "timeout")
	
#	HolderNode.get_child(1).set_card_to_holder(2)
	pass

func ChangeEnergyValue():
	.ChangeEnergyValue()
	EnergyValue = EnemyScript.EnergyValue
	EnergyTXT.Text = EnemyScript.EnergyValue
	pass

func set_damage(target, value):
	if target == Type:
		EnemyScript.EnergyValue -= value
	ChangeEnergyValue()
	pass

func set_heal(target, value):
	if target == Type:
		EnemyScript.EnergyValue += value
	ChangeEnergyValue()
	pass

func SetCardPositionByIndex(index : int, max_index : int, pos_index = null):
	.SetCardPositionByIndex(index, max_index, max_index-index-1)
	pass

func MoveEnergyCounter():
	pass

func SelectCard(card):
	if active && HolderNode.get_children().has(card):
		selected_card = card
		SetCardsPosition(card.get_index())
	pass

func UnselectCard(card):
	if active && HolderNode.get_children().has(card):
		selected_card = card
		SetCardsPosition()
	pass

func SetCardsPosition(target = null):
	var HolderChildren = HolderNode.get_children()
	var HolderChildrenCount = HolderNode.get_child_count()
	var step = HolderNode.rect_size.x / (HolderNode.get_children().size() + 1)
#	prints("step", step)
	var count = 0
	TweenNode.remove_all()
	for card in HolderChildren:
		var yieldTime = 0
		var card_body = card.CardBody
#		var finalPosition = Vector2((count + 1) * step - (card_body.rect_size.x * card_body.rect_scale.x), 0 - (card_body.rect_size.y * card_body.rect_scale.y))
		var finalPosition = Vector2((HolderChildrenCount - count) * step, 0)
#		prints("finalPosition", finalPosition)
		
		if target != null:
			if count < target:
				finalPosition.x += card_body.rect_size.x / (HolderNode.get_children().size()-1)
			elif count > target:
				finalPosition.x -= card_body.rect_size.x / (HolderNode.get_children().size()-1)
#			else:
#				finalPosition.x = (count + 1) * step - (card_body.rect_size.x * card_body.rect_scale.x)
		else:
			yieldTime = 0.07
#			yield(get_tree().create_timer(0.1), "timeout")
		TweenNode.interpolate_property(card, "rect_position", card.rect_position, finalPosition, 0.3, Tween.TRANS_QUART, Tween.EASE_OUT, yieldTime)
		count += 1
	TweenNode.start()
	pass

func _input(event):
	if event is InputEventMouseMotion:
		selected = HolderPanel.get_global_rect().has_point(get_global_mouse_position())
		if selected:
			hided = false
		if !hided && !selected:
			Hide(true)
	pass

func Hide(flag = false):
	hided = true
#	SelfTween.interpolate_property(HolderPanel, "rect_position:y", HolderPanel.rect_position.y, Hide_y_pos, 0.3, Tween.TRANS_QUART, Tween.EASE_OUT)
	SelfTween.interpolate_property(HolderPanel, "rect_size:y", HolderPanel.rect_size.y, Hide_y_size, 0.3, Tween.TRANS_QUART, Tween.EASE_OUT)
	SelfTween.start()
	pass

func Show():
#	SelfTween.interpolate_property(HolderPanel, "rect_position:y", HolderPanel.rect_position.y, Show_y_pos, 0.3, Tween.TRANS_QUART, Tween.EASE_OUT)
	SelfTween.interpolate_property(HolderPanel, "rect_size:y", HolderPanel.rect_size.y, Show_y_size, 0.3, Tween.TRANS_QUART, Tween.EASE_OUT)
	SelfTween.start()
	pass
	
func _on_Panel_mouse_exited():
	pass
