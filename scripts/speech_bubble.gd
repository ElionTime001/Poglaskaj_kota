extends Control

var dialogue_array 
var array_size
var index

var label : Label
var animation_player: AnimationPlayer
var random_dialogue: MarginContainer


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
	dialogue_array = DataFiles.read_dialogue_data(key,"dialogues")
	array_size = dialogue_array.size()
	#label.text = dialogue_array[index]
	print(array_size)
	change_label_with_bounce(dialogue_array[index])
	appear()
	bounce_container_once(random_dialogue)

func _on_proceed_pressed():
		if index+1 < array_size:
			index += 1
			#label.text = dialogue_array[index]
			change_label_with_bounce(dialogue_array[index])
			bounce_container_once(random_dialogue)
		else:
			print("Dialogue finished")
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



