extends StaticBody2D

var initX: int
var initY: int
var upSpeed: float

@export var anime: AnimatedSprite2D

func _ready():
	position.x = initX
	position.y = initY

func _process(_delta):
	position.y -= upSpeed
	if position.y < -200:
		queue_free()


func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("player"):
		anime.play("spring", 1.5)
		body.on_spring()
	pass
