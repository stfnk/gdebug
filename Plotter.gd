extends Control

# These plots assume constant frame time. 
# Graphs x axis does not represent real time, but frame steps.

const _MAX_SAMPLES = 256

var plots = {}

const _COLORS = [
	Color.red,
	Color.green,
	Color(0.4,0.5,1.0,1.0),
	Color.yellow,
	Color.magenta,
	Color.cyan ]

func add_plot_single(identifier: String, label: String, value: float, range_min: float = -1.0, range_max: float = 1.0):
	add_plot_multi(identifier, [label], [value], range_min, range_max)

func add_plot_multi(identifier: String, labels: PoolStringArray, values: PoolRealArray, range_min: float = -1.0, range_max: float = 1.0):
	if !plots.has(identifier):
		# create a new plot for given identifier
		plots[identifier] = { 
			lbls = labels, 
			vals = [values], 
			r_min = range_min, 
			r_max = range_max }
		
		# create an empty sample to fill array with...
		var empty: PoolRealArray
		for _j in range(values.size()):
			empty.push_back(0.0)
		
		# fill actual samples array
		for _i in range(_MAX_SAMPLES-1):
			plots[identifier].vals.push_back(empty)
	else:
		# add to existing plot
		plots[identifier].vals.remove(0)
		plots[identifier].vals.push_back(values)
	
	# redraw plots
	update()

func _draw():
	var PAD = 16 # from control origin or earlier plots
	var TEXT_PAD = 2 # from rect borders
	
	# plot dimensions
	var WIDTH = 380
	var HEIGHT = 86
	
	# start position
	var x = PAD
	var y = PAD
	
	for identifier in plots.keys():
		var plot = plots[identifier]
		var plot_rect = Rect2(Vector2(x, y), Vector2(WIDTH, HEIGHT))
		var font = get_font("")
		
		var dim_color = Color(1.0,1.0,1.0,0.2)
		
		# draw background
		draw_rect(plot_rect, Color(0.2,0.2,0.2,0.2)) # bg
		
		# if plot min/max contain 0, draw 0 line
		if plot.r_min < 0.0 && plot.r_max > 0.0:
			var zero_y_pos = map(0.0, plot.r_min, plot.r_max, HEIGHT, 0)
			draw_line(Vector2(x, y + zero_y_pos), Vector2(x+WIDTH, y+zero_y_pos), dim_color, 2.0)
		
		# draw min and max on right end
		var max_str = str(plot.r_max)
		var min_str = str(plot.r_min)
		var max_pos = Vector2(x + WIDTH - font.get_string_size(max_str).x, y + font.height - TEXT_PAD)
		var min_pos = Vector2(x + WIDTH - font.get_string_size(min_str).x, y + HEIGHT - TEXT_PAD)
		draw_string(font, max_pos, max_str, dim_color)
		draw_string(font, min_pos, min_str, dim_color)
		
		# draw plot lines
		var width = WIDTH / float(_MAX_SAMPLES) # distance between graph points
		for s in range(plots[identifier].vals.size()-1):
			# each sample is a PoolRealArray of all plots from this identifier
			var sample = plots[identifier].vals[s]
			var next_sample = plots[identifier].vals[s+1]
			
			for i in range(sample.size()):
				# get the actual value for this sample and assign consistent color

				var point_y = map(sample[i], plots[identifier].r_min, plots[identifier].r_max, HEIGHT, 0)
				var next_point_y = map(next_sample[i], plots[identifier].r_min, plots[identifier].r_max, HEIGHT, 0)
				#draw_circle(Vector2(x, y + point_y), 2.0, _COLORS[i])
				draw_line(Vector2(x, y + point_y), Vector2(x + width, y + next_point_y), _COLORS[i], 1.0)
			
			x += width
		
		x = PAD + TEXT_PAD # reset x for labels drawing...
		
		# draw labels in corresponding colors
		var text_y = y + HEIGHT
		for i in range(plots[identifier].lbls.size()):
			draw_string(font, Vector2(x, text_y), plots[identifier].lbls[i], _COLORS[i])
			text_y -= font.height
		
		# draw identifier on top
		draw_string(font, Vector2(x, y + font.height), identifier, Color.whitesmoke)
		
		# draw next plot below
		y += HEIGHT + PAD

func map(value: float, istart: float, istop: float, ostart: float, ostop: float) -> float:
	return ostart + (ostop - ostart) * ((value - istart) / (istop - istart));


### TESTING
#var t = 0.0
#func _process(delta):
#	var _sin = sin(t)
#	var _cos = cos(t)
#	var _lol = sin(t*3.0)*0.5
#	var _oth = abs(cos(t*2.0))-1.0
#	t += delta*4.0
#	add_plot_multi("TestMultiPlot", ["Sin", "Cos", "sin times 3", "abs cos times 2"], [_sin, _cos, _lol, _oth])
#	add_plot_single("OtherSinglePlot", "Faster Cos", cos(t*10.0), -4.0, 2.0)
