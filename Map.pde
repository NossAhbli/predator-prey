class Map {
  static final float LAKE_THRESH = .65;
  static final float FERTILITY_SCALAR = .15;
  static final int MAP_HEIGHT = 100;
  static final int MAP_WIDTH = 200;
  static final float NOISE_SCALE = .05;
  
  static final int SHEEP_NUM = 100;
  static final int WOLF_NUM = 40;
  
  
  Land[][] land;
  ArrayList<Animal> animals, deaths, births;
  
  Map() {
    land = new Land[MAP_WIDTH][MAP_HEIGHT];
    animals = new ArrayList<Animal>();
    deaths = new ArrayList<Animal>();
    births = new ArrayList<Animal>();
    
    for(int i = 0; i < MAP_WIDTH; i++) for (int j = 0; j < MAP_HEIGHT; j++) {
      float landValue = noise(i*NOISE_SCALE, j*NOISE_SCALE);
      if(landValue >= LAKE_THRESH) land[i][j] = new Water();
      else {
        land[i][j] = new Grass(landValue*FERTILITY_SCALAR);
        grass++;
      }
    }
    
    for(int i = 0; i < SHEEP_NUM; i++) {
      int x = (int) random(0, MAP_WIDTH + 1), y = (int) random(0, MAP_HEIGHT + 1);
      if(cellFree(x, y) && !(land[x][y] instanceof Water)) animals.add(new Sheep(x, y));
    }
    
    for(int i = 0; i < WOLF_NUM; i++) {
      int x = (int) random(0, MAP_WIDTH + 1), y = (int) random(0, MAP_HEIGHT + 1);
      if(cellFree(x, y) && !(land[x][y] instanceof Water)) animals.add(new Wolf(x, y));
    }
  }
  
  void update() {
    for(Animal a : animals) {
      a.update();
      if(a.food <= 0) deaths.add(a);
    }
    for(Animal a : deaths) land[a.x][a.y].leave();
    animals.removeAll(deaths);
    
    for(Animal a : births) land[a.x][a.y].occupy(a);
    animals.addAll(births);
    deaths.clear();
    births.clear();
    
    for(int i = 0; i < MAP_WIDTH; i++) for (int j = 0; j < MAP_HEIGHT; j++) land[i][j].update();
  }
  
  boolean cellFree(int x, int y) {
    //if(x < 0 || x >= MAP_WIDTH || y < 0 || y >= MAP_HEIGHT || land[x][y] instanceof Water) return false;
    //for(Animal a : animals) if(a.x == x && a.y == y) return false;
    //for(Animal a : births) if(a.x == x && a.y == y) return false;
    //return true;
    return x >= 0 && x < MAP_WIDTH && y >= 0 && y < MAP_HEIGHT && !land[x][y].isOccupied();
  }
  
  boolean cellValid(int x, int y) {
    return x >= 0 && x < MAP_WIDTH && y >= 0 && y < MAP_HEIGHT && !(land[x][y] instanceof Water);
  }
}