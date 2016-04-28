# Pacman #

Pacman AI for [botzone.org](http://www.botzone.org)

Homework of Practice on Programming

## Progress ##

Game simulation is finished

Simple greedy, evaluation is still unfinished

Offline judge is finished, base on simulation

## Build ##

`npm install` to install dependencies first

`gulp coffee`, or `gulp watch` to build automatically

## How to Use Built-in Judge ##

Build first

Check `scripts/config.js` to config for the game:

- `exports.game`: the initial setting
- `exports.scripts`: the scripts for four players

`node scripts/judge.js` to start the judge

Commands:

- `n`: next turn
- `a`: run automatically, `ctrl-c` to break
- `p`: print current map
- `q`: quit

## Author ##

Tiny Tiny
