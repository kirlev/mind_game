
var shapes = ["rectangle", "triangle", "circle"];
var colors = ["red", "blue", "yellow", "green"];
var cloneShapes;
var cloneColors;
var bigShapeCasted;
var smallShapeCasted;
var correctBigShapeCasted;
var correctSmallShapeCasted;
var correctAnswers = 0;
var reatio;
var repeats;


function init() {
	castShapeAndColor();
	drowCastedShape();
	drowChoices();
}

function castShapeAndColor() {
    cloneShapes = shapes.slice(0);
    cloneColors = colors.slice(0);
	bigShapeCasted = castShapeColor("_big_");
	smallShapeCasted = castShapeColor("_small_");
}

function drowCastedShape() {
	
	correctBigShapeCasted = bigShapeCasted;
	correctSmallShapeCasted = smallShapeCasted;
	$("#small_shape").addClass(correctSmallShapeCasted);
	$("#small_shape").css("background-image", "url(/assets/games/game3/" + correctSmallShapeCasted + ".png)");
	$("#big_shape").addClass(correctBigShapeCasted);
	$("#big_shape").css("background-image", "url(/assets/games/game3/" + correctBigShapeCasted + ".png)");;
}

function castShapeColor(size) {
	var result;
	var shapeCasted = cloneShapes[Math.floor(Math.random() * cloneShapes.length)];
	var colorCasted = cloneColors[Math.floor(Math.random() * cloneColors.length)];
	
	cloneShapes.splice($.inArray(shapeCasted, cloneShapes), 1);
    cloneColors.splice($.inArray(colorCasted, cloneColors), 1);
	
	result = shapeCasted.toString() + size + colorCasted.toString();
	
	return result
}

function drowChoices() {
	var keys = [0, 1, 2, 3];
	var choicesBigShapes = [];
	var choicesSmallShapes = [];
	
	choicesBigShapes.push(correctBigShapeCasted);
	choicesSmallShapes.push(correctSmallShapeCasted);

	for (var i = 0; i < 3; i++) {
		do {
			castShapeAndColor();
		} while (isAllreadyChosen(bigShapeCasted, smallShapeCasted, choicesBigShapes, choicesSmallShapes));
		
		choicesBigShapes.push(bigShapeCasted);
		choicesSmallShapes.push(smallShapeCasted);
	}
	
	for (var i = 0; i < 4; i++) {
		k = Math.floor(Math.random() * keys.length);
		$("#choices_table").append("<div class='choice choice_" + i + " " + choicesSmallShapes[keys[k]] + " " + choicesBigShapes[keys[k]] +"'></div>");
		$(".choice_" + i).css("background", "url(/assets/games/game3/" + choicesSmallShapes[keys[k]] + ".png) 50% 60% no-repeat, url(/assets/games/game3/" + choicesBigShapes[keys[k]] + ".png)");  
		keys.splice(k, 1);
	}
	
	$(".choice").click(function() {
			if( $(this).hasClass(correctBigShapeCasted) && $(this).hasClass(correctSmallShapeCasted) ) {
				winProcedure();
			} else {
				$(this).unbind("click").css("visibility", "hidden");
				$("#display ").html("<h4>Wrong! try again</h4>");
				setInterval(function(){
					$("#display h4").remove();
				}, 5000);
			}
	});
}


function winProcedure() {
	$("#small_shape").removeClass(correctSmallShapeCasted);
	$("#big_shape").removeClass(correctBigShapeCasted);
	$(".choice").remove();
	correctAnswers++;
	$("#display").html("<h3>points: " + correctAnswers + "</h3>");
	init();
}

$(document).ready(function () {
	init();
	startTimer();
});

$(window).unload(function() {
	minutesPassed = getMinutesPassed();
	if(minutesPassed > 0) {
		ratio = correctAnswers / minutesPassed;
		repeats = correctAnswers;
		sendGameStats(repeats, ratio, 1);
	}
});


function isAllreadyChosen(bigShapeCasted, smallShapeCasted, choicesBigShapes, choicesSmallShapes) {
	for (var i = 0; i < choicesSmallShapes.length; i++) {
		if( (bigShapeCasted == choicesBigShapes[i]) && (smallShapeCasted == choicesSmallShapes[i]) ) {
			return 1;
		}
	}
	return 0;
}


