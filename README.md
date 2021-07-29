# gDebugGui - *Immediate Mode* Debug UI for Godot

gDebug is a small collection of helper scripts to display debug information on screen during game runtime.
It currently supports simple text drawing and small plots, useful for monitoring values change over time.

### Overview
gDebug aims to be as straight forward to use as possible, highly inspired by immediate mode gui systems like Unity's `OnGui()` functionality. As its content is cleared after each draw, it should be mostly called recurringly from `_process()` (or similar every-frame-methods)  

It consists of the main `Debug.gd` class and several submodules, automatically created when requested.
The main class also acts as a wrapper and provides all submodule functionality through a unified interface.

### Modules
**Printer**</br>
Prints information on screen. Either at a specific screen position or as a block of strings in top left corner.
```python
# simple prints
Debug.print("Test") # adds a line to top left of screen
Debug.print("Important Information: " + str(get_important_info())) # adds another line

# screen space print
Debug.print_screen("Test at position", Vector2(64,128)) # prints text at given position
```
**Plotter**</br>
Plots graphs of fixed number of samples. Either for a single value, or multiple values in a single graph, with different colors.
```python
# single plot graph
Debug.plot_single(identifier, label, value, _min, _max)
# multi value plot graph
Debug.plot_single(identifier: String, labels: PoolStringArray, values: PoolRealArray, _min: float, _max: float)
```
*Function Arguments* </br>
`identifier: String`: unique name or header for this graph </br>
`label/s: String/PoolStringArray`: name(s) of the value(s) plotted, in case of *_multi* this is *PoolStringArray* </br>
`value/s: float/PoolRealArray`: the value(s) in this frame, for *_multi* this is a *PoolRealArray* </br>
`min: float`: the coordinate system's minimum value </br>
`max: float`: the coordinate system's maximum value </br>

```python
# Example calls
Debug.plot_single("Performance", "fps", get_fps(), 0, 120)
Debug.plot_multi("Waves", ["sine","cosine"], [sin(time), cos(time)]], -1.1, 1.1)
```


### Future Ideas
* provide a Button mechanism to quickly trigger function calls
* basic console with log messages (and support for logging to file?)