extends Node2D
@onready var tilemap = $TileMap

func save_layer(layer_index):
	tilemap.save_layer(layer_index)

func restore_layer(layer_index):
	tilemap.restore_layer(layer_index)
	
func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	pass
