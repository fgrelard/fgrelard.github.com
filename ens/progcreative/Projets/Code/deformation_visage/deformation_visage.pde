import gab.opencv.*;
import java.awt.Rectangle;
import processing.video.*;

PImage source, destination;
OpenCV opencv;
Rectangle[] faces;

void settings() {
  opencv = new OpenCV(this, "p.jpg");
  size(opencv.width, opencv.height);
}

void setup()
{
  source = loadImage("p.jpg");  // fill in your own image here
  opencv.loadCascade(OpenCV.CASCADE_MOUTH);  
  faces = opencv.detect();
  destination = warp(source);
}

void draw()
{
  opencv.useColor();
  //deformation();
  image(destination, 0, 0);
  noLoop();
  //scaleCrop();
}

void deformation() {
  source.loadPixels();
  for (int x = 0; x < source.width; x++) {
    for (int y = 0; y < source.height; y++) {
      float i = x * 1.0 / source.width;
      float j = y * 1.0 / source.height;
      float r = sqrt(pow(i - 0.5, 2.0) + pow(j - 0.5, 2.0));
      float angle = atan((j - 0.5) / (i - 0.5));
      float rk = pow(r, 1.5);
      float newI = rk * cos(angle) + 0.5;
      float newJ = rk * sin(angle) + 0.5;
      if (i < 0.5) {
        newI = -rk * cos(angle) + 0.5;
        newJ = -rk * sin(angle) + 0.5;
      }

      int newX = int(newI * source.width);
      int newY = int(newJ * source.height);
      destination.set(x, y, source.get(newX, newY));
    }
  }
  destination.updatePixels();
}

void scaleCrop() {
  for (int i = 0; i < faces.length; i++) {
    opencv.setROI(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    PImage cropped = opencv.getSnapshot();
    cropped.resize(cropped.width, cropped.height*2);
    image(cropped, faces[i].x, faces[i].y);
  }
}

void mousePressed() {
  println(mouseX);
  Spherize(mouseX, mouseY, 50);
}


final float effectAmount = 0.75;

void Spherize(int xPos, int yPos, int radius)
{
  int tlx = xPos - radius, tly = yPos - radius;
  PImage pi = source.get(tlx, tly, radius * 2, radius * 2);
  for (int x = - radius; x < radius; x++)
  {
    for (int y = - radius; y < radius; y++)
    {
      // Rescale cartesian coords between -1 and 1
      float cx = (float)x / radius;
      float cy = (float)y / radius;

      // Outside of the sphere -> skip
      float square = sq(cx) + sq(cy);
      if (square >= 1)
        continue;

      // Compute cz from cx & cy
      float cz = sqrt(1 - square);

      // Cartesian coords cx, cy, cz -> spherical coords sx, sy, still in -1, 1 range
      float sx = atan(effectAmount * cx / cz) * 2 / PI;
      float sy = atan(effectAmount * cy / cz) * 2 / PI;

      // Spherical coords sx & sy -> texture coords
      int tx = tlx + (int)((sx + 1) * radius);
      int ty = tly + (int)((sy + 1) * radius);

      // Set pixel value
      pi.set(radius + x, radius + y, source.get(tx, ty));
    }
  }
  source.set(tlx, tly, pi);
}

// implement a simple vertical wave warp.
PImage warp(PImage source)
{
  float waveAmplitude = 20, // pixels
    numWaves = 5;       // how many full wave cycles to run down the image
  int w = source.width, h = source.height;
  PImage destination = new PImage(w, h);
  source.loadPixels();
  destination.loadPixels();

  float yToPhase = 2*PI*numWaves / h; // conversion factor from y values to radians.

  for (int x = 0; x < w; x++)
    for (int y = 0; y < h; y++)
    {
      int newX, newY;
      newX = int(x + waveAmplitude*sin(y * yToPhase));
      newY = y;
      color c;
      if (newX >= w || newX < 0 ||
        newY >= h || newY < 0)
        c = color(0, 0, 0);
      else
        c = source.pixels[newY*w + newX];
      destination.pixels[y*w+x] = c;
    }
  return destination;
} 
