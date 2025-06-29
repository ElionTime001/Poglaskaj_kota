extends CanvasLayer

var dialogue_player : Control
var item_box: Control
var drag_preview 
var current_button_held : TextureButton
var menu: Control
var interface: Control

var chapter1_controller

func _ready():
	dialogue_player = $dialogue_player
	item_box = $item_box
	interface = $interface
	menu = $menu
	chapter1_controller = $Chapter1_controller
	
	interface.button_clicked.connect(interface_change)
	
	item_box.visible = false
	menu.visible = false
	interface.visible = true
	item_box.item_picked.connect(_create_drag_preview)
	
	await get_tree().create_timer(0.5).timeout
	
	#TO JEST DO USUNIĘCIA PÓŹNIEJ!!!!
	Flags.change_state("first_quest")
	
	chapter1_controller.story_proceed()
	#dialogue_player.play_dialogue("test_dialogue")
	
func _process(delta):
	if drag_preview:
		drag_preview.global_position = get_viewport().get_mouse_position()
		if !drag_preview.visible:
			drag_preview.visible = true
			await get_tree().create_timer(1).timeout
			item_box.visible = false
	
func _create_drag_preview(button):
	current_button_held = button
	
	if drag_preview:
		drag_preview.queue_free()

	drag_preview = TextureRect.new()
	drag_preview.texture = button.texture_normal
	drag_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE  # So it doesn't block input
	drag_preview.z_index = 1000  # Make sure it's on top
	drag_preview.scale = Vector2(0.5, 0.5)  # Optional: shrink if needed
	drag_preview.visible = false  # Optional: shrink if needed
	
	add_child(drag_preview)

func _remove_drag_preview():
	if drag_preview:
		var item_name = drag_preview.name
		drag_preview.queue_free()
		drag_preview = null
		button_dropped(current_button_held)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		_remove_drag_preview()

func button_dropped(button):
	interface.make_button_visible(button)
	print("Dropped button c: | " + button.name)
	
	if button.name == "shop":
		dialogue_player.play_dialogue("starting_1")
	
func interface_change(button):
	match button.name:
		"MainMenuButton":
			menu.visible = true
		"AddElementButton":
			item_box.visible = true
			
			#To tylko się dzieje jak jesteśmy przy tutorialu
			if Flags.get_flag("interface_clickable"):
				chapter1_controller.story_proceed()
			
		"petButton":
			var clicability = Flags.get_flag("cat_clickable")
			
			if clicability:
				chapter1_controller.story_proceed()
			else:
				#tu powinna być animacja.. w obu powinna być w sumie, może tutaj pass
				pass
			print("catto patted")
