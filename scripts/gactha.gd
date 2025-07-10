extends Control

var gatcha_panels
var background
var changed_currency

@export var bg_basic: TextureRect
@export var bg_featured: TextureRect
@export var bg_skin: TextureRect

@export var cat_basic: TextureRect
@export var cat_basic2: TextureRect
@export var cat_featured: TextureRect
@export var cat_skin: TextureRect
@export var cat_skin2: TextureRect

@export var gatcha_currency : TextureRect
@export var losowanie: Panel

@export var windows: Control
@export var dialogue_player : Control

signal gatcha_closed

signal gatcha_active

func _ready():
	#background = $background
	changed_currency = $changed_currency
	
	gatcha_panels = get_tree().get_nodes_in_group("gatcha_panels")
	
	for panel in gatcha_panels:
		panel.visible = false
	#background.visible = false
	gatcha_currency.visible = false
	_hide_all()
	losowanie.visible = false
	gatcha_currency.visible = false

func make_panel_visible(panel_name):
	for panel in gatcha_panels:
		if panel.name == panel_name:
			panel.visible = true
			if panel.name == "skinCollection":
				for panel2 in gatcha_panels:
					if panel2.name == "gatcha_character_rate":
						panel2.visible = true
			break
			
func _on_add_element_button_pressed():
	Flags.is_gatcha_active = true
	self.visible = false
	gatcha_active.emit()

func get_panels():
	return gatcha_panels

func _on_close_item_box_pressed():
	self.visible = false
	gatcha_closed.emit()

func _hide_all():
	bg_basic.visible = false
	bg_featured.visible = false
	bg_skin.visible = false
	
	cat_basic.visible = false
	cat_basic2.visible = false
	cat_featured.visible = false
	cat_skin.visible = false
	cat_skin2.visible = false

func _on_featured_button_pressed():
	_hide_all()
	bg_featured.visible = true
	fade_in_node(cat_featured)


func _on_skin_button_pressed():
	_hide_all()
	bg_skin.visible = true
	fade_in_node(cat_skin)
	fade_in_node(cat_skin2)


func _on_basic_button_pressed():
	_hide_all()
	bg_basic.visible = true
	fade_in_node(cat_basic)
	fade_in_node(cat_basic2)

func make_currency_appear():
	gatcha_currency.visible = true
	bounce_window(gatcha_currency)

func make_losowanie_appear():
	losowanie.visible = true

func screen_after_gatcha_finish():
	make_currency_appear()
	make_losowanie_appear()
	bg_basic.visible = true
	cat_basic.visible = true
	cat_basic2.visible = true

func bounce_window(window):
	
	var tween = get_tree().create_tween()
	var start_pos = window.position
	var bounce_up = start_pos - Vector2(0, 20)

	tween.tween_property(window, "position", bounce_up, 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(window, "position", start_pos, 0.2).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

func fade_in_node(node: TextureRect, duration := 0.3):
	node.modulate.a = 0.0  # Make fully transparent
	node.visible = true

	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 1.0, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _on_losowanie_pressed():
	windows.open_window("specialgatcha")
	if !Flags.get_flag("gatcha_tried_pulling"):
		dialogue_player.play_dialogue("gatcha_ad")
		await dialogue_player.dialogue_finished
		Flags.change_flag("gatcha_tried_pulling",true)
	
	
