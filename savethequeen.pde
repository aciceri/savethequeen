import ddf.minim.*; //Not needed in Processing JS
/* @pjs preload="img/background.png, img/splashscreen.png; */

Minim minim; //For audio
AudioPlayer music;

Splashscreen ss; //For starting background image
Background bg; //For background(and some sprites)
Ufo ufo;
Quiz quiz;

void setup() {
  size(640, 480);
  frameRate(60);
  
  minim = new Minim(this); //For audio
  music = minim.loadFile("snd/music.mp3"); //Background music
  music.play(); //Starts at the beginning
  
  ss = new Splashscreen();
  bg = new Background();
  ufo = new Ufo(0, 1, 20, 15);
  quiz = new Quiz(minim.loadFile("snd/correct.mp3"), minim.loadFile("snd/wrong.mp3"));
  
  quiz.randomSentence();
}

void draw() {
  if(ss.enable)
    ss.display();
  else {
    if(!quiz.loseVar) {
      bg.display();
      ufo.move();
      ufo.display();
      quiz.display();
    }
    else {
      music.pause();
      quiz.gameOver();
    }
  }
}

void mousePressed() {
  if(!ss.enable && !quiz.loseVar) quiz.clicked();
  if(ss.enable) ss.enable = false;
}

class Sentence {
  String part1, part2, solution, choice1, choice2, choice3;
  PFont sentenceFont;
  
  Sentence(String p1, String p2, String sol, String c1, String c2, String c3) {
    part1 = p1;
    part2 = p2;
    solution = sol;
    choice1 = c1;
    choice2 = c2;
    choice3 = c3;
    
    sentenceFont = createFont("font/dejavu.ttf", 22);
  }
  
  void display() {
    fill(0);
    stroke(255);
    textFont(sentenceFont);
    textAlign(CENTER);
    text(part1 + " ... " + part2, 0, height - 130, width, height - 132);
  }
}

class Button {
  String msg;
  int xpos, ypos, xsize, ysize;
  boolean correct;
  color normal, hover;
  PFont buttonFont;
  
  Button(int x, int y, int xs, int ys, color norm, color hov) {
    xpos = x;
    ypos = y;
    xsize = xs;
    ysize = ys;
    normal = norm;
    hover = hov;
    
    buttonFont = createFont("font/dejavu.ttf", 20);
  }
  
  void display() {
    if(mouseX >= xpos && mouseX <= (xpos + xsize) && mouseY >= ypos && mouseY <= (ypos + ysize)) {
      fill(hover);
    }
    else {
      fill(normal);
    }
    stroke(0);
    rect(xpos, ypos, xsize, ysize, 10);
    fill(255);
    
    textFont(buttonFont);
    textAlign(CENTER, CENTER);
    text(msg, xpos, ypos - 4, xsize, ysize);
  }
  
  void setAnswer(String m, boolean c) {
    msg = m;
    correct = c;
  }
  
  boolean isClicked() {
    if(mouseX >= xpos && mouseX <= (xpos + xsize) && mouseY >= ypos && mouseY <= (ypos + ysize))
      return true;
    else
      return false;
  }
  
  boolean isCorrect() {
    if(correct)
      return true;
    else
      return false;
  }
}

class Quiz {
  int score;
  boolean loseVar;
  AudioPlayer correct_sound, wrong_sound;
  PFont gameOverFont;
  ArrayList<Sentence> list;
  Sentence actual_sentence;
  Button b1, b2, b3, b4;
  
  Quiz(AudioPlayer cs, AudioPlayer ws) {
    score = 0;
    boolean loseVar = false;
    
    correct_sound = cs;
    wrong_sound = ws;
    
    gameOverFont = createFont("font/dejavu.ttf", 24);
    
    b1 = new Button(10, height - 45, 300, 32, color(30), color(100));
    b2 = new Button(10, height - 87, 300, 32, color(30), color(100));
    b3 = new Button(width - 310, height - 45, 300, 32, color(30), color(100));
    b4 = new Button(width - 310, height - 87, 300, 32, color(30), color(100));
   
    list = new ArrayList<Sentence>();
    
    // Sentences here
    list.add(new Sentence("The apple", "by John tomorrow", "will be eaten", "is eaten", "is being eaten", "are ate"));
    list.add(new Sentence("My mother", "", "had the curtains changed", "has the curtains changed", "has the curtains change", "had the curtains change"));
    list.add(new Sentence("I", "nice", "am", "be", "are", "to be"));
    list.add(new Sentence("Thomas", "now", "had the car washed", "has the car washed", "have the car washed", "had the car wash"));
    list.add(new Sentence("I must", "", "will get my car fixed", "will get my car fix", "will have my car fixed", "get my car fixed"));
    list.add(new Sentence("She", " by Tom going to the supermarket.", "was seen", "was saw", "is seen", "had seen"));
    list.add(new Sentence("This program", "two years ago", "has been developed", "was developed", "is developed", "will be developed"));
    list.add(new Sentence("There letters", "by Peter", " were given me", "was given me", "were given to me", "were give me"));
    list.add(new Sentence("Everybody", "", "wants to be loved", "will be loved", "wants to be love", "want to be loved"));
    list.add(new Sentence("The house", "by a lightning", "was hit", "is hit", "is being", "is hitten"));
  }
  
