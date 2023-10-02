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
@onready var currentPos = get_node("position-label");
@onready var winPosition = get_node("win-position");
@onready var losePosition = get_node("lose-position");
var dice;
var rng;
var selected = '';
var yourdieselected = '';
var roll_daily_rolled = false;
var you_rolled_higher = false;
var yourdieVal = 0;
var dieVal = 0;
var dieIndex = -1;
var dieDailyArchive =[]
var days = 0;
var diceVals = []

var json = JSON.new()
var json_scene= "res://my_scene.json"
var json_data = {}
var json_stage = {}
var current_json_id = 24;
var attributes = [];
var spaces_to_go = 0;
var substituting = false;
var money = 0;
var direction = -1;

# Called when the node enters the scene tree for the first time.
func _ready():
	roll_daily.text = "Click me"

	randomize();
	print('sds')
	dice = [die1,die2,die3,die4,die5,die6]
	diceVals = [0,0,0,0,0,0]
	roll_daily.pressed.connect(self._button_pressed_click_me)
	option1.pressed.connect(self._button_pressed_advance.bind(1))
	option2.pressed.connect(self._button_pressed_advance.bind(2))
	for die in dice :

		die.pressed.connect( self._button_pressed_die_selected.bind(dice.find(die)))
	yourdie.pressed.connect(self._button_pressed_yourdie_selected)
	yourdie.disabled = true
	json_data = load_json_file(json_scene)
	print(json_data['stages'][0]['description'])
	pass # Replace with function body.

func setupAll():
	for d in dieDailyArchive:
		dice[d].disabled = true;
	var json_stage = json_data['stages'][current_json_id];

	for a in attributes:
		if (a == json_data['stages'][current_json_id]['substituteIf']):
			json_stage = json_data['stages'][current_json_id]['substituteObject'];
		
	for a in attributes:
		if (a == json_data['stages'][current_json_id]['substituteIf']):
			json_stage[current_json_id]['substituteObject'];
	if (json_stage["value"] == 1337):	##1337 is FIRED
		if (attributes.count('FIRED')==0):
			attributes.append('FIRED');
	elif (json_stage["value"] == 1000):
		if (attributes.count('NEEDS_NOT_MET')==0):	#1000 is NEEDS_NOT_MET
			attributes.append('NEEDS_NOT_MET');
	elif (json_stage["value"] == 7430): 	#7430 is HAS_BAND
		if (attributes.count('HAS_BAND')==0):
			attributes.append('HAS_BAND');
	elif (json_stage["value"] == 6969): #6969 is INFLATED
		if (attributes.count('INFLATED')==0):
			attributes.append('INFLATED');
	elif (json_stage["value"] == 1594): 	#1594 is HAS_LOAN
		if (attributes.count('HAS_LOAN')==0):
			attributes.append('HAS_LOAN');
	elif (json_stage["value"] == 6660):	#6660 is BOSS
		if (attributes.count('BOSS')==0):
			attributes.append('BOSS');
	elif (json_stage["value"] == 1212):	#1212 is IRA
		if (attributes.count('IRA')==0):
			attributes.append('IRA');

	elif (json_stage["value"] == 4424):	#4424 is remove FIRED
		if (attributes.count('FIRED')>0):
			attributes.remove_at(attributes.find('FIRED'));
	elif (json_stage["value"] == 8032):	#8032 is remove HAS_BAND
		if (attributes.count('HAS_BAND')>0):
			attributes.remove_at(attributes.find('HAS_BAND'));
	elif (json_stage["value"]== 1201):	#1201 is remove HAS_LOAN
		if (attributes.count('HAS_LOAN')>0):
			attributes.remove_at(attributes.find('HAS_LOAN'));
	elif (json_stage["value"] == 8080):	#8080 is remove IRA
		if (attributes.count('IRA')>0):
			attributes.remove_at(attributes.find('IRA'));
	elif (json_stage["value"] == 5550):	#5550 is remove NEEDS_NOT_MET
		if (attributes.count('NEEDS_NOT_MET')>0):
			attributes.remove_at(attributes.find('NEEDS_NOT_MET'));
	elif (json_stage["value"] == 9696):	#9696 is remove INFLATED
		if (attributes.count('INFLATED')>0):
			attributes.remove_at(attributes.find('INFLATED'));
	else:
		money += json_stage["value"]
	currentPos.text = json_stage['title'];
	var winId = 0;
	var loseId = 0;
	var win = ''
	var lose = ''
	if (json_stage['type'] == 'contest'):
		winId = current_json_id + direction;
		loseId= current_json_id + direction;
		win = json_data['stages'][winId]['title']
		lose = json_data['stages'][loseId]['title']
	elif (json_stage['type']== 'a'):
		if (json_stage['spacesForward']>0):
			winId= current_json_id + json_stage['spacesForward'];
			win = json_data['stages'][winId]['title']
		elif (json_stage['spacesForward']<0):
			loseId= current_json_id + json_stage['spacesForward'];
			lose = json_data['stages'][loseId]['title']
	winPosition.text = win
	losePosition.text = lose

#	pass
	

func _button_pressed_advance(opt):
	dieDailyArchive.append(dieIndex);

	if (json_stage["type"] == "a"):
		if (opt == 1):
			current_json_id = direction;
		elif (opt == 2):
			current_json_id = -1*direction;
	elif (json_stage["type"] == 'contest'):
		current_json_id = direction*json_stage["spacesForward"];
	setupAll();


	pass

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
	
func _which_option(option):
	if (option == 1):
		option1.disabled = true;
		option2.disabled = false;
	elif (option == 2):
		option1.disabled = false;
		option2.disabled = true;
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
