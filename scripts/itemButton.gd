#extends TextureButton
#
#signal item_button_clicked(button)
#signal item_button_being_pressed(texture)
#
#func _on_pressed():
	#item_button_clicked.emit(self)
#
#
#func _on_button_down():
	#item_button_being_pressed.emit(self.texture_normal)


extends TextureButton

signal item_button_clicked(button)
signal item_button_being_pressed(button)
signal item_button_dragged(button)

var is_mouse_down := false
var drag_start_position := Vector2.ZERO
var drag_threshold := 10.0
var has_dragged := false

func _ready():
	set_process(true)  # Make sure _process runs

func _on_pressed():
	if not has_dragged:
		item_button_clicked.emit(self)

func _on_button_down():
	is_mouse_down = true
	has_dragged = false
	drag_start_position = get_global_mouse_position()
	item_button_being_pressed.emit(self)

func _on_button_up():
	is_mouse_down = false

func _process(delta):
	if is_mouse_down:
		var current_pos = get_global_mouse_position()
		if not has_dragged and drag_start_position.distance_to(current_pos) > drag_threshold:
			has_dragged = true
			item_button_dragged.emit(self)
