extends MenuButton

@onready var node_a = get_parent().get_node("spinButton")

func _ready():
	# Connect the internal popup's id_pressed signal
	get_popup().connect("id_pressed", Callable(self, "_on_item_pressed"))

func _on_item_pressed(id: int) -> void:
	var popup = get_popup()

	# Disable the clicked item
	popup.set_item_disabled(id, true)

	if node_a != null:
		match id:
			0: node_a.Userbalance += 30
			1: node_a.Userbalance += 50
			2: node_a.Userbalance += 100
			3: node_a.Userbalance += 150
			4: node_a.Userbalance += 200
		print("New balance:", node_a.Userbalance)
	else:
		print("Node A not found!")
