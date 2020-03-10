class Triangle {
  PVector center, p1, p2, p3;

  Triangle(PVector center, PVector normal, int size) {
    normal = normal.normalize();
    PVector rd = PVector.random3D().normalize();
    float z2 = (-normal.x * rd.x - normal.y * rd.y) / normal.z;
    PVector dir = new PVector(rd.x, rd.y, z2).normalize();
    PVector firstPoint = PVector.mult(dir, size);
    dir = dir.cross(normal).normalize();
    PVector secondPoint = PVector.mult(dir, size);
    dir = dir.cross(normal).normalize();
    PVector thirdPoint = PVector.mult(dir, size);
    this.center = center;
    this.p1 = firstPoint;
    this.p2 = secondPoint;
    this.p3 = thirdPoint;
  }

  Triangle(PVector center, int size) {
    float direction = random(2*PI);
    float rad120 = radians(120);
    PVector firstPoint = PVector.mult(PVector.fromAngle(direction), size);
    PVector secondPoint = PVector.mult(PVector.fromAngle((direction + rad120)), size);
    PVector thirdPoint = PVector.mult(PVector.fromAngle((direction + 2*rad120)), size);

    this.center = center;
    this.p1 = firstPoint;
    this.p2 = secondPoint;
    this.p3 = thirdPoint;
  }
}
