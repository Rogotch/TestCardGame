tool
extends RichTextLabel

class_name CustomRichTextLabel

var fontsDictionary = {
	"NunitoSans-Regular"           : "res://Project/Fonts/Nunito_Sans/NunitoSans-Regular.ttf",
	"NunitoSans-Black"             : "res://Project/Fonts/Nunito_Sans/NunitoSans-Black.ttf",
	"NunitoSans-BlackItalic"       : "res://Project/Fonts/Nunito_Sans/NunitoSans-BlackItalic.ttf",
	"NunitoSans-Bold"              : "res://Project/Fonts/Nunito_Sans/NunitoSans-Bold.ttf",
	"NunitoSans-BoldItalic"        : "res://Project/Fonts/Nunito_Sans/NunitoSans-BoldItalic.ttf",
	"NunitoSans-ExtraBold"         : "res://Project/Fonts/Nunito_Sans/NunitoSans-ExtraBold.ttf",
	"NunitoSans-ExtraBoldItalic"   : "res://Project/Fonts/Nunito_Sans/NunitoSans-ExtraBoldItalic.ttf",
	"NunitoSans-ExtraLight"        : "res://Project/Fonts/Nunito_Sans/NunitoSans-ExtraLight.ttf",
	"NunitoSans-ExtraLightItalic"  : "res://Project/Fonts/Nunito_Sans/NunitoSans-ExtraLightItalic.ttf",
	"NunitoSans-Italic"            : "res://Project/Fonts/Nunito_Sans/NunitoSans-Italic.ttf",
	"NunitoSans-Light"             : "res://Project/Fonts/Nunito_Sans/NunitoSans-Light.ttf",
	"NunitoSans-LightItalic"       : "res://Project/Fonts/Nunito_Sans/NunitoSans-LightItalic.ttf",
	"NunitoSans-SemiBold"          : "res://Project/Fonts/Nunito_Sans/NunitoSans-SemiBold.ttf",
	"NunitoSans-SemiBoldItalic"    : "res://Project/Fonts/Nunito_Sans/NunitoSans-SemiBoldItalic.ttf",
	"Tupo-Vyaz_Bold"               : "res://Project/Fonts/Tupo-Vyaz/Tupo-Vyaz_Bold.ttf",
	"Tupo-Vyaz_Regular"            : "res://Project/Fonts/Tupo-Vyaz/Tupo-Vyaz_Regular.ttf",
	"Tupo-Vyaz_Thin"               : "res://Project/Fonts/Tupo-Vyaz/Tupo-Vyaz_Thin.ttf",
	"Tupo-Vyaz_VF"                 : "res://Project/Fonts/Tupo-Vyaz/Tupo-Vyaz_VF.ttf",
	"DwarvenStonecraftCyr"         : "res://Project/Fonts/dwarven_stonecraft/DwarvenStonecraftCyr.otf",
	"NeverSmile"                   : "res://Project/Fonts/never_smile/NeverSmile/NeverSmile.ttf",
	"Rurikvikingfont-Regular"      : "res://Project/Fonts/rurik/Rurikvikingfont-Regular.ttf",
	"Skandal"                      : "res://Project/Fonts/skandal/Skandal.ttf",
	"JetBrainsMono-Regular"        : "res://Project/Fonts/JetBrainsMono/JetBrainsMono-Regular.ttf",
}

#var keys = ["NunitoSans-Regular", "NunitoSans-ExtraLight", "SourceSansPro-Regular", "SourceSansPro-ExtraLight", "DwarvenStonecraftCyr", "Skandal"]
export(int) var font_size = 14          setget setFontSize
export(Color) var font_outline_color    setget SetOutlineColor
export(int)   var font_outline_size = 0 setget SetOutlineSize


var Text = "" setget SetLabelText
var newFont = null

#var my_property = 0

var TypeNormalFont     = "NunitoSans-Regular"       setget setNormalFontParams
var TypeBoldFont       = "NunitoSans-Bold"          setget setBoldFontParams
var TypeBoldItalicFont = "NunitoSans-BoldItalic"    setget setBoldItalicFontParams
var TypeItalicFont     = "NunitoSans-Italic"        setget setItalicFontParams
var TypeMonoFont       = "JetBrainsMono-Regular"    setget setMonoFontParams

#func _get_property_list():
#	var properties = []
#	# Same as "export(int) var my_property"
#	properties.append({
#		name = "my_property",
#		type = TYPE_INT
#	})
#	return properties

