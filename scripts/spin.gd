extends Button

var rng = RandomNumberGenerator.new()
@onready var ball = $"../ball"
var balance = 100;

func _on_pressed() -> void:
	$"../winDisplay".texture = null
	ball.visible = true
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
	ball.hide()

	var result = rng.randi_range(1, 2)
	print(result)
	if result == 1:
		print("Red")
		$"../winDisplay".texture = load("res://assets/red.png")
	elif result == 2:
		print("Black")
		$"../winDisplay".texture = load("res://assets/black.png")
	
	$balance.text = "Balance: $" + str(balance)
