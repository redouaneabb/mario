class Game {
  private Level _level;
  private Mario _mario;
  private PImage _fondImg,_fond_start, _marioIdle, _marioJump, _imgChampignon, _superMarioIdle, _superMarioJump;
  private PImage[] _marioWalk = new PImage[3];
  private PImage[] _superMarioWalk = new PImage[3];
  private float cameraX = 0;
  private boolean _pause = false;
  private ArrayList<Item> _items = new ArrayList<Item>();
  private ArrayList<Goomba> _goombas = new ArrayList<Goomba>();
  private ArrayList<Plant> _plants = new ArrayList<Plant>();
  ArrayList<PVector> pos_plants_start = new ArrayList<PVector>();

  Menu _btnReprendre, _btnSauvegarder, _btnQuitterPause, _btnPLay, _btnNiveaux;;
  private int niveauChoisi = 1;
  private Menu[] _btnLevels = new Menu[5];

  private boolean afficherNiveaux = false;

  public Game() {
    this._fondImg = loadImage("fond.jpg");
    this._fond_start = loadImage("fond_start.jpg");
    this._marioIdle = loadImage("mario_idle.png");
    this._marioJump = loadImage("mario_air.png");
    this._imgChampignon = loadImage("mushroom.png");
    this._marioWalk[0] = loadImage("mario_1.png");
    this._marioWalk[1] = loadImage("mario_2.png");
    this._marioWalk[2] = loadImage("mario_3.png");
    this._superMarioIdle = loadImage("gmario_idle.png");
    this._superMarioJump = loadImage("gmario_1.png");
    this._superMarioWalk[0] = loadImage("gmario_1.png");
    this._superMarioWalk[1] = loadImage("gmario_2.png");
    this._superMarioWalk[2] = loadImage("gmario_3.png");
    float cx = width/2 - 100;
    this._btnReprendre = new Menu((int)cx, height/2 - 60, 200, 40);
    this._btnQuitterPause = new Menu((int)cx, height/2 - 10, 200, 40);
    this._btnPLay = new Menu(50, 300, 200, 60);
    this._btnNiveaux = new Menu(50, 390, 200, 60);

    for (int i = 0; i < 5; i++) {
      this._btnLevels[i] = new Menu(320, 120 + i * 80, 180, 50);
    }
    this.chargerNiveau(this.niveauChoisi);
  }

  public void spawnItem(float x, float y) {
    this._items.add(new Item(x, y, this._imgChampignon));
  }
  
  public void update() {
    if (this._pause) return;        
    this._mario.update(this._level, this);
    
    for (Item it : this._items) {
      it.update(this._level);
      if (it.active) {
        boolean toucheX = this._mario._posX < it.x + TILE_SIZE && this._mario._posX + TILE_SIZE > it.x;
        boolean toucheY = this._mario._posY < it.y + TILE_SIZE && this._mario._posY + TILE_SIZE > it.y;
        
        if (toucheX && toucheY) {
          it.active = false; 
          score += 100;
          this._mario.devenirSuper(this._superMarioIdle, this._superMarioWalk, this._superMarioJump);
        }
      }
    }
    for (Plant p : _plants) {
      p.update();
      if (p.y > p.startY - 15) {
        continue; 
      }
      boolean toucheX = this._mario._posX < (p.x + TILE_SIZE - PLANT_MARGE_X) && (this._mario._posX + TILE_SIZE) > (p.x + PLANT_MARGE_X);
      boolean toucheY = this._mario._posY < (p.y + TILE_SIZE) && (this._mario._posY + TILE_SIZE) > (p.y + PLANT_MARGE_Y);

      if (toucheX && toucheY && p.active) {
        if (this._mario._invincibilite <= 0) {
          if (this._mario._isSuper) {
            this._mario.devenirPetit(this._marioIdle, this._marioWalk, this._marioJump);
            score -= 100;
          } 
          else {
            this._mario._posX = this._level.pos_mario_start.x;
            this._mario._posY = this._level.pos_mario_start.y;
            score = 0;
          }
        }
      }
    }
    for (Goomba g : this._goombas) {
      g.update(this._level);
      if (g.active) {
        boolean toucheX = this._mario._posX < g.x + TILE_SIZE && this._mario._posX + TILE_SIZE > g.x;
        boolean toucheY = this._mario._posY < g.y + TILE_SIZE && this._mario._posY + TILE_SIZE > g.y;
        
        if (toucheX && toucheY) {
          if (this._mario._vy > 0 && this._mario._posY < g.y) {
            g.active = false;
            this._mario._vy = JUMP_FORCE / 1.5;
            score += 150;
          }
          else {
            if (this._mario._invincibilite <= 0) {
              if (this._mario._isSuper) {
                this._mario.devenirPetit(this._marioIdle, this._marioWalk, this._marioJump);
                score -= 100;
              } 
              else {
                this._mario._posX = this._level.pos_mario_start.x;
                this._mario._posY = this._level.pos_mario_start.y;
                score = 0;
              }
            }
          }
        }
      }
    }
    if (this._level.pos_flag != null) {
       float topDrapeau = this._level.pos_flag.y - 360; 
       float basDrapeau = this._level.pos_flag.y + TILE_SIZE;
       
       boolean toucheX = this._mario._posX < this._level.pos_flag.x + TILE_SIZE && this._mario._posX + TILE_SIZE > this._level.pos_flag.x;
       boolean toucheY = this._mario._posY < basDrapeau && this._mario._posY + TILE_SIZE > topDrapeau;
       if (toucheX && toucheY) {
        score += 500;
         this.niveauChoisi++;
         if (this.niveauChoisi > 5) {
           current_mode = Mode.Win;
         }
         else {
           this.chargerNiveau(this.niveauChoisi);
         }
       }
     }
     if (score < 0) {
        score = 0;
     }
  }
  
  public void chargerNiveau(int numero) {
    niveauChoisi = numero;
    this._items.clear();
    this._goombas.clear();
    this._plants.clear();
    this._level = new Level("levels/mario_" + niveauChoisi + ".txt", 86, 15);
    this._mario = new Mario(this._level.pos_mario_start, this._marioIdle, this._marioWalk, this._marioJump);
    for (PVector p : this._level.pos_goombas_start) {
      this._goombas.add(new Goomba(p.x, p.y));
    }
    for (PVector p : this._level.pos_plants_start) {
      this._plants.add(new Plant(p.x, p.y));
    }
  }

  public void drawIt() {
    this.cameraX = this._mario._posX - 266;
    if (this.cameraX < 0) this.cameraX = 0;
    float finDuNiveau = (this._level._nbTilesX * TILE_SIZE) - width;
    if (this.cameraX > finDuNiveau) this.cameraX = finDuNiveau;

    pushMatrix();
    translate(-this.cameraX, 0);
    float startX = this.cameraX - (this.cameraX %width);
    image(this._fondImg, startX, 0,width, height);
    image(this._fondImg, startX +width, 0,width,height);
    for (Plant p : this._plants) p.drawIt();
    this._level.drawIt();
    for (Item it : this._items) it.drawIt();
    for (Goomba g : this._goombas) g.drawIt();
    this._mario.drawIt();
    popMatrix();

    fill(255);
    textSize(24);
    textAlign(LEFT); 
    text("Score: " +score, 40, 40);
    textAlign(RIGHT); 
    text("Niveau " + this.niveauChoisi + "/5", width - 40, 40);
    textAlign(LEFT);

    if (this._pause) this.afficherMenuPause();
  }
  
  public void handleKeyPressed(int k) {
    if (key == ESC) { key = 0; this._pause = !this._pause; return; }
    if (this._pause) return;
    if (k == CODED) {
      if (keyCode == LEFT) this._mario.setMove(-1);
      if (keyCode == RIGHT) this._mario.setMove(1);
      if (keyCode == UP) this._mario.jump();
    } else {
      if (k == 'q' || k == 'Q') this._mario.setMove(-1);
      if (k == 'd' || k == 'D') this._mario.setMove(1);
      if (k == 'z' || k == 'Z' || k == ' ') this._mario.jump();
    }
  }
  
  public void handleKeyReleased(int k) {
    if (k == CODED) { if (keyCode == LEFT || keyCode == RIGHT) this._mario.setMove(0); }
    else { if (k == 'q' || k == 'Q' || k == 'd' || k == 'D') this._mario.setMove(0); }
  }

  public void handleMouse() {
    if (this._pause) {
      if (this._btnReprendre.Presse()) this._pause = false;
      if (this._btnQuitterPause.Presse()) exit();
    }
  }
  
  public void afficherMenuPause() {
    fill(0, 180); rect(0, 0, width, height);
    textAlign(CENTER, CENTER); fill(255);
    text("PAUSE", width/2, height/2 - 180);
    this._btnReprendre.drawIt("Reprendre", 26, color(255, 0, 0));
    this._btnQuitterPause.drawIt("Quitter", 26, color(255, 0, 0));
  }
  
  public void drawMenu() {
    image(this._fond_start, 0, 0,width,height);
    fill(0, 120);
    rect(0, 0, 300,height);
  
    fill(255);
    textSize(38);
    textAlign(LEFT, CENTER);
    text("SUPER MARIO", 20, 120);
    this._btnPLay.drawIt("JOUER", 30, color(220, 40, 40));
    this._btnNiveaux.drawIt("NIVEAUX", 26, color(40, 40, 220));
    if (this.afficherNiveaux) {
      fill(0, 180);
      rect(280, 70, 260, 450);
      for (int i = 0; i < 5; i++) {
        this._btnLevels[i].drawIt("NIVEAU " + (i + 1), 22, color(50, 180, 50));
      }
    }
  }
}
