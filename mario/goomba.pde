class Goomba {
  private float x, y;
  private float vx = -2;
  private float vy = 0;
  private PImage img;
  private boolean active = true;

  public Goomba(float startX, float startY) {
    this.x = startX;
    this.y = startY;
    this.img = loadImage("goomba.png");
  }

  public void update(Level level) {
    if (!active) return;
    this.x += this.vx;
    this.checkHorizontalCollisions(level);
    this.vy += GRAVITY;
    this.y += this.vy;
    this.checkVerticalCollisions(level);
    if (this.y > height) this.active = false;
  }

  private void checkHorizontalCollisions(Level level) {
    if (this.x < 0) { this.x = 0; this.vx *= -1; }
    float limit = level._nbTilesX * TILE_SIZE - TILE_SIZE;
    if (this.x > limit) { this.x = limit; this.vx *= -1; }

    int i_haut = int(this.y / TILE_SIZE);
    int i_bas = int((this.y + TILE_SIZE - 0.1) / TILE_SIZE); 

    if (this.vx > 0) { 
      int j_droite = int((this.x + TILE_SIZE) / TILE_SIZE);
      if (this.isWall(level, i_haut, j_droite) || this.isWall(level, i_bas, j_droite)) {
        this.x = j_droite * TILE_SIZE - TILE_SIZE;
        this.vx *= -1;
      }
    } 
    else if (this.vx < 0) {
      int j_gauche = int(this.x / TILE_SIZE);
      if (this.isWall(level, i_haut, j_gauche) || this.isWall(level, i_bas, j_gauche)) {
        this.x = (j_gauche + 1) * TILE_SIZE;
        this.vx *= -1;
      }
    }
  }

  private void checkVerticalCollisions(Level level) {
    int j_gauche = int(this.x / TILE_SIZE);
    int j_droite = int((this.x + TILE_SIZE - 0.1) / TILE_SIZE);
    
    if (this.vy > 0) {
      int i_bas = int((this.y + TILE_SIZE) / TILE_SIZE); 
      if (this.isWall(level, i_bas, j_gauche) || this.isWall(level, i_bas, j_droite)) {
        this.y = i_bas * TILE_SIZE - TILE_SIZE;
        this.vy = 0; 
      }
    }
  }

  private boolean isWall(Level level, int i, int j) {
    if (i < 0 || i >= level._nbTilesY || j < 0 || j >= level._nbTilesX) return false;
    return level._cells[i][j] != TypeCell.EMPTY;
  }

  public void drawIt() {
    if (this.active && this.img != null) {
      image(this.img, this.x, this.y, TILE_SIZE, TILE_SIZE);
    }
  }
}