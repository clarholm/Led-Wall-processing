import processing.video.*;
 
import java.util.*;
import java.nio.*;
 
import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.CvType;
import org.opencv.core.Scalar;
import org.opencv.objdetect.HOGDescriptor;
import org.opencv.core.MatOfRect;
import org.opencv.core.MatOfDouble;
import org.opencv.core.Rect;
import org.opencv.core.Size;
import org.opencv.imgproc.Imgproc;
 
Capture cap;
PImage small;
HOGDescriptor hog;
 
byte [] bArray;
int [] iArray;
int pixCnt1, pixCnt2;
int w, h;
float ratio;
 
Eye e1;
Eye e2;
Eye e3;
Eye e4;
 
void setup() {
  //size(64*5,26*5);
  size(640,480);
  ratio = 0.5;
  w = int(640*ratio);
  h = int(480*ratio);
  strokeWeight(1);
  cap = new Capture(this, width, height);
  cap.start();
  e1 = new Eye(width/8*1, height/2);
  e2 = new Eye(width/8*3, height/2);
  e3 = new Eye(width/8*5, height/2);
  e4 = new Eye(width/8*7, height/2);
  
    // Load the OpenCV native library.
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
 
  // pixCnt1 is the number of bytes in the pixel buffer.
  // pixCnt2 is the number of integers in the PImage pixels buffer.
  pixCnt1 = w*h*4;
  pixCnt2 = w*h;
 
  // bArray is the temporary byte array buffer for OpenCV cv::Mat.
  // iArray is the temporary integer array buffer for PImage pixels.
  bArray = new byte[pixCnt1];
  iArray = new int[pixCnt2];
 
  small = createImage(w, h, ARGB);
  hog = new HOGDescriptor();
  hog.setSVMDetector(HOGDescriptor.getDefaultPeopleDetector());

  
  
  
}
 
void draw() {
  //background(0,0,0);
  if (cap.available()) {
    cap.read();
  } 
  else {
    return;
  }
  image(cap, 0, 0);
  // Resize the video to a smaller PImage.
  small.copy(cap, 0, 0, width, height, 0, 0, w, h);
  // Copy the webcam image to the temporary integer array iArray.
  arrayCopy(small.pixels, iArray);
 
  // Define the temporary Java byte and integer buffers. 
  // They share the same storage.
  ByteBuffer bBuf = ByteBuffer.allocate(pixCnt1);
  IntBuffer iBuf = bBuf.asIntBuffer();
 
  // Copy the webcam image to the byte buffer iBuf.
  iBuf.put(iArray);
 
  // Copy the webcam image to the byte array bArray.
  bBuf.get(bArray);
 
  // Create the OpenCV cv::Mat.
  Mat m1 = new Mat(h, w, CvType.CV_8UC4);
 
  // Initialise the matrix m1 with content from bArray.
  m1.put(0, 0, bArray);
  // Prepare the grayscale matrix.
  Mat m3 = new Mat(h, w, CvType.CV_8UC1);
  Imgproc.cvtColor(m1, m3, Imgproc.COLOR_BGRA2GRAY);
 
  MatOfRect found = new MatOfRect();
  MatOfDouble weight = new MatOfDouble();
 
  hog.detectMultiScale(m3, found, weight, 0, new Size(8, 8), new Size(24, 24), 1.05, 2, false);
 
  Rect [] rects = found.toArray();
  if (rects.length > 0) {
    for (int i=0; i<rects.length; i++) {
      ellipse(rects[i].x/ratio+(rects[i].width/ratio)/2, rects[i].y/ratio+(rects[i].height/ratio)/6, 55, 55);
        e1.update(rects[i].x/ratio+(rects[i].width/ratio)/2, rects[i].y/ratio+(rects[i].height/ratio)/6);
        e2.update(rects[i].x/ratio+(rects[i].width/ratio)/2, rects[i].y/ratio+(rects[i].height/ratio)/6);
        e3.update(rects[i].x/ratio+(rects[i].width/ratio)/2, rects[i].y/ratio+(rects[i].height/ratio)/6);
        e4.update(rects[i].x/ratio+(rects[i].width/ratio)/2, rects[i].y/ratio+(rects[i].height/ratio)/6);
      //rect(rects[i].x/ratio, rects[i].y/ratio, rects[i].width/ratio, rects[i].height/ratio);
    }
  }
  text("Frame Rate: " + round(frameRate), 500, 50); 
  // Update each monster's pupils to follow cursor.

   
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

