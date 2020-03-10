// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain

// 2D Water Ripples
// Video: https://youtu.be/BZUdGqeOD0w
// Algorithm: https://web.archive.org/web/20160418004149/http://freespace.virgin.net/hugo.elias/graphics/x_water.htm
import processing.video.*;

int cols;
int rows;
float[][] current;// = new float[cols][rows];
float[][] previous;// = new float[cols][rows];
Capture video;
float dampening = 0.99;

void setup() {
  size(600, 480);
  video = new Capture(this, width, height);
  video.start();
  cols = width;
  rows = height;
  current = new float[cols][rows];
  previous = new float[cols][rows];
}

void mouseDragged() {
  //previous[mouseX][mouseY] = 255;

  int size=30;
  for (int i = -size; i <= size; i++) {
    for (int j = -size; j <= size; j++) {
      int x = mouseX + i;
      int y = mouseY + j;
      float coeff = gaussianCoefficients(i+size, j+size, 1) * 10;
      if (x > 0 && x < width && y > 0 && y < height) 
        previous[x][y] = 255 * coeff;
    }
  }
}

void captureEvent(Capture v) {
  v.read();
}

float gaussianCoefficients(int x, int y, float sigma) {
  return (1/(2*PI*sigma*sigma)) * exp(-(x*x+y*y)/(2*sigma*sigma));
}
void draw() {
  //background(0);

  video.loadPixels();
  for (int i = 1; i < cols-1; i++) {
    for (int j = 1; j < rows-1; j++) {
      current[i][j] = (
        previous[i-1][j] + 
        previous[i+1][j] +
        previous[i][j-1] + 
        previous[i][j+1]) / 2 -
        current[i][j];
      current[i][j] = current[i][j] * dampening;
      int index = i + j * cols;
      color currentColor = video.get(i, j);
      video.pixels[index] = color(red(currentColor) +current[i][j]*0.7, green(currentColor) +current[i][j]*0.7, blue(currentColor) + current[i][j]*0.7);
    }
  }
  video.updatePixels();
  image(video, 0, 0);
  float[][] temp = previous;
  previous = current;
  current = temp;
}
