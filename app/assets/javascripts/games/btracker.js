var timeStart;

function sendGameStats(repeats, ratio, normalize) {
	var timeEnd = new Date().getTime();
	var totalTime = (timeEnd - timeStart) / 60000;
  if(typeof normalize === 'undefined') {
    totalTime = totalTime * 10;
  }

	var stats = {
 		"statistic":
  		{
   			"game_id": game,
   			"ratio": ratio,
   			"repeats": repeats,
   			"time": totalTime,
   			"user_id": user
  		}
	}

	//$.post("/statistics", stats);

  $.ajax({
    type: "POST", 
    url: "/statistics",
    data: stats,
    async: false
  });

}

function startTimer() {
	timeStart = new Date().getTime();
}

function getTimePassed() {
  var timeNow = new Date().getTime();
  var time = (timeNow - timeStart);
  return time;
}

function getMinutesPassed() {
  var time = getTimePassed() / 60000;
  return time;
}


