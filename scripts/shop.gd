extends Control

var shop_elements = []
var shop_buttons = []

signal shop_active
signal button_has_been_clicked(button)
signal shop_closed

@export var interface: Control

func _ready():
	shop_elements = get_tree().get_nodes_in_group("shop_elements")
	shop_buttons = get_tree().get_nodes_in_group("shop_button")
	for panel in shop_elements:
			panel.visible = false
	for button in shop_buttons:
			button.clicked.connect(button_clicked)

func _process(delta):
	pass


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

func _on_close_shop_pressed():
	self.visible = false
	shop_closed.emit()
