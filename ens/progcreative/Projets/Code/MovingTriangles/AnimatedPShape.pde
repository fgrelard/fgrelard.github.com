class AnimatedPShape {
  PShape shape;
  float amplitude;
  float speed;
  float time;
  boolean animating;

  AnimatedPShape(PShape sh) {
    shape = sh;
    amplitude = 0;
    speed = 0;
    time = 0;
    animating = false;
  }

  AnimatedPShape(PShape sh, float a, float s) {
    shape = sh;
    amplitude = a;
    speed = s;
    time = 0;
    animating = false;
  }

  void move() {
    float deltaPos = amplitude - time * speed;
    if (time > (2*amplitude/speed)) {
      animating = false;
      time = 0;
      PVector center = centerTriangle(shape);
      PVector newCenter = centerTriangle(shape.getTessellation());
      PVector diff = PVector.sub(center, newCenter);
      shape.translate(diff.x, diff.y, diff.z);
    } else {
      PVector n = shape.getNormal(0);
      shape.translate(n.x*deltaPos, n.y*deltaPos, n.z*deltaPos);
    }
  }

  void draw() {
    if (animating) {
      move();
      time++;
    }
    shape(shape);
  }
}
