extends StaticBody2D

var initial_position
var amp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_position = position
	amp = RandomNumberGenerator.new().randi_range(10, 1000)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var ticks = Time.get_ticks_usec()
	var a = 0.00001
	var b = 100
	position = initial_position + Vector2(sin(ticks*a)*b, 0)
