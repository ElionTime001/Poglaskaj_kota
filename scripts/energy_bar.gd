extends Control

@export var energy_value: TextureProgressBar

var current_energy_maximum := 5

signal no_energy_left

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	energy_value.value = 5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func energy_depleat():
	var current_value = energy_value.value
	if current_value > 0:
		energy_value.value = current_value - 1
	else:
		no_energy_left.emit()

func energy_added(how_much: int):
	var current_value = energy_value.value
	if current_value + how_much > 5:
		energy_value.value = 5
	else:
		energy_value.value = current_value + how_much

func _get_energy():
	return energy_value.value
