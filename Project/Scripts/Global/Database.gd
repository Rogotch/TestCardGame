extends Node


var cards = {}

func _ready():
#	yield(get_tree(), "idle_frame")
	cards = loadDB("res://Project/Database/All_Cards.json")
	pass

func loadDB(path):
	var uploadedData = {}
	var data_file = File.new()
	
	if data_file.open(path, File.READ) != OK:
		push_error("Error open file")
		return
		
	var data_text = data_file.get_as_text()
	data_file.close()
	var data_parse = JSON.parse(data_text)
	
	if data_parse.error != OK:
		push_error("Error parse")
		return
		
	var data = data_parse.result
	uploadedData = data
	
	return uploadedData
	pass

func GetObjectByIDFromArr(id, arr):
	return GetObjectByValueFromArr("id", id, arr)
	pass

func GetObjectByValueFromArr(valueName : String, value, arr):
	for obj in arr:
		if obj.has(valueName) && obj[valueName] == value:
			return obj
	return null
	pass

func GetAllObjectsByValueFromArr(valueName : String, value, arr):
	var finalArr = []
	for obj in arr:
		if obj.has(valueName) && obj[valueName] == value:
			finalArr.append(obj)
	return finalArr
	pass
