extends CanvasLayer

@export var arena_timer_manager: Node
@onready var label = %Label

func _process(delta):
	if arena_timer_manager == null:
		return
		
	var time_elapsed = arena_timer_manager.get_elapsed_time()
	print(time_elapsed)
	label.text = format_seconds_to_str(time_elapsed)


func format_seconds_to_str(time_elapsed: float):
	var minutes = floor(time_elapsed / 60)
	var seconds = floor(time_elapsed - 60 * minutes)
	return str(minutes) + ":" + ("%02d" % seconds)
