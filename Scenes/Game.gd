extends Node2D


onready var sentence_word = preload("res://SentenceWord.tscn")
var mouse_inside = false
var missing_words_len 
var full_sentence

func _ready():
	Global.pop_up = get_node("UI/MenuButtons/PopupMenu")

func _process(delta):
	pass

func _on_Quit_pressed():
	get_tree().quit()

func set_box_color(subjekt, objekt, predikat, box, rijec):
	if rijec in subjekt:
		box.texture = load("res://Assets/Blocks/RedButton.png")
	elif rijec in objekt:
		box.texture = load("res://Assets/Blocks/DiffBlueButton.png")
	elif rijec in predikat:
		box.texture = load("res://Assets/Blocks/OrangeButton.png")
	else:
		pass

func delete_children_nodes(parent_node):
	for n in parent_node.get_children():
		parent_node.remove_child(n)
		n.queue_free()
	
func generate_sentence(sentence_len):
	var sentence_container = get_node("Sentence/HBoxContainer")
	delete_children_nodes(sentence_container)
	for i in range (sentence_len):
		var word = sentence_word.instance()
		sentence_container.add_child(word)

func setup_scene():
	#FALI NADODAT DA FALI JEDNA RIJEC
	var maybe_random_position 
	var maybe_missing_word_value
	var missing_word_value = []
	var random_position = []
	var suggestions = []
	var missing_word_type = []
	var sentences = Global.sentences
	var sentence = Global.sentences
	var number_of_sentences = sentence.size() 
	
	#GENERATING PARTS FOR MAIN SENTENCE AND CHOOSING MAIN SENTENCE
	var rand
	while true:
		randomize()
		rand = randi() % number_of_sentences
		rand = str(rand)
		if !(rand in Global.used_sentence):
			break
			
	Global.used_sentence.append(rand)
	
	sentence = sentence[rand]
	full_sentence = sentence.recenica
	var sentence_array = sentence.recenica.split(" ")
	Global.curr_sentence_array = sentence_array
	var subjekt = sentence.subjekt
	var objekt = sentence.objekt
	var predikat = sentence.predikat
	var sentence_container = get_node("Sentence/HBoxContainer")
	generate_sentence(len(sentence_array))
	
	sentence_container = get_node("Sentence/HBoxContainer").get_children()
	Global.global_sentence_container = sentence_container
	
	#RANDOM FOR MISSING WORD IN SENTENCE
	for i in range (missing_words_len):
		while true:
			randomize()
			maybe_random_position = randi()% len(sentence_array) # randf(optimiziranije)
			maybe_missing_word_value = sentence_array[maybe_random_position] # rijec koja nedostaje u recenici
			if maybe_missing_word_value in missing_word_value:
				continue
			if maybe_missing_word_value in predikat:
				missing_word_type.append('p')
				suggestions.append(maybe_missing_word_value)
				random_position.append(maybe_random_position)
				missing_word_value.append(maybe_missing_word_value)
				break
			elif maybe_missing_word_value in subjekt:
				missing_word_type.append('s')
				suggestions.append(maybe_missing_word_value)
				random_position.append(maybe_random_position)
				missing_word_value.append(maybe_missing_word_value)
				break
			elif maybe_missing_word_value in objekt:
				missing_word_type.append('o')
				suggestions.append(maybe_missing_word_value)
				random_position.append(maybe_random_position)
				missing_word_value.append(maybe_missing_word_value)
				break
				
	Global.missing_word = missing_word_value
	
	#SETTING UP SENTENCE AND BLANK BOX
	for i in len(sentence_container):
		if i in random_position:
			sentence_container[i].get_children()[0].text = "_____"
		else:
			sentence_container[i].get_children()[0].text = sentence_array[i]
			set_box_color(subjekt, objekt, predikat, sentence_container[i], sentence_array[i])
	
	#GENERATING SUGGESTIONS
	#for i in range(Global.len_suggestions_words):
	while true:
		if len(suggestions) == Global.len_suggestions_words + 1:
			break
		var flag = false
		randomize()
		var random_sentence = randi() % number_of_sentences # randf(optimiziranije)
		random_sentence = str(random_sentence)
		if not sentences[random_sentence].subjekt or not sentences[random_sentence].predikat:
			continue
		#AKO IMAMO PREDIKAT TRAZIMO SUBJEKTE I OBJEKTE
		if 'p' in missing_word_type:
		#if sentence[random_sentence].subjekt.to_upper() in sentence_array: # provjera ako predlozena rijec vec postoji u nasoj recenici koja je u zadatku
			var tmp_array = sentences[random_sentence].subjekt + sentences[random_sentence].objekt
			tmp_array.shuffle()
			for suggested_subjekt in tmp_array:
				if suggested_subjekt in sentence_array:
					flag = true
					break
			if flag or tmp_array[0] in suggestions:
				continue
			suggestions.append(tmp_array[0])
		#SHUFFLANJE PREDIKATA?!!?
		elif 's' in missing_word_type or 'o' in missing_word_type:
			for suggested_objekt_subjekt in sentences[random_sentence].predikat:
				if suggested_objekt_subjekt in sentence_array:
					flag = true
					break
			if flag or sentences[random_sentence].predikat[0] in suggestions:
				continue
			suggestions.append(sentences[random_sentence].predikat[0])
		
	suggestions.shuffle()
	#DISPLAYING SUGGESTIONS
	var suggestions_boxes = get_node("SuggestedAnswers/HBoxContainer").get_children()
	#var suggestions_boxes_size = get_node("SuggestedAnswers/HBoxContainer").get_children().size()
	for i in range(5):
		if i < Global.len_suggestions_words + 1:
			suggestions_boxes[i].get_children()[0].text = suggestions[i]
			suggestions_boxes[i].show()
		else:
			suggestions_boxes[i].hide()
	
