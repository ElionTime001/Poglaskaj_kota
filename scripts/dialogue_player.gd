extends Control

var further_doalogue : Button
var dialogue_window : Control
var cat_sprite: Control

var dialogue_array = []
var index 
var array_size 
var current_key

signal dialogue_finished(current_dialogue_key)

func appear():
	self.visible = true

func disappear():
	self.visible = false

func _ready():
	further_doalogue = $FurtherDialogueButton
	dialogue_window = $dialogue_window
	cat_sprite = $sprite
	
func _on_further_dialogue_button_pressed():
	print("pass")
	foroward_dialogue()
	
func play_dialogue(key: String):
	current_key = key
	index = 0
	dialogue_array = DataFiles.read_dialogue_data(key,"dialogues")
	array_size = dialogue_array.size()
	animate_cat()
	dialogue_window.change_label(dialogue_array[index])
	print(array_size)
	appear()
	
func foroward_dialogue():
	if dialogue_window.get_line_status():
		if index+1 < array_size:
			index += 1
			animate_cat()
			dialogue_window.change_label(dialogue_array[index])
		else:
			print("Dialogue finished")
			dialogue_finished.emit(current_key)
			disappear()
	else:
		dialogue_window.skip_clicked()
		
func animate_cat():
	var start_y = cat_sprite.position.y
	var up_y = start_y - 10

	var tween = get_tree().create_tween()
	tween.tween_property(cat_sprite, "position:y", up_y, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(cat_sprite, "position:y", start_y, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

