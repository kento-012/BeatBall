class ParticleVec3 {
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector gravity;
  float mass;
  float friction;
  PVector min;
  PVector max;
  float radius;
  float G;
  float velCol;

  PVector v;


  ParticleVec3() {
    radius = 3.0;
    //radius = 2.0;
    //radius = 2.5;
    mass = 1.0;
    friction = 0.01;
    G = 1.0;
    location = new PVector(0.0, 0.0, 0.0);
    velocity = new PVector(0.0, 0.0, 0.0);
    acceleration = new PVector(0.0, 0.0, 0.0);
    gravity = new PVector(0.0, 0.0, 0.0);
    min = new PVector(0.0, 0.0, 0.0);
    max = new PVector(width, height, height/2);
    v = new PVector(0.0, 0.0, 0.0);
  }

  void update() {
    v = PVector.random3D();
    v.mult(0.3);

    acceleration.add(v);
    acceleration.add(gravity);
    velocity.add(acceleration);
    velocity.mult(1.0 - friction);
    location.add(velocity);
    acceleration.set(0, 0, 0);

    velCol = mag(velocity.x, velocity.y, velocity.z);
  }

  void draw() {
    pushMatrix();
    translate(location.x, location.y, location.z);

    //if (millis()/1000.0 < 30.0) {
    fill(50 + velCol * 50, 30 + velCol*6, 90-velCol*5);
    //} else {
    //  fill(90-velCol*5, 50 + velCol * 50, 30 + velCol*6);
    //}

    //fill(50 + velCol * 30, 30 + velCol*6, 90);
    //fill(10 + velCol * 30, 30 + velCol*6, 50);
    //fill(50 + velCol * 30, 30 + velCol*6, 70 + velCol*5);
    ellipse(0, 0, mass * radius * 2, mass * radius * 2);
    //ellipse(0, 0, mass * radius * 2, mass * radius * 1);
    popMatrix();

    //println(velCol);
  }

  void addForce(PVector force) {
    force.div(mass);
    acceleration.add(force);
  }

  void attract(PVector center, float _mass, float min, float max) {
    float distance = PVector.dist(center, location);
    distance = constrain(distance, min, max);
    float strength = G * (mass * _mass) / (distance * distance);
    PVector force = PVector.sub(center, location);
    force.normalize();
    force.mult(strength);
    addForce(force);
  }

  void bounceOffWalls() {
    if (location.x > max.x) {
      location.x = max.x;
      velocity.x *= -1;
    }
    if (location.x < min.x) {
      location.x = min.x;
      velocity.x *= -1;
    }
    if (location.y > max.y) {
      location.y = max.y;
      velocity.y *= -1;
    }
    if (location.y < min.y) {
      location.y = min.y;
      velocity.y *= -1;
    }
    if (location.z > max.z) {
      location.z = max.z;
      velocity.z *= -1;
    }
    if (location.z < min.z) {
      location.z = min.z;
      velocity.z *= -1;
    }
  }

  void throughWalls() {
    if (location.x > max.x) {
      location.x = min.x;
    }
    if (location.x < min.x) {
      location.x = max.x;
    }
    if (location.y > max.y) {
      location.y = min.y;
    }
    if (location.y < min.y) {
      location.y = max.y;
    }
    if (location.z > max.z) {
      location.z = min.z;
    }
    if (location.z < min.z) {
      location.z = max.z;
    }
  }
}
