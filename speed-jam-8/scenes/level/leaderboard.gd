extends Control

func display_list(list: Array):
	var place = 1
	for record in list:
		var lab = Label.new()
		lab.set("theme_override_colors/font_color", Color(0, 0, 0 , 1))
		lab.text = "(%d.) %s: %.3fs" % [place, record[0], record[1]]
		place += 1
		$ScrollContainer/Container.add_child(lab)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var err = $HTTPRequest.request(Globals.leaderboard_api + "/top_ten")
	if err != OK:
		display_list([["Error", "Can't connect to the leaderboard :("]])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code != 200:
		display_list([["Error", "Can't connect to the leaderboard :("]])
		return
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	display_list(json.get_data())


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level/Level.tscn")
	Globals.game_running = true
