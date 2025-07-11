extends Control

var dialogue_array 
var array_size
var index

var label : Label
var animation_player: AnimationPlayer
var random_dialogue: MarginContainer
var current_key

signal dialogue_finished(current_dialogue_key)


# Called when the node enters the scene tree for the first time.
func _ready():
	label = $"random dialogue/MarginContainer/Label"
	random_dialogue = $"random dialogue"
	index = 0
	
	#play_dialogue("intro")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_dialogue(key: String):
	index = 0
	current_key = key
	dialogue_array = DataFiles.read_dialogue_data(key,"dialogues")
	array_size = dialogue_array.size()
	#label.text = dialogue_array[index]
	print(array_size)
	var pure_dialogue = extract_sprite_tag(dialogue_array[index])
	change_label_with_bounce(pure_dialogue["text"])
	appear()
	bounce_container_once(random_dialogue)

func _on_proceed_pressed():
		if index+1 < array_size:
			index += 1
			#label.text = dialogue_array[index]
			var pure_dialogue = extract_sprite_tag(dialogue_array[index])
			change_label_with_bounce(pure_dialogue["text"])
			bounce_container_once(random_dialogue)
		else:
			print("Dialogue finished")
			dialogue_finished.emit(current_key)
			disappear()

func disappear():
	self.visible = false
	
func appear():
	self.visible = true
	
func bounce_container_once(container: MarginContainer):
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	var start_pos = container.position
	var up_pos = start_pos + Vector2(0, -10)

	tween.tween_property(container, "position", up_pos, 0.1)
	tween.tween_property(container, "position", start_pos, 0.1)
	
func change_label_with_bounce(new_text: String):
	# 1. Clear text to let the container shrink
	label.text = ""

	# 2. Force an update
	await get_tree().process_frame

	# 3. Now update the text to grow naturally
	label.text = new_text

	# 4. Bounce effect (optional)
	#bounce_container_once(random_dialogue)

func extract_sprite_tag(line: String) -> Dictionary:
	var pattern = r"\((.*?)\)$"  # Matches text in () at the end
	var regex = RegEx.new()
	regex.compile(pattern)
	var result = regex.search(line)
	
	var sprite_name = ""
	if result:
		sprite_name = result.get_string(1)
		# Remove the (tag) from the original line
		line = line.substr(0, result.get_start()).strip_edges()
	
	return {
		"text": line,
		"sprite": sprite_name
	}





