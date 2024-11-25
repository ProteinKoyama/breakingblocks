extends RigidBody2D

var initial_velocity = Vector2(randf_range(-3,3),randf_range(-2,-3))
var initial_speed = 6
var screen_size
var max_speed_multiplier = 1
var linear_velocity_low_limit = 1
#var min_angle = deg_to_rad(45)
#var max_angle = deg_to_rad(180)

func _ready():
	$ContactsTimer.start()
	screen_size = get_viewport_rect().size

func int_process(delta) -> void:
	pass
func _on_body_entered(body):
	#if body is TileMapLayer:
		#var pos = body.local_to_map(position)
		#body.erase_cell(pos)
		#print(body.get_cell_source_id(pos))
	if body.is_in_group("Block"):
		body.queue_free()
		linear_velocity = linear_velocity.normalized() * (initial_speed + randf_range(0,50))
	if body.name =="Paddle":
		var offset = position.x - body.position.x
		var paddle_width = body.shape_owner_get_shape(0, 0).extents.x * 2
		#var normalized_offset = abs(offset / paddle_width)  # 0から1の範囲に正規化（中央からの距離）
		#var speed_multiplier = 1.0 + normalized_offset * (max_speed_multiplier - 1.0)
		#linear_velocity = linear_velocity.normalized() * initial_velocity.length() * speed_multiplier
		
func _integrate_forces(_state):
	#var direction = linear_velocity.normalized()
	#print(direction)
	#var tmp_rad = Vector2(sin(min_angle)*10,sin(max_angle)*10)
	##linear_velocity = linear_velocity.normalized()
	#print(tmp_rad," ",linear_velocity)
	#if abs(direction.y) >= min_angle:
		#print("a")
		#if direction.y >= 0:
			#linear_velocity.y = linear_velocity.y * tmp_rad.y
			#print(sin(min_angle),linear_velocity)
		#else:
			#linear_velocity.y = sin(min_angle) * linear_velocity.x
			#print(max_angle,linear_velocity)
		#
	#if abs(linear_velocity.x) <= abs(linear_velocity_low_limit) and continuous_cd:
		#pass#linear_velocity.x = tmp.x * abs(randf_range(1,4))
	var tmp_velocity = abs(linear_velocity)
	linear_velocity = linear_velocity.normalized() * initial_speed
	if abs(linear_velocity.y) <= linear_velocity_low_limit and continuous_cd:
		linear_velocity.y = randf_range(-400,400)
	if abs(linear_velocity.x) <= linear_velocity_low_limit and continuous_cd:
		linear_velocity.x = randf_range(-100,100)
	if abs(linear_velocity.y) - tmp_velocity.y < abs(1) and continuous_cd:
		if linear_velocity.y > 0:
			linear_velocity = linear_velocity + Vector2(0,0.5)
		else: 
			linear_velocity = linear_velocity + Vector2(0,-0.5)


func _on_start_button_pressed():
	linear_velocity = initial_velocity.normalized() * initial_velocity


func _on_contacts_timer_timeout() -> void:
	pass

func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if body is TileMapLayer:
		body.erase_cell(body.get_coords_for_body_rid(body_rid))
