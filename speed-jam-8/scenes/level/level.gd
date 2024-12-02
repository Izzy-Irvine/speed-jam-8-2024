extends Node2D

var undo_stack = []
var simultaneous_scene = preload("res://scenes/level/leaderboard.tscn").instantiate()

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_undo") and len(undo_stack):
		set_state(undo_stack.pop_back())
	else:
		undo_stack.append(get_state())

func get_state() -> Dictionary:
	return {
		"Player": $Player.get_state(),
		"Tick": Globals.ticks
	}

func set_state(state: Dictionary):
	$Player.set_state(state["Player"])
	Globals.ticks = state["Tick"]

func _on_button_pressed() -> void:
	$FinishScreen/SubmitMenu.show()

func _on_button_2_pressed() -> void:
	get_tree().reload_current_scene()
	Globals.game_running = true

func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level/leaderboard.tscn")
