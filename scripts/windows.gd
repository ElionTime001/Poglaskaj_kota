extends Control

var windows = []

signal window_opened(window_name)
signal window_closed(window_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	windows = get_tree().get_nodes_in_group("windows")
	
	for window in windows:
		window.visible = false
		window.window_closed.connect(on_window_closed)
		

func on_window_closed(window_name):
	self.visible = false
	window_closed.emit(window_name)

func open_window(window_name):
	make_everything_invisible()
	
	for window in windows:
		if window.name == window_name:
			window.visible = true
			self.visible = true
			window_opened.emit(window.name)
			bounce_window(window)
			break

func make_everything_invisible():
	for window in windows:
		if window.visible:
			window.visible = false

func bounce_window(window):
	
	var tween = get_tree().create_tween()
	var start_pos = window.position
	var bounce_up = start_pos - Vector2(0, 20)

	tween.tween_property(window, "position", bounce_up, 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(window, "position", start_pos, 0.2).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