func _get_property_list():
	var ret = []
	ret.push_back({"name": "TypeNormalFont", "type": TYPE_STRING, "usage" : PROPERTY_USAGE_DEFAULT, "hint": 3, "hint_string": getAllfonts()})
	ret.push_back({"name": "TypeBoldFont", "type": TYPE_STRING, "usage" : PROPERTY_USAGE_DEFAULT, "hint": 3, "hint_string": getAllfonts()})
	ret.push_back({"name": "TypeBoldItalicFont", "type": TYPE_STRING, "usage" : PROPERTY_USAGE_DEFAULT, "hint": 3, "hint_string": getAllfonts()})
	ret.push_back({"name": "TypeItalicFont", "type": TYPE_STRING, "usage" : PROPERTY_USAGE_DEFAULT, "hint": 3, "hint_string": getAllfonts()})
	ret.push_back({"name": "TypeMonoFont", "type": TYPE_STRING, "usage" : PROPERTY_USAGE_DEFAULT, "hint": 3, "hint_string": getAllfonts()})
#	ret.push_back({"name": "my_property", "type": TYPE_INT, "hint": 3, "hint_string": "Hello,Something,Else"})
	return ret

func getAllfonts() -> String:
	var allFontsString = ""
	var count = 0
	for font in fontsDictionary.keys():
		allFontsString += font
		if count != fontsDictionary.size() - 1:
			allFontsString += ","
		count += 1
	return allFontsString
	pass

func _ready():
#	print(bbcode_text)
#	var friendFormating = Scripts._bbc_AddShakeString("Друг", 13, 13)
#	friendFormating = Scripts._bbc_AddClicable(friendFormating, {tap = true})
#	SetLabelText("Давно не виделись, мой старый добрый " + friendFormating)
#	set_text("Давно не виделись, мой старый добрый ")
#	append_bbcode(AddShakeString("Друг"))
#	set_bbcode("Давно не виделись, мой старый добрый "+AddShakeString("Друг"))
#	setAllFontParams()
#	setFontParams()
	pass

func SetLabelText(newText):
	if bbcode_enabled:
		set_bbcode(str(newText)) 
	else:
		set_text(str(newText))
	Text = text
#	prints("newText", newText)
#	text = newText
#	bbcode_enabled = true
	pass

#func GetLabelText():
#	return text
#	pass

func SetOutlineColor(color):
	font_outline_color = color
	setAllFontParams()
#	setFontParams()
	pass

func SetOutlineSize(size):
	font_outline_size = size
	setAllFontParams()
#	setFontParams()
	pass

#func setFontParams():
#	if TypeNormalFont == null:
#		type = 0
#	newFont = DynamicFont.new()
##	newFont.antialiased = true
#	newFont.outline_color = font_outline_color
#	newFont.outline_size = font_outline_size
#	newFont.font_data = load(fonts[type]).duplicate()
##	newFont.font_data.antialiased = false
#	newFont.size = font_size
#	add_font_override("bold_font", newFont)
#	add_font_override("bold_italics_font", newFont)
#	add_font_override("italics_font", newFont)
#	add_font_override("mono_font", newFont)
#	add_font_override("normal_font", newFont)
#	pass

func getFontParam(fontKey) -> DynamicFont:
	newFont = DynamicFont.new()
#	newFont.antialiased = true
	newFont.outline_color = font_outline_color
	newFont.outline_size = font_outline_size
	newFont.font_data = load(fontsDictionary[fontKey]).duplicate()
#	newFont.font_data.antialiased = false
	newFont.size = font_size
	return newFont
	pass

func setNormalFontParams(newValue = null):
	if newValue == null:
		newValue = fontsDictionary.keys()[0]
	TypeNormalFont = newValue
	add_font_override("normal_font", getFontParam(TypeNormalFont))
	pass

func setBoldFontParams(newValue = null):
	if newValue == null:
		newValue = fontsDictionary.keys()[0]
	TypeBoldFont = newValue
	add_font_override("bold_font", getFontParam(TypeBoldFont))
	pass

func setBoldItalicFontParams(newValue = null):
	if newValue == null:
		newValue = fontsDictionary.keys()[0]
	TypeBoldItalicFont = newValue
	add_font_override("bold_italics_font", getFontParam(TypeBoldItalicFont))
	pass

func setItalicFontParams(newValue = null):
	if newValue == null:
		newValue = fontsDictionary.keys()[0]
	TypeItalicFont = newValue
	add_font_override("italics_font", getFontParam(TypeItalicFont))
	pass

func setMonoFontParams(newValue = null):
	if newValue == null:
		print("newValueBefore", newValue)
		newValue = fontsDictionary.keys()[0]
		print("newValueAfter", newValue)
		
	TypeMonoFont = newValue
	add_font_override("mono_font", getFontParam(TypeMonoFont))
	pass

func setAllFontParams():
	setNormalFontParams(TypeNormalFont)
	setBoldFontParams(TypeBoldFont)
	setBoldItalicFontParams(TypeBoldItalicFont)
	setItalicFontParams(TypeItalicFont)
	setMonoFontParams(TypeMonoFont)
	pass

func setFontSize(value):
	font_size = value
	setAllFontParams()
#	setFontParams()
	pass

func setFontType(value):
#	type = value
#	setFontParams()
	pass
