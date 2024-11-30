extends Label

var start;
var now;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start = Time.get_unix_time_from_system()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	now = Time.get_unix_time_from_system()
	var time_elapsed = now - start
	text = "Time: %.3f" % (time_elapsed)
	
	