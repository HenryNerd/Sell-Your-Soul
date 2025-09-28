extends Button

@onready var volume_slider = $"../volume"
@onready var music = $"../AudioStreamPlayer2D"

func _ready():
	music.play()
	music.volume_db = 8
	if music and volume_slider:
		volume_slider.value = clamp(music.volume_db + 24, 0, 24)
		volume_slider.connect("value_changed", Callable(self, "_on_volume_changed"))
	else:
		print("Music or volume slider node not found!")

func _on_volume_changed(value):
	if music:
		var db = value - 24
		var bus_index = AudioServer.get_bus_index("Master")  # "Master" is the main bus
		AudioServer.set_bus_volume_db(bus_index, db)


func _on_pressed():
	var new_scene = load("res://scences/wheel.tscn") as PackedScene
	get_tree().change_scene_to_packed(new_scene)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
