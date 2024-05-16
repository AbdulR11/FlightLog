/**
 * ImageMarker class extends AbstractMarker (from unfolding library) to create a visual marker on a map using an image and text.
 *
 * This class inherits properties and functionality from the AbstractMarker class. It adds the following features:
 *  - Stores an image (`img`) to be displayed as the marker icon.
 *  - Stores text (`text`) to be displayed below the image.
 *  - Stores text color (`textColor`). (Color definition likely happens elsewhere).
 *  - Stores latitude and longitude for marker positioning on a map (assuming used with a map library).
 *  - In the constructor `ImageMarker(Location location, PImage img, String text)`:
 *      - Initializes inherited properties from AbstractMarker (likely location).
 *      - Sets the provided image (`img`) and text (`text`) for this marker.
 *  - In the `draw(PGraphics pg, float x, float y)` method:
 *      - Pushes a style matrix to isolate changes made within this method.
 *      - Sets the image mode to `CORNER` for positioning from the top-left corner.
 *      - Draws the image (`img`) at the specified coordinates (`x-11`, `y-37`) with an offset.
 *      - Sets the text style:
 *          - Text color (`textColor`).
 *          - Text size (20 pixels).
 *          - Text alignment (centered horizontally, positioned below the image).
 *      - Draws the text (`text`) at the specified coordinates (`x`, `y-40`) with an offset.
 *      - Pops the style matrix to restore previous styling.
 *  - In the `isInside(float checkX, float checkY, float x, float y)` method (likely for hit detection):
 *      - Checks if a given point (`checkX`, `checkY`) falls within the image bounds (`x` to `x+width`, `y` to `y+height`).
 *      - Returns true if the point is inside the image marker, false otherwise. (This might be used for user interaction).
 */
import de.fhpotsdam.unfolding.marker.AbstractMarker;
import processing.core.PConstants;
import processing.core.PGraphics;
import processing.core.PImage;

public class ImageMarker extends AbstractMarker {

  PImage img;
  String text;
  int textColor; 
  float latitude;
  float longitude;

  public ImageMarker(Location location, PImage img, String text) {
    super();
    this.location = location;
    this.img = img;
    this.text = text;
  }

  public void draw(PGraphics pg, float x, float y) {
    pg.pushStyle();
    pg.imageMode(PConstants.CORNER);
    pg.image(img, x - 11, y - 37);
    pg.fill(0);
    pg.textSize(20);
    pg.textAlign(PConstants.CENTER, PConstants.BOTTOM);
    pg.text(text, x, y - 40);
    pg.popStyle();
  }

  protected boolean isInside(float checkX, float checkY, float x, float y) {
    return checkX > x && checkX < x + img.width && checkY > y && checkY < y + img.height;
  }
}
