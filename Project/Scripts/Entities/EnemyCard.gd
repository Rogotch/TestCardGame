extends Card_class


func _ready():
	connect("grow_timeout", self, "Grow")
	connect("card_focused_off", self,"Decrease")
	pass # Replace with function body.
	
#func PayCost():
#	PlayerScript.EnergyValue -= card_params.cost
#	SignalsScript.emit_signal("damage", Global.Target.Player, PlayerScript.EnergyValue)
#	pass

func Grow(tween_time = 0.3, new_z_index = 2):
#	if !block_flag:
#		if on_field:
#			Set_Z_Index(new_z_index + 1)
#		else:
	Set_Z_Index(new_z_index)
	
	if !on_field:
		TweenNode.interpolate_property(CardBody, "rect_position:y", CardBody.rect_position.y, -(CardBody.rect_size.y)/1.4, tween_time, Tween.TRANS_QUART, Tween.EASE_OUT)
	
	.Grow(tween_time, new_z_index)
	pass

func Decrease(tween_time = 0.3, new_z_index = 1):
#	if !block_flag:
	Set_Z_Index(new_z_index)
#		if !on_field:
#			Set_Z_Index(new_z_index)
#		else:
#			Set_Z_Index(new_z_index + 1)
#			TweenNode.interpolate_callback(self, tween_time, "Set_Z_Index", new_z_index)
	
	if !on_field:
		TweenNode.interpolate_property(CardBody, "rect_position:y", CardBody.rect_position.y, -(CardBody.rect_size.y) /2, tween_time, Tween.TRANS_QUART, Tween.EASE_OUT)
	
	.Decrease(tween_time, new_z_index)
	pass

func Attack():
#	TweenNode = Tween.new()
	.Attack()
	Set_Z_Index(2)
	TweenNode.remove_all()
	TweenNode.interpolate_property(CardBody, "rect_position:y", CardBody.rect_position.y, -340, 0.2, Tween.TRANS_EXPO, Tween.EASE_OUT)
	TweenNode.interpolate_property(CardBody, "rect_position:y", -340, -200, 0.1, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.2)
	TweenNode.interpolate_property(CardBody, "rect_position:y", -200, -300, 0.3, Tween.TRANS_CIRC, Tween.EASE_OUT, 0.3)
	TweenNode.interpolate_callback(self, 0.6, "Set_Z_Index", 1)
	TweenNode.start()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func focused_on():
	_shader_selected_material.set_shader_param("border_color", Color.tomato)
	pass # Replace with function body.
