extends Window

@onready var error_label = $HBoxContainer/VBoxContainer/error

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_requested() -> void:
	self.hide()

func display_error(error: String):
	error_label.show()
	error_label.text = "Error: %s" % error

func _on_submit_button_pressed() -> void:
	var user_text = $HBoxContainer/VBoxContainer/username/LineEdit.text
	var pass_text = $HBoxContainer/VBoxContainer/password/LineEdit.text

	error_label.hide()

	if user_text == "" or pass_text == "":
		display_error("Fields can't be empty")
		return
	
	var body = JSON.new().stringify({
		"final_time": Globals.final_time,
		"username": user_text,
		"password": pass_text
	})
	var err = $HTTPRequest.request(Globals.leaderboard_api + "/submit", [], HTTPClient.METHOD_POST, body)
	if err != OK:
		display_error("Failed to connect to leaderboard :(")

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code != 200:
		display_error(body.get_string_from_utf8())
		return
	hide()

func _on_visibility_changed() -> void:
	$HBoxContainer/VBoxContainer/SubmitButton.text = "Submit (%.3fs)" % Globals.final_time
