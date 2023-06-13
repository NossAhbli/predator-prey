abstract class Animal {
  int timeWellFed, x, y;
  float food;
  final float WELL_FED_PERCENT;
  final float MAX_FOOD;
  final float CONSUMPTION;
  final int BUDDING_TIME;
  
  Animal(int bt, float mf, float c, float wfp) {
    BUDDING_TIME = bt;
    MAX_FOOD = mf;
    CONSUMPTION = c;
    WELL_FED_PERCENT = wfp;
  }
  
  abstract color getColor();
  
  void update() {
    if((food -= CONSUMPTION) >= WELL_FED_PERCENT*MAX_FOOD) timeWellFed++;
    else timeWellFed = 0;
  }
  
  boolean canBud() {return timeWellFed >= BUDDING_TIME;}
}

class Sheep extends Animal {
  final static float WELL_FED_PERCENT = .8;
  final static float MAX_FOOD = 30;
  final static float CONSUMPTION = 3;
  final static int BUDDING_TIME = 25;
  
  Sheep(int x, int y, float f) {
    super(BUDDING_TIME, MAX_FOOD, CONSUMPTION, WELL_FED_PERCENT);
    this.x = x;
    this.y = y;
    food = f;
  }
  
  Sheep(int x, int y) {
    this(x, y, MAX_FOOD/2);
  }
  
  color getColor() {return color(240);}
  
  void update() {
    super.update();
    Grass loc = (Grass) map.land[x][y];
    if(loc.level >= MAX_FOOD - food) {
      loc.level -= MAX_FOOD - food;
      food = MAX_FOOD;
    } else {
      food += loc.level;
      loc.level = 0;
    }
    
    int dir = (int) random(0, 5);
    int right = 0, down = 0;
    
    switch(dir) {
      case 0: right = 1; break;
      case 1: down = 1; break;
      case 2: right = -1; break;
      case 3: down = -1; break;
    }
    
    if(map.cellFree(x + right, y + down) && !(map.land[x + right][y + down] instanceof Water)) {
      if(canBud()) {
        map.births.add(new Sheep(x, y, food/2));
        timeWellFed = 0;
        food /= 2;
      }
      
      map.land[x][y].leave();
      x += right;
      y += down;
      map.land[x][y].occupy(this);
    }
  }
}

class Wolf extends Animal {
  final static float WELL_FED_PERCENT = .5;
  final static float MAX_FOOD = 5;
  final static float CONSUMPTION = .01;
  final static int BUDDING_TIME = 20;
  
  Wolf(int x, int y, float f) {
    super(BUDDING_TIME, MAX_FOOD, CONSUMPTION, WELL_FED_PERCENT);
    this.x = x;
    this.y = y;
    food = f;
  }
  
  Wolf(int x, int y) {
    this(x, y, MAX_FOOD/2);
  }
  
  color getColor() {return color(50);}
  
  void update() {
    super.update();
    
    int dir = (int) random(0, 5);
    int right = 0, down = 0;
    
    switch(dir) {
      case 0: right = 1; break;
      case 1: down = 1; break;
      case 2: right = -1; break;
      case 3: down = -1; break;
    }
    
    Sheep sheepToEat = null;
    if(food < MAX_FOOD && map.cellValid(x + right, y + down) &&map.land[x + right][y + down].getOccupant() == Sheep.class) {
      for(Animal a : map.animals) {
        if(a instanceof Sheep && a.x == x + right && a.y == y + down) {
          sheepToEat = (Sheep) a;
          break;
        }
      }
    }
    
    if(sheepToEat != null || (map.cellFree(x + right, y + down) && !(map.land[x + right][y + down] instanceof Water))) {
      if(canBud()) {
        map.births.add(new Wolf(x, y, food/2));
        timeWellFed = 0;
        food /= 2;
      }
      
      if(sheepToEat != null) {
        food++;
        map.deaths.add(sheepToEat);
      }
      
      map.land[x][y].leave();
      x += right;
      y += down;
      map.land[x][y].occupy(this);
    }
  }
}