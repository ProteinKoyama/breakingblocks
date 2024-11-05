extends RigidBody2D

var initial_velocity = Vector2(randf_range(-300,300),randf_range(-200,-300))
var initial_speed = 400

func _ready():
	pass
func _process(_float) -> void:
	pass

func _on_body_entered(body):
	print(linear_velocity)
	if linear_velocity <= Vector2(abs(1),abs(1)):
		linear_velocity.y = 300
	if body.is_in_group("Block"):
		body.queue_free() 
		linear_velocity = linear_velocity.normalized() * (initial_speed + randf_range(0,50))
func _integrate_forces(_state):
	# 常に一定の速度を維持する
	linear_velocity = linear_velocity.normalized() * initial_speed

func _on_start_button_pressed():
	linear_velocity = initial_velocity.normalized() * initial_velocity

