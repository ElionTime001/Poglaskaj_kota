extends Label

var timer: Timer

func _ready():
	timer = $Timer
	timer.start()

func _process(delta):
	update_timer_text()

func update_timer_text():
	var time_remaining = int(timer.get_time_left())
	var hours = time_remaining / 3600
	var minutes = (time_remaining % 3600) / 60
	var seconds = time_remaining % 60

	text = "%02d:%02d:%02d" % [hours, minutes, seconds]
