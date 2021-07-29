extends Control

#const Console = preload("Console.gd")
const Printer = preload("Printer.gd")
const Plotter = preload("Plotter.gd")

#var _console: Console = null
var _printer: Printer = null
var _plotter: Plotter = null

func _ready():
	# init subsystems
	_printer = Printer.new()
	_plotter = Plotter.new()

	_printer.name = "Printer"
	_plotter.name = "Plotter"

	add_child(_printer)
	add_child(_plotter)

func log(msg: String) -> void:
	print(msg)

func log_error(msg: String) -> void:
	push_error(msg)

func log_warn(msg: String) -> void:
	print(msg)

func print(msg: String) -> void:
	_printer.add_print(msg)

func print_screen(msg: String, screen_pos: Vector2) -> void:
	_printer.add_print_screen(msg, screen_pos)

func plot_single(identifier: String, label: String, value: float, _min: float = -1.0, _max: float = 1.0) -> void:
	_plotter.add_plot_single(identifier, label, value, _min, _max)
	
func plot_multi(identifier: String, labels: PoolStringArray, values: PoolRealArray, _min: float = -1.0, _max: float = 1.0) -> void:
	_plotter.add_plot_multi(identifier, labels, values, _min, _max)
