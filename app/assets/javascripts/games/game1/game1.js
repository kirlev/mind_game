var squaresDimensions = 5;
var gameMapping = [];
var singleCubeWidth;
var singleCubeHeight;
var stage = null;
var playersLayer = null;
var fruitsLayer = null;
var optionsLayer = null;
var currentLevel = 0;
var selectedOne = false;
var imageResources = {};
var BoardLayer;
var BoxGroup;
var obstacles = [];
var fruitsLeft = 0;
var whereToMove = [];
var ratio = 0;
var repeats = 0;
var stepsCounter = 0;


window.onload = function() {	
	loadImages(function(images) {		
		imageResources = images;
		init(currentLevel, 0);
	});	
	$('.next').click(function(e){
		e.preventDefault();		
		if(levels[currentLevel + 1]) {
			$("#board").html('');
			init(currentLevel + 1, 0);
			checkLevels();
		}	
		else {
			return;
		}
	});
	$('.prev').click(function(e){
		e.preventDefault();
		if(levels[currentLevel - 1]) {
			$("#board").html('');
			init(currentLevel - 1, 0);
			checkLevels();
		}	
		else {
			return;
		}
	});
	$('.restart').click(function(e){
		e.preventDefault();
		$("#board").html('');
		init(currentLevel, 1);
		checkLevels();
	});
	$('.player').live('click', function(e){
		e.preventDefault();
		var player = document.getElementById('mainTheme');
		if(!$(this).hasClass('muted')) {
			player.pause();
			$(this).addClass('muted').html('<span></span>Play');
		}
		else {
			player.play();
			$(this).removeClass('muted').html('<span></span>Mute');
		}
	});
	$('nav a').click(function(e){
		var target = $(this).attr('href');
		$('body > section').removeClass('show');
		$(target).addClass('show');
		e.preventDefault();
	});
	$('.close').click(function(e){
		$('body > section').removeClass('show');
		e.preventDefault();
	});
	
	if(localStorage.getItem('firstTime') == null) {
		$('nav a[href="#howToPlay"]').trigger('click');
		localStorage.setItem('firstTime', false);
	}
	
};

function checkLevels() {
	if(levels[currentLevel + 1]) {
		$('.next').removeClass('disabled');
	}
	else {
		$('.next').addClass('disabled');
	}
	if(levels[currentLevel - 1]) {
		$('.prev').removeClass('disabled');
	}
	else {
		$('.prev').addClass('disabled');
	}
	// Update the level status text
	$('#levelStatus strong').text(currentLevel + 1);
	// Zero the steps info

	$('#steps strong').text(stepsCounter);
}

function loadImages(callback) {
	var images = {};
	var loadedImages = 0;
	var numItems = 0;	
	for(var name in characters) {		
		numItems++;	  		
	}
	for(var name in characters) {
		images[name] = new Image();
		images[name].onload = function() {
			if(++loadedImages >= numItems) {
				callback(images);
			}
		};
		if(characters[name].image) {
			images[name].src = characters[name].image;
		}
		else {
			numItems--;
		}
	}
}

function init(level, restartCounter) {
	gameMapping = [];
	stepsCounter = 0;
	if(restartCounter == 0) {
		repeats = 0;
		startTimer();
	}
	else {
		repeats++;
	}
	
	
	if(stage != null) {
		stage.clear();
	}
	
	$('#levelStatus span').text(levels.length).show();
	
	stage = new Kinetic.Stage({
		container: "board",
		width: 350,
		height: 350
	});
	
	BoardLayer = new Kinetic.Layer();
	BoxGroup = new Kinetic.Group();        
	
	singleCubeWidth = stage.getWidth() / squaresDimensions;
	singleCubeHeight = stage.getHeight() / squaresDimensions;
	
	var left = 0;
	var top = 0;
	
	for(i = 0; i < squaresDimensions; i++) {
		gameMapping[i] = [];
		obstacles[i] = [];
		for(x = 0; x < squaresDimensions; x++) {
			gameMapping[i][x] = false;
			var fill;
			if(i == Math.floor(squaresDimensions - 1) && x == Math.floor(squaresDimensions - 1)) {
				fill = {image: imageResources.exit, offset:[-9,-8]};
			}
			//
			else {
				fill = '#cccccc';
			}
			var box = new Kinetic.Rect({
			  x: left,
			  y: top,
			  width: singleCubeWidth,
			  height: singleCubeHeight,
			  name: 'square' + [i],
			  fill: fill,
			  stroke: "#999999",
			  strokeWidth: 3,
			  shadow: {
					color: '#fff',
					blur: 0,
					offset: [-3, -3],
					alpha: 0.8
				}
			});

			BoxGroup.add(box);
			left += singleCubeWidth;
		}
		left = 0;
		top += singleCubeHeight;
	}

	BoardLayer.add(BoxGroup);
	stage.add(BoardLayer);	
	createLevel(level);
}

