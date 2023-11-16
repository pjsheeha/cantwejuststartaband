extends Control
@onready var daysLabel = get_node("display/days");
@onready var fansLabel = get_node("display/fans");
@onready var moneyLabel = get_node("display/money");
@onready var attributesLabel = get_node("display/attributes");
@onready var roll_daily = get_node("display/roll-day");
@onready var die1 = get_node("display/die1");

@onready var die2 = get_node("display/die2");
@onready var die3 = get_node("display/die3");
@onready var die4 = get_node("display/die4");
@onready var die5 = get_node("display/die5");
@onready var die6 = get_node("display/die6");
@onready var yourdie = get_node("display/yourdie");
@onready var selectedText = get_node("display/selected");
@onready var resultsText = get_node("display/results");
@onready var whoWinsText = get_node("display/whowins");
@onready var option1 = get_node("display/option1");
@onready var option2 = get_node("display/option2");
@onready var currentPos = get_node("display/position-label");
@onready var winPosition = get_node("display/option1/win-position");
@onready var losePosition = get_node("display/option2/lose-position");
@onready var display = get_node("display");
@onready var feedback = get_node("feedback");

var temp_attr = '';
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
var fans = 0;
var json = JSON.new()
var json_scene= "res://my_scene.json"
var json_data = {}
var json_stage = {}
var current_json_id = 24;
var attributes = [];
var spaces_to_go = 0;
var substituting = false;
var money = 0;
var health = 6;
var direction = -1;
var automatic_status = 'none';
var temp_money = 0;
var inflation_value = 0;
# Called when the node enters the scene tree for the first time.
func _ready():
	roll_daily.text = "Click me"
	feedback.visible = false;
	display.visible =true;
	randomize();

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

	attributes.append('HIRED');

	setupAll();
	initialRoll();
	
	pass # Replace with function body.

func initialRoll():
	roll_daily.disabled = false;
	print(health)
	for die in health :
		dice[die].disabled = true;
	print(dice)
	var newdice =[]
	for d in dice.size() :
		
		if (d>health-1):
			print('true')
			dice[d].visible = false;
			
		else:
			newdice.append(dice[d])
	dice = newdice;
	option1.disabled = true;
	option2.disabled = true;

func makeEverythingInvisible():
	feedback.visible = true;
	display.visible =false;
	print('p')

