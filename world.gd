extends Node2D

@export var game_time_label: Label

var seconds = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	while(true):
		await wait(1.0)
		if(get_tree().paused == true):
			break
		game_time_label.text = str(seconds)
		seconds += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func wait(second: float) -> void:
	await get_tree().create_timer(second).timeout
