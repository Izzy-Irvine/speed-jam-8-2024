extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#err = $HTTPRequest.request(Globals.leaderboard_api + "/top_ten")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	pass # Replace with function body.
