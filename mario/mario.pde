class Mario {
  private float _posX, _posY;
  private float _vx, _vy;
  private float _speed = 7;
  private boolean _isGrounded = false;
  private boolean _facingRight = true;
  private boolean _isSuper = false;
  private int _invincibilite = 0;

  private PImage _idleSprite;
  private PImage _jumpSprite;
  private PImage[] _walkSprites;
  private PImage _currentSprite;

  private int _frameIndex = 0;
  private int _animTimer = 0;
  private int _animSpeed = 4;
  
  public Mario(PVector startPos, PImage idle, PImage[] walk, PImage jump) {
    this._posX = startPos.x;
    this._posY = startPos.y;
    this._vx = 0;
    this._vy = 0;
    
    this._idleSprite = idle;
    this._walkSprites = walk;
    this._jumpSprite = jump;
    this._currentSprite = this._idleSprite;
  }
  
  public void update(Level level, Game game) {
    if (this._invincibilite > 0) {
      this._invincibilite--;
    }
    this._posX += this._vx;
    checkHorizontalCollisions(level);
    this._vy += GRAVITY;
    this._posY += this._vy;
    checkVerticalCollisions(level, game);
    if (this._posY > height) {
      this._posX = level.pos_mario_start.x;
      this._posY = level.pos_mario_start.y;
      this._vy = 0;
      score = 0;
    }
  }
  
  void checkHorizontalCollisions(Level level) {
    if (this._posX < 0) this._posX = 0;
    float limit = level._nbTilesX * TILE_SIZE - TILE_SIZE;
    if (this._posX > limit) this._posX = limit;

    int i_haut = int(this._posY / TILE_SIZE);
    int i_bas = int((this._posY + TILE_SIZE - 0.1) / TILE_SIZE);

    if (this._vx > 0) { // Vers la droite
      int j = int((this._posX + TILE_SIZE) / TILE_SIZE);
      if (isWall(level, i_haut, j) || isWall(level, i_bas, j)) {
        this._posX = j * TILE_SIZE - TILE_SIZE;
      }
    } 
    else if (this._vx < 0) { // Vers la gauche
      int j = int(this._posX / TILE_SIZE);
      if (isWall(level, i_haut, j) || isWall(level, i_bas, j)) {
        this._posX = (j + 1) * TILE_SIZE;
      }
    }
  }

  void checkVerticalCollisions(Level level, Game game) {
    int j_gauche = int(this._posX / TILE_SIZE);
    int j_droite = int((this._posX + TILE_SIZE - 0.1) / TILE_SIZE);
    
    if (this._vy > 0) {
      int i_bas = int((this._posY + TILE_SIZE) / TILE_SIZE);
      if (isWall(level, i_bas, j_gauche) || isWall(level, i_bas, j_droite)) {
        this._posY = i_bas * TILE_SIZE - TILE_SIZE;
        this._vy = 0;
        this._isGrounded = true;
      } 
      else {
        this._isGrounded = false;
      }
    } 
    else if (this._vy < 0) {
      int i_haut = int(this._posY / TILE_SIZE);
      if (isWall(level, i_haut, j_gauche) || isWall(level, i_haut, j_droite)) {
        this._posY = (i_haut + 1) * TILE_SIZE;
        this._vy = 0;
        TypeCell cellGauche = (i_haut >= 0 && j_gauche >= 0 && j_gauche < level._nbTilesX) ? level._cells[i_haut][j_gauche] : TypeCell.EMPTY;
        TypeCell cellDroite = (i_haut >= 0 && j_droite >= 0 && j_droite < level._nbTilesX) ? level._cells[i_haut][j_droite] : TypeCell.EMPTY;
        
        if (cellGauche == TypeCell.QUESTION_BLOCK) {
          level.setCell(i_haut, j_gauche, TypeCell.USED_BLOCK);
          game.spawnItem(j_gauche * TILE_SIZE, i_haut * TILE_SIZE);
          score += 50;
        } 
        else if (cellDroite == TypeCell.QUESTION_BLOCK) {
          level.setCell(i_haut, j_droite, TypeCell.USED_BLOCK);
          game.spawnItem(j_droite * TILE_SIZE, i_haut * TILE_SIZE);
          score += 50;
        }
      }
    }
  }

  private boolean isWall(Level level, int i, int j) {
    if (i < 0 || i >= level._nbTilesY || j < 0 || j >= level._nbTilesX) return false;
    return level._cells[i][j] != TypeCell.EMPTY;
  }
  
  private void jump() {
    if (this._isGrounded) {
      this._vy = JUMP_FORCE;
      this._isGrounded = false;
    }
  }
  
  private void setMove(float dirX) {
    this._vx = dirX * this._speed;
    if (dirX != 0) this._facingRight = (dirX > 0);
  }
  
  public void drawIt() {
    gererAnimation();
    pushMatrix(); 
    if (this._facingRight) {
      if (this._isSuper) image(this._currentSprite, this._posX, this._posY-10, 30, 50);
      else image(this._currentSprite, this._posX, this._posY, 30, 40); 
    } 
    else {
      translate(this._posX + 30, this._posY); 
      scale(-1, 1);
      if (this._isSuper) image(this._currentSprite, 0, -10, 30, 50); 
      else image(this._currentSprite, 0, 0, 30, 40);
    }
    popMatrix(); 
  }

  void gererAnimation() {
    if (!this._isGrounded) {
      this._currentSprite = this._jumpSprite;
    } 
    else if (this._vx == 0) {
      this._currentSprite = this._idleSprite;
      this._frameIndex = 0;
    } 
    else {
      this._animTimer++;
      if (this._animTimer >= this._animSpeed) {
        this._animTimer = 0;
        this._frameIndex = (this._frameIndex + 1) % this._walkSprites.length;
      }
      this._currentSprite = this._walkSprites[this._frameIndex];
    }
  }

  void devenirSuper(PImage idle, PImage[] walk, PImage jump) {
    if (!this._isSuper) {
      this._isSuper = true;
      this._idleSprite = idle;
      this._walkSprites = walk;
      this._jumpSprite = jump;
      this._currentSprite = this._idleSprite;
    }
  }

  void devenirPetit(PImage idle, PImage[] walk, PImage jump) {
    if (this._isSuper) {
      this._isSuper = false;
      this._idleSprite = idle;
      this._walkSprites = walk;
      this._jumpSprite = jump;
      this._currentSprite = this._idleSprite;
      this._invincibilite = 120;
    }
  }
}
