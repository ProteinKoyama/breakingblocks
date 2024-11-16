extends RigidBody2D
@onready var tilemap = $Main/TileMap

var initial_velocity = Vector2(randf_range(-300,300),randf_range(-200,-300))
var initial_speed = 400
var screen_size
var max_speed_multiplier = 1

func _ready():
	screen_size = get_viewport_rect().size
	
func _process(_float) -> void:
	if abs(linear_velocity.y) <= abs(1):
		linear_velocity.y = randf_range(-100,-300)
	if abs(linear_velocity.x) <= abs(1):
		linear_velocity.x = randf_range(-100,-100)

func _on_body_entered(body):
	if body == tilemap:
		var collision_point = position
		var tile_coords = tilemap.world_to_map(collision_point)
		
	#	if tilemap.get_cell(0,tile_coords) != TileMap.INVALID_CELL:
	#		tilemap.set_cell(0,tile_coords,TileMap.INVALID_CELL)
	if body.is_in_group("Block"):
		body.queue_free() 
		linear_velocity = linear_velocity.normalized() * (initial_speed + randf_range(0,50))
	if body.name =="Paddle":
		var offset = position.x - body.position.x
		var paddle_width = body.shape_owner_get_shape(0, 0).extents.x * 2
		var normalized_offset = abs(offset / paddle_width)  # 0から1の範囲に正規化（中央からの距離）
		var speed_multiplier = 1.0 + normalized_offset * (max_speed_multiplier - 1.0)
		linear_velocity = linear_velocity.normalized() * initial_velocity.length() * speed_multiplier
		
func _integrate_forces(_state):
	# 常に一定の速度を維持する
	linear_velocity = linear_velocity.normalized() * (initial_speed + randf_range(-5,10))

func _on_start_button_pressed():
	linear_velocity = initial_velocity.normalized() * initial_velocity
