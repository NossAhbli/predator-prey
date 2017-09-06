abstract class Animal {
  int hunger, posX, posY;
  Land[][] map;
  
  Animal(Land[][] m) {
    map = m;
  }
  
  
  abstract boolean canEat();
  abstract void eat();
  abstract boolean canBud();
  abstract void bud();
}