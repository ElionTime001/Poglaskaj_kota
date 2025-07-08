extends Node2D

@export var sprite_1: Sprite2D
@export var sprite_2: Sprite2D

var switch_back_timer: Timer

func _ready():
	# Ensure only sprite_1 is visible at start
	sprite_1.visible = true
	sprite_2.visible = false

	# Create a timer to handle the switch-back delay
	switch_back_timer = Timer.new()
	switch_back_timer.one_shot = true
	add_child(switch_back_timer)
	switch_back_timer.timeout.connect(_on_switch_back_timeout)
	

func switch_sprite_temporarily():
	sprite_1.visible = false
	sprite_2.visible = true

	# If timer is already running, stop it so we reset the duration
	if switch_back_timer.is_stopped() == false:
		switch_back_timer.stop()

	# Start the timer for the switch-back delay (0.2 sec)
	switch_back_timer.start(0.5)

func _on_switch_back_timeout():
	# When the timer finishes, switch back to sprite_1
	sprite_1.visible = true
	sprite_2.visible = false
