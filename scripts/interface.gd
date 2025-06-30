extends Control

signal button_clicked(button)
signal button_dropped(button)

var buttons := []

var main_menu_button: TextureButton
var add_element_button: TextureButton
var catto_pat_button: Button

signal interface_button_clicked(button)


# Called when the node enters the scene tree for the first time.
func _ready():
	main_menu_button = $MainMenuButton
	add_element_button = $AddElementButton
	catto_pat_button = $petButton
	
	buttons = get_tree().get_nodes_in_group("mainscreenbutton")
	
	for button in buttons:
		button.visible = false
		button.clicked.connect(interface_button_pressed)
		
	#main_menu_button.visible = false
	#add_element_button.visible = false


func _process(delta):
	pass
	
func make_button_visible(button, is_drag_preview_there:=true):
	var button_name = button.name
	for right_button in buttons:
		if right_button.name == button_name:
			right_button.visible = true
			break
	if is_drag_preview_there:
		button_dropped.emit(button)


func _on_main_menu_button_pressed():
	button_clicked.emit(main_menu_button)


func _on_add_element_button_pressed():
	button_clicked.emit(add_element_button)

func show_menu():
	main_menu_button.visible = true
	add_element_button.visible = true

func _on_pet_button_pressed():
	button_clicked.emit(catto_pat_button)
	
func interface_button_pressed(button):
	print(button.name + " pressed")
	interface_button_clicked.emit(button)
