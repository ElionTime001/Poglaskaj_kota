extends Node

var language = "eng"
var gameDataFileFath = "res://jasons/ui_elements_dialogue.json"

#JUST THE LOADED DATA
var gameData = {}

#RIGHT DATA IN THE RIGHT LANGUAGE
var itemData = {}
var dialogueData = {}

#
func _ready():
	gameData = load_json_file(gameDataFileFath)
	
	for key in gameData.keys():
		var type = gameData[key]["type"][language]
		print(gameData[key]["type"][language])
		if type == "ui":
			itemData[key] = {"name" : gameData[key]["name"][language], "sprite" : gameData[key]["sprite"]}
		elif type == "dialogue":
			var dialogue_array = gameData[key]["dialogues"]
			var new_dialogue_array = []
			
			for i in range(dialogue_array.size()):
				new_dialogue_array.append(dialogue_array[i][language])
			dialogueData[key] = {"name" : gameData[key]["name"][language], "dialogues": new_dialogue_array} 
	print(dialogueData)
	print(itemData)
	


func load_json_file(filePath: String):
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Dictionary:
			print("Game Data Loaded!")
			return parsedResult
		else:
			print("File is not a Disctonary!")
	else:
		print("File does not exist!")
		
func read_item_data(key:String, type: String):
	if itemData.has(key):
		return itemData[key][type]
	else:
		print("Failed to load the data!: ", key, " , ", type)
		
func read_dialogue_data(key:String, type: String):
	if dialogueData.has(key):
		return dialogueData[key][type]
	else:
		print("Failed to load the data!: ", key, " , ", type)
		
		
func change_language(new_language: String):
	language = new_language
