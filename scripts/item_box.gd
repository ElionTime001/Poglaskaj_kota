extends Control

var item_buttons
var drag_preview 
var drag_texture 

signal item_dropped(item)

func _ready():
	item_buttons = get_tree().get_nodes_in_group("itemboxbutton")
	if item_buttons.size() > 0:
		for button in item_buttons:
			button.item_button_clicked.connect(_on_button_pressed)
			button.item_button_being_pressed.connect(_on_button_down)
			button.item_button_dragged.connect(_on_button_dragged)

func _on_button_pressed(button):
	print("Clicked:", button.name)
	#_remove_drag_preview()

func _on_button_down(texture):
	drag_texture = texture  # Store texture for use if dragging happens

func _on_button_dragged(button):
	print("Dragged:", button.name)
	_create_drag_preview(drag_texture)

func _process(delta):
	if drag_preview:
		drag_preview.global_position = get_viewport().get_mouse_position()
		if !drag_preview.visible:
			drag_preview.visible = true

func _create_drag_preview(button):
	if drag_preview:
		drag_preview.queue_free()

	drag_preview = TextureRect.new()
	drag_preview.texture = button.texture_normal
	drag_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE  # So it doesn't block input
	drag_preview.z_index = 1000  # Make sure it's on top
	drag_preview.scale = Vector2(0.5, 0.5)  # Optional: shrink if needed
	drag_preview.visible = false  # Optional: shrink if needed
	drag_preview.name = button.name
	add_child(drag_preview)

func _remove_drag_preview():
	if drag_preview:
		var item_name = drag_preview.name
		drag_preview.queue_free()
		drag_preview = null
		item_dropped.emit(item_name)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		_remove_drag_preview()
