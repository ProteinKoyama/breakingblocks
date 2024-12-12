extends CharacterBody2D
signal hit
@export var speed = 200
var screen_size
var character_size= Vector2.ZERO
var pause_mode = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	character_size = $ColorRect.size  # スプライトの半分の大きさ
	
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if pause_mode == 0:
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1

	position += velocity.normalized() * speed * delta
	position.x = clamp(position.x, 0, screen_size.x - character_size.x )


func _on_main_pause_signal() -> void:
	pause_mode += 1
	pause_mode %= 2
