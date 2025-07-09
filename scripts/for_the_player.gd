extends Control

var highlightsandarrows = []
var fade_tween: Tween
var float_tween: Tween 

@export var float_distance := 20.0  
@export var float_duration := 1.0

@export var interface_info: Panel
@export var interface_label : Label
@export var shop_info : Panel

var label_texts = {
	"loss_aversion" : "Wskaż elementy interfejsu, które mogą mieć związek z Loss Aversion.",
	"sunk_cost" : "Wskaż element powiązany z Sunk Cost Fallacy.",
	"shop" : "Wskaż element, który będzie użyty jako waluta cen w sklepie.",
	"free_reward" : "Wskaż gdzie można umieścić kolejną, codzienną, darmową nagrodę.",
	"habit" : "Wskaż elementy interfejsu wpływające na wyrabianie nawyków."
}

func _ready():
	highlightsandarrows = get_tree().get_nodes_in_group("highlights_and_arrows")
	for node in highlightsandarrows:
		node.visible = false
		
		
func appear_info(key: String, is_shop := false):
	if is_shop:
		shop_info.visible = true
		bounce_window(shop_info)
	else:
		interface_label.text = label_texts[key]
		interface_info.visible = true
		bounce_window(interface_info)

func hide_info():
	interface_info.visible = false
	shop_info.visible = false

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

func bounce_window(window):
	var tween = get_tree().create_tween()
	var start_pos = window.position
	var bounce_up = start_pos - Vector2(0, 20)

	tween.tween_property(window, "position", bounce_up, 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(window, "position", start_pos, 0.2).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
