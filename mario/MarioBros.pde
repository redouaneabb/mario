import ddf.minim.*;

private Minim minim;
private AudioPlayer musique;
private PFont font;
private Game game;
private PImage winImg;

public void setup() {
  size(800, 600, P2D);
  this.game = new Game();
  this.font = createFont("Arial", 24);
  this.minim = new Minim(this);
  this.musique = minim.loadFile("musique.wav");
  this.musique.loop();
  this.winImg = loadImage("win.png");
}

public void draw() {
  if (current_mode == Mode.Menu) {
    this.game.drawMenu();
  } 
  else if (current_mode == Mode.Game) {
    this.game.update();
    this.game.drawIt();
    this.game.handleMouse();
  }
  else if (current_mode == Mode.Win) {
    background(114, 172, 243);
    imageMode(CENTER);
    image(winImg, width / 2, height / 2, winImg.width / 2, winImg.height / 2);
    imageMode(CORNER); 
    textAlign(CENTER, CENTER);
    fill(255);
    textSize(32);
    float scoreY = (height / 2) + (winImg.height / 4) + 40; 
    text("Score Final: " + score, width / 2, scoreY);
    textAlign(LEFT, BASELINE);
  }
}

public void keyPressed() {
  this.game.handleKeyPressed(key);
}
public void keyReleased() {
  this.game.handleKeyReleased(key);
}

public void mousePressed() {
  if (current_mode == Mode.Menu) {
    if (this.game._btnPLay.Presse()) {
      this.game = new Game();
      current_mode = Mode.Game;
    }
    if (this.game._btnNiveaux.Presse()) {
      this.game.afficherNiveaux = !this.game.afficherNiveaux;
    }
    if (this.game.afficherNiveaux) {
      for (int i = 0; i < 5; i++) {
        if (this.game._btnLevels[i].Presse()) {
          this.game.niveauChoisi = i + 1;
          this.game.chargerNiveau(this.game.niveauChoisi);
          current_mode = Mode.Game;
        }
      }
    }
  }
}
