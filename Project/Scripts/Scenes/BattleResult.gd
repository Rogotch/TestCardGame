extends CanvasLayer

export (NodePath) var _Text
export (NodePath) var _MainNode

onready var TextLabel = get_node(_Text)
onready var MainNode = get_node(_MainNode)
var tween_node = Tween.new()

func _ready():
	add_child(tween_node)
	pass

func Victory():
	visible_on()
	TextLabel.font_outline_color = Color.cornflower
	TextLabel.Text = "[wave amp=50 freq=4][center]Победа[/center][/wave]"
	pass

func Defeat():
	visible_on()
	TextLabel.font_outline_color = Color.webmaroon
	TextLabel.Text = "[shake rate=10 level=15][center]Поражение[/center][/shake]"
	pass

func visible_on():
	MainNode.visible = true
	tween_node.interpolate_property(MainNode, "modulate:a", 0, 1, 3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween_node.start()
	pass
