extends Node
@export var block_scene: PackedScene
@onready var ball = $Ball
@onready var blocktilemaps = $BlockTileMaps

var score
var block_spacing = Vector2(100,50)
var BallInitialSpeed = 300

func game_over():
	ball.hide()
	$HUD/StartButton.show()
	$HUD/GameoverLabel.show()
	
func _ready():
	print(ball.linear_velocity)
	$HUD/GameoverLabel.hide()
	$HUD/ReadyLabel.hide()
	score = 0
	ball.position = $BallSpawnPosition.position
	$Paddle.hide()
	ball.hide()
	ball.freeze = true
	
func _physics_process(delta):
	if !ball.visible:
		ball.position = $BallSpawnPosition.position
		ball.linear_velocity = Vector2.ZERO
	
func new_game():
	_ready()
	$HUD/ReadyLabel.show()
	$NewGameTimer.start()
	ball.initial_speed = BallInitialSpeed
	if $HUD/GameoverLabel.visible:
		$HUD/GameoverLabel.hide()
	ball.show()
	$Paddle.position = $PadleStartPosition.position - ( $Paddle/ColorRect.size / 2 )
	$Paddle.show()

func _process(_delta):
	pass

func _on_start_button_pressed():
	$HUD/StartButton.hide()
	new_game()

func _on_dead_zone_body_entered(body):
	game_over()


func _on_new_game_timer_timeout() -> void:
	ball.freeze = false
	$HUD/ReadyLabel.hide()
