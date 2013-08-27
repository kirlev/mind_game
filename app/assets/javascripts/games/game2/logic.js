
var MINIMUM_MOVES = 20;
var NO_CARD = -1;
var FALSE = 0;
var TRUE = 1;
var tags = ["cat", "bird", "flower", "turtle", "monkey", "tree", "football", "dog"];
tags = tags.concat(tags);
var isMatch;
var firstCard = NO_CARD;
var twoCardsAreOpen;
var moves;
var allPairsWereFound;
var gameStarted;
var ratio = 0;
var repeats = 0;

function timeMinus() {
	if (allPairsWereFound == FALSE) {
		if (gameStarted == TRUE) {}
		else {
			gameStarted = TRUE;
		}
		//$("#display em").html(moves);
		var tidt = setTimeout('timeMinus()', 2000);
	}
}
function init() {

	if ($("#table").html() != "") {
		$("#table").fadeOut(function () {
			repeats++;
			$(this).html("");
			init();
		});
		return true;
	}

	//$("#display p").html("Points: <em>0</em>");

	startTimer();
	ratio = 0;
	firstCard = NO_CARD;
	twoCardsAreOpen = FALSE;
	moves = 0;
	allPairsWereFound = FALSE;
	gameStarted = FALSE;
	var keys = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
	for (i = 0; i < 16; i++) {
		k = Math.floor(Math.random() * keys.length);
		$("#table").append("<div><figure class='" + keys[k] + "'><p>&clubs;</p></figure></div>");
		keys.splice(k, 1);
	}
	$("#table").fadeIn();
	$("#table figure").click(function () {
		if (gameStarted == FALSE) {
			timeMinus();
		}
		if (twoCardsAreOpen == FALSE && !$(this).hasClass("open")) {
			$(this).animate({
				"width" : 0,
				"right" : "50%"
			}, 200, 'swing', function () {
				var cardValue = tags[$(this).attr("class")];
				$(this).html("<p class='" + cardValue + "_open" + "'>.</p>").addClass("open").parent().addClass(cardValue);
				$(this).animate({
					"width" : "2.15em",
					"right" : 0
				}, 200, 'swing', function () {
					if (firstCard == NO_CARD) { //this is the first card to be flipped
						firstCard = cardValue;
					} else {
						checkForMatch(cardValue);
					}
					moves++;
					//$("#display em").html(moves);
				});
			});
		}
	});
}
function chk() {}

function checkForMatch(cardValue) {
	twoCardsAreOpen = TRUE;
	isMatch = FALSE;
	if (firstCard == cardValue) { //match!
		isMatch = TRUE;
		$(".open").unbind("click").fadeOut(function () {
			$(this).removeClass("open").addClass("done").children().removeClass(cardValue + "_open");
			$(this).fadeIn();
			if ($(".done").size() == 16) { //all pairs were found
				allPairsWereFound = TRUE;
				//var pnts = $("#display em").text();
				//$("#display p").html("Contgratulations! Your ratio is: <em>" + Math.floor(MINIMUM_MOVES / moves * 100) + "</em>");
				//
				ratio = Math.floor(MINIMUM_MOVES / moves * 100);
				sendGameStats(repeats, ratio);
			} else {
				closeOpen();
			}
		});
	} else { //no match
		//do something
	}
	if (isMatch == FALSE) {
		var tid = setTimeout('closeOpen()', 1000);
	}
}

$(document).ready(function () {
	init();
});
function closeOpen() {
	twoCardsAreOpen = FALSE;
	firstCard = NO_CARD;
	if ($(".open").size() == 2) {
		$(".open").fadeOut(function () {
			$(this).removeClass("open").html("<p>&clubs;</p>").fadeIn().parent().removeClass();
		});
	}
}
