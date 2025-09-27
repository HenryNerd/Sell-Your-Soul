extends Button

var rng = RandomNumberGenerator.new()
@onready var ball = $"../ball"

func _on_pressed() -> void:
	ball.spinning = true
	disabled = true
	icon = load("res://assets/spun-button.png")

	$"../wheelspin".play("Spin")

	var spintime = rng.randf_range(1, 7)
	print("Spin Started for ", spintime, "s")

	await get_tree().create_timer(spintime).timeout

	print("Spin Stop")
	$"../wheelspin".stop()

	disabled = false
	icon = load("res://assets/spin-button.png")
	ball.spinning = false
	
	var result = rng.randi_range(1, 2)
	print(result)
	if result == 1:
		print("Red")
	elif result == 1:
		print("Black")