function createLevel(level) {
	// Set the current level
	currentLevel = level;
	
	// Clear previus canvas levels
	if(playersLayer != null)
		playersLayer.clear();
	if(fruitsLayer != null)
		fruitsLayer.clear();
		
	fruitsLeft = 0;
		
	playersLayer = new Kinetic.Layer();
	fruitsLayer = new Kinetic.Layer();
	var fruitsGroup = new Kinetic.Group();
	var playersGroup = new Kinetic.Group();
	var levelData = levels[level];	
	
	for(i = 0; i < levelData.characters.length; i++) {		
		var cahracter = levelData.characters[i];
		var player = new Kinetic.Image({
			x: ((cahracter.position[0]) * singleCubeWidth) + ((singleCubeWidth - 46) / 2),
			y: ((cahracter.position[1]) * singleCubeHeight) + ((singleCubeHeight - 46) / 2),
			width: 46,
			height: 46,
			image: imageResources[cahracter.name],
			shadow: characters[cahracter.name].shadow,
			name: cahracter.name,
			position: [cahracter.position[0], cahracter.position[1]]
        });		
		if(cahracter.name == 'watermelon'){
			fruitsGroup.add(player);
			fruitsLeft++;
		}
		else{
			playersGroup.add(player);
			gameMapping[cahracter.position[0]][cahracter.position[1]] = true;
			if(cahracter.name == 'main'){
			SelectPlayer(player)
		}
		}
		
	}
	
	
	fruitsGroup.on('click tap', function(evt) {				
		// get the shape that was clicked on
		var shape = evt.shape;
		
		if(isValidFruitHit(shape)) {
			fruitsLeft--;
			fruitsGroup.remove(shape);
			//fruitsLayer.remove(shape);
		
			//put a new obstacle
			placeObstacle(shape.attrs.position[0], shape.attrs.position[1]);
			moveMain(evt.shape, level);
			fruitsLayer.draw();
		}
	});
	
	fruitsLayer.add(fruitsGroup);
	playersLayer.add(playersGroup);
	stage.add(playersLayer);
	stage.add(fruitsLayer);
	getOptions(level, selectedOne);
}

function getOptions(level, selected) {
	whereToMove = [];
	var selectedPosX = selected.attrs.position[0];
	var selectedPosY = selected.attrs.position[1];
	
	// Check where can it move	
	if(isValidPosition(selectedPosX, selectedPosY - 1) && gameMapping[selectedPosX][selectedPosY - 1] !== true){
		whereToMove['top'] = [selectedPosX, selectedPosY - 1];
	}
	else {
		whereToMove['top'] = false;
	}
	if(isValidPosition(selectedPosX, selectedPosY + 1) && gameMapping[selectedPosX][selectedPosY + 1] !== true){
		whereToMove['bottom'] = [selectedPosX, selectedPosY + 1];
	}
	else {
		whereToMove['bottom'] = false;
	}
	if(isValidPosition(selectedPosX - 1,selectedPosY) && gameMapping[selectedPosX - 1][selectedPosY] !== true){
		whereToMove['left'] = [selectedPosX - 1, selectedPosY];
	}
	else {
		whereToMove['left'] = false;
	}
	if(isValidPosition(selectedPosX + 1, selectedPosY) && gameMapping[selectedPosX + 1][selectedPosY] !== true){
		whereToMove['right'] = [selectedPosX + 1, selectedPosY];
	}
	else {
		whereToMove['right'] = false;
	}
	
	showOptions(level, whereToMove);
}

function showOptions(level, options) {
	if(optionsLayer != null) {
		clearOptions();
	}
	else {
		optionsLayer = new Kinetic.Layer();
	}
	var optionsGroup = new Kinetic.Group();
	for(var dir in options) {
		var optionPosition = options[dir];
		if(optionPosition) {
			var option = new Kinetic.Circle({
			  x: ((optionPosition[0]) * singleCubeWidth) + ((singleCubeWidth) / 2),
			  y: ((optionPosition[1]) * singleCubeHeight) + ((singleCubeHeight) / 2),	
			  radius: 20,
			  stroke: 'yellow',
			  strokeWidth: 8,
			  name: dir,
			  position: [optionPosition[0], optionPosition[1]]
			});		
			optionsGroup.add(option);
		}
	}
	
	optionsLayer.add(optionsGroup);
	stage.add(optionsLayer);
	fruitsLayer.moveUp();
	
	optionsLayer.off('click');
	optionsLayer.on('click tap', function(evt) {				
		// Get the shape that was clicked on
		var shape = evt.shape;
		moveMain(shape, level);
	});
	
	// Add cursor styling
	optionsLayer.on("mouseover", function(e) {
	  document.body.style.cursor = "pointer";
	});
	optionsLayer.on("mouseout", function(e) {
	  document.body.style.cursor = "default";
	});		
}

