extends RigidBody2D

var initial_velocity = Vector2(randf_range(-300,300),randf_range(-200,-300))
var initial_speed = 400

func _ready():
	pass
func _process(_float) -> void:
	pass

func _on_body_entered(body):
	print(linear_velocity)
	# 法線に基づく反射ベクトルを計算
	var collision_normal = (position - body.position).normalized()
	var bounce_velocity = linear_velocity.bounce(collision_normal)
		# 最小のy方向速度を設定して水平な跳ね返りを防ぐ
	if abs(bounce_velocity.y) < 50:
		bounce_velocity.y = -sign(bounce_velocity.y) * 50  # Y成分の最低速度
		
	linear_velocity = bounce_velocity
	if body.is_in_group("Block"):
		body.queue_free() 
		linear_velocity = linear_velocity.normalized() * (initial_speed + randf_range(0,50))


func _integrate_forces(_state):
	# 常に一定の速度を維持する
	linear_velocity = linear_velocity.normalized() * initial_speed

func _on_start_button_pressed():
	linear_velocity = initial_velocity.normalized() * initial_velocity

