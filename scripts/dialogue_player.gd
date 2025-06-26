extends Control

var further_doalogue : Button
var dialogue_window : Control

var dialogue_array = []
var index 
var array_size 

func appear():
	self.visible = true

func disappear():
	self.visible = false

func _ready():
	further_doalogue = $FurtherDialogueButton
	dialogue_window = $dialogue_window
	
func _on_further_dialogue_button_pressed():
	print("pass")
	foroward_dialogue()
	
func play_dialogue(key: String):
	index = 0
	dialogue_array = DataFiles.read_dialogue_data(key,"dialogues")
	array_size = dialogue_array.size()
	dialogue_window.change_label(dialogue_array[index])
	print(array_size)
	appear()
	
func foroward_dialogue():
	if dialogue_window.get_line_status():
		if index+1 < array_size:
			index += 1
			dialogue_window.change_label(dialogue_array[index])
		else:
			print("Dialogue finished")
			disappear()
	else:
		dialogue_window.skip_clicked()
