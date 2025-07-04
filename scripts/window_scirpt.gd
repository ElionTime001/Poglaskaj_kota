extends TextureRect

signal window_closed(window_name)


func _ready():
	pass


func _on_close_window_pressed():
	self.visible = false
	window_closed.emit(self.name)
	