  void randomSentence() {
    //randomSeed();
    actual_sentence = list.get(int(random(0, list.size())));
    switch(int(random(0, 4))) {
      case 0:
        b1.setAnswer(actual_sentence.solution, true);
        b2.setAnswer(actual_sentence.choice1, false);
        b3.setAnswer(actual_sentence.choice2, false);
        b4.setAnswer(actual_sentence.choice3, false);
        break;
      case 1:
        b1.setAnswer(actual_sentence.choice2, false);
        b2.setAnswer(actual_sentence.solution, true);
        b3.setAnswer(actual_sentence.choice2, false);
        b4.setAnswer(actual_sentence.choice3, false);
        break;
      case 2:
        b1.setAnswer(actual_sentence.choice2, false);
        b2.setAnswer(actual_sentence.choice1, false);
        b3.setAnswer(actual_sentence.solution, true);
        b4.setAnswer(actual_sentence.choice3, false);
        break;
      case 3:
        b1.setAnswer(actual_sentence.choice3, false);
        b2.setAnswer(actual_sentence.choice1, false);
        b3.setAnswer(actual_sentence.choice2, false);
        b4.setAnswer(actual_sentence.solution, true);
        break;
    }
  }
  
  void clicked() {
    if(b1.isClicked())
      if(b1.isCorrect())
        this.win();
      else
        this.lose();
    else if(b2.isClicked())
      if(b2.isCorrect())
        this.win();
      else
        this.lose();
    else if(b3.isClicked())
      if(b3.isCorrect())
        this.win();
      else
        this.lose();
    else if(b4.isClicked())
      if(b4.isCorrect())
        this.win();
      else
        this.lose();
  }
    
  void win() {
    correct_sound.rewind();
    correct_sound.play();
    this.randomSentence();
    score++;
  }
  
  void lose() {
    wrong_sound.play();
    loseVar = true;
  }
  
  void gameOver() {
    background(0);
    fill(255);
    textFont(gameOverFont);
    textAlign(CENTER, CENTER);
    text("You lose\nYour score is " + this.score + "\nReload the page to try again...", 0, 0, width, height);
  }
  
  void display() {
    actual_sentence.display();
    b1.display();
    b2.display();
    b3.display();
    b4.display();
  }
}

class Splashscreen {
  boolean enable = true;
  PImage splashscreen_img;
  PFont splashscreenFont;
  
  Splashscreen() {
    splashscreen_img = loadImage("img/splashscreen.png");
    splashscreenFont = createFont("font/dejavu.ttf", 20);
  }
  
  void display() {
    if(enable) {
      background(splashscreen_img);
      fill(255);
      textFont(splashscreenFont);
      text("Aliens are attacking London because they hate English.\nYour goal is to save the queen.\nTo do this, click on the correct answer.\n\nClick on the screen to start...", 20, 20, width, height);
    }
  }
}

class Background {
  PImage background_img;
  Soldier soldier;
  Alien alien;
  
  Background() {
    background_img = loadImage("img/background.png");
    soldier = new Soldier(10, 1, width + 20, height - 200);
    alien = new Alien(10, 1, width + 80, height - 215);
  }
  
  void display() {
    background(background_img);
    soldier.move();
    alien.move();
    soldier.display();
    alien.display();
  }
}

class Sprite { //Abstract class for any sprite
  PImage[] images;
  int imageCount, frame, fps, i, j;
  float xpos, ypos, speed;
  
  Sprite(String imagePrefix, int count, int f, float s, float x, float y) {
    imageCount = count;
    images = new PImage[imageCount];
    
    for(int i = 0; i < imageCount; i++) {
      String filename = imagePrefix + i + ".png";
      
      images[i] = loadImage(filename);
    }
    
    xpos = x;
    ypos = y;
    speed = s;
    fps = f; //How many frame is a single sprite image
    i = 0;
    j = 0;
  }
  
  void display() {
    if(j == fps + 1) {
      i++;
      j=0;
    }
    else j++;
    if(i == imageCount) i = 0;

    image(images[i], xpos, ypos);
  }
}

class Ufo extends Sprite {
  boolean toRight = true;
  int padding = 20;
  
  Ufo(int f, float s, float x, float y) {
    super("img/ufo/ufo_", 12, f, s, x, y);
  }
  
  void move() {
    if(toRight) {
      xpos += speed;
      if(xpos >= width - 53 - padding) toRight = false; //53 is image width
    }
    else {
      xpos -= speed;
      if(xpos <= padding) toRight = true;
    }
  }
}

class Soldier extends Sprite {
  
  Soldier(int f, float s, float x, float y) {
    super("img/soldier/soldier_", 6, f, s, x, y);
  }
  
  void move() {
    xpos -= speed;
    if(xpos <= -100) xpos = width;
  }
}

class Alien extends Sprite {
  
  Alien(int f, float s, float x, float y) {
    super("img/alien/alien_", 6, f, s, x, y);
  }
  
  void move() {
    xpos -= speed;
    if(xpos <= - 100) xpos = width;
  }
}
