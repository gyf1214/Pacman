require('../bin/lib.min');

var readline = require("readline")
  .createInterface({
    input: process.stdin,
    output: process.stdout
  }),
  fs = require("fs"),
  append = fs.appendFileSync,
  util = require("util"),
  logPath = "tmp/judge.log",
  exec = require("child_process").exec,
  loop = true,
  wait = true,
  inputs = [],
  config = require("./config"),
  scripts = config.scripts,
  game = global.game(config.game, null, 0),
  last = "n";

var print = function () {
  var data = game.getData(),
    info = game.getInfo(),
    width = info.consts.width,
    height = info.consts.height,
    statics = info.statics,
    contents = data.contents,
    i, j, k;

  console.log("Turn %d:", info.turn);
  console.log("Next Generate: %d", data.nextGenerate);
  for (i = 0; i < 4; ++i) {
    var p = data.players[i];
    console.log("[Player %d @(%d, %d) | strength: %d | duration: %d | %s]",
      i, p.i, p.j, p.strength, p.duration, p.dead ? "dead" : "alive");
  }

  var line = "  ";
  for (j = 0; j < width; ++j) line += "  " + j + " ";
  console.log(line);

  for (i = 0; i < height; ++i) {
    line = "  ";
    for (j = 0; j < width; ++j) {
      line += " " + ((statics[i][j] & mask.wall(0)) ? "---" : "   ");
    }
    console.log(line);

    line = i + " ";
    for (j = 0; j < width; ++j) {
      line += ((statics[i][j] & mask.wall(3)) ? "|" : " ") + " ";
      var player = -1;
      for (k = 0; k < 4; ++k) {
        if (contents[i][j] & mask.player(k)) player = (player == -1) ? k : 4;
      }
      if (player == 4) line += "*";
      else if (player != -1) line += player;
      else if (statics[i][j] & mask.generator) line += "G";
      else if (contents[i][j] & mask.small) line += ".";
      else if (contents[i][j] & mask.large) line += "O";
      else line += " ";
      line += " ";
    }
    line += (statics[i][width - 1] & mask.wall(1)) ? "|" : " ";
    console.log(line);
  }
  line = "  ";
  for (j = 0; j < width; ++j) {
    line += " " + ((statics[height - 1][j] & mask.wall(2)) ? "---" : "   ");
  }
  console.log(line);
}

var debug = function (data) {
  if (data === undefined || data === null) data = "";
  if (util.isString(data) || util.isBuffer(data)) {
    append(logPath, data);
  } else {
    append(logPath, JSON.stringify(data));
  }
  append(logPath, "\n");
}

var nextTurn = function() {
  var finished = 0;
  var responses = {};
  var turn = game.getInfo().turn;

  debug("turn " + turn + ":");
  debug();

  debug("last game: ")
  debug(JSON.stringify(game.getData()));
  debug();

  for (var i = 0; i < 4; ++i) {
    if (!game.getData().players[i].dead) {
      (function (i) {
        var child = exec(scripts[i], function (err, stdout, stderr) {
          process.stderr.write(stderr);
          if (err !== null) {
            console.log("error for player %d in turn %d!", i, turn);
            readline.close();
          } else {
            ++finished;
            var out = JSON.parse(stdout);
            debug("player " + i + " output:");
            debug(out);
            debug();
            responses[i] = out.response;
            if (out.data !== undefined || out.data !== null) inputs[i].data = out.data
            inputs[i].responses.push(out.response);
            if (finished == 4) {
              for (var _ = 0; _ < 4; ++_) inputs[_].requests.push(responses);
              loop = !game.nextTurn(responses);
              print();
              if (wait) {
                readline.question('? ', answer);
              } else if (loop) {
                nextTurn(wait);
              } else {
                readline.close();
              }
            }
          }
        });
        debug("player " + i + " input:");
        debug(inputs[i]);
        debug();
        child.stdin.write(JSON.stringify(inputs[i]));
        child.stdin.end();
      })(i);
    } else ++finished;
  }
}

var popState = function () {
  game.popState();
  print();
}

var answer = function(r) {
  if (r === "") r = last;
  if (r === "n") {
    wait = true;
    nextTurn();
  } else if (r === "p") {
    print();
    readline.question('? ', answer);
  } else if (r === "a") {
    wait = false;
    nextTurn();
  } else if (r === "q") {
    readline.close();
  } else if (r === "l") {
    popState();
    readline.question('? ', answer);
  } else {
    console.log("negative input!");
    readline.question('? ', answer);
  }
  last = r;
}

if (fs.existsSync(logPath)) {
  fs.unlinkSync(logPath);
}
debug("test case: " + new Date(Date.now()));
debug();
debug("config:");
debug(config);
debug();
print();

for (var i = 0; i < 4; ++i) {
  x = JSON.parse(JSON.stringify(config.game));
  x.id = i;
  inputs[i] = { requests: [x], responses: [] };
}

readline.on('close', function () {
  console.log("");
  loop = false;
});
readline.on('SIGINT', function () {
  if (!wait) {
    wait = true;
  } else {
    readline.close();
  }
});
readline.question('? ', answer);
