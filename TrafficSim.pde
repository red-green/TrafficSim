ArrayList<Lane> lanes;
ArrayList<Car> cars;  // represents cars inside the intersection

int CARSIZE = 35;

int startx,starty,scalex,scaley;

void setup() {
  size(640,640);

  lanes = new ArrayList<Lane>();
  cars = new ArrayList<Car>(100);
  
  lanes.add(0,new Lane(0,Side.TOP, 15, Light.COMBINED_R, Turn.STRAIGHT_RIGHT));
  lanes.add(1,new Lane(1,Side.TOP, 5, Light.COMBINED_L, Turn.LEFT));
  lanes.add(2,new Lane(2,Side.TOP));

  lanes.add(3,new Lane(3,Side.RIGHT, 15, Light.COMBINED_R, Turn.STRAIGHT_RIGHT));
  lanes.add(4,new Lane(4,Side.RIGHT, 5, Light.COMBINED_L, Turn.LEFT));
  lanes.add(5,new Lane(5,Side.RIGHT));

  lanes.add(6,new Lane(6,Side.BOTTOM, 15, Light.COMBINED_R, Turn.STRAIGHT_RIGHT));
  lanes.add(7,new Lane(7,Side.BOTTOM, 5, Light.COMBINED_L, Turn.LEFT));
  lanes.add(8,new Lane(8,Side.BOTTOM));

  lanes.add(9,new Lane(9,Side.LEFT, 15, Light.COMBINED_R, Turn.STRAIGHT_RIGHT));
  lanes.add(10,new Lane(10,Side.LEFT, 5, Light.COMBINED_L, Turn.LEFT));
  lanes.add(11,new Lane(11,Side.LEFT));

  startx = width / 6;
  starty = height / 6;
  scalex = (width - 2*startx) / 3;
  scaley = (height - 2*starty) / 3;
}

int loops = 0;

void draw() {
  int currx = startx, curry = starty;
  strokeWeight(3);
  background(255);
  loops++;
  for (Lane l : lanes) {
    int ax = currx, ay = curry;
    String type = "";
    l.run();
    if (l.output) {
      type = "Out";
    } else {
      switch (l.turn) {
        case LEFT:
          type = "Left";
          break;
        case LEFT_STRAIGHT:
          type = "Left/Straight";
          break;
        case STRAIGHT:
          type = "Straight";
          break;
        case STRAIGHT_RIGHT:
          type = "Right/Straight";
          break;
        case RIGHT:
          type = "Right";
          break;
      }
    }
    fill(128);
    rect(0,0,startx,starty);
    rect(startx*5,0,startx,starty);
    rect(0,starty*5,startx,starty);
    rect(startx*5,starty*5,startx,starty);
    
    fill(0);
    int car;
    
    String ctype;
    switch (l.turn) {
      case LEFT:
        ctype = "L";
        break;
      case STRAIGHT:
        ctype = "S";
        break;
      case RIGHT:
        ctype = "R";
        break;
      default:
        ctype = "?";
    }
    
    switch (l.side) {
      case TOP:
        currx += scalex;
        stroke(0,155,0);
        line(ax,ay,ax,-10);
        stroke(0);
        line(ax,ay,currx,curry);
        stroke(0,155,0);
        line(currx,curry,currx,-10);
        text(type,ax,ay);
        
        car = 0;
        
        for (Car c : l.carqueue) {
          car++;
          
          noStroke();
          fill(c.col);
          ellipse(ax + scalex/2,ay - car*(CARSIZE+6),CARSIZE,CARSIZE);
          text(ctype,ax + scalex/2,ay - car*(CARSIZE+6));
        }
        break;
      case RIGHT:
        curry += scaley;
        stroke(0,155,0);
        line(ax,ay,width+10,ay);
        stroke(0);
        line(ax,ay,currx,curry);
        stroke(0,155,0);
        line(currx,curry,width+10,curry);
        text(type,currx,curry);
        
        car = 0;
        
        for (Car c : l.carqueue) {
          car++;
          
          noStroke();
          fill(c.col);
          ellipse(ax + car*(CARSIZE+6),ay + scaley/2,CARSIZE,CARSIZE);
          text(ctype,ax + car*(CARSIZE+6),ay + scaley/2);
        }
        break;
      case BOTTOM:
        currx -= scalex;
        stroke(0,155,0);
        line(ax,ay,ax,height+10);
        stroke(0);
        line(ax,ay,currx,curry);
        stroke(0,155,0);
        line(currx,curry,currx,height+10);
        text(type,currx,curry + 15);
        
        car = 0;
        
        for (Car c : l.carqueue) {
          car++;
          
          noStroke();
          fill(c.col);
          ellipse(ax - scalex/2,ay + car*(CARSIZE+6),CARSIZE,CARSIZE);
          text(ctype,ax - scalex/2,ay + car*(CARSIZE+6));
        }
        break;
      case LEFT:
        curry -= scaley;
        stroke(0,155,0);
        line(ax,ay,-10,ay);
        stroke(0);
        line(ax,ay,currx,curry);
        stroke(0,155,0);
        line(currx,curry,-10,curry);
        text(type,ax - 50,ay);
        
        car = 0;
        
        for (Car c : l.carqueue) {
          car++;
          
          noStroke();
          fill(c.col);
          ellipse(ax - car*(CARSIZE+6),ay - scaley/2,CARSIZE,CARSIZE);
          text(ctype,ax - car*(CARSIZE+6),ay - scaley/2);
        }
        break;
    }
    l.x = (currx + ax) / 2;
    l.y = (curry + ay) / 2;
    if (loops > 4 && l.carqueue.size() > 0 && random(100) > 99) {
      Car c = l.carqueue.remove(0);
      c.x = l.x;
      c.y = l.y;
      c.destx = lanes.get(c.tolane).x;
      c.desty = lanes.get(c.tolane).y;
      c.vel = new PVector((c.destx - c.x) / 40,(c.desty - c.y) / 40);  
      c.vel.normalize();
      /*float ang;
      switch (c.turn) {
        case LEFT:
          ang = -30;
          break;
        case RIGHT:
          ang = 45;
          break;
        default:
          ang = 0;
      }
      
      c.angle = radians(ang / max((c.destx - c.x) / c.vel.x,(c.desty - c.y) / c.vel.y));
      c.vel.rotate(radians(-ang/3.0)); */
      c.vel.mult(7);
      cars.add(c);
    }
  }
  text(cars.size(),300,300);
  for (int i = 0; i < cars.size(); i++) {
    Car c = cars.get(i);
    // FIGURE OUT IF IT'S CLOSE to another car, then figure out which one should go (angles)
    PVector a = c.vel.get();
    boolean run = true;
    for (Car k:cars) {
      if (sqrt(pow(abs(k.x-c.x),2)+pow(abs(k.y-c.y),2)) < CARSIZE * 3) {
        PVector b = k.vel.get();    //TODO: fix this , its probably better
        PVector ab = PVector.sub(a,b);
        float ang1 = abs(degrees(PVector.angleBetween(a,ab)));
        if (ang1 > 180) ang1 = 360 - ang1;
        float ang2 = abs(degrees(PVector.angleBetween(b,ab)));
        if (ang2 > 180) ang2 = 360 - ang2;
        if (run && (ang1 < ang2)) {
          run = !k.run;
        }
        /*
        switch (c.turn) {
          case LEFT:
            run = false;
            break;
          case STRAIGHT:
            run = true;
            break;
          case RIGHT:
            if (k.turn == Turn.STRAIGHT) {
              run = false;
            } else {
              run = true;
            }
        }*/
        if (!k.run) {
          //run = true;
        }
      }
    }
    
    c.run = run;
    
    if (run) {
      //c.vel.rotate(c.angle);
      c.x += c.vel.x;
      c.y += c.vel.y;
    }
    
    if (abs(c.x - c.destx) < 5 && abs(c.y - c.desty) < 5)
      cars.remove(i);
      
    fill(c.col);
    noStroke();
    ellipse(c.x,c.y,CARSIZE,CARSIZE);
    stroke(0);
    a.mult(4);
    line(c.x,c.y,c.x+a.x,c.y+a.y);
    //text(ctype,c.x,c.y);
  }
}


