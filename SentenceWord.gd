extends TextureRect

var suggested_word
var flag = false
var ref = Vector2(0.5, 0.5)
var missing_words_len = len(Global.missing_word)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_child_position(inst):
	var inst_len = len(Global.global_sentence_container)
	var pos
	for i in range(inst_len):
		if inst == Global.global_sentence_container[i]:
			pos = i
			break
	return pos
	
func move_buttons_away():
	get_tree().get_root().get_node("Game").get_node("HomeButton").move(Vector2(1100, -100))
	get_tree().get_root().get_node("Game").get_node("BackButton").move(Vector2(0, -100))
	get_tree().get_root().get_node("Game").get_node("ResetButton").move(Vector2(0, 780))

func _process(delta):
	if flag and Input.is_action_just_released("left_click"):
		var sentence_word_label = self.get_child(0)
		var position = get_child_position(self)
#		var sentence_word_area2d = self.get_child(1)
#		var sentence_word_CollShape = self.get_child(1).get_child(0)
		
		#Širina/2
#		var sentence_word_width = sentence_word_CollShape.shape.extents.x
#		var sentence_word_height = sentence_word_CollShape.shape.extents.y
#
#		var diff = sentence_word_area2d.global_position - suggested_word.global_position
		
#		if abs(diff.x) < sentence_word_width and abs(diff.y) < sentence_word_height:
		if suggested_word.get_owner().get_child(0).text in Global.missing_word and sentence_word_label.text == "_____" and suggested_word.get_owner().get_child(0).text == Global.curr_sentence_array[position]:
			Global.missing_word.erase(suggested_word.get_owner().get_child(0).text)
			if Global.missing_word.empty() and Global.sentences.size() != len(Global.used_sentence):
				Global.pop_up.show()
				move_buttons_away()
			elif Global.missing_word.empty() and Global.sentences.size() == len(Global.used_sentence):
				Global.end_pop_up.show()
				move_buttons_away()
		
		flag = false

func _on_Area2D_area_entered(area):
	flag = true
	suggested_word = area
   
