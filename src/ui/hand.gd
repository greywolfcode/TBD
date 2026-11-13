extends Control

const CARD: PackedScene = preload("res://cards/card.tscn")
var num_cards: int = 0

func _ready() -> void:
	add_card("meadow")
	add_card("forest")
	add_card("moutain")
	add_card("water")

func add_card(card_name: String) -> void:
	var card: Node = CARD.instantiate()
	
	var card_x: int = num_cards * 120 #card is 240 pixels wide, this adds overlap
	var card_y: int = get_viewport_rect().size.y - 50 #offset from bottom of screen
	card.set_card_default_pos(card_x, card_y)
	
	card.set_card_name(card_name)
	
	self.add_child(card)
	num_cards += 1
