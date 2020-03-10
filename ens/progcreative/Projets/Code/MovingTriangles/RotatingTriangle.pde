





class RotatingTriangle {

  Triangle triangle;
  float rx, ry, rz;
  float speedx, speedy, speedz;
  color c;
  float speed = 0.1;


  RotatingTriangle(Triangle t, color c) {
    this.triangle = t;
    this.rx = 0;
    this.ry = 0;
    this.rz = 0;
    setSpeed(speed);
    this.c = c;
  }
  
  void setSpeed(float speed) {
    this.speed = speed;
    this.speedx = random(speed);
    this.speedy = random(speed);
    this.speedz = random(speed);
  }

  void draw() {
    fill(c, 200);
    translate(this.triangle.center.x, this.triangle.center.y, 0);
    rotateX(this.rx);
    rotateY(this.ry);
    rotateZ(this.rz);

    triangle(this.triangle.p1.x, this.triangle.p1.y, this.triangle.p2.x, this.triangle.p2.y, this.triangle.p3.x, this.triangle.p3.y);

    rotateZ(-this.rz);
    rotateY(-this.ry);
    rotateX(-this.rx);
    translate(-this.triangle.center.x, -this.triangle.center.y, 0);

    this.ry += this.speedy;
    this.rx += this.speedx;
    this.rz += this.speedz;
  }
}
