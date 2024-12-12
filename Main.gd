extends Node
@export var block_scene: PackedScene
@onready var ball = $Ball

signal pause_signal

var score = Grobal.score
var stage = Grobal.stage
var ball_initial_speed = 300
var clear_flag:bool = false
var pause_opened_flag = true

func _ready():
	$PauseBackground.hide()
	$HUD/ExitButton.hide()
	$HUD/ReturnButton.hide()
	$HUD/RestartButton.hide()
	$HUD/ContinueButton.hide()
	$HUD/NextButton.hide()
	$HUD/MessageLabel.hide()
	$HUD/ScoreResultLabel.hide()
	$HUD/PauseButton.hide()
	tilemap_set()
	$Paddle.hide()
	ball.hide()
	$Paddle.position = $PadleStartPosition.position - ( $Paddle/ColorRect.size / 2 )
	$Paddle.show()
	PhysicsServer2D.set_active(false)

func tilemap_set():
	var tilemap_children =$TileMapLayers.get_children()
	for child in tilemap_children:
		child.enabled = false
	tilemap_children[stage].enabled = true

func _process(_delta):
	if $TileMapLayers.get_child_count() <= stage:
		stage_clear()
	elif $TileMapLayers.get_children()[stage].get_used_cells() == [] and !clear_flag and score >= 100:
		stage_clear()

func new_game():
	if !has_node("Ball"):
		add_child(ball)
	ball.global_position = $BallSpawnPosition.global_position
	tilemap_set()
	ball.show()
	$HUD/PauseButton.show()
	$HUD/NextButton.hide()
	$HUD/ContinueButton.hide()
	$HUD/ScoreResultLabel.hide()
	$HUD/MessageLabel.hide()
	$HUD/MessageLabel.text = "READY"
	$HUD/MessageLabel.show()
	PhysicsServer2D.set_active(false)
	$NewGameTimer.start()
	ball.initial_speed = ball_initial_speed
	if clear_flag:
		$ClearMarginTimer.start()

func game_over():
	$BGM.stop()
	$GameOverSE.play()
	$HUD/MessageLabel.text = "GAME OVER"
	$HUD/MessageLabel.show()
	$HUD/PauseButton.hide()
	$HUD/ExitButton.show()
	$HUD/ContinueButton.show()
	$HUD/ScoreResultLabel.text = "SCORE: " + str(score)
	$HUD/ScoreResultLabel.show()
	PhysicsServer2D.set_active(false)
	clear_flag = true

func stage_clear():
	$StageClearSE.play()
	$HUD/MessageLabel.text = "STAGE CLEAR"
	$HUD/MessageLabel.show()
	PhysicsServer2D.set_active(false)
	$HUD/ScoreResultLabel.text = "SCORE: " + str(score)
	$HUD/ScoreResultLabel.show()
	clear_flag = true
	stage += 1
	if $TileMapLayers.get_child_count() <= stage:
		$HUD/MessageLabel.text = "GAME CLEAR"
		$HUD/RestartButton.show()
	else:
		$HUD/NextButton.show()

func _on_dead_zone_body_entered(body):
	ball.get_parent().remove_child(ball)
	game_over()

func _on_start_button_pressed():
	$HUD/PauseButton.show()
	$HUD/StartButton.hide()
	$ButtonSE.play()
	new_game()

func _on_continue_button_pressed() -> void:
	score = 0
	$HUD/ScoreLabel.text = str(score)
	$HUD/ExitButton.hide()
	$ButtonSE.play()
	$BGM.play()
	new_game()
	
func _on_next_button_pressed() -> void:
	$ButtonSE.play()
	new_game()

func _on_ball_block_broke() -> void:
	score += 100
	$HUD/ScoreLabel.text = str(score)

func _on_clear_margin_timer_timeout() -> void:
	clear_flag = false
	ball.show()

func _on_new_game_timer_timeout() -> void:
	PhysicsServer2D.set_active(true)
	$HUD/MessageLabel.hide()

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()

func pause_hide_display():
	PhysicsServer2D.set_active(true)
	$PauseBackground.hide()
	$HUD/ExitButton.hide()
	$HUD/ReturnButton.hide()
	emit_signal("pause_signal")
	pause_opened_flag = true
	
func _on_pause_button_pressed() -> void:
	if !pause_opened_flag:
		pause_hide_display()
	elif pause_opened_flag :
		PhysicsServer2D.set_active(false)
		$PauseBackground.show()
		$HUD/ExitButton.show()
		$HUD/ReturnButton.show()
		emit_signal("pause_signal")
		pause_opened_flag = false

func _on_return_button_pressed() -> void:
	pause_hide_display()
