/*
created by takashi matsuyuki  2016/06/15

processing == 3.0.2

library
  peasycam == v201
  punktiert == 3.0.1

*/
import peasy.PeasyCam;
import punktiert.math.Vec;
import punktiert.physics.*;

VPhysics physics;
PeasyCam cam;

int setsphere = 0;                                              // 0:false, 1:true
int spheresize = 300;                                       // Base Sphere size
int numberofdots = 1000;                             // number of flocking dot 
int dotsize = 4;                                                  // flocking dot size
float dotspeed = 5.0f;                                    // flocking dot speed
int setcolor = 1;                                               // 0:monochro, 1:rainbow, 2:soapbubble
color dotcolor = color(255, 255, 255);   // colormode = HSB
float h = 0;
float a  = 100;


public void setup() {

  size(800, 800, P3D);
  colorMode(HSB);
  smooth();

  cam = new PeasyCam(this, 800); // init camera distance from the origin
  //cam.setMinimumDistance(500); 
  //cam.setMaximumDistance(5000); 

  physics = new VPhysics();

  //init dots
  for (int i = 0; i < numberofdots; i++) { 

    Vec pos = new Vec(0, 0, 0).jitter(1);
    Vec vel = new Vec(random(-1, 1), random(-1, 1), random(-1, 1));
    VBoid p = new VBoid(pos, vel);

//  When you change this parameter, then dots behavior is changed 
    p.swarm.setSeperationScale(1.0f);
    p.swarm.setSeperationRadius(80);
    p.swarm.setAlignScale(.8f);
    p.swarm.setAlignRadius(80);
    p.swarm.setCohesionScale(.08f);
    p.swarm.setCohesionRadius(50);
    p.swarm.setMaxSpeed(dotspeed);
    physics.addParticle(p);

    VSpring anchor = new VSpring(new VParticle(p.x(), p.y(), p.z()), p, spheresize, .5f);
    physics.addSpring(anchor);
  }
}

public void draw() {
  background(0);

  // set base sphere
  if (setsphere == 1) { 
    noFill();
    stroke(255, 0, 255, a);
    sphere(spheresize);
    a--;
  }

  physics.update();

  // colormode: rainbow
  if (setcolor == 1) { 
    h += 1;
    if (h ==2550) h = 0;
    dotcolor = color(h/10, 150, 255);
  }

  for (int i = 0; i < physics.particles.size(); i++) {
    VBoid boid = (VBoid) physics.particles.get(i);

    // colormode: soap bubble
    if (setcolor == 2) { 
      h = boid.y;
      h += spheresize;
      dotcolor = color(h*255/(2*spheresize), 150, 255);
    }

    strokeWeight(dotsize);
    stroke(dotcolor);
    point(boid.x, boid.y, boid.z);
  }
  //save frame for creating movie
  //saveFrame("frames/######.tif");
}