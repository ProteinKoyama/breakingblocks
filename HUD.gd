extends CanvasLayer

signal start_game
# Called when the node enters the scene tree for the first time.
func show_message(text):
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	score += 10
	$ScoreLabel.text = str(score)

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
