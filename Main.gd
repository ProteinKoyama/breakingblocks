extends Node
@export var block_scene: PackedScene
@onready var ball = $Ball

var score = 0
var stage_count = 0
var block_spacing = Vector2(100,50)
var BallInitialSpeed = 300

func _ready():
	$HUD/RetryButton.hide()
	$HUD/NextButton.hide()
	$HUD/GameoverLabel.hide()
	$HUD/StageClearLabel.hide()
	$HUD/ReadyLabel.hide()
	$HUD/ScoreResultLabel.hide()
	var tilemap_children =$TileMapLayers.get_children()
	for child in tilemap_children:
		child.enabled = false
	$TileMapLayers/Layer1.enabled = true
	ball.position = $BallSpawnPosition.position
	$Paddle.hide()
	ball.hide()
	ball.freeze = true
func _process(_delta):
	#if $TileMapLayers/Layer3.get_used_cells():
	#	stage_clear()
	pass
func stage_clear():
	$HUD/StageClearLabel.show()
	$HUD/ScoreResultLabel.show()
	stage_count += 1
	pass
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
	_ready()
	$HUD/ReadyLabel.show()
	$NewGameTimer.start()
	ball.initial_speed = BallInitialSpeed
	if $HUD/GameoverLabel.visible:
		$HUD/GameoverLabel.hide()
	ball.show()
	$Paddle.position = $PadleStartPosition.position - ( $Paddle/ColorRect.size / 2 )
	$Paddle.show()

func _on_start_button_pressed():
	$HUD/StartButton.hide()
	new_game()

func _on_dead_zone_body_entered(body):
	game_over()


func _on_new_game_timer_timeout() -> void:
	ball.freeze = false
	$HUD/ReadyLabel.hide()


func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()

func update_score()-> void:
	$HUD/ScoreLabel.text = str(score)

func _on_ball_block_broke() -> void:
	score += 100
	update_score()
