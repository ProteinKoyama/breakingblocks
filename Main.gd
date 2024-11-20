extends Node
@export var block_scene: PackedScene
@onready var ball = $Ball
@onready var blocktilemaps = $BlockTileMaps

var score
var block_rows = 5
var block_columns = 5
var block_spacing = Vector2(100,50)
var BallInitialSpeed = 300

func game_over():
	print("gameover")
	ball.hide()
	ball.linear_velocity = Vector2.ZERO
	$HUD/StartButton.show()
	$HUD/GameoverLabel.show()
func _ready():
	#new_game()
	$HUD/GameoverLabel.hide()
	$HUD/ReadyLabel.hide()
	score = 0
	$Paddle.hide()
	ball.hide()
	
func _physics_process(delta):
	if !ball.visible:
		ball.position = $BallSpawnPosition.position
		ball.freeze = true
	else: pass
	
func new_game():
	print(ball.linear_velocity,ball.position)
	$HUD/ReadyLabel.show()
	$NewGameTimer.start()
	ball.initial_speed = BallInitialSpeed
	if $HUD/GameoverLabel.visible:
		$HUD/GameoverLabel.hide()
	ball.show()
	$HUD/StartTimer.start()
	$Paddle.position = $PadleStartPosition.position - ( $Paddle/ColorRect.size / 2 )
	$Paddle.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_start_button_pressed():
	$HUD/StartButton.hide()
	new_game() # Replace with function body.


func _on_dead_zone_body_entered(body):
	game_over()


func _on_new_game_timer_timeout() -> void:
	ball.freeze = false
	$HUD/ReadyLabel.hide()


func _on_start_timer_timeout() -> void:
	pass # Replace with function body.
