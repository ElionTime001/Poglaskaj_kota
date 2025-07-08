extends Control

@export var description_label : Label
@export var name_label : Label
@export var badges_control : Control

signal badge_window_closed

var badges = []

var descriptions = {
	"time" : "Typ monetyzacji polegający na ograniczaniu czasu, który gracz może spędzić w grze i nakłanianiu do regularnego powracania przez nakładanie wydarzeń bazowanych na czasie rzeczywistym.",
	"ease" : "Typ monetyzacji polegający na nakładaniu ograniczeń na postęp w grze i sprzedawaniu przedmiotów, które te ograniczenia niwelują albo skracając czas zadań.",
	"random" : "Typ monetyzacji polegający na wprowadzaniu do gry elementów losowych.",
	"online" : "Typ monetyzacji polegający na wprowadzaniu do gry mechanik pozwalających na porównywanie się z innymi graczami, co napędza rywalizację i osoby podatne na to.",
	"final" : "Gratulację. Gra została uczyniona dużo lepszą dzięki tobie!"
}

var names = {
	"time" : "Time-Gated \n Progression",
	"ease" : "Ease of Play",
	"random" : " Randomized Reward \n Systems",
	"online" : "Conflict-Driven \n Design",
	"final" : "Anti Consumer \n Practices"
}
# Called when the node enters the scene tree for the first time.
func _ready():
	badges = get_tree().get_nodes_in_group("badges")
	make_invisible_badges()
	animate_panel(badges_control)
	self.visible = false


func make_invisible_badges():
	for badge in badges:
		badge.visible = false

func make_visible_badge(badge_name: String):
	for badge in badges:
		if badge.name == badge_name:
			badge.visible = true
			break

func change_badge_elements(badge_name: String):
	make_invisible_badges()
	description_label.text = descriptions[badge_name]
	name_label.text = names[badge_name].to_upper()
	make_visible_badge(badge_name)

func appear(label_name: String):
	change_badge_elements(label_name)
	self.visible = true
	bounce_window()

func disappear():
	self.visible = false
	badge_window_closed.emit()

func bounce_window():
	var tween = get_tree().create_tween()
	var start_pos = self.position
	var bounce_up = start_pos - Vector2(0, 20)

	tween.tween_property(self, "position", bounce_up, 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", start_pos, 0.2).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

func change_badge(type: String):
	make_invisible_badges()
	match type:
		"time_gate":
			#Time-Gated Progression
			change_badge_elements("time")
		"random":
			#with Randomized Reward Systems
			change_badge_elements("random")
		"ease_of_play":
			#Ease of Play
			change_badge_elements("ease")
		"online":
			#Conflict-Driven Design.
			change_badge_elements("online")
		"final":
			#Anti Consumer Practices
			change_badge_elements("final")

func animate_panel(badge):
	var tween = create_tween()
	tween.set_loops()

	tween.tween_property(badge, "scale", Vector2(1.1, 1.1), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(badge, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_close_window_pressed():
	disappear()
