class Copy {

  float x, y, textEnd, xLimit, xStart, yStart, yLimit; 
  int size;
  String text;
  PFont font;
  boolean textBox;

  Copy(String _Text, PFont _Font, float _x, float _y, int _size, float _xLimit, float _yLimit, boolean _textBox ) {
    text = _Text;
    font = _Font;
    x = _x;
    y = _y;
    size = _size;
    xStart = _x;
    yStart = _y-_size;
    xLimit = _xLimit;
    yLimit = _yLimit;
    textBox =_textBox;
  }

  void drawCopy() { 
    fill(255);
    textFont(font);
    textSize(size);
    if (textBox) {
      textLeading(size*1.2);
      text(text, xStart, y-size, xLimit, size*1.2*2);
    } 
    if (!textBox) {
      text(text, x, y);
    }
    //noFill();
    //stroke(0, 255, 0);  
    //rect(xStart, yStart, xLimit-x, yLimit-yStart);
  }
}