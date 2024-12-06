extends Node
@export var block_scene: PackedScene
@onready var ball = $Ball

var score = Grobal.score
var stage = Grobal.stage
var ball_initial_speed = 300
var clear_flag:bool = false

func _ready():
	$HUD/GameClearLabel.hide()
	$HUD/RetryButton.hide()
	$HUD/NextButton.hide()
	$HUD/GameoverLabel.hide()
	$HUD/StageClearLabel.hide()
	$HUD/ReadyLabel.hide()
	$HUD/ScoreResultLabel.hide()
	tilemap_set()
	$Paddle.hide()
	ball.hide()
	$Paddle.position = $PadleStartPosition.position - ( $Paddle/ColorRect.size / 2 )
	$Paddle.show()
	$HUD/NextButton.hide()

func tilemap_set():
	var tilemap_children =$TileMapLayers.get_children()
	for child in tilemap_children:
		child.enabled = false
	tilemap_children[Grobal.stage].enabled = true

func _process(_delta):
	if $TileMapLayers.get_children()[stage].get_used_cells() == [] and !clear_flag:
		stage_clear()

func game_over():
	$HUD/GameoverLabel.show()
	ball.hide()
	$HUD/RetryButton.show()
	$HUD/ScoreResultLabel.text = "SCORE: " + str(score)
	$HUD/ScoreResultLabel.show()

func _physics_process(delta):
	if !ball.visible:
		ball.position = $BallSpawnPosition.position
		ball.linear_velocity = Vector2.ZERO

func new_game():
	tilemap_set()
	ball.show()
	$NewGameTimer.start()
	PhysicsServer2D.set_active(false)
	$HUD/ReadyLabel.show()
	$HUD/StageClearLabel.hide()
	ball.initial_speed = ball_initial_speed
	if $HUD/GameoverLabel.visible:
		$HUD/GameoverLabel.hide()
	if clear_flag:
		$ClearMarginTimer.start()
		
func stage_clear():
	$HUD/StageClearLabel.show()
	PhysicsServer2D.set_active(false)
	$HUD/ScoreResultLabel.text = "SCORE: " + str(score)
	$HUD/ScoreResultLabel.show()
	$HUD/NextButton.show()
	clear_flag = true
	stage += 1

func _on_dead_zone_body_entered(body):
	game_over()

func _on_start_button_pressed():
	$HUD/StartButton.hide()
	new_game()

func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_next_button_pressed() -> void:
	new_game()

func _on_ball_block_broke() -> void:
	score += 100
	$HUD/ScoreLabel.text = str(score)

func _on_clear_margin_timer_timeout() -> void:
	clear_flag = false
	ball.show()

func _on_new_game_timer_timeout() -> void:
	PhysicsServer2D.set_active(true)
	$HUD/ReadyLabel.hide()