func move_all():
	#get_node("Start").move(Vector2(-1280, 0))
	#get_node("Options").move(Vector2(0, 100))
	get_node("UI").move(Vector2(0, -1280))
	#get_node("Sentence/HBoxContainer/Button6").hide()
	#get_node("Sentence/HBoxContainer/Button3").hide()
	get_node("Sentence").move(Vector2(0, 190))
	get_node("BackButton").move(Vector2(50, 50))
	get_node("ResetButton").move(Vector2(50, 580))
	get_node("HomeButton").move(Vector2(1100, 50))
	get_node("SuggestedAnswers").move(Vector2(0, 550))
	
func reset_suggestion_box_positions():
	var suggestion_container = get_node("SuggestedAnswers/HBoxContainer")
	suggestion_container.set_alignment(1)
		
func easyPressed(full_reset=true):
	if full_reset:
		Global.used_sentence = []
	Global.difficulty = 1
	missing_words_len = 1
	Global.load_sentences("res://Data/easy_db.json")
	Global.len_suggestions_words = 2
	setup_scene()
	move_all()
	Global.pop_up.get_child(4).text = full_sentence

func mediumPressed(full_reset=true):
	if full_reset:
		Global.used_sentence = []
	Global.difficulty = 2
	missing_words_len = 1
	Global.load_sentences("res://Data/medium_hard_db.json")
	Global.len_suggestions_words = 3
	setup_scene()
	move_all()
	Global.pop_up.get_child(4).text = full_sentence

func hardPressed(full_reset=true):
	if full_reset:
		Global.used_sentence = []
	Global.difficulty = 3
	missing_words_len = 2
	Global.load_sentences("res://Data/medium_hard_db.json")
	Global.len_suggestions_words = 4
	setup_scene()
	move_all()
	Global.pop_up.get_child(4).text = full_sentence

func resetButtonPressed():
	reset_suggestion_box_positions()
	if Global.difficulty == 1:
		easyPressed(true)
	elif Global.difficulty == 2:
		mediumPressed(true)
	else:
		hardPressed(true)

func inGameBackButtonPressed():
	Global.pop_up.hide()
	get_node("UI").move(Vector2(0, 0))
	get_node("Sentence").move(Vector2(0, -300))
	get_node("BackButton").move(Vector2(0, -100))
	get_node("ResetButton").move(Vector2(0, 780))
	get_node("HomeButton").move(Vector2(1100, -100))
	reset_suggestion_box_positions()
	get_node("SuggestedAnswers").move(Vector2(0, 840))

func homeButtonPressed():
	Global.pop_up.hide()
	get_node("UI").move(Vector2(0, 0))
	get_node("UI/MenuButtons/Options").move(Vector2(1280, 100))
	get_node("UI/MenuButtons/Start").move(Vector2(0, 0))
	get_node("Sentence").move(Vector2(0, -300))
	get_node("BackButton").move(Vector2(0, -100))
	get_node("ResetButton").move(Vector2(0, 780))
	get_node("HomeButton").move(Vector2(1100, -100))
	reset_suggestion_box_positions()
	get_node("SuggestedAnswers").move(Vector2(0, 840))

func popUpButtonPressed():
	Global.pop_up.hide()
	get_node("Sentence").move(Vector2(0, -300))
	reset_suggestion_box_positions()
	get_node("SuggestedAnswers").move(Vector2(0, 840))
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	if Global.difficulty == 1:
		easyPressed(false)
	elif Global.difficulty == 2:
		mediumPressed(false)
	else:
		hardPressed(false)
