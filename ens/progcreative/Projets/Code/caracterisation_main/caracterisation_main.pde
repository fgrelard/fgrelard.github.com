import gab.opencv.*;
import java.awt.Rectangle;
import processing.video.*;
import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.Size;
import org.opencv.core.Point;
import org.opencv.core.Scalar;
import org.opencv.core.CvType;
import org.opencv.imgproc.Imgproc;

PImage dst, hist, histMask, binary, imageFond;
OpenCV opencv;
Capture cam;
Mat skinHistogram;
boolean estEnregistree = false;

void settings() {

  cam = new Capture(this);
  cam.start();
  hist = new PImage(100, 100);
  opencv = new OpenCV(this, cam, true);
  skinHistogram = Mat.zeros(256, 256, CvType.CV_8UC1);
  Core.ellipse(skinHistogram, new Point(113.0, 155.6), new Size(40.0, 25.2), 43.0, 0.0, 360.0, new Scalar(255, 255, 255), Core.FILLED);
  dst = createImage(cam.width, cam.height, RGB);

  histMask = createImage(256, 256, ARGB);
  size(cam.width, cam.height);
}

void captureEvent(Capture v) {
  v.read();
}



void setup() {
}

Scalar colorToScalar(color c) {
  return new Scalar(blue(c), green(c), red(c));
}

void detection() {
  opencv.toPImage(skinHistogram, histMask);
  hist.blend(histMask, 0, 0, 256, 256, 0, 0, 256, 256, ADD);

  dst = opencv.getOutput();
  dst.loadPixels();

  for (int i = 0; i < dst.pixels.length; i++) {

    Mat input = new Mat(new Size(1, 1), CvType.CV_8UC3);
    input.setTo(colorToScalar(dst.pixels[i]));
    Mat output = OpenCV.imitate(input);
    Imgproc.cvtColor(input, output, Imgproc.COLOR_BGR2YCrCb );
    double[] inputComponents = output.get(0, 0);
    if (skinHistogram.get((int)inputComponents[1], (int)inputComponents[2])[0] > 0) {
      dst.pixels[i] = color(255);
    } else {
      dst.pixels[i] = color(0);
    }
  }

  dst.updatePixels();
}

void draw() {
  opencv.useColor();

  //Chargement des pixels
  if (estEnregistree) {
    suppressionFond();
    binary = dst.copy();
    //image(dst, 0,0);
    opencv.loadImage(binary);

    opencv.gray();
    opencv.threshold(250);
    opencv.erode();
    opencv.erode();
    opencv.dilate();
    opencv.dilate();



    opencv.dilate();
    opencv.dilate();
    opencv.dilate();
    opencv.dilate();
    opencv.erode();
    opencv.erode();
    opencv.erode();    
    opencv.erode();

    image(opencv.getOutput(), 0, 0);


    ArrayList<Contour> contours = opencv.findContours();
    //Contour contour = contours.get(0);
    println(contours.size());
    if (contours.size() > 0) {
      Contour maxContour = contours.get(0);
      for (Contour contour : contours) {
        if(contour.area() > maxContour.area()) {
         maxContour = contour; 
        }
      }
      int nb = numberFingers(maxContour);
      println("Nombre de doigts=" + nb);
    }
  } else {
    image(cam, 0, 0);
  }

  /*hist.copy(cam, 0, 0, cam.width, cam.height, 
   0, 0, hist.width, hist.height);
   opencv.loadImage(hist);
   detection();
   */
}

PVector closestPoint(PVector p, Contour c) {
  float max = Float.MAX_VALUE;
  PVector close = new PVector(0, 0);
  for (PVector p2 : c.getPoints()) {
    if (p.dist(p2) < max ) {
      max = p.dist(p2);
      close = p2;
    }
  }
  return close;
}


void suppressionFond() {
  dst.loadPixels();
  cam.loadPixels(); 
  imageFond.loadPixels();

  for (int x = 0; x < cam.width; x ++ ) {
    for (int y = 0; y < cam.height; y ++ ) {
      color fgColor = cam.get(x, y); //on récupère la couleur courante du pixel
      color bgColor = imageFond.get(x, y); //on récupère la couleur du pixel correspondant dans l'image de fond

      // On compare
      float r1 = red(fgColor);
      float g1 = green(fgColor);
      float b1 = blue(fgColor);
      float r2 = red(bgColor);
      float g2 = green(bgColor);
      float b2 = blue(bgColor);
      float diff = dist(r1, g1, b1, r2, g2, b2);

      // Si la distance est supérieure au seuil
      if (diff > 20) {
        // alors c'est un pixel objet
        dst.set(x, y, color(255));
      } else {
        dst.set(x, y, color(0));
      }
      /* if (diff > seuil) {
       // alors c'est un pixel objet
       imageAffichee.set(x, y, fgColor);
       } else {
       imageAffichee.set(x, y, color(0, 255, 0));
       }*/
    }
  }
  dst.updatePixels();
}


void mousePressed() {
  estEnregistree = true;
  // On copie l'image courante dans l'image de fond
  imageFond = cam.copy();
  //imageFond.updatePixels();
}

float angle(ArrayList<PVector> list, int indexCourant) {
  int indexPrecedent = (indexCourant - 1) < 0 ? list.size() - 1 : indexCourant - 1;
  int indexSuivant = ((indexCourant + 1) > list.size() - 1) ?  0 : indexCourant + 1;
  PVector courant = list.get(indexCourant);
  PVector suivant = list.get(indexSuivant);
  PVector precedent = list.get(indexPrecedent);
  PVector v1 = PVector.sub(precedent, courant);
  PVector v2 = PVector.sub(suivant, courant);
  return degrees(PVector.angleBetween(v1, v2));
}

int numberFingers(Contour main) {
  Contour approxPolygonale = main.getPolygonApproximation();
  Contour c = main.getConvexHull();
  approxPolygonale.draw();
  noFill();
  stroke(255, 0, 0);
  c.draw();
  float seuil = 5.0;
  int nb = 0;
  ArrayList<PVector> list = approxPolygonale.getPoints();
  int size = list.size();

  for (int i = 0; i < size; i++) {
    PVector p  = list.get(i);
    PVector f = closestPoint(p, c);
    if (f.dist(p) > seuil  && angle(list, i) < 90) {
      stroke(255, 0, 0);
      ellipse(p.x, p.y, 20, 20);
      nb++;
    }
  }
  return nb;
}
