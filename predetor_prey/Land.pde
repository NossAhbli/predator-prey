abstract class Land {
  abstract color getColor();
  void update(int data) {};
}

class Grass extends Land {
  int level;
  color getColor() {
    return color(level*10, 255 - level*10, 0);
  }
  
  @Override
  void update(int data) {
    
  }
}

class Water extends Land {
  color getColor() {
    return color(0, 0, 255);
  }
}