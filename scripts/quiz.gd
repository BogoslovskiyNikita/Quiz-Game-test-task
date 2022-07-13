extends Control

var right_answer_pos
var curr_question_index = 0
var life = 3
var score = 0
var question_amonunt


func _ready():
	_bind_buttons()


func _process(delta):
	_bind_score()
	_check_lose()


func _btn_press(pos: int):
	if pos == right_answer_pos:
		_right_answer()
	else:
		_wrong_answer()


func _right_answer():
	_increase_score()
	_new_question()


func _wrong_answer():
	_hide_heart(life)
	life -= 1
	_new_question()


func _increase_score():
	score += 1


func _bind_buttons():
	var question = db.get_all_questions()[curr_question_index]
	$VBoxContainer/CenterContainer5/QuestionLabel.bbcode_text = (
		"[center]"
		+ question["question"]
		+ "[/center]"
	)
	var answer_oprtions = [
		question["option_1"], question["option_2"], question["option_3"], question["option_4"]
	]
	randomize()
	answer_oprtions.shuffle()
	var t = answer_oprtions.find(question["option_" + str(question["right_option"])])
	right_answer_pos = t + 1
	$VBoxContainer/CenterContainer/FrstAnswerBtn.text = answer_oprtions[0]
	$VBoxContainer/CenterContainer2/ScndAnswerBtn.text = answer_oprtions[1]
	$VBoxContainer/CenterContainer3/ThrdAnswerBtn.text = answer_oprtions[2]
	$VBoxContainer/CenterContainer4/FrthAnserBtn.text = answer_oprtions[3]
	question_amonunt = len(db.get_all_questions())


func _bind_score():
	$ScoreLabel.text = "Очки: " + str(score)


func _hide_heart(pos: int):
	if pos == 3:
		$Life/Heart3.hide()
	elif pos == 2:
		$Life/Heart2.hide()
	elif pos == 1:
		$Life/Heart1.hide()


func _new_question():
	if curr_question_index + 1 < question_amonunt:
		curr_question_index += 1
		_bind_buttons()
	else:
		_win()


func _check_lose():
	if life <= 0:
		_lose()


func _win():
	if score > 0 and score < 5:
		$AcceptDialog.dialog_text = (
			"Вы победили, ответив на %s ворпоса"
			% str(score)
		)
	else:
		$AcceptDialog.dialog_text = (
			"Вы победили, ответив на %s ворпосов"
			% str(score)
		)
	$AcceptDialog.window_title = "Победа!"
	$AcceptDialog.show()


func _lose():
	$AcceptDialog.dialog_text = "Вы проиграли :("
	$AcceptDialog.window_title = "Поражение"
	$AcceptDialog.show()


func _on_FrstAnswerBtn_pressed():
	_btn_press(1)


func _on_ScndAnswerBtn_pressed():
	_btn_press(2)


func _on_ThrdAnswerBtn_pressed():
	_btn_press(3)


func _on_FrthAnserBtn_pressed():
	_btn_press(4)


func _on_AcceptDialog_confirmed():
	get_tree().change_scene("res://scenes/menu.tscn")


func _on_AcceptDialog_about_to_show():
	$VBoxContainer/CenterContainer/FrstAnswerBtn.disabled = true
	$VBoxContainer/CenterContainer2/ScndAnswerBtn.disabled = true
	$VBoxContainer/CenterContainer3/ThrdAnswerBtn.disabled = true
	$VBoxContainer/CenterContainer4/FrthAnserBtn.disabled = true
