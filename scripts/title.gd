extends Button

func _on_pressed():
	var new_scene = load("res://scences/wheel.tscn") as PackedScene
	get_tree().change_scene_to_packed(new_scene)
