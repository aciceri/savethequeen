PImage bg;
Quiz q;
Ufo u;

void setup() {
  size(640, 480);
  frameRate(60);
	/* @pjs preload="img/background.png"; */
	bg = loadImage("img/background.png");
  q = new Quiz();
  u = new Ufo("img/ufo/ufo_", 12);
  q.randomSentence();
}

void draw() {
  background(bg);
  u.move();
  u.display();
  q.display();
}

class Sentence {
  String part1, part2, solution, choice1, choice2, choice3;
  PFont f1;
  
  Sentence(String p1, String p2, String sol, String c1, String c2, String c3) {
    part1 = p1;
    part2 = p2;
    solution = sol;
    choice1 = c1;
    choice2 = c2;
    choice3 = c3;
    f1 = createFont("Arial", 20);
  }
  
  void display() {
    fill(0);
    stroke(255);
    textFont(f1);
    textAlign(CENTER);
    text(part1 + " ... " + part2, 0, height - 130, width, height - 132);
  }
}

class Button {
  String msg;
  int xpos, ypos, xsize, ysize;
  color normal, hover;
  PFont f2;
  
  Button(int x, int y, int xs, int ys, color norm, color hov) {
    xpos = x;
    ypos = y;
    xsize = xs;
    ysize = ys;
    normal = norm;
    hover = hov;
    f2 = createFont("Courier", 20);
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
    textFont(f2);
    textAlign(CENTER, CENTER);
    text(msg, xpos, ypos - 4, xsize, ysize);
  }
  
  void setText(String m) {
    msg = m;
  }
}

class Quiz {
  ArrayList<Sentence> list;
  Sentence actual_sentence;
  Button b1, b2, b3, b4;
  
  Quiz() {
    list = new ArrayList<Sentence>();
    b1 = new Button(10, height - 45, 300, 32, color(30), color(100));
    b2 = new Button(10, height - 87, 300, 32, color(30), color(100));
    b3 = new Button(width - 310, height - 45, 300, 32, color(30), color(100));
    b4 = new Button(width - 310, height - 87, 300, 32, color(30), color(100));
    // Sentences here
    list.add(new Sentence("The apple", "by John tomorrow", "will be eaten", "is eaten", "is being eaten", "are ate"));
    list.add(new Sentence("My mother", "", "had the curtains changed", "has the curtains changed", "has the curtains change", "had the curtains change"));
    list.add(new Sentence("I", "nice", "am", "be", "are", "to be"));
    list.add(new Sentence("Thomas", "now", "had the car whashed", "has the car whashed", "have the car whashed", "had the car whash"));
    list.add(new Sentence("I must", "", "will get my car fixed", "will get my car fix", "will have my car fixed", "get my car fixed"));
    list.add(new Sentence("She", " by Tom going to the supermarket.", "was seen", "was saw", "is seen", "had seen"));
    list.add(new Sentence("This program", "by Ciceri, Sala and Destefani two years ago", "has been developed", "was developed", "is developed", "will be developed"));
    list.add(new Sentence("There letters", "by Peter", " were given me", "was given me", "were given to me", "were give me"));
    list.add(new Sentence("Everybody", "", "wants to be loved", "will be loved", "wants to be love", "want to be loved"));
    list.add(new Sentence("The house", "by a lightning", "was hit", "is hit", "is being", "is hitten"));
  }
  
  void randomSentence() {
    randomSeed(millis());
    actual_sentence = list.get(int(random(0, list.size())));
    b1.setText(actual_sentence.solution);
    b2.setText(actual_sentence.choice1);
    b3.setText(actual_sentence.choice2);
    b4.setText(actual_sentence.choice3);
  }
  
  void display() {
    actual_sentence.display();
    b1.display();
    b2.display();
    b3.display();
    b4.display();
  }
}

class Ufo {
  PImage[] images;
  int xpos, imageCount, frame, padding, speed;
  boolean toRight;
  
  Ufo(String imagePrefix, int count) {
    imageCount = count;
    images = new PImage[imageCount];
    
    for(int i = 0; i < imageCount; i++) {
      String filename = imagePrefix + i + ".png";
      images[i] = loadImage(filename);
    }
    
    padding = 20;
    xpos = padding + 1;
    speed = 1;
    toRight = true;
  }
  
  void display() {
    frame = (frame + 1) % imageCount;
    image(images[frame], xpos, 15);
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
