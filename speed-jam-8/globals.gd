extends Node

var ticks = 0
var time_elapsed = 0
var final_time = null
var game_running = true
var leaderboard_api = "http://cult-flat.izzy.kiwi:8000"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if game_running:
		ticks += 1
