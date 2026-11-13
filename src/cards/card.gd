extends Control

var default_x: int = 0
var default_y: int = 0

func _on_card_button_mouse_entered() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", Vector2(self.position.x, default_y - 336), 0.5) #move up 1 card length

func _on_card_button_mouse_exited() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", Vector2(default_x, default_y), 0.5)

func _on_card_button_button_down() -> void:
	pass # Replace with function body.

func set_card_name(name: String) -> void:
	$card_button/name.text = name

func set_card_default_pos(x: int, y: int) -> void:
	default_x = x
	default_y = y
	
	self.position.x = default_x
	self.position.y = default_y
