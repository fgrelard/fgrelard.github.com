import gab.opencv.*;
import java.awt.Rectangle;
import processing.video.*;
import org.opencv.core.Point;

OpenCV opencv;
Rectangle[] faces;
Rectangle[] mouths,noses;
Capture video;

void captureEvent(Capture video) {
  video.read(); //Rafraîchit l'image
}

void setup() {
  video = new Capture(this, 640, 480);
  video.start();

  opencv = new OpenCV(this, video);

  frameRate(25);
  size(640, 480);
}

void draw() {
  image(video, 0, 0);
  opencv.loadImage(video); //Permet actualiser l'image avec l'image courante de la video dans openCV 
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE); //Initialise e module l'openCV

  faces = opencv.detect(); //Recuperation de tous les visages

  //Dessine les rectangles
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  for (int i = 0; i < faces.length; i++) {
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  }

  //opencv.loadImage(video); //Permet actualiser l'image avec l'image courante de la video dans openCV
  opencv.loadCascade(OpenCV.CASCADE_MOUTH);
  mouths = opencv.detect(); //Recuperation de tous les visages


  opencv.loadCascade(OpenCV.CASCADE_NOSE);
  noses = opencv.detect();
  //Dessine les rectangles
  
  for (Rectangle r : noses) {
     rect(r.x, r.y, r.width, r.height); 
  }

  rectMode(CORNER);
  for (int i = 0; i < mouths.length; i++) {
    Rectangle m = mouths[i];
    for (int y=0; y<faces.length; y++) {
      Rectangle f = faces[y];
      if (m.width < f.width && m.height < f.height) {
        if (m.x > f.x && m.x < (f.x + f.width)) {
          if (m.y > (f.y + 2*f.height/3) && m.y < (f.y + f.height)) {
            opencv.setROI(m.x, m.y, m.width, m.height);
            // PImage m_img = opencv2.getSnapshot();
            // opencv2.loadImage(m_img);
            drawcontour(m.x, m.y);
            stroke(255, 0, 0);
            //rect(m.x, m.y, m.width, m.height);
          }
        }
      }
    }
  }
  opencv.releaseROI();
}

void translatePointsContour(Contour contour, int x, int y) {
  ArrayList<PVector> points = contour.getPoints();
  for (int i = 0; i < points.size(); i++) {
    PVector p = points.get(i);
    p.x += x;
    p.y += y;
  }
}

void drawcontour(int x, int y) {
  stroke(255, 0, 255);
  strokeWeight(3);
  noFill();
  opencv.findCannyEdges(200, 250);
  ArrayList<Contour> contours = opencv.findContours();
  for (Contour contour : contours) {
    translatePointsContour(contour, x, y);
    contour.draw();
    stroke(0, 255, 255);
    Rectangle box = contour.getBoundingBox();
    stroke(255, 0, 255);
    Contour conv = contour.getConvexHull();  
    conv.draw();
    //conv.draw();
  }
}
