extends StaticBody2D

var initX: int
var initY: int
var upSpeed: float

func _ready():
	position.x = initX
	position.y = initY

func _physics_process(_delta):
	position.y -= upSpeed
	if position.y < -200:
		queue_free()


func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("player"):
		body.on_nail()
	pass
