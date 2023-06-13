private final int CELL_SIZE = 6;
private final int INFO_BAR_HEIGHT = 250;
private final int INFO_BAR_WIDTH = 1350;
private final float GRAPH_WIDTH = 375;
private final float GRAPH_HEIGHT = 175;
private final int GRAPH_INFO_LENGTH = 600;
private final int GRAPH_TICK = 5;

int grass = 0;
int graphTickTimer = 0;
DynamicGraph grassGraph, sheepGraph, wolvesGraph;
PFont scaleFont;

Map map;
float indent;

private float SGXpos, WGXpos, GGXpos, GYpos;

void setup() {
  surface.setSize((Map.MAP_WIDTH*CELL_SIZE) > INFO_BAR_WIDTH? Map.MAP_WIDTH*CELL_SIZE : INFO_BAR_WIDTH, Map.MAP_HEIGHT*CELL_SIZE + INFO_BAR_HEIGHT);
  frameRate(60);
  background(100);
  
  scaleFont = createFont("Arial", 10);
  textFont(scaleFont);
  textAlign(RIGHT, CENTER);
  
  indent = (width - Map.MAP_WIDTH*CELL_SIZE)/2;
  map = new Map();
  
  GGXpos = (INFO_BAR_WIDTH/3 - GRAPH_WIDTH)/2;
  SGXpos = GGXpos + INFO_BAR_WIDTH/3;
  WGXpos = SGXpos + INFO_BAR_WIDTH/3;
  GYpos = (INFO_BAR_HEIGHT - GRAPH_HEIGHT)/2 + height - INFO_BAR_HEIGHT;
  
  grassGraph = new DynamicGraph(GGXpos, GYpos, GRAPH_WIDTH, GRAPH_HEIGHT, GRAPH_INFO_LENGTH, color(0, 255, 0));
  sheepGraph = new DynamicGraph(SGXpos, GYpos, GRAPH_WIDTH, GRAPH_HEIGHT, GRAPH_INFO_LENGTH, color(255));
  wolvesGraph = new DynamicGraph(WGXpos, GYpos, GRAPH_WIDTH, GRAPH_HEIGHT, GRAPH_INFO_LENGTH, color(50));
}

void draw() {
  map.update();
  noStroke();
  
  for(int i = 0; i < Map.MAP_WIDTH; i++) for (int j = 0; j < Map.MAP_HEIGHT; j++) {
    fill(map.land[i][j].getColor());
    rect(i*CELL_SIZE + indent, j*CELL_SIZE, CELL_SIZE, CELL_SIZE);
  }
  
  for(Animal a : map.animals) {
    fill(a.getColor());
    rect(a.x*CELL_SIZE + indent, a.y*CELL_SIZE, CELL_SIZE, CELL_SIZE);
  }
  
  //graph update
  if(graphTickTimer++ == GRAPH_TICK) {
    graphTickTimer = 0;
    
    float grassLevel = 0;
    for(int i = 0; i < Map.MAP_WIDTH; i++) for (int j = 0; j < Map.MAP_HEIGHT; j++) if(map.land[i][j] instanceof Grass) grassLevel += ((Grass) map.land[i][j]).level;
    grassLevel /= grass;
    
    int sheep = 0, wolves = 0;
    for(Animal a : map.animals) {
      if(a instanceof Sheep) sheep++;
      else if(a instanceof Wolf) wolves++;
    }
    
    fill(100);
    noStroke();
    rect(0, height - INFO_BAR_HEIGHT + 1, width, INFO_BAR_HEIGHT);
    
    grassGraph.update(grassLevel);
    sheepGraph.update(sheep);
    wolvesGraph.update(wolves);
  }
}