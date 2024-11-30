extends Node2D

var undo_stack = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_undo"):
		set_state(undo_stack.pop_back())
	else:
		undo_stack.append(get_state())

func get_state() -> Dictionary:
	return {
		#"Player": $Player.get_state() # Waiting for player to implement
	}

func set_state(state: Dictionary):
	pass
	#$Player.set_state(state["Player"])
