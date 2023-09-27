extends Control

@onready var roll_daily = get_node("roll-day");
@onready var die1 = get_node("die1");
@onready var die2 = get_node("die2");
@onready var die3 = get_node("die3");
@onready var die4 = get_node("die4");
@onready var die5 = get_node("die5");
@onready var die6 = get_node("die6");
@onready var yourdie = get_node("yourdie");
@onready var selectedText = get_node("selected");
@onready var resultsText = get_node("results");
@onready var whoWinsText = get_node("whowins");
@onready var option1 = get_node("option1");
@onready var option2 = get_node("option2");
var dice;
var rng;
var selected = '';
var yourdieselected = '';
var roll_daily_rolled = false;
var you_rolled_higher = false;
var yourdieVal = 0;
var dieVal = 0;
var dieIndex = -1;
var diceVals = []

var json = JSON.new()
var json_scene= "res://my_scene.json"
var json_data = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	roll_daily.text = "Click me"

	randomize();
	print('sds')
	dice = [die1,die2,die3,die4,die5,die6]
	diceVals = [0,0,0,0,0,0]
	roll_daily.pressed.connect(self._button_pressed_click_me)
	for die in dice :

		die.pressed.connect( self._button_pressed_die_selected.bind(dice.find(die)))
	yourdie.pressed.connect(self._button_pressed_yourdie_selected)
	yourdie.disabled = true
	json_data = load_json_file(json_scene)
	print(json_data['lol'][0]['name'])
	pass # Replace with function body.

func load_json_file(filePath : String):
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath, FileAccess.READ);
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		if parsedResult is Dictionary:
			return parsedResult
		else:
			print("error")
	else:
		print("don't exist")

func _button_pressed_yourdie_selected():

		var rol = randi() % 6;
		yourdieVal = rol+1;
		yourdie.text = str(rol+1);
		
		yourdieselected = str(rol+1);


func _button_pressed_die_selected(di):
	print(di)
	if (dice[di].text != selected or selected == ''):
		dieVal = int(diceVals[di])
		dieIndex = di;
		selected = str(diceVals[di])
	elif ( dieIndex == di):
		dieVal = 0;
		dieIndex = di;
		print('index', dieIndex)
		selected = ''
	
	pass

func _button_pressed_click_me():

	if (roll_daily_rolled == false):
		for die in dice :

			var rol = randi() % 6;
			die.text = str(rol+1);
			diceVals[dice.find(die)] = str(rol+1);
			roll_daily.disabled = true;
		roll_daily_rolled = true;


	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (yourdieselected != ''):
		if dieVal == 6 or dieVal == 1:
			resultsText.text = 'doesnt matter';
		else:
			resultsText.text = 'your rolled die is ' + yourdieselected+ '.';
	
	if (selected != ''):
		selectedText.text = 'your selected die is '+selected+ '.';
		yourdie.disabled = false
	else: 
		selectedText.text = "You haven't selected a die to roll against";
	if (selected != ''):
		if (dieVal == 6):
			
			whoWinsText.text = 'You automatically pass this check'
			yourdie.disabled = true
		elif (dieVal ==1):
			whoWinsText.text = 'You automatically fail this check'
			yourdie.disabled = true
		else:
			yourdie.disabled = false
			whoWinsText.text = ''
			if (yourdieselected != ''):

				if yourdieVal < dieVal:
					
					you_rolled_higher = false;
					
					print('asasa',str(yourdieVal));
					whoWinsText.text = 'Your roll of ' + str(yourdieVal) + ' was less than your competitions which was ' + str(dieVal) +'. You win!'
				elif yourdieVal == dieVal:
					you_rolled_higher = true;
					print('asasa',str(yourdieVal));
					whoWinsText.text = 'Your roll of ' + str(yourdieVal) + ' was equal to your competitions which was ' + str(dieVal) +'. You lose.'
				else:
					you_rolled_higher = true;
					whoWinsText.text = "Your roll of " + str(yourdieVal) + ' was higher than your competitors roll which was ' + str(dieVal) + '. You lose.'
				for die in dice :
					die.disabled = true;
				yourdie.disabled = true

	else:
		resultsText.text = '';
		whoWinsText.text = ''
	pass
