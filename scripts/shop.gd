extends Control

var shop_elements = []

signal shop_active

@export var interface: Control

func _ready():
	shop_elements = get_tree().get_nodes_in_group("shop_elements")
	for panel in shop_elements:
			panel.visible = false

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
