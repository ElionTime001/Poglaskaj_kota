extends Control


@export var labels: Control
@export var mon_ile : Label
@export var hab_ile : Label
@export var ir_ile : Label

var original_position: Vector2

func _ready():
	original_position = position
	#await _appear("3","2","4").finished
	#await get_tree().create_timer(1.5).timeout
	#_disappear()

func appear_disappear(mon: String, hab: String, ir: String):
	await _appear(mon,hab,ir).finished
	await get_tree().create_timer(1.5).timeout
	await _disappear().finished

func _appear(mon: String, hab: String, ir: String):
	mon_ile.text = "+" + mon
	hab_ile.text = "+" + hab
	ir_ile.text = "+" + ir
	
	visible = true
	position = original_position

	# Reset labels alpha to 0
	mon_ile.modulate.a = 0.0
	hab_ile.modulate.a = 0.0
	ir_ile.modulate.a = 0.0

	var tween = create_tween()

	# Pop up motion
	tween.tween_property(self, "position", original_position + Vector2(0, -20), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", original_position, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	# Panel fade in
	modulate.a = 0.0
	tween.parallel().tween_property(self, "modulate:a", 1.0, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	# Staggered label fades
	tween.parallel().tween_property(mon_ile, "modulate:a", 1.0, 0.2).set_delay(0.1)
	tween.parallel().tween_property(hab_ile, "modulate:a", 1.0, 0.2).set_delay(0.2)
	tween.parallel().tween_property(ir_ile, "modulate:a", 1.0, 0.2).set_delay(0.3)

	return tween
	
func _disappear():
	var tween = create_tween()

	# Move down by 20px for exit pop
	tween.tween_property(self, "position", original_position + Vector2(0, 20), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	# Fade out in parallel
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_callback(Callable(self, "_on_disappear_finished"))
	return tween

func _on_disappear_finished():
	visible = false
	position = original_position
