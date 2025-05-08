extends Control

var dialogue_label: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	dialogue_label = $dialogue_box/dialogue


func change_label(new_label : String):
	dialogue_label.text = new_label
