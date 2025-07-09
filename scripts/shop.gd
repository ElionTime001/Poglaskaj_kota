extends Control

var shop_elements = []
var shop_buttons = []

signal shop_active
signal button_has_been_clicked(button)
signal shop_closed

var pln_labels = []
var coin_textures = []
var pln_price = []
var coin_price = []

@export var interface: Control

@export var specialOffer: Panel
@export var freeOffer: Panel

func _ready():
	shop_elements = get_tree().get_nodes_in_group("shop_elements")
	shop_buttons = get_tree().get_nodes_in_group("shop_button")
	
	pln_labels = get_tree().get_nodes_in_group("pln")
	coin_textures = get_tree().get_nodes_in_group("paid")
	pln_price = get_tree().get_nodes_in_group("pln_price")
	coin_price = get_tree().get_nodes_in_group("coin_price")
	
	for texture in coin_textures:
		texture.visible = false
	for coin in coin_price:
		coin.visible = false
	
	for panel in shop_elements:
			panel.visible = false
	for button in shop_buttons:
			button.clicked.connect(button_clicked)
	freeOffer.visible = false
	animate_panel(freeOffer)
	specialOffer.visible = false

func _process(delta):
	pass

func change_for_coins():
	for pln in pln_labels:
		pln.visible = false
	for pln in pln_price:
		pln.visible = false
	for texture in coin_textures:
		texture.visible = true
	for coin in coin_price:
		coin.visible = true

func _on_add_element_button_pressed():
	Flags.is_shop_active = true
	self.visible = false
	shop_active.emit()

func get_panels():
	return shop_elements

func make_panel_visible(panel_name):
	for panel in shop_elements:
		if panel.name == panel_name:
			panel.visible = true
			
func button_clicked(button):
	button_has_been_clicked.emit(button)

func make_skins_disappear():
	for element in shop_elements:
		if element.name == "skinCollection":
			element.visible = false

func _on_close_shop_pressed():
	self.visible = false
	shop_closed.emit()

func special_offer_appear():
	specialOffer.visible = true
	bounce_window(specialOffer)

func free_offer_appear():
	freeOffer.visible = true
	bounce_window(freeOffer)

func bounce_window(window):
	
	var tween = get_tree().create_tween()
	var start_pos = window.position
	var bounce_up = start_pos - Vector2(0, 20)

	tween.tween_property(window, "position", bounce_up, 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(window, "position", start_pos, 0.2).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

func animate_panel(badge):
	var tween = create_tween()
	tween.set_loops()

	tween.tween_property(badge, "scale", Vector2(1.1, 1.1), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(badge, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
