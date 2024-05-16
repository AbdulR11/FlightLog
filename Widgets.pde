/**
 * Widget class represents a basic interactive element displayed on the application screens.
 *
 * This class defines the properties and structure of a generic widget used across all screens.
 * Each widget has properties like position, size, label, color, font, and an associated event code.
 *
 * -Patrick
 */
class Widget {
  int x, y, Width, Height;
  String label;
  int event;
  color widgetColor, labelColor, borderColor;
  PFont widgetFont;

  Widget(int x, int y, int Width, int Height, String label,
    color widgetColor, PFont widgetFont, int event) {
    this.x=x;
    this.y=y;
    this.Width = Width;
    this.Height= Height;
    this.label=label;
    this.event=event;
    this.widgetColor=widgetColor;
    this.widgetFont=widgetFont;
    labelColor= color(255);
    borderColor = defaultBorderColor;
  }
  /**
 * Draws the widget on the screen and handles its visual appearance based on mouse interaction.
 *
 * This method likely performs the following tasks:
 *  - Fills the widget with its background color (`widgetColor`).
 *  - Changes the fill color slightly to a brighter shade if the mouse is hovering over the widget.
 *  - Draws a rectangle for the widget body.
 *  - Draws the widget label using the specified font (`widgetFont`).
 *  - Depending on the widget label (e.g., "Flight Logs", "Graphs", "Home", "Maps"):
 *      - Draws custom icons or shapes to represent the widget's functionality.
 *  - Fills a black rectangle behind the widget text to ensure proper contrast.
 *
 * @-Patrick
   */
  void draw() {
    fill(widgetColor);
    stroke(0);
    if(isMouseOver(mouseX, mouseY)){
      fill(widgetColor +100);
    }else{
    fill(widgetColor);}
    rect(x, y, Width, Height);
    noStroke();
    fill(0);
    switch(label){
      case "Flight Logs":
      push();
      stroke(255);
      strokeWeight(2.5);
      line(515.5 + 100 -20, 114, 520 + 100 -20, 120);
      ellipse(510.5 + 100 -20, 110, 10,10);
      pop();
      break;
      case "Graphs":
      push();
      fill(255);
      rect(105 + 100 -18, 115, 3, 5);
      rect(112 + 100 -18, 110, 3, 10);
      rect(119 + 100 -18, 105, 3, 15);
      rect(105 + 100 -18, 123, 18, 2);
      pop();
      break;
      case "Home":
      push();
      stroke(255);
      strokeWeight(3);
      fill(255);
      line(720+ 100 -25, 105, 710 + 100 -25, 110);
      line(730 + 100 -25, 110, 720 + 100 -25, 105);
      pop();
      push();
      stroke(255);
      strokeWeight(2.5);
      line(710 + 100 -25, 110, 710 + 100 -25, 120);
      line(729 + 100 -25, 110, 729 + 100 -25, 120);
      line(710 + 100 -25,120, 729 + 100 -25, 120);
      popMatrix();
      break;
      case "Maps":
      push();
      stroke(255);
      strokeWeight(2.5);
      circle(322 + 100 -20, 115, 20);
      pop();
      push();
      stroke(255);
      strokeWeight(2);
      line(312 + 100 -20, 115, 332 + 100 -20, 115);
      line(320 +2.5 + 100 -20 , 108, 320 +2.5 + 100 -20, 122);
      pop();
      break;
    }
    noStroke();
    fill(0);
    rect(100, 160, 800, 500);
  }
  
  //Gets an event when a specific widget is pressed.-Patrick
  int getEvent(int mX, int mY) {
    if (mX > x && mX < x + Width && mY > y && mY < y + Height) {
      return event;
    }
    return EVENT_NULL;
    
  }

  //Is used to check if the mouse is over the widget.-Patrick
  boolean isMouseOver(int mX, int mY) {
    return (mX > x && mX < x + Width && mY > y && mY < y + Height);
  }

  void setBorderColor(color newColor) {
    borderColor = newColor;
  }
}
