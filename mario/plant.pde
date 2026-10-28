class Plant { 
  private float x, y, startY, angle = 0; 
  private PImage img; 
  private boolean active = true; 

  public Plant(float startX, float startY) { 
    this.x = startX + 10;
    this.startY = this.y = startY;
    this.img = loadImage("plant.png"); 
  } 

  public void update() { 
    if (!this.active) return; 
    angle += 0.02; 
    this.y = this.startY + min(0.0, -sin(angle) * TILE_SIZE); 
  } 

  public void drawIt() { 
    if (this.active) image(this.img, this.x, this.y, TILE_SIZE, TILE_SIZE); 
  } 
}
