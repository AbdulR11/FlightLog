/**
 * Home class represents the main screen of the application. - Ayush
 *
 * This class extends the Screens class and provides the following functionalities:
 *  - Displays a rotating 3D globe using the HeightMapEarth library (`earth`).
 *  - Loads and displays an image logo (`imageLogo`).
 *  - Shows the group member names as text with a slight shadow effect.
 *  - Handles mouse dragging to rotate the globe around the X and Y axes (`mouseDragged`).
 */
class Home extends Screens {
  private HeightMapEarth earth;
  float angle = 0;
  PImage imageLogo;
  float angleX,angleY;
  private PFont text;
  Home(color backgroundColor, String screenText) {
    super(backgroundColor, screenText);
    earth = new HeightMapEarth();
    imageLogo = loadImage("PlaneWatcherLogo-removebg-preview.png");
  }
  void draw() {
    angle += 1;
    super.draw();
    pushStyle();
    pushMatrix();
    translate(540, 400, 100);
    directionalLight(255, 250, 245, -0.9, 0.7, 0);
    rotateX(angleX);
    rotateY(angleY);
    rotateY(radians(200+angle));
    earth.draw();
    popMatrix();
    popStyle();

    hint(DISABLE_DEPTH_TEST);
    pushStyle();
    lights();
    image(imageLogo, 190, 270, 300, 300);
    text = createFont("Aachen Bold.ttf", 20);
    textFont(text);
    fill(100, 200);
    text("Group 15: Ayush, Shuban, Brian, Abdul, Thai, Patrick", 127, 642);
    fill(18, 188, 252);
    text("Group 15: Ayush, Shuban, Brian, Abdul, Thai, Patrick", 125, 640);
    popStyle();
    hint(ENABLE_DEPTH_TEST);
  }
  void mouseDragged(){
    angleX += (pmouseY - mouseY) * 0.01;
    angleY -= (pmouseX - mouseX) * 0.01;
  }
}
