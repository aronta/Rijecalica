extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#SKRIPTA ZA MOVANJE TO TOP SUGGESTION BOXEVA
# Called when the node enters the scene tree for the first time.
func _ready():
	#var suggestions = get_node("SuggestedAnswers/HBoxContainer").get_children()
	for suggestionBox in get_children():
		suggestionBox.connect('move_to_top', self, "move_window_to_top")

func move_window_to_top(node):
	move_child(node, Global.len_suggestions_words)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
