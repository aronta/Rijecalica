extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal move_to_top
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var drag_position = null

func _on_TextureRect_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_click"):
			drag_position = get_global_mouse_position() - rect_global_position
			emit_signal('move_to_top', self)
		else:
			drag_position = null
			
	if event is InputEventMouseMotion and drag_position:
		rect_global_position = get_global_mouse_position() - drag_position
