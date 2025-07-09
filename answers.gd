extends Control


signal answer_chosen(answer)

@export var answer_1 : Button
@export var answer_2 : Button
@export var answer_3 : Button
var answers = []

func _ready():
	answers = [answer_1,answer_2,answer_3]

func change_label(button_name, new_label):
	for answer in answers:
		if answer.name == button_name:
			answer.text = new_label.to_upper()
			print("Answer changed")
			break

func change_visible(button_name, is_visible):
	for answer in answers:
		if answer.name == button_name:
			if !is_visible:
				answer.visible = false
			else:
				answer.visible = true

func _on_answer_1_pressed():
	answer_chosen.emit("1")


func _on_answer_2_pressed():
	answer_chosen.emit("2")


func _on_answer_3_pressed():
	answer_chosen.emit("3")
