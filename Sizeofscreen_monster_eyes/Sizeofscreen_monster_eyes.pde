/**
 * Monster Dance
 *
 * Assignment:
 * Course: Interactive Digital Mdedia
 * Author: David Langly
 * Date:
 *
 * Description: Group of monsters dancing to the beat
 * of the music.
 */
 
Eye e1;
Eye e2;
Eye e3;
Eye e4;
 
void setup() {
  size(64*5,26*5);
  strokeWeight(1);
   
  e1 = new Eye(width/8*1, height/2);
  e2 = new Eye(width/8*3, height/2);
  e3 = new Eye(width/8*5, height/2);
  e4 = new Eye(width/8*7, height/2);
}
 
void draw() {
  background(0,0,0);
   
  // Update each monster's pupils to follow cursor.
  e1.update(mouseX, mouseY);
  e2.update(mouseX, mouseY);
  e3.update(mouseX, mouseY);
  e4.update(mouseX, mouseY);
   
  // Display each monster with updated pupil position.
  e1.display();
  e2.display();
  e3.display();
  e4.display();
}
 /*
void mousePressed() {
  m1.mousePressed();
  m2.mousePressed();
  m3.mousePressed();
  m4.mousePressed();
}
 
void mouseDragged() {
  m1.mouseDragged();
  m2.mouseDragged();
  m3.mouseDragged();
  m4.mouseDragged();
}
 
void mouseReleased() {
  m1.mouseReleased();
  m2.mouseReleased();
  m3.mouseReleased();
  m4.mouseReleased();
}
 */

/**
 * Eye.
 *
 * This class defines the blueprint for diplaying an eye whose
 * pupil follows the position of the mouse cursor. The original
 * idea and calculations were taken from the example application
 * "Arctangent" bundled with the Processing application.
 *
 * The eye increases and decreases in size automatically as a
 * function of time. The initial size of an eye as well as the
 * rate at which the eye grows are both determined by using a
 * random number generator.
 */
class Eye
{
  final static int MAX_EYE_SIZE = 70;
  final static int MIN_EYE_SIZE = 30;
 
  final static float MAX_EYE_VELOCITY = 0.2;
  final static float MIN_EYE_VELOCITY = -0.2;
   
  int ex, ey;
  float size;
  float velocity;
  float angle = 0.0;
   
  Eye(int x, int y) {
    ex = x;
    ey = y;   
    size = random(MIN_EYE_SIZE, MAX_EYE_SIZE);
    velocity = random(MIN_EYE_VELOCITY, MAX_EYE_VELOCITY);
  }
  
  boolean isInside(float mx, float my) {
   float distance = sqrt(sq(ex - mx) + sq(ey - my));
   if (distance <= size)
   {
     return true;
   }
   else
   {
     return false;
   }
  }
  
  void update(float mx, float my) {
    angle = atan2(my-ey, mx-ex);
    size += velocity;
    if (size > MAX_EYE_SIZE) {
      velocity = -velocity;
    }
    if (size < MIN_EYE_SIZE) {
      velocity = -velocity; 
    }
  }
   
  void display() {
    pushMatrix();
    translate(ex, ey);
    fill(255);
    stroke(0);
    ellipse(0, 0, size, size);
    rotate(angle);
    fill(153);
    ellipse(size/4, 0, size/2, size/2);
    popMatrix();
  }
}

