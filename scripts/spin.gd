extends Button

var rng = RandomNumberGenerator.new()
@onready var node_a = get_parent().get_node("spinButton")
@onready var ball = $"../ball"
@onready var balance_label = $"../balance"
@onready var balance_edit = $"../balanceEdit"
@onready var redButton = $"../redBetButton"
@onready var blackButton = $"../blackBetButton"
@onready var spinSound = $"../spining"
@onready var music = $"../../Music"
@onready var confirm_dialog = $"../ConfirmationDialog"

var Userbalance: int = 100
var UserBetChoice: String
var resultFriendly: String
var userBet: int = 0
var betSelected = false
var amountSelected = false
var betValid = false
var item_owned := [true, true, true, true, true]
var item_costs := [30, 50, 100, 150, 200]

func _ready():
	self.disabled = true
	confirm_dialog.hide()
	set_process(true)
	if balance_label:
		balance_label.text = "Balance: $" + str(Userbalance)

func _on_pressed() -> void:
	set_process(false)
	$"../winDisplay".texture = null
	balance_edit.editable = not balance_edit.editable
	ball.visible = true
	ball.spinning = true
	spinSound.play()
	music.stop()

	if balance_edit.text.strip_edges() == "":
		print("No bet entered, defaulting to 0")
		userBet = 0
	else:
		userBet = int(balance_edit.text)

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
		resultFriendly = "Red"
	elif result == 2:
		print("Black")
		$"../winDisplay".texture = load("res://assets/black.png")
		resultFriendly = "Black"
		
	betCheck()
	
	balance_edit.editable = true
	balance_edit.text = ""
	
	redButton.disabled = false
	blackButton.disabled = false
	self.disabled = true
	set_process(true)
	betSelected = false
	amountSelected = false
	spinSound.stop()
	music.play()
	
	if balance_label:
		balance_label.text = "$" + str(Userbalance)
	else:
		print("Balance label not found! Check node name and path.")
		

func _on_red_bet_button_pressed() -> void:
	UserBetChoice = "Red"
	redButton.disabled = true
	blackButton.disabled = true
	self.disabled = false
	betSelected = true

func _on_black_bet_button_pressed() -> void:
	UserBetChoice = "Black"
	redButton.disabled = true
	blackButton.disabled = true
	self.disabled = false
	betSelected = true

func _process(delta):
	balance_label.text = "$" + str(Userbalance)
	if balance_edit.text.strip_edges() != "":
		amountSelected = true
		var parsed_bet = int(balance_edit.text)
		userBet = parsed_bet
	else:
		amountSelected = false
		userBet = 0
	
	if userBet > 0 and userBet <= Userbalance:
		betValid = true
	else:
		betValid = false
	
	if betSelected and amountSelected and betValid:
		self.disabled = false
	else:
		self.disabled = true
		
	if not item_owned.has(true) and Userbalance == 0:
		print("Your Poor")
		confirm_dialog.popup_centered()

func betCheck() -> void:
	print("Bet Check, Bet =", userBet)
	if userBet <= 0:
		print("Invalid bet amount, skipping balance update.")
		return
	
	if resultFriendly == UserBetChoice:
		Userbalance += userBet
	else:
		Userbalance -= userBet

func _on_quit_button_pressed() -> void:
	var new_scene = load("res://scences/menu.tscn") as PackedScene
	get_tree().change_scene_to_packed(new_scene)

func _on_confirmation_dialog_confirmed() -> void:
	var new_scene = load("res://scences/menu.tscn") as PackedScene
	get_tree().change_scene_to_packed(new_scene)

func _on_confirmation_dialog_canceled() -> void:
	get_tree().quit()

func _on_confirmation_dialog_close_requested() -> void:
	var new_scene = load("res://scences/menu.tscn") as PackedScene
	get_tree().change_scene_to_packed(new_scene)
