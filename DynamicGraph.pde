class DynamicGraph {
  float x, y, graphWidth, graphHeight;
  int dataLength, index = 0, maxIndex = 0, minIndex = 0;
  color dataColor;
  float[] data;
  
  DynamicGraph(float x, float y, float w, float h, int l, color c) {
    this.x = x;
    this.y = y;
    graphWidth = w;
    graphHeight = h;
    dataLength = l;
    dataColor = c;
    
    data = new float[dataLength];
  }
  
  void update(float newData) {
    
    if(++index == data.length) index = 0;
    
    //finding next highest sheep value if removing previous highest
    if(index == maxIndex) {
      float tempMax = 0;
      int tempIndex = maxIndex;
      for(int i = 0; i < data.length; i++) {
        if(i == maxIndex) continue;
        if(data[i] > tempMax) {
          tempMax = data[i];
          tempIndex = i;
        }
      }
      maxIndex = tempIndex;
    }
    
    //same but with min
    if(index == minIndex) {
      float tempMin = 100000;
      int tempIndex = minIndex;
      for(int i = 0; i < data.length; i++) {
        if(i == minIndex) continue;
        if(data[i] < tempMin) {
          tempMin = data[i];
          tempIndex = i;
        }
      }
      minIndex = tempIndex;
    }
    
    data[index] = newData;
    if(data[index] >= data[maxIndex]) maxIndex = index;
    if(data[index] <= data[minIndex]) minIndex = index;
    
    //draw sheep graph
    stroke(200);
    fill(100);
    rect(x, y, graphWidth, graphHeight);
    
    stroke(dataColor);
    float lastPX = 0, lastPY = 0;
    for(int i = 0, j = index; i < data.length; i++, j = (--j) == -1? data.length - 1 : j) {
      
      float px = x + graphWidth*(1 - (float) (i)/data.length), py = y + graphHeight*(1 - percentBetween(data[minIndex], data[maxIndex], data[j]));
      if(i != 0) line(lastPX, lastPY, px, py);
      lastPX = px;
      lastPY = py;
    }
    
    //draw sheep scale
    fill(255);
    text(round(data[minIndex]), x - 3, y + graphHeight);
    text(round(data[maxIndex]), x - 3, y);
    //for(int i : relevantScale(data[minIndex], data[maxIndex])) text(i, x - 3, y + graphHeight*(1 - percentBetween(data[minIndex], data[maxIndex], i)));
  }
  
  int[] relevantScale(float min, float max) {
    int[] nums = {1, 2, 5};
    
    //lowerBound is first above min
    int lowerBound = 0;
    while(nums[lowerBound % nums.length] * pow(10, lowerBound/nums.length) < min) lowerBound++;
    
    //upperBound is first above max
    int upperBound = lowerBound;
    while(nums[(upperBound) % nums.length] * pow(10, upperBound/nums.length) < max) upperBound++;
    
    ArrayList<Integer> scaleNums = new ArrayList<Integer>();
    for(int i = lowerBound; i < upperBound; i++) {
      scaleNums.add(nums[i % nums.length] * (int) pow(10, i/nums.length));
    }
    
    int[] result = new int[scaleNums.size()];
    for(int i = 0; i < scaleNums.size(); i++) result[i] = scaleNums.get(i);
    
    return result;
  }
  
  float percentBetween(float min, float max, float num) {return (num - min)/(max - min);}
}