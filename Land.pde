abstract class Land {
  private Class<? extends Animal> occupant;
  
  void occupy(Animal a) {occupant = a.getClass();}
  void leave() {occupant = null;}
  boolean isOccupied() {return occupant != null;}
  Class<? extends Animal> getOccupant() {return occupant;}
  
  abstract color getColor();
  void update() {}
}

class Grass extends Land {
  float level = 0, fertility;
  static final int MAX_LEVEL = 100;
  
  Grass(float f) {
    fertility = f;
    level = random(fertility/Map.FERTILITY_SCALAR)*MAX_LEVEL;
  }
  
  color getColor() {
    return color(100 - level, 100 + level, 0);
  }
  
  @Override
  void update() {
    if(level < MAX_LEVEL) {
      level += fertility;
    }
  }
}

class Water extends Land {
  color getColor() {
    return color(0, 0, 255);
  }
}