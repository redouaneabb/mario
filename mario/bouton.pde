class Bouton {
  private int _x;
  private int _y;
  private int _width;
  private int _height;

  public Bouton(int x, int y, int width, int height) {
    this._x = x;
    this._y = y;
    this._width = width;
    this._height = height;
  }

  public boolean Presse() {
    return mousePressed &&
           mouseX >= this._x && mouseX <= this._x + this._width &&
           mouseY >= this._y && mouseY <= this._y + this._height;
  }

  public void drawIt(String text, int taillePolice, color couleur) {
    noStroke();
    fill(couleur);
    rect(this._x, this._y, this._width, this._height);

    fill(255);
    textAlign(CENTER, CENTER);
    textFont(font, taillePolice);
    text(text, this._x, this._y, this._width, this._height);
  }
}
