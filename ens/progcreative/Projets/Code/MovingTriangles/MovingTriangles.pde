//Using DLIB and EOS to obtain 3D face model

import processing.sound.*;
import controlP5.*;
import java.awt.Rectangle;

ControlP5 cp5;

PImage img;
PShape face3D, box;
int radius = 5;
int step = 50;
int sizeTriangle = 20;

ArrayList<Particle> background;
ArrayList<AnimatedPShape> triangleFace;

int tx = 251;
int ty = 191;

//Sound variables
int bands = 128;
float smoothingFactor = 0.2;

// Create a vector to store the smoothed spectrum data in
float[] sum = new float[bands];
SoundFile sample;
FFT fft;


color couleurMoyenne(int x, int y, int radius, PImage img) {
  float r = 0.0;
  float g = 0.0;
  float b = 0.0;
  for (int i = -radius; i <= radius; i++) {
    for (int j = -radius; j <= radius; j++) {
      color c = img.get(x+i, y+j);
      r += red(c);
      g += green(c);
      b += blue(c);
    }
  }
  int nb = 2*radius+1;
  r /= nb*nb;
  g /= nb*nb;
  b /= nb*nb;
  return color(r, g, b);
}

PVector centerTriangle(PShape triangle) {
  PVector p1 = triangle.getVertex(0);
  PVector p2 = triangle.getVertex(1);
  PVector p3 = triangle.getVertex(2);
  PVector center = PVector.add(p1, p2).add(p3).mult(0.33333);
  return center;
}

PShape createGroupFromTriangle(PShape triangle, int radius) {
  PShape group = createShape(GROUP);
  PVector center = centerTriangle(triangle);
  for (PShape t : face3D.getChildren()) {
    PVector centerT = centerTriangle(t);
    float dist = abs(centerT.x - center.x) + abs(centerT.y - center.y) + abs(centerT.z -center.z);
    if (dist <= radius) {
      group.addChild(t.getTessellation());
    }
  }
  return group;
}

PShape groupToTriangle(PShape group) {
  // PShape triangle = createShape(TRIANGLE, 1, 2, 3, 2,3);
  PVector barycenter = new PVector(0, 0, 0);
  PVector normal = new PVector(0, 0, 0);
  for (PShape triangle : group.getChildren()) {
    PVector center = centerTriangle(triangle.getTessellation());
    barycenter = PVector.add(barycenter, center);
    normal = PVector.add(normal, triangle.getNormal(0));
  }
  barycenter.div(group.getChildCount());
  normal.div(group.getChildCount()).normalize();

  Triangle t = new Triangle(barycenter, normal, sizeTriangle);
  PShape s = createShape();
  s.beginShape();
  s.vertex(t.center.x+t.p1.x, t.center.y+t.p1.y, t.center.z+t.p1.z);
  s.vertex(t.center.x+t.p2.x, t.center.y+t.p2.y, t.center.z+t.p2.z);
  s.vertex(t.center.x+t.p3.x, t.center.y+t.p3.y, t.center.z+t.p3.z);
  s.endShape(CLOSE);
  s.setNormal(0, normal.x, normal.y, normal.z);
  return s;
}

void decomposeShape() {

  for (int i = 0; i < face3D.getChildCount(); i+=sizeTriangle) {
    PShape t = face3D.getChild(i);
    PShape group = createGroupFromTriangle(t, 15);
    PShape newTriangle = groupToTriangle(group);
    float r = 0, g = 0, b = 0;
    for (PShape triangle : group.getChildren()) {
      PVector p1 = triangle.getVertex(0);
      PVector p2 = triangle.getVertex(1);
      PVector p3 = triangle.getVertex(2);
      PVector center = PVector.add(p1, p2).add(p3).mult(0.33333);
      color c = couleurMoyenne(int(center.x), int(center.y), 5, img); 
      r += red(c);
      g += green(c);
      b += blue(c);
    }
    r/=group.getChildCount();
    g/=group.getChildCount();
    b/=group.getChildCount();
    newTriangle.setFill(color(r, g, b, 200));
    triangleFace.add(new AnimatedPShape(newTriangle));
  }
}

PShape boundingBox3D(PShape shape) {
  float minX = width+1, minY = height+1;
  float maxX = -1, maxY = -1;
  for (PShape s : shape.getChildren()) {
    s = s.getTessellation();
    PVector p = s.getVertex(0);
    if (p.x < minX) {
      minX = p.x;
    }
    if (p.y < minY) {
      minY = p.y;
    }
    if (p.x > maxX) {
      maxX = p.x;
    }
    if (p.y > maxY) {
      maxY = p.y;
    }
  }
  PShape box = createShape();
  box.set3D(false);
  box.setVertex(0, new PVector(minX, minY));
  box.setVertex(1, new PVector(maxX, maxY));

  return box;
}

boolean boxContains(PShape box, PVector p) {
  float shift = 30;
  PVector lb = box.getVertex(0).add(2*shift, shift); 
  PVector ub = box.getVertex(1).sub(shift, shift);
  if (p.x > lb.x && p.x <= ub.x && p.y > lb.y && p.y <= ub.y) {
    return true;
  }
  return false;
}

void play(int event) {
  sample.play(); 
  fft = new FFT(this, bands);
  fft.input(sample);
}

void settings() {
  img = loadImage("coltrane.jpeg");
  size(img.width, img.height, P3D);
}

void setup() {
  cp5 = new ControlP5(this);
  PImage[] imgs = {loadImage("button_a.png"), loadImage("button_b.png"), loadImage("button_c.png")};

  cp5.addButton("play").setPosition(10, 10).setSize(19, 19).setImages(imgs).updateSize();

  face3D = loadShape("out.obj");
  face3D.scale(1.6);

  face3D.rotateX(0.15);
  face3D.rotateY(-0.1);
  face3D.rotateZ(3.12);
  face3D.translate(tx, ty);

  box = boundingBox3D(face3D);
  sample = new SoundFile(this, "Resolution.wav");

  noStroke();
  image(img, 0, 0);
  img.loadPixels();
  background = new ArrayList();
  triangleFace = new ArrayList();
  decomposeShape();

  for (int x = 0; x < img.width; x+=step) {
    //for (int y = 0; y < img.height; y+=step) {
      color c = couleurMoyenne(x, 0, radius, img);
      //RotatingTriangle t = new RotatingTriangle(new Triangle(new PVector(x, y), sizeTriangle), c);
      Particle p = new Particle((2*x+step)/2, height, step+10);
      background.add(p);
    }
  //}
}


void draw() {
  background(img);
  if (sample.isPlaying()) {
    background(color(255));
     // Perform the analysis
    fft.analyze();

    for (int i = 0; i < bands; i++) {
      sum[i] += (fft.spectrum[i] - sum[i]) * smoothingFactor;
    }
    float binSizeRotating = width / float(bands);
    for (Particle  p : background) {
      int ind = int(map(p.x, 0, width + step/2, 0, float(bands)));
      p.update();
      println(ind);
      p.show(sum[ind]);
    }
    /*for (RotatingTriangle t : triangles) {
      if (!boxContains(box, PVector.add(t.triangle.p1, t.triangle.center)) && 
        !boxContains(box, PVector.add(t.triangle.p2, t.triangle.center)) && 
        !boxContains(box, PVector.add(t.triangle.p3, t.triangle.center)) && 
        t.triangle.center.x > 60 && t.triangle.center.y > 60) {
        int ind = int(t.triangle.center.x % binSizeRotating);
        t.setSpeed(sum[ind]);
        t.draw();
      }
    }
    fill(255, 0, 150);*/
    noStroke();

   
    float binSize = (box.getVertex(1).y - box.getVertex(0).y) / float(bands);
    for (AnimatedPShape s : triangleFace) {
      PVector center = centerTriangle(s.shape);
      int ind = int(center.y % binSize);

      if (!s.animating) {
        s.speed = 0.2;
        s.amplitude = sum[ind]*25;
        s.animating = true;
      }
      s.draw();
    }
  }
}



float totalX, totalY = 0;
void mouseDragged() {
  float valueX = (mouseX - pmouseX)/100.0;
  float valueY = (mouseY - pmouseY)/100.0;
  totalX += valueX;
  totalY += valueY;
  //face3D.rotateX(valueX);
  println(totalX);
  println(totalY);
  for (AnimatedPShape s : triangleFace) {
    s.shape.rotateY(valueX);
  }
  //face3D.rotateY(mouseY/100.0);
}
