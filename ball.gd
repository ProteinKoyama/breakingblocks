extends RigidBody2D

var initial_velocity = Vector2(randf_range(-300,300),randf_range(-200,-300))
var initial_speed = 300
var screen_size
var max_speed_multiplier = 1
var linear_velocity_low_limit = 5
var max_angle = deg_to_rad(180)
var add_angle = randf_range(45,90)

func _ready():
	$ContactsTimer.start()
	screen_size = get_viewport_rect().size
	
func _process(delta) -> void:
	if abs(linear_velocity.y) <= abs(linear_velocity_low_limit):
		linear_velocity.y = randf_range(-200,-300)
	if abs(linear_velocity.x) <= abs(linear_velocity_low_limit):
		linear_velocity.x = randf_range(-100,-100)
	
func _on_body_entered(body):
	if abs(linear_velocity.y) - max_angle <= abs(max_angle) :
		linear_velocity.y += add_angle
	if body is TileMapLayer:
		body.queue_free()
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


func _on_contacts_timer_timeout() -> void:
	pass
