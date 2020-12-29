extends Node2D

var file_path = "res://Data/easy_db.json"
var len_suggestions_words
var missing_word = []
var pop_up
var difficulty
var used_sentence = []
var global_sentence_container
var curr_sentence_array
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var sentences : Dictionary
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func load_json(path) -> Dictionary:
	var file = File.new()
	
	file.open(path, file.READ)
	var sentences = parse_json(file.get_as_text())
	return sentences
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func load_sentences(path_to_json):
	self.sentences = load_json(path_to_json)
	

