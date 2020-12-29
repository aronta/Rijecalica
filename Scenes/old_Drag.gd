extends TextureRect

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var mouse_in = false
var dragging = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#
#func _input(event):
#	if event is InputEventMouseButton:
#		if mouse_in and event.is_pressed():
#			draggingDistance = position.distance_to(get_viewport().get_mouse_position())
#			dir = (get_viewport().get_mouse_position() - position).normalized()
#			dragging = true
#			newPosition = get_viewport().get_mouse_position() - draggingDistance * dir
#		else:
#			dragging = false
#	elif event is InputEventMouseMotion:
#		if dragging:
#			newPosition = get_viewport().get_mouse_position() - draggingDistance * dir

#var dragPosition
#func _process(delta):
#	if (mouse_in && Input.is_action_pressed("left_click")):
#		dragging = true
#		#dragPosition = get_global_mouse_position() - rect_global_position
#
#		#var dragPosition = get_global_mouse_position() - rect_global_position
#	if (dragging && Input.is_action_pressed("left_click")):
#		dragPosition = get_global_mouse_position() - rect_global_position
#		#rect_global_position = get_global_mouse_position() - dragPosition
#		#dragPosition = dragPosition.abs()
#
#		#print(rect_global_position)
#		print("1 Pozicija misa u rect")
#		print(dragPosition)
#		print("2 Globalna pozicija misa")
#		print(get_viewport().get_mouse_position())
#		print("3 Miš - pozicija miša u rect")
#		print(get_viewport().get_mouse_position() - dragPosition)
#
#
#		set_global_position(dragPosition + get_global_mouse_position())
#
#	else:
#		dragPosition = null
#		dragging = false
#
#func _on_TextureRect_mouse_entered():
#	print("uso")
#	mouse_in = true
#
#func _on_TextureRect_mouse_exited():
#	print("izaso")
#	mouse_in = false


var previous_mouse_position = Vector2()
var is_dragging = false

func _on_TextureRect_gui_input(event):
	if event.is_action_pressed("left_click"):
		get_tree().set_input_as_handled()
		previous_mouse_position = event.position
		is_dragging = true

func _input(event):
	if not is_dragging:
		return
		
	if event.is_action_released("left_click"):
		previous_mouse_position = Vector2()
		#rect_global_position = event.position
		is_dragging = false

	if is_dragging and event is InputEventMouseMotion:
		print(rect_position)
		rect_position += event.position - previous_mouse_position
		previous_mouse_position = event.position

