extends Sprite2D

@onready var wheel = $"../wheelspin"
var center = Vector2(402.0, 179.0)
var radius = 180.0
var speed = -6.0
var angle = 0.0
var spinning = false

func _process(delta):
	if spinning:
		visible = true
		angle += speed * delta
		position = center + Vector2(cos(angle), sin(angle)) * radius
	else:
		angle = 0.0
		position = center + Vector2(cos(angle), sin(angle)) * radius
