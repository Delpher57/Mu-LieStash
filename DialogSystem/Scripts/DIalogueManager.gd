#----NOTES:
#--Curent script supports up to 4 possible answers, if you need more make sure to set up the buttons and
#change the number acordingly at the clamp() function
#--Conditionals are not Implemented, if you need conditionals concider the solution found at:
# https://godotengine.org/asset-library/asset/273
#--This is a very simple demo, made for people getting started with json parsing / graph traversing
#--The setup of this graph traversion is perfect for loops and jumping around, but due to the free form 
#of the json format and id tracking you could get mixed up quite fast, quite easily, if you need a really
#intricate dialogue mapping it out on papper or drawing software is advised
#--Force and Random are stored as a common typecast int->bool (where 0 == false else true)

#----HOW TO----#
#-- Get a reference of the script in whatever way you prefer
#-- Use LoadFile(string x) and pass it the name of the dialogue file you want loaded (IMPORTANT: path and extension are already set, do not add the .json extension)
#-- Call StartDialogue() whenever you want the dialogue to start
#-- The rest is handled in the script already , and the buttons are updated dynamicly.



extends Panel


var stats = PlayerStats
#---File---#
#var file_name = "dialogue_4" # You could pass a new file here on area body enter or whenever you feel like
var file_name
var texture


var nodes # containes all the nodes of the current dialogue

var sound_on = false
signal finprint

#----DATA (from file)-----#
var curent_node_id # handles the current node we are traversing Note: -1 exits the dialogue
var curent_node_name # name of the speaker 
var curent_node_text # dialogue text
var curent_node_next_id # connect to the next node Note: ignored if curent_node_choices has things inside
var curent_node_choices # If you want more than one possible answear, you should fill this up



#------UI--------#
onready var dialogueText = $DialogueText 
onready var dialoguePanel = self #Less rewritting if you want to move the script to another object
onready var dialogueName = $DialogueName
onready var dialogueButtons = [$Control/DialogueButton,$Control/DialogueButton2,$Control/DialogueButton3,$Control/DialogueButton4]
onready var sprite = $Sprite
onready var talkSound = $talksound
onready var timer = $Timer

func iniciar_dialogo(archivo):
# warning-ignore:return_value_discarded
	dialogueButtons[0].grab_focus()
	LoadFile(archivo)
	StartDialogue()
	


func LoadFile(fname):
	file_name = fname
	var file = File.new()
	var extention = ".json"
	if file.file_exists("res://DialogSystem/Dialogues/" + file_name + extention):
		file.open("res://DialogSystem/Dialogues/" + file_name + extention, file.READ)
		var json_result = parse_json(file.get_as_text())


		curent_node_id = json_result["root"]["next"]
		nodes = json_result


	else:
		print("Dialogue: File Open Error")
	file.close()

	
#-----Traversing Graph-----#
func StartDialogue():
	if nodes:
		stats.can_move = false
		HandleNode()


func EndDialogue():
	curent_node_id = "_NULL_"

func NextNode(id):
	curent_node_id = id
	HandleNode()

#----Handle Current Node-----#
func HandleNode():
	if !GrabNode(curent_node_id):
		EndDialogue()
	UpdateUI()
	
func GrabNode(id):
	for node in nodes:
		if  node == id:
			curent_node_name = nodes[node]["name"]
			curent_node_text = nodes[node]["text"]["en"]
			
			if nodes[node].has("next"):
				curent_node_next_id = nodes[node]["next"]
			else:
				curent_node_next_id = "_NULL_"
				
			if nodes[node].has("choices"):
				curent_node_choices = nodes[node]["choices"]
			else:
				curent_node_choices = []
			
			texture = nodes[node]["portrait"]
			return true
	return false

#----Update UI-----#
func UpdateUI():
	if curent_node_id != "_NULL_":

		dialoguePanel.show()
		
		sprite.texture = load(texture)
		
		for x in dialogueButtons:
			x.hide()
			#disconnect buttons
			if x.is_connected("pressed",self,"_on_Button_Pressed"):
				x.disconnect("pressed",self,"_on_Button_Pressed")
			
		dialogueName.text = curent_node_name
		prueba(curent_node_text)
		yield(self, "finprint")

		if curent_node_choices.size() > 0:
			dialogueButtons[0].grab_focus()
			for x in clamp(curent_node_choices.size(),0,3):
				dialogueButtons[x].text = curent_node_choices[x]["text"]["en"]
				
				#connecto to button
				dialogueButtons[x].connect("pressed",self,"_on_Button_Pressed", [curent_node_choices[x]["next"]])
				dialogueButtons[x].show()
				
		else:
			dialogueButtons[0].text = "Continue"
			dialogueButtons[0].show()
			#connect to the button
			dialogueButtons[0].connect("pressed",self,"_on_Button_Pressed", [curent_node_next_id])
			dialogueButtons[0].grab_focus()

	else:
		dialoguePanel.hide()
		stats.can_move = true

#-----On Button Pressed-----#
func _on_Button_Pressed(id):
	NextNode(id)

#imprimir texto
func prueba(text):
	var buscando = false
	dialogueText.bbcode_text = ""
	var timertime = .02
	var tempbb = ""
	for c in(text):
		if buscando == true:
			if c == ']':
				tempbb += c
				dialogueText.bbcode_text += tempbb
				buscando = false
				continue
			else:
				tempbb += c
				continue
		if c == '[':
			buscando = true
			tempbb = ""
			tempbb += c
			continue
		
		if sound_on == false:
			talkSound.play()
			sound_on = true
			timer.start(timertime*5)
		if Input.is_action_pressed("dash"):
			timertime = 0
			
		dialogueText.bbcode_text += c
		if timertime == 0:
			continue
		yield(get_tree().create_timer(timertime), "timeout")
	yield(get_tree().create_timer(timertime*5), "timeout")
	talkSound.stop()
	emit_signal("finprint")


func _on_Timer_timeout():
	pass
	sound_on = false
