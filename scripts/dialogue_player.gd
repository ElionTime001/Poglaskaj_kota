extends Control

var further_doalogue : Button

var dialogue_array = []

func _ready():
	further_doalogue = $FurtherDialogueButton

func _on_further_dialogue_button_pressed():
	print("pass")
	
func play_dialogue(key: String):
	dialogue_array = DataFiles.read_dialogue_data(key,"dialogues")
	
