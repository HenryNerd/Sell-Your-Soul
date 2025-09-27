extends Button
var rng = RandomNumberGenerator.new()

func _on_pressed() -> void:
	print("Hello Dingus")
	self.disabled = !self.disabled
	self.icon = load("res://assets/spun-button.png")
	$"../wheelspin".play("Spin")
	var spintime = rng.randf_range(0, 10.0)
