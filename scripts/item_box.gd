extends Control

var item_buttons
var drag_preview 
var drag_texture 

@export var shop_button: TextureButton

signal item_dropped(item)
signal item_picked(button)
signal item_clicked(button)

func _ready():
	item_buttons = get_tree().get_nodes_in_group("itemboxbutton")
	if item_buttons.size() > 0:
		for button in item_buttons:
			button.item_button_clicked.connect(_on_button_pressed)
			button.item_button_being_pressed.connect(_on_button_down)
			button.item_button_dragged.connect(_on_button_dragged)

func _on_button_pressed(button):
	print("Clicked:", button.name)
	item_clicked.emit(button)

func _on_button_down(texture):
	drag_texture = texture  # Store texture for use if dragging happens

func _on_button_dragged(button):
	if !Flags.get_flag("dragging_locked"):
		print("Dragged:", button.name)
		button.visible = false
		item_picked.emit(button)

func make_invisible(button):
	button.visible = false

func _process(delta):
	pass

func _on_close_item_box_pressed():
	self.visible = false