function checkWinning(selectedOne) {
	// Check for victory
	if(	
		selectedOne.getName() == 'main' && 
		selectedOne.attrs.position[0] === Math.floor(gameMapping.length - 1) && 
		selectedOne.attrs.position[1] === Math.floor(gameMapping.length - 1) && fruitsLeft === 0) 
	{			
		ratio = levels[currentLevel].steps / stepsCounter * 100;
		sendGameStats(repeats, ratio);
		
		window.setTimeout(function(){
			$('#levelInfo strong.level').text(currentLevel + 1);
			$('#levelInfo strong.step').text($('#steps strong').text());
			$('#levelInfo').fadeIn('fast');
		}, 2000);
		// Check if this is the last level
		if(levels[currentLevel + 1]) {
			window.setTimeout(function(){		
				$('.next').trigger('click');
				$('#levelInfo').fadeOut('fast');
			}, 5500);
		}
		else {
			$('#levelInfo h2').text('Praise the Queen!');
			$('#levelInfo h3').hide();
			$('<h3 id="finish">You have finished the game! <br />Hooray!!!</h3>').appendTo('#levelInfo');
			$('.prev').unbind('click').addClass('disabled');
			$('.restart').unbind('click');
		}
	}
}


function clearOptions() {
	optionsLayer.off('click');
	optionsLayer.clear();
	optionsLayer.removeChildren();
	optionsLayer.draw();
}

function SelectPlayer(player) {
	selectedOne = player;
}

function isValidPosition(x, y) {
	if (x > 4 || y > 4) {
		return false;	
	}
	if (x < 0 || y < 0) {
		return false;	
	}
	return true;
}

function placeObstacle(posX, posY){
	var obstacle = new Kinetic.Image({
			x: (posX * singleCubeWidth) + ((singleCubeWidth - 46) / 2),
			y: (posY * singleCubeHeight) + ((singleCubeHeight - 46) / 2),
			//stroke:  '#000',
			//strokeWidth: 4,
			width: 46,
			height: 46,
			image: imageResources['orange'],
			shadow: characters['orange'].shadow,
			name: 'orange',
			position: [posX, posY]
        });		
		playersLayer.add(obstacle);
		obstacles[posX][posY] = true;
}

function moveMain(shape, level) {
	if(selectedOne != false) {
						// Set the shadow and make the transition
			selectedOne.setShadow(characters.selected.shadow[shape.getName()]);
			selectedOne.transitionTo({
				//x: shape.attrs.position[0],
				//y: shape.attrs.position[1],	
				x: ((shape.attrs.position[0]) * singleCubeWidth) + ((singleCubeWidth - 46) / 2),
				y: ((shape.attrs.position[1]) * singleCubeHeight) + ((singleCubeHeight - 46) / 2),			
				duration: 0.5,
				callback: function() {
					checkWinning(selectedOne);
					selectedOne.setShadow(characters[selectedOne.getName()].shadow);
				}
			});			
			if(obstacles[selectedOne.attrs.position[0]][selectedOne.attrs.position[1]] !== true) {
				gameMapping[selectedOne.attrs.position[0]][selectedOne.attrs.position[1]] = false;
			}
			gameMapping[shape.attrs.position[0]][shape.attrs.position[1]] = true;
			// Set the selected one new attributes
			selectedOne.attrs.position = [shape.attrs.position[0], shape.attrs.position[1]];

			// Update the steps status
			stepsCounter++;
			$('#steps strong').text(stepsCounter);
		};			
			
		
		playersLayer.draw();
		clearOptions();
		
		//show options for next play
		getOptions(level, selectedOne);
}

function isValidFruitHit(shape) {
	var options = whereToMove;
	for(var dir in options) {
		var optionPosition = options[dir];
		if(optionPosition) {
			if(shape.attrs.position[0] === optionPosition[0] && shape.attrs.position[1] === optionPosition[1]) {
				return true;
			}
		}
	}
	return false;
}