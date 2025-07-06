extends "res://scripts/window_scirpt.gd"

@export var claim_button: Button
@export var touch_screen_label: Label

@export var freeCurrency_icon : TextureRect
@export var paidCurrency_icon : TextureRect
@export var energy_icon : TextureRect

@export var claim_label: Label

var _currency_number
var _currency_name

var icons = []

func _ready():
	tween_label(touch_screen_label) 
	icons = [freeCurrency_icon, paidCurrency_icon, energy_icon]

func _process(delta):
	pass


func prepare_claim(currency_name: String, currency_number: String):
	_currency_name = currency_name
	_currency_number = currency_number
	for icon in icons:
		icon.visible = false
	claim_label.text = "x" + currency_number
	for icon in icons:
		if icon.name == currency_name:
			icon.visible = true
			break
	
func get_currency_number():
	return _currency_number

func get_currency_name():
	return _currency_name

func _on_claim_button_pressed():
	self.visible = false
	claim_button.visible = false
	window_closed.emit(self.name)
	
func tween_label(label):
	# Make sure the node starts visible
	label.modulate.a = 1.0

	var tween = create_tween()
	tween.set_loops()  

	tween.tween_property(label, "modulate:a", 0.0, 1.0).from(1.0)
	tween.tween_property(label, "modulate:a", 1.0, 1.0).from(0.0)
