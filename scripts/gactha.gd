extends Control

var gatcha_panels
var background
var changed_currency

signal gatcha_active

func _ready():
	background = $background
	changed_currency = $changed_currency
	
	gatcha_panels = get_tree().get_nodes_in_group("gatcha_panels")
	
	for panel in gatcha_panels:
		panel.visible = false
	background.visible = false

func make_panel_visible(panel_name):
	for panel in gatcha_panels:
		if panel.name == panel_name:
			panel.visible = true
			break
			
func _on_add_element_button_pressed():
	Flags.is_gatcha_active = true
	self.visible = false
	gatcha_active.emit()

func get_panels():
	return gatcha_panels

func _on_close_item_box_pressed():
	self.visible = false
