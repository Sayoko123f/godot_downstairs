extends CharacterBody2D

@export var anime: AnimatedSprite2D
@export var hp_bar: ProgressBar
@export var sound_player: AudioStreamPlayer
@export var gameover_panel: CanvasLayer
const SPEED = 120.0
const JUMP_VELOCITY = -490.0
var _health = 3


enum State {IDLE, RUN}

func _ready():
	gameover_panel.visible = false
	init_hp_bar()
	
func init_hp_bar():
	hp_bar.max_value = _health
	hp_bar.value = _health
	hp_bar.min_value = 0
	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	_handle_input()
	_animate()
	move_and_slide()

func _handle_input() -> void:
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _animate() -> void:
	if velocity.x == 0:
		anime.play("idle")
	if velocity.x != 0:
		anime.play("run")
		anime.flip_h = velocity.x > 0

func on_spring():
	velocity.y = JUMP_VELOCITY
	sound_player.stream = load("res://assets/ns-shaft/sounds/jump.ogg")
	sound_player.play()
	
func change_health(val: int):
	if(val < 0):
		print("玩家扣血")
		_health += val
		hp_bar.value = _health
		if(_health <= 0):
			gameover()
			return
	return

func on_nail():
	change_health(-1)
	sound_player.stream = load("res://assets/ns-shaft/sounds/hit.wav")
	sound_player.play()

func gameover():
	print('遊戲結束')
	gameover_panel.visible = true
	get_tree().paused = true
	


func _on_bottom_wall_body_entered(body):
	if(body.is_in_group("player")):
		change_health(-99)
	pass
