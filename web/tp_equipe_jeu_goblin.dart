import 'dart:html';
import 'dart:math';
import 'dart:async';

CanvasElement canvas = document.query('#canvas');
CanvasRenderingContext2D context = canvas.getContext('2d');
Random random = new Random();
Goblin goblin;
Hero hero;
Obstacle obstacle;
var goblinsCaught = 0;



compteurGoblin(){ //compte les goblins tués 
  context.fillStyle = "rgb(250, 250, 250)";
  context.font = "24px Helvetica";
  context.textAlign = "left";
  context.textBaseline = "top";
  context.fillText("Goblins tués:  ${goblinsCaught}", 32, 32);
}

class Hero { //créer la classe héro
  int x = 256;
  int y = 240;
  int width = 75;
  int height = 65;
  ImageElement hero;

  Hero() {
    canvas.onMouseMove.listen((MouseEvent event) => update(event));
    hero = document.query('#hero_img');
  }

  update(MouseEvent event) {
    x = event.offset.x;
    y = event.offset.y;
    if (x <= (goblin.x + 32)
        && goblin.x <= (x + 32)
        && y <= (goblin.y + 32)
        && goblin.y <= (y + 32)) {
      ++goblinsCaught;
      reset();
    } 
    if (x <= (obstacle.x + 32)
        && obstacle.x <= (x + 32)
        && y <= (obstacle.y + 32)
        && obstacle.y <= (y + 32)) {
      --goblinsCaught;
      reset();
    }
  }

  draw() {
    context.drawImage(hero, x, y);
  }
}

class Goblin {   //créer la class goblin
  int x = 220;
  int y = 117;
  int width = 60;
  int height = 63;
  ImageElement goblin;

  Goblin() {
    goblin = document.query('#goblin_img');
  }

  move() {
    var xx = random.nextInt(canvas.width-32);
    var yy = random.nextInt(canvas.height-32);
      x = xx; y = yy;
  }

  draw() {
    context.drawImage(goblin, x, y);
  }
}

class Obstacle {   //créer la class Obstacle
  int x = 120;
  int y = 250;
  int width = 60;
  int height = 63;
  ImageElement obstacle;

  Obstacle() {
    obstacle = document.query('#obstacle_img'); 
  }

  move() {
    var xx = random.nextInt(canvas.width-32);
    var yy = random.nextInt(canvas.height-32);
      x = xx; y = yy;
  }

  draw() {
    context.drawImage(obstacle, x, y);
    context.drawImage(obstacle, goblin.x+150, goblin.y-95);
    context.drawImage(obstacle, goblin.x +45, goblin.y +45);
    context.drawImage(obstacle, goblin.x -45, goblin.y -45);
    context.drawImage(obstacle, goblin.x -150, goblin.y+95);
  }
}

reset(){
  hero.x = 256;
  hero.y = 240;
  goblin.move();
  obstacle.move();
}

draw() {
  context.clearRect(0, 0, canvas.width, canvas.height);
  hero.draw();
  goblin.draw();
  obstacle.draw();
}

void main() {
  query("#startButton").onClick.listen((event) => startGame());
  query("#restartButton").onClick.listen((event) => restartGame());
}

startGame(){   //démare le jeu lorsque la souris est déplacé sur le canvas
  hero = new Hero();
  goblin = new Goblin();
  obstacle = new Obstacle();
  context.clearRect(0, 0, canvas.width, canvas.height);
  canvas.onMouseMove.listen((e) => draw());
  canvas.onMouseMove.listen((e) => compteurGoblin());
  gameTimer();
}

gameTimer(){
  new Timer.periodic(const Duration(seconds: 5), (t) => restartGame());
  new Timer.periodic(const Duration(seconds: 5), (t) => window.alert('Vous avez attrapez: ${goblinsCaught} Goblins'));
}

restartGame(){  //redémarre le compteur du jeu
  reset();
  goblinsCaught = 0;
}
