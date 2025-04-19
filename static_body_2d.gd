extends StaticBody2D

var initX: int
var initY: int
var upSpeed: float
# Called when the node enters the scene tree for the first time.
func _ready():
	position.x = initX
	position.y = initY


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	position.y -= upSpeed
	if position.y < -200:
		queue_free()
