class Particle {
  float x;
  float y;
  float size;
  ArrayList<PVector> history;
  final int MAX_ARRAY_SIZE = height/2;
  Particle(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.history = new ArrayList<PVector>();
  }

  void update() {
    this.y -= random(10);
    /*for (PVector v : this.history) {
      v.y += random(-2, 2);
    }*/

    PVector v = new PVector(this.x, this.y);
    this.history.add(v); 
    if (this.history.size() > MAX_ARRAY_SIZE) {
      this.history.remove(0);
    }
  }
  
  void reset() {
    this.y = height;
  }

  void show(float amplitude) {
    if (amplitude > 1.0) {
     reset(); 
    }
    noStroke();
    fill(255, 150);
    ellipse(this.x, this.y, size, size);

    noFill();
    //beginShape();
    float inter = map(amplitude, 0.0, 10.0, 0, 1);
    color yellow = color(255, 255, 0);
    color red = color(255, 0, 0);
      color c = lerpColor(yellow, red, inter);
    for (int i = 0; i < history.size(); i++) {
      int opacity = int(map(i, 0, MAX_ARRAY_SIZE, 0, 255)); 
      PVector pos =  history.get(i);
      fill(c, opacity);
      ellipse(pos.x, pos.y, size, size);
    }
   // endShape();
  }
}
