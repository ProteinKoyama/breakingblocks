extends CharacterBody2D
signal hit

@export var speed = 200
var screen_size
var character_size= Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	character_size = $ColorRect.size  # スプライトの半分の大きさ
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1

	position += velocity.normalized() * speed * delta
	position.x = clamp(position.x, 0, screen_size.x - character_size.x )



func _on_body_dentered(_body):
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
