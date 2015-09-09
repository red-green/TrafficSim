class Lane { // represents a lane
  Side side; // top,left,right,bottom
  float probability; // likelyhood a car will come
  Light light; // light type
  Turn turn = Turn.STRAIGHT; // legal turns
  ArrayList<Car> carqueue;
  int id;
  boolean output;
  float x,y;
  
  Lane(int id, Side s, float p, Light l, Turn t) {
    this.side = s;
    this.probability = p;
    this.light = l;
    this.turn = t;
    this.id = id;
    this.output = false;
    
    carqueue = new ArrayList<Car>(10);
  }

  Lane(int id, Side s) {
    this.side = s;
    this.id = id;
    this.output = true;
    
    carqueue = new ArrayList<Car>(10);
  }
  
  void run() {
    // add new cars
    if (!this.output && random(500) < this.probability) {
      Turn dir;
      switch (this.turn) {
        case LEFT_STRAIGHT:
          if (random(1) > 0.5) {
            dir = Turn.LEFT;
          } else {
            dir = Turn.STRAIGHT;
          }
          break;
        case STRAIGHT_RIGHT:
          if (random(1) > 0.5) {
            dir = Turn.RIGHT;
          } else {
            dir = Turn.STRAIGHT;
          }
          break;
        default:
          dir = this.turn;
          break;
      }
      Side turnside = Side.TOP;
      switch (dir) {  // there's probably an easier way...
        case LEFT:
          switch (this.side) {
            case TOP:
              turnside = Side.RIGHT;
              break;
            case RIGHT:
              turnside = Side.BOTTOM;
              break;
            case BOTTOM:
              turnside = Side.LEFT;
              break;
            case LEFT:
              turnside = Side.TOP;
              break;
          }
          break;
        case STRAIGHT:
          switch (this.side) {
            case TOP:
              turnside = Side.BOTTOM;
              break;
            case RIGHT:
              turnside = Side.LEFT;
              break;
            case BOTTOM:
              turnside = Side.TOP;
              break;  
            case LEFT:
              turnside = Side.RIGHT;
              break;
          }
          break;
        case RIGHT:
          switch (this.side) {
            case TOP:
              turnside = Side.LEFT;
              break;
            case RIGHT:
              turnside = Side.TOP;
              break;
            case BOTTOM:
              turnside = Side.RIGHT;
              break;
            case LEFT:
              turnside = Side.BOTTOM;
              break;
          }
          break;
      }
      int otherlane = 0;
      for (Lane i : lanes) {
        if (i.output && i.side == turnside) {
          otherlane = i.id;
          if (dir == Turn.LEFT) {
            break; // for left turns, we want the leftmost lane. for other turns, rightmost.
          }
        }
      }
      
      carqueue.add(new Car(dir,id,otherlane,color(random(255),random(255),random(255))));
    }
  }
  
  void draw() {
    
  }
}

class Car {
  Turn turn;
  int fromlane, tolane;
  color col;
  float x,y;
  float destx,desty;
  PVector vel;
  float angle;
  boolean run = false; // visible to other cars
  
  Car(Turn t, int lanea, int laneb, color c) {
    this.turn = t;
    this.fromlane = lanea;
    this.tolane = laneb;
    this.col = c;
  }
  
  void run() {
    
  }
  
  void draw() {
    
  }
}

class Event {
  
}
