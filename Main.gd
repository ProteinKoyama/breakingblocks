extends Node
@export var block_scene: PackedScene
@onready var ball = $Ball
@onready var blocktilemaps = $BlockTileMaps

var score
var block_rows = 5
var block_columns = 5
var block_spacing = Vector2(100,50)
var block_start_position
var BallInitialSpeed = 300

func game_over():
	print("gameover")
	$Ball.hide()
	$HUD/StartButton.show()
	$HUD/GameoverLabel.show()
func _ready():
	#new_game()
	$HUD/GameoverLabel.hide()
	$HUD/ReadyLabel.hide()
	score = 0
	$Paddle.hide()
	$Ball.hide()
	
func _physics_process(delta):
	if !$Ball.visible:
		$Ball.position = $BallSpawnPosition.position
		$Ball.freeze = true
	else: pass

func _on_start_timer_timeout():
	pass
func new_game():
	$HUD/ReadyLabel.show()
	$NewGameTimer.start()
	if $HUD/GameoverLabel.visible:
		$HUD/GameoverLabel.hide()
	$Ball.show()
	$Ball.initial_speed = BallInitialSpeed
	$HUD/StartTimer.start()
	$Paddle.position = $PadleStartPosition.position - ( $Paddle/ColorRect.size / 2 )
	$Paddle.show()
	
	#for row in range(block_rows):
		#for col in range(block_columns):
			#var block_instance = block_scene.instantiate()
			#block_instance.position = Vector2(col * block_spacing.x, row * block_spacing.y)
			#add_child(block_instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_start_button_pressed():
	$HUD/StartButton.hide()
	new_game() # Replace with function body.


func _on_dead_zone_body_entered(body):
	game_over()


func _on_new_game_timer_timeout() -> void:
	$Ball.freeze = false
	$HUD/ReadyLabel.hide()
