extends Node2D

@export var normalFloor: PackedScene
@export var trampolineFloor: PackedScene
@export var nailFloor: PackedScene
@export var worldNode: Node
var isTiming = false
var normalFloorCount = 0
var trampolineFloorCount = 0
var nailFloorCount = 0
var normalFloorCombo = 0
enum FloorType {Normal, Nail, Trampoline}
var prevFloor = FloorType.Normal
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	_createNormalFloor(-10, 40)
	_createNormalFloor(70, 110)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !isTiming:
		isTiming = true
		await wait(calculate_floor_spawn_speed())
		_createRandomFloor()
		isTiming = false

func _createRandomFloor() -> void:
	var floors = [FloorType.Normal, FloorType.Nail, FloorType.Trampoline]
	var normalWeight = max(0.8 - normalFloorCombo * 0.12, 0.1)
	var weights = PackedFloat32Array([normalWeight, 0.1, 0.1])
	var newFloorType = floors[rng.rand_weighted(weights)]
	var x = rng.randi_range(-95, 95)
	if newFloorType == FloorType.Normal:
		_createNormalFloor(x, 210)
	elif newFloorType == FloorType.Nail:
		normalFloorCombo = 0
		_createNailFloor(x, 210)
	elif newFloorType == FloorType.Trampoline:
		normalFloorCombo = 0
		_createTrampolineFloor(x, 210)		

func _createNormalFloor(x: int, y: int) -> void:
	var newFloor = normalFloor.instantiate()
	newFloor.initX = x
	newFloor.initY = y
	newFloor.upSpeed = calculate_floor_speed()
	add_child(newFloor)
	normalFloorCount += 1
	if(prevFloor == FloorType.Normal):
		normalFloorCombo += 1
	else:
		normalFloorCombo = 0
	prevFloor = FloorType.Normal
	
func _createNailFloor(x: int, y: int) -> void:
	var newFloor = nailFloor.instantiate()
	newFloor.initX = x
	newFloor.initY = y
	newFloor.upSpeed = calculate_floor_speed()
	add_child(newFloor)
	nailFloorCount += 1
	prevFloor = FloorType.Nail
	
func _createTrampolineFloor(x: int, y: int) -> void:
	var newFloor = trampolineFloor.instantiate()
	newFloor.initX = x
	newFloor.initY = y
	newFloor.upSpeed = calculate_floor_speed()
	add_child(newFloor)
	trampolineFloorCount += 1
	prevFloor = FloorType.Trampoline

func wait(second: float) -> void:
	await get_tree().create_timer(second).timeout

func calculate_floor_speed() -> float:
	var seconds = worldNode.seconds
	const BASE_SPEED: float = 1.0
	const MAX_SPEED: float = 6.0
	const INTERVAL: int = 12
	const TARGET_TIME: int = 90

	var intervals_passed: int = seconds / INTERVAL
	var speed_increment: float = (MAX_SPEED - BASE_SPEED) * (float(seconds) / TARGET_TIME)
	var speed: float = BASE_SPEED + speed_increment
	return min(speed, MAX_SPEED)


func calculate_floor_spawn_speed() -> float:
	var seconds = worldNode.seconds
	const BASE_MIN_SPAWN: float = 1.25
	const BASE_MAX_SPAWN: float = 1.7
	const MIN_SPAWN_LIMIT: float = 0.6
	const SPEED_INTERVAL: int = 12
	const SPAWN_INTERVAL: int = SPEED_INTERVAL * 2  # 每24秒增加一次生成速度
	const TARGET_TIME: int = 90
	
	# 計算經過的生成速度間隔數量
	var intervals_passed: int = seconds / SPAWN_INTERVAL
	
	# 計算生成速度的縮減比例（隨時間線性減少）
	var progress: float = float(seconds) / TARGET_TIME
	var current_min_spawn: float = lerp(BASE_MIN_SPAWN, MIN_SPAWN_LIMIT, progress)
	var current_max_spawn: float = lerp(BASE_MAX_SPAWN, MIN_SPAWN_LIMIT, progress)
	
	# 返回隨機生成速度
	return max(randf_range(current_min_spawn, current_max_spawn), MIN_SPAWN_LIMIT)
