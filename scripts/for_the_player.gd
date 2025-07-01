extends Control

var highlightsandarrows = []
var fade_tween: Tween
var float_tween: Tween 

@export var float_distance := 20.0  
@export var float_duration := 1.0

func _ready():
	highlightsandarrows = get_tree().get_nodes_in_group("highlights_and_arrows")
	for node in highlightsandarrows:
		node.visible = false

func find_node(target_node_name: String):
	for node in highlightsandarrows:
		if node.name == target_node_name:
			return node

func node_appear_ingame(target_node_name: String, is_fading := true ):
	if is_fading:
		fade_loop(target_node_name)
	else:
		float_loop(target_node_name)
	_node_appear(target_node_name)

func node_disappear_ingame(target_node_name: String, is_fading := true):
	_node_disappear(target_node_name)
	if is_fading:
		stop_fade()
	else:
		stop_float()

func _node_appear(target_node_name: String):
	var target_node = find_node(target_node_name)
	target_node.visible = true
	
func _node_disappear(target_node_name: String):
	var target_node = find_node(target_node_name)
	target_node.visible = false

func fade_loop(target_node_name: String):
	var target_node = find_node(target_node_name)
	
	var fade_duration := 1.0
	if fade_tween: 
		fade_tween.kill()

	fade_tween = create_tween()
	fade_tween.set_loops()
	fade_tween.tween_property(target_node, "modulate:a", 0.0, 1.0).from(1.0)
	fade_tween.tween_property(target_node, "modulate:a", 1.0, 1.0).from(0.0)

func float_loop(target_node_name: String):
	
	var target_node = find_node(target_node_name)
	if float_tween:
		float_tween.kill()

	float_tween = create_tween()
	float_tween.set_loops()

	var start_pos = target_node.position
	var up_pos = start_pos + Vector2(0, -float_distance)
	var down_pos = start_pos + Vector2(0, float_distance)

	float_tween.tween_property(target_node, "position", up_pos, float_duration)
	float_tween.tween_property(target_node, "position", down_pos, float_duration)

func stop_fade():
	if fade_tween:
		fade_tween.kill()
		fade_tween = null 

func stop_float():
	if float_tween:
		float_tween.kill()
		float_tween = null

func _process(delta):
	pass
