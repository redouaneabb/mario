class Level {
  private TypeCell _cells[][];
  private int _nbTilesX, _nbTilesY;
  private PVector pos_mario_start;
  PImage _ground, _brick, _qBlock, _pipe, _pipeBody, _goomba;
  private ArrayList<PVector> pos_goombas_start = new ArrayList<PVector>();
  private ArrayList<PVector> pos_plants_start = new ArrayList<PVector>();
  PImage _plant;
  private PVector pos_flag;
  private PImage _flag;

  public Level(String filename, int nbX, int nbY) {
    this._nbTilesX = nbX;
    this._nbTilesY = nbY;
    this._cells = new TypeCell[nbY][nbX];
    this._ground = loadImage("ground.jpeg");
    this._brick = loadImage("brick.jpeg");
    this._qBlock = loadImage("question_block.jpeg");
    this._pipe = loadImage("pipe.png");
    this._pipeBody = loadImage("pipe_body.png");
    this._goomba = loadImage("goomba.png");
    this._plant = loadImage("plant.png");
    this._flag = loadImage("drapeau_mario.png");

    String[] lignes = loadStrings(filename);
    for(int i=0; i<lignes.length; i++){
      for(int j=0; j<lignes[i].length(); j++){
        char c = lignes[i].charAt(j);
        switch (c) {
          case 'X': this._cells[i][j] = TypeCell.GROUND; break;
          case 'B': this._cells[i][j] = TypeCell.BRICK; break;
          case '?': this._cells[i][j] = TypeCell.QUESTION_BLOCK; break;
          case 'P': this._cells[i][j] = TypeCell.PIPE; break;
          case 'A': this._cells[i][j] = TypeCell.PIPEBODY; break;
          case 'F':
            this._cells[i][j] = TypeCell.EMPTY;
            this.pos_flag = new PVector(j * TILE_SIZE, i * TILE_SIZE);
            break;
          case 'T':
            this._cells[i][j] = TypeCell.EMPTY; 
            this.pos_plants_start.add(new PVector(j * TILE_SIZE, (i + 1) * TILE_SIZE));
            break;
          case 'G': 
            this._cells[i][j] = TypeCell.EMPTY;
            this.pos_goombas_start.add(new PVector(j * TILE_SIZE, i * TILE_SIZE));
            break;
          case 'M': 
            this._cells[i][j] = TypeCell.EMPTY;
            this.pos_mario_start = new PVector(j * TILE_SIZE, i * TILE_SIZE);
            break;
          default:  this._cells[i][j] = TypeCell.EMPTY; break;
        }
      }
    }
  }

  void setCell(int i, int j, TypeCell type) {
    if (i >= 0 && i < this._nbTilesY && j >= 0 && j < this._nbTilesX) {
      this._cells[i][j] = type;
    }
  }

  void drawIt() {
    for(int i=0; i<this._nbTilesY; i++){
      for(int j=0; j<this._nbTilesX; j++){
        float x = j * TILE_SIZE;
        float y = i * TILE_SIZE;
        switch (this._cells[i][j]) {
          case GROUND: image(this._ground, x, y, TILE_SIZE, TILE_SIZE); break;
          case BRICK: image(this._brick, x, y, TILE_SIZE, TILE_SIZE); break;
          case QUESTION_BLOCK: image(this._qBlock, x, y, TILE_SIZE, TILE_SIZE); break;
          case PIPE: image(this._pipe, x, y, 60, TILE_SIZE); break;
          case PIPEBODY: image(this._pipeBody, x, y, 60, TILE_SIZE); break;
          case USED_BLOCK: 
            fill(120, 70, 30);
            rect(x, y, TILE_SIZE, TILE_SIZE); 
            break;
          case EMPTY: break;
        }
      }
    }
    float flagWidth = 80;
    float flagHeight = 400;
    float solY = this.pos_flag.y + TILE_SIZE;
    image(this._flag, this.pos_flag.x - 20, solY - flagHeight, flagWidth, flagHeight);
  }
}
