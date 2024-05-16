/**
 * ArrowWidget represents a clickable arrow on the screen for user interaction.
 * 
 * Extends the base Widget class and inherits common properties like position, size, label, and color.
 * This class specifically defines properties for an arrow:
 *  - Arrow dimensions (width and height)
 *  - Direction (left or right)
 * 
 * Provides methods for:
 *  - Drawing the arrow shape (shaft and triangle head) on the screen. - Abdul 
 */
class ArrowWidget extends Widget
{
  int arrowWidth = 215;
  int arrowHeight = 400;
  int marginRight = 20;
  int windowWidth = 1024;
  int windowHeight = 780;

  String direction;

// Constructor: Calls the parent constructor and sets the arrow's direction.
  ArrowWidget(int x, int y, int width, int height, String label, color widgetColor, PFont widgetFont, int event, String direction)
  {
    super(x, y, width, height, label, widgetColor, widgetFont, event);
    this.direction = direction;
  }

  void draw() {
    strokeWeight(5);
    stroke(255);
    fill(255);

//positions of the arrow
    int shaftY = 400;
    int headBaseStartX = direction.equals("left") ? 150 : 850;
    int headBaseEndX = direction.equals("left") ? 135 : 870;
    int headY = 400;

 // Draws a triangle representing the arrowhead on the screen
    triangle(headBaseStartX, shaftY - 5, headBaseEndX, headY, headBaseStartX, shaftY + 5);
  }
}
