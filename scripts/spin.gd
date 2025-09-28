extends Button

var rng = RandomNumberGenerator.new()
@onready var node_a = get_parent().get_node("spinButton")
@onready var ball = $"../ball"
@onready var balance_label = $"../balance"
@onready var balance_edit = $"../balanceEdit"
@onready var redButton = $"../redBetButton"
@onready var blackButton = $"../blackBetButton"

var Userbalance: int = 100
var UserBetChoice: String
var resultFriendly: String
var userBet: int = 0
var betSelected = false
var amountSelected = false
var betValid = false

func _ready():
	self.disabled = true
	set_process(true)
	if balance_label:
		balance_label.text = "Balance: $" + str(Userbalance)

func _on_pressed() -> void:
	set_process(false)
	$"../winDisplay".texture = null
	balance_edit.editable = not balance_edit.editable
	ball.visible = true
	ball.spinning = true

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
	
	if balance_label:
		balance_label.text = "Balance: $" + str(Userbalance)
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
	balance_label.text = "Balance: $" + str(Userbalance)
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

func betCheck() -> void:
	print("Bet Check, Bet =", userBet)
	if userBet <= 0:
		print("Invalid bet amount, skipping balance update.")
		return
	
	if resultFriendly == UserBetChoice:
		Userbalance += userBet
	else:
		Userbalance -= userBet
