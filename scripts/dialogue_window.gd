extends Control

var dialogue_label: Label
var chunk_size := 1
signal line_finished
var is_line_finished : bool
var current_label : String

# Called when the node enters the scene tree for the first time.
func _ready():
	dialogue_label = $dialogue_box/dialogue
	is_line_finished = false
	current_label = ""


func change_label(new_label : String):
	current_label = new_label
	var shown := ""
	var pos := 0
	is_line_finished = false
	# Create timer
	while pos < new_label.length() and !is_line_finished:
		var next_chunk := new_label.substr(pos, chunk_size)
		shown += next_chunk
		dialogue_label.text = shown
		await get_tree().create_timer(0.04).timeout  
		pos += chunk_size
	is_line_finished = true
	
func skip_clicked():
	dialogue_label.text = current_label
	is_line_finished = true
	
func get_line_status():
	return is_line_finished
