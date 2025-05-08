extends CanvasLayer

var dialogue_player : Control

func _ready():
	dialogue_player = $dialogue_player
	dialogue_player.play_dialogue("test_dialogue")

