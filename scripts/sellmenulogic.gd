extends MenuButton

@onready var spin_node = get_parent().get_node("spinButton")  # external Userbalance

# Item data
var item_owned := [true, true, true, true, true]  # default = owned → selling
var item_costs := [30, 50, 100, 150, 200]  # base sell price
var item_names := ["Kids (x2)", "Spouse", "Soul", "Car", "House"]

func _ready():
	var popup = get_popup()
	popup.connect("id_pressed", Callable(self, "_on_item_pressed"))
	_update_items()  # initialize menu

func _process(delta):
	# Update grayed-out items continuously based on current balance
	_update_items()

func _on_item_pressed(id: int) -> void:
	var sell_cost = item_costs[id]
	var buy_cost = sell_cost * 3
	var name = item_names[id]

	if item_owned[id]:
		# Owned → sell
		spin_node.Userbalance += sell_cost
		item_owned[id] = false
		print("Sold", name, "for +$", sell_cost, "New balance:", spin_node.Userbalance)
	else:
		# Not owned → buy
		if spin_node.Userbalance < buy_cost:
			print("Not enough balance to buy", name, "for -$", buy_cost)
			return
		spin_node.Userbalance -= buy_cost
		item_owned[id] = true
		print("Bought", name, "for -$", buy_cost, "New balance:", spin_node.Userbalance)

	_update_items()

func _update_items() -> void:
	var popup = get_popup()
	for i in range(item_owned.size()):
		var sell_cost = item_costs[i]
		var buy_cost = sell_cost * 3
		var name = item_names[i]

		if item_owned[i]:
			# Owned → sell
			popup.set_item_disabled(i, false)
			popup.set_item_text(i, "%s | +$%d" % [name, sell_cost])
		else:
			# Not owned → buy, disable if cannot afford
			var can_buy = spin_node.Userbalance >= buy_cost
			popup.set_item_disabled(i, not can_buy)
			popup.set_item_text(i, "%s | -$%d" % [name, buy_cost])
