extends Node2D

var initial_position
@export var amp: float = 100
@export var freq: float = 5.3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_position = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	position = initial_position + Vector2(sin(Globals.ticks*freq)*amp, 0)
