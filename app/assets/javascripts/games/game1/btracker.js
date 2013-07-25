var timeStart;

function sendGameStats(repeats, ratio) {
	var timeEnd = new Date().getTime();
	var totalTime = (timeEnd - timeStart) / 60000;
  var normalizedRatio = ratio * 100;
  var normalizedTotalTime = totalTime * 10;

	var stats = {
 		"statistic":
  		{
   			"game_id": game,
   			"ratio": normalizedRatio,
   			"repeats": repeats,
   			"time": normalizedTotalTime,
   			"user_id": user
  		}
	}

	$.post("http://localhost:3000/statistics?callback=?", stats);

}

function startTimer() {
	timeStart = new Date().getTime();
}