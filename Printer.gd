extends Control

var _messages: PoolStringArray = []
var _screen_messages = []

func _ready():
	_clear_prints()

func add_print(msg: String) -> void:
	_messages.push_back(msg)
	update()

func add_print_screen(msg: String, pos: Vector2) -> void:
	_screen_messages.push_back({position = pos, message = msg})
	update()

func _clear_prints() -> void:
	_messages.resize(0)
	_screen_messages.resize(0)

func draw() -> void:
	var y: float = 0.0 # relative to rect
	var x: float = 0.0 # ^^
	var font: Font = get_font("")
	var line_height: float = font.get_height()

	# print normal messages in single block
	for msg in _messages:
		draw_string(font, Vector2(x,y), msg, Color(1.0,1.0,1.0,0.5))
		y += line_height
	
	# draw positioned prints
	for format in _formats:
		draw_string(font, format.position, format.message, Color(1.0,1.0,1.0,0.5))

	# current state drawn, clear arrays
	_clear_prints()