func setupAll():
	resultsText.text = '';
	whoWinsText.text = ''
	yourdie.text = ''
	selectedText.text = '';

	json_stage = json_data['stages'][current_json_id];
	

	for a in attributes:
		if (a == json_data['stages'][current_json_id]['substituteIf']):
			json_stage = json_data['stages'][current_json_id]['substituteObject'];
	if (current_json_id <24):
		direction = -1

	if (current_json_id >24):
		direction = 1

	#automatic_status = "none"

	deciding_die()
	if (json_stage["value"] == 1337):	##1337 is FIRED
		if (attributes.count('FIRED')==0):
			attributes.append('FIRED');
			if (attributes.count('HIRED')>0):
				attributes.remove_at(attributes.find('HIRED'));

	elif (json_stage["value"] == 7430): 	#7430 is HAS_BAND
		if (attributes.count('HAS_BAND')==0):
			attributes.append('HAS_BAND');
	elif (json_stage["value"] == 6969): #6969 is INFLATED
		if (attributes.count('INFLATED')==0):
			attributes.append('INFLATED');
	elif (json_stage["value"] == 1594): 	#1594 is HAS_LOAN
		if (attributes.count('HAS_LOAN')==0):
			attributes.append('HAS_LOAN');
	elif (json_stage["value"] == 9164): 	#9164 is HAS_NO_BAND_NAME
		if (attributes.count('HAS_BAND_NAME')==0):
			attributes.append('HAS_BAND_NAME');

		
	elif (json_stage["value"] == 1212):	#1212 is IRA
		if (attributes.count('IRA')==0):
			attributes.append('IRA');

	elif (json_stage["value"] == 23580):	#23580 is HAS_INSTRUMENTS
		if (attributes.count('HAS_INSTRUMENTS')==0):
			attributes.append('HAS_INSTRUMENTS');



	elif (json_stage["value"] == 4424):	#4424 is remove FIRED
		if (attributes.count('FIRED')>0):
			attributes.remove_at(attributes.find('FIRED'));
	elif (json_stage["value"] == 8032):	#8032 is remove HAS_BAND
		if (attributes.count('HAS_BAND')>0):
			attributes.remove_at(attributes.find('HAS_BAND'));
		if (attributes.count('HAS_INSTRUMENTS')>0):
			attributes.remove_at(attributes.find('HAS_INSTRUMENTS'));
		if (attributes.count('HAS_BAND_NAME')>0):
			attributes.remove_at(attributes.find('HAS_BAND_NAME'));
	elif (json_stage["value"]== 1201):	#1201 is remove HAS_LOAN
		if (attributes.count('HAS_LOAN')>0):
			attributes.remove_at(attributes.find('HAS_LOAN'));

	elif (json_stage["value"] == 8080):	#8080 is remove IRA
		if (attributes.count('IRA')>0):
			attributes.remove_at(attributes.find('IRA'));
	elif (json_stage["value"] == 5432):	#5432 is sent to prison
		health-=3;
	elif (json_stage["value"] == 5550):	#5550 is remove NEEDS_NOT_MET
		if (attributes.count('NEEDS_NOT_MET')>0):
			attributes.remove_at(attributes.find('NEEDS_NOT_MET'));
	elif (json_stage["value"] == 9696):	#9696 is remove INFLATED
		if (attributes.count('INFLATED')>0):
			attributes.remove_at(attributes.find('INFLATED'));
	elif (json_stage["value"] == 6115): #HAS_INSTRUMENT
		if (attributes.count('HAS_INSTRUMENTS')==0):
			inflation_value_result(500)
			if money > 500+inflation_value:
				temp_money = 500+inflation_value
				automatic_status = "true"	
				option1.disabled = false
				option2.disabled = false
			else:
				automatic_status = "false"
				option1.disabled = true
				option2.disabled = false
		else:
			automatic_status = "true"
		temp_attr = 'HAS_INSTRUMENTS'

	
	elif (json_stage["value"] == 8055): #BOSS
		if (attributes.count('BOSS')==0):
			inflation_value_result(10000)
			if money > 10000+inflation_value:
				temp_money = 10000+inflation_value
				automatic_status = "true"
				option1.disabled = false
				option2.disabled = false
				if (attributes.count('BOSS')==0):
					attributes.append('BOSS');	
			else:
				automatic_status = "false"
				option1.disabled = true
				option2.disabled = false
		else:
			automatic_status = "true"
		temp_attr = 'BOSS'
	elif (json_stage["value"] == 30763): #CONCERT
		inflation_value_result(5000)
		if money > 5000+inflation_value:
			option1.disabled = false
			option2.disabled = false
			temp_money = 5000+inflation_value
			automatic_status = "true"	
		else:
			option1.disabled = true
			option2.disabled = false
			automatic_status = "false"
		temp_attr = 'CONCERT'
	elif (json_stage["value"] == 2244): #NEEDS_MET
		inflation_value_result(600)

		if money >= 600+inflation_value:

			temp_money = 600+inflation_value

			option1.disabled = false
			option2.disabled = false
			automatic_status = "true"	
		else:

			option1.disabled = true
			option2.disabled = false
			automatic_status = "false"
		temp_attr = 'NEEDS_MET'

	currentPos.text = json_stage['title'];




	for d in dieDailyArchive:

		
		dice[d].disabled = true
	if money < 5000:
		if (attributes.count('NOT_HAS_5000')==0):
			attributes.append('NOT_HAS_5000');

	if money >= 5000:
		if (attributes.count('NOT_HAS_5000')>0):
			attributes.remove_at(attributes.find('NOT_HAS_5000'));
	
	var fullAttr = "";
	for at in attributes:
		fullAttr+= at+ ', \n';

	attributesLabel.text = "attributes: \n" + fullAttr
	fansLabel.text = "fans: "+str(fans);
	moneyLabel.text = "money: "+ str(money);
	daysLabel.text = "days: "+str(days);
	if (current_json_id == 24):
		roll_daily_rolled = false
		direction = 1
		if (days>0):
			if (attributes.has("NEEDS_MET")):
				attributes.remove_at(attributes.find('NEEDS_MET'));
			else:
				if (health > 0):
					health -=1
				if (health == 0):
					makeEverythingInvisible();

				
		diceVals = [0,0,0,0,0,0]
		for o in dice:
			o.text = ''
		dieDailyArchive.clear();
		initialRoll();
	#		

