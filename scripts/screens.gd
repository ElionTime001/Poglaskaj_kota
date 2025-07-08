extends CanvasLayer

var dialogue_player : Control
var item_box: Control
var drag_preview 
var current_button_held : TextureButton
var menu: Control
var interface: Control
var shop: Control
var gatcha: Control
var windows: Control
var show_numbers: Control

var energy_bar: Control

var chapter1_controller

func _ready():
	dialogue_player = $dialogue_player
	item_box = $item_box
	interface = $interface
	menu = $menu
	chapter1_controller = $Chapter1_controller
	shop = $shop
	gatcha = $gatcha
	energy_bar = $energy_bar
	windows = $windows
	show_numbers = $just_number_showing_labels
	
	interface.button_clicked.connect(interface_change)
	interface.interface_button_clicked.connect(interface_change)
	
	shop.shop_active.connect(shop_active_function)
	gatcha.gatcha_active.connect(gatcha_active_function)
	
	item_box.visible = false
	menu.visible = false
	interface.visible = true
	item_box.item_picked.connect(_create_drag_preview)
	
	await get_tree().create_timer(0.5).timeout
	
	#TO JEST DO USUNIĘCIA PÓŹNIEJ!!!!
	#Flags.change_state("tutorial_interface")
	#interface.show_menu()
	#Flags.change_flag("dragging_locked",false)
	
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
	
func shop_active_function():
	interface.hide_menu()
	interface.show_back_to_shop()
	
	while true:
		var button = await interface.interface_button_clicked
		if button.name == "BackToShopButton":
			Flags.is_shop_active = false
			shop.visible = true
			interface.show_menu()
			interface.hide_back_to_shop()
			break
		else:
			var found := false
			var panels = shop.get_panels()
			for panel in panels:
				if button.name == panel.name:
					shop.visible = true
					interface.show_menu()
					interface.hide_back_to_shop()
					await get_tree().create_timer(0.5).timeout
					match button.name:
						"gatcha":
							await add_statistics("gatcha_shop")
						"skinCollection":
							await add_statistics("skins_shop")
						"paidCurrency":
							await add_statistics("paid_currency_shop")
						"energy":
							await add_statistics("energy_shop")
					shop.make_panel_visible(panel.name)
					Flags.is_shop_active = false
					chapter1_controller.story_proceed(panel.name) #what's this??
					found = true
					break
			if found:
				break

func gatcha_active_function():
	interface.hide_menu()
	interface.show_back_to_shop()
	
	while true:
		var button = await interface.interface_button_clicked
		if button.name == "BackToShopButton":
			Flags.is_gatcha_active = false
			gatcha.visible = true
			interface.show_menu()
			interface.hide_back_to_shop()
			break
		else:
			var found := false
			var panels = gatcha.get_panels()
			for panel in panels:
				if button.name == panel.name:
					gatcha.visible = true
					interface.show_menu()
					interface.hide_back_to_shop()
					await get_tree().create_timer(0.5).timeout
					match panel.name:
						"skinCollection":
							await add_statistics("gatcha_skin")
							Flags.change_flag("skins_gatcha", true)
						"catCollection":
							await add_statistics("gatcha_cat")
							Flags.change_flag("characters_gatcha",true)
					gatcha.make_panel_visible(panel.name)
					Flags.is_gatcha_active = false
					chapter1_controller.gatcha_sidequest_proceed(panel.name)
					found = true
					break
			if found:
				break

func interface_change(button):
	if !Flags.is_shop_active and !Flags.is_gatcha_active and !Flags.is_choosing_answer:
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
					pass
				Flags.amount_of_pats += 1
				if energy_bar.visible:
					energy_bar.energy_depleat()
					var energy_number = int(interface.get_currency("energy"))
					if energy_number > 0:
						Flags.amount_of_energy_used += 1
						energy_number -= 1
						interface.set_currency("energy",str(energy_number))
					else:
						windows.open_window("specialOfferenergy")
					
				print("catto patted")
			"shop":
				shop.visible = true
			"gatcha":
				gatcha.visible = true
				if !Flags.get_flag("gatcha_quest_finished"):
					chapter1_controller.gatcha_sidequest_proceed()

func add_statistics(panel_name):
	var panel_data = DataFiles.read_panel_data(panel_name)
	var mon = panel_data["money"]
	var hab = panel_data["habit"]
	var ir = panel_data["annoyance"]
	menu.add_values_to_progress_bars(int(mon),int(hab),int(ir))
	await show_numbers.appear_disappear(str(mon),str(hab),str(ir))
