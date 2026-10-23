final int TILE_SIZE = 40; 
final float GRAVITY = 0.7;
final float JUMP_FORCE = -14.0;
int score = 0;
final float PLANT_MARGE_X = 8.0;
final float PLANT_MARGE_Y = 12.0;

enum Mode {
  Menu, Game, Win
}

enum TypeCell {
  EMPTY, GROUND, BRICK, QUESTION_BLOCK, PIPE, PIPEBODY, USED_BLOCK
}

Mode current_mode = Mode.Menu;