#	pass

func inflation_value_result(temp_money_val):		
	if (attributes.count('INFLATED')>0):
		inflation_value = (temp_money_val*.3)+20

		if (attributes.count('IRA')>0):
			inflation_value = 0


func deciding_die():
	var winId = 0;
	var loseId = 0;
	var win = ''
	var lose = ''
	if (json_stage['type'] == 'contest'):
		for p in dice:
			p.disabled = false
		winId = current_json_id + direction;
		loseId= current_json_id + (-1*direction);
		option1.disabled = true;
		option2.disabled = true;
		win = json_data['stages'][winId]['title']
		lose = json_data['stages'][loseId]['title']
	elif (json_stage['type'] == 'payout'):
		for p in dice:
			p.disabled = true
		winId = current_json_id + direction;
		#money+=json_stage['value']
		loseId= current_json_id + (-1*direction);
		option1.disabled = true;
		option2.disabled = true;
		win = json_data['stages'][winId]['title']
		lose = json_data['stages'][loseId]['title']
	else:
		for piu in dice:

			piu.disabled = true
		
		if (json_stage['type'] != 'teleport'):
			if (json_stage['spacesForward']>0):
				winId= current_json_id + json_stage['spacesForward'];
				option2.disabled = true;
				option1.disabled = false;
				win = json_data['stages'][winId]['title']
			elif (json_stage['spacesForward']<0):
				loseId= current_json_id + json_stage['spacesForward'];
				lose = json_data['stages'][loseId]['title']
				option2.disabled = false;
				option1.disabled = true;
		else:
			winId=  json_stage['spacesForward'];
			option2.disabled = true;
			option1.disabled = false;
			win = json_data['stages'][winId]['title']
			pass
	winPosition.text = win
	losePosition.text = lose
func _button_pressed_advance(opt):


	if (json_stage["type"] == "a"):
		current_json_id += json_stage["spacesForward"];
	elif (json_stage["type"] == "payday"):

		money += json_stage["value"];

		current_json_id += json_stage["spacesForward"];
	elif (json_stage["type"] == "rollpaydayboss"):
		money += json_stage["value"]+ ((randi() % 6)+1);
		current_json_id += json_stage["spacesForward"];
	elif (json_stage["type"] == "spotifyfanspayout"):
		money += 500+ (fans*100); 
		current_json_id += json_stage["spacesForward"];
	elif (json_stage["type"] == "fansgain"):
		fans+=1 
		current_json_id += json_stage["spacesForward"];
		
	elif (json_stage["type"] == "fansrandomincrease"):
		fans+=1 *((randi() % 6)+1)
		current_json_id += json_stage["spacesForward"];
	elif (json_stage["type"] == "teleport"):
		current_json_id = json_stage["spacesForward"];

	elif (json_stage["type"] == 'contest'):

		dieDailyArchive.append(dieIndex);
		if (opt == 1):

			current_json_id += (direction);
		elif (opt == 2):
			current_json_id += -1*direction;
	if (json_stage["type"] == 'payout'):

		if (opt == 1):
			money -= temp_money
			if (attributes.count(temp_attr)==0):
				attributes.append(temp_attr);	
			current_json_id += direction;
		elif (opt == 2):
			current_json_id += -1*direction;
		#if (automatic_status == 'true'):

		#	if (json_stage["spacesForward"]==0):
		#		current_json_id += 1*direction;
		#	else:
		#		current_json_id += json_stage["spacesForward"]
				
		#elif (automatic_status == 'false'):
		#	print(current_json_id -(1*direction))
		#	if (json_stage["spacesForward"]==0):
		#		current_json_id += -1*direction;
		#	else:
		#		current_json_id += json_stage["spacesForward"]
		
		#if (money >= temp_money):
		#	if (opt == 1):
		#		money -= temp_money
		#		if (json_stage["spacesForward"]==0):
		#			current_json_id += -1*direction;
		#		else:
		#			current_json_id += json_stage["spacesForward"]
		#	elif (opt == 2):
		#		
		#		if (json_stage["spacesForward"]==0):
		#			current_json_id += 1*direction;
		#		else:
		#			current_json_id += json_stage["spacesForward"]
		
		#else:
		#	automatic_status = 'false'	
		#	option1.disabled = false
		#	option2.disabled = true
		#dieDailyArchive.append(dieIndex);
		
		
	if (current_json_id == 81 or current_json_id == 79):

		current_json_id = 24;
		days +=1;
		setupAll();

		dieDailyArchive.clear();
		roll_daily_rolled = false
	else:
		if (dieDailyArchive.size() >= health):
			if (current_json_id == 94 or current_json_id == 92):	
				print('hello')
			else:
				current_json_id = 80;
			setupAll();


		else:
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
		if (yourdieselected != ''):
				if dieVal == 6 or dieVal == 1:
					resultsText.text = 'doesnt matter';
				else:
					resultsText.text = 'your rolled die is ' + yourdieselected+ '.';
					yourdie.disabled = false
					whoWinsText.text = ''
					if yourdieVal < dieVal:
						
						you_rolled_higher = false;
						whoWinsText.text = 'Your roll of ' + str(yourdieVal) + ' was less than your competitions which was ' + str(dieVal) +'. You win!'
					elif yourdieVal == dieVal:
						you_rolled_higher = true;

						whoWinsText.text = 'Your roll of ' + str(yourdieVal) + ' was equal to your competitions which was ' + str(dieVal) +'. You lose.'
					else:
						you_rolled_higher = true;
						whoWinsText.text = "Your roll of " + str(yourdieVal) + ' was higher than your competitors roll which was ' + str(dieVal) + '. You lose.'
					for die in dice :
						die.disabled = true;
					yourdie.disabled = true

				_which_option()


func _button_pressed_die_selected(di):

	if (dice[di].text != selected or selected == ''):
		dieVal = int(diceVals[di])
		dieIndex = di;
		selected = str(diceVals[di])
	elif ( dieIndex == di):
		dieVal = 0;
		dieIndex = -1;
	
		selected = ''
	elif ( dieIndex != di):
		dieIndex = di;
		dieVal = int(diceVals[di])
		selected = str(diceVals[di])
	if (selected != ''):
		selectedText.text = 'your selected die is '+selected+ '.';
		yourdie.disabled = false
	else: 
		selectedText.text = "You haven't selected a die to roll against";
		yourdie.disabled = true
	if (selected != ''):
		if (dieVal == 6):
			
			whoWinsText.text = 'You automatically pass this check'
			yourdie.disabled = true
			you_rolled_higher = false;
			_which_option()
		elif (dieVal ==1):
			whoWinsText.text = 'You automatically fail this check'
			yourdie.disabled = true
			you_rolled_higher = true;
			_which_option()
		else:
			option1.disabled = true;
			option2.disabled = true;

			
	pass

func _button_pressed_click_me():

	if (roll_daily_rolled == false):
		for die in dice :
			if (json_stage["type"] == "a"):
				die.disabled = true
				
			elif (json_stage["type"] == "contest"):
				die.disabled = false
			else:
				die.disabled = true
			var rol = randi() % 6;
			die.text = str(rol+1);
			diceVals[dice.find(die)] = str(rol+1);

			roll_daily.disabled = true;
		roll_daily_rolled = true;
	deciding_die();


	pass
	
func _which_option():
	if (you_rolled_higher == false):
		option1.disabled = false;
		option2.disabled = true;
	elif (you_rolled_higher == true):
		option1.disabled = true;
		option2.disabled = false;
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	

	pass
