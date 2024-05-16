import processing.core.*;

/**
 * DropDownMenu class provides a user interface element for selecting options from a list. - Thai
 * 
 * This class utilizes the ControlP5 library to create a dropdown menu within a Processing (PApplet) sketch.
 * It manages the visual state (open/closed), selected option, hover state, and scrolling behavior for the menu.
 */
public class DropDownMenu {
  PApplet parent;
  float x, y;
  float w, h;
  String[] options;
  String dataOption = null;
  boolean isOpen = false;
  int selectedIndex = -1;
  int hoverIndex = -1;
  int maxDisplayedOptions = 5;
  int scrollOffset = 0;

/**
 * DropDownMenu constructor that initializes the menu with provided parameters.
 *
 * @param p A reference to the parent Processing (PApplet) sketch.
 * @param x X-coordinate of the top-left corner of the menu.
 * @param y Y-coordinate of the top-left corner of the menu.
 * @param w Width of the menu.
 * @param h Height of the menu.
 * @param options An array of Strings representing the available options in the dropdown menu.
 */
  public DropDownMenu(PApplet p, float x, float y, float w, float h, String[] options) {
    parent = p;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.options = options;
  }

/**
 * Draws the dropdown menu on the screen, handling visual elements and interaction.
 *
 * This method performs the following tasks:
 *  1. Sets the text size for the menu options.
 *  2. Changes the background color based on mouse hover (lighter color when hovering).
 *  3. Draws a rectangle for the menu background.
 *  4. Displays the selected option text or a default "Select data" message.
 *  5. If the menu is open (based on `isOpen` flag):
 *      - Calculates the number of options to display based on `maxDisplayedOptions` and scrolling.
 *      - Loops through the visible options:
 *          - Draws a rectangle for each option.
 *          - Changes the background color based on hover state (lighter color when hovering).
 *          - Displays the text for each option.
 */
  public void draw() {

    textSize(15);
    if (mouseX > x && mouseX < x + w &&
      mouseY > y && mouseY < y + h) {
      fill(color(0)+100);
    } else {
      parent.fill(0);
    }
    parent.rect(x, y, w, h);
    noStroke();
    parent.fill(255);
    parent.textAlign(PConstants.LEFT, PConstants.CENTER);
    if (selectedIndex == -1) {
      parent.text("Select data", x + 10, y + h / 2);
    } else {
      parent.text(options[selectedIndex], x + 10, y + h / 2);
    }
    
    // Restricts the amount of displayed options when dropdown is clicked.
    if (isOpen) {
      int numDisplayedOptions = Math.min(options.length - scrollOffset, maxDisplayedOptions);
      for (int i = 0; i < numDisplayedOptions; i++) {
        float optionY = y + h * (i + 1);
        if (i + scrollOffset == hoverIndex) {
          parent.fill(200);
        } else {
          parent.fill(255);
        }
        parent.rect(x, optionY, w, h);
        parent.fill(0);
        parent.textAlign(PConstants.LEFT, PConstants.CENTER);
        parent.text(options[i + scrollOffset], x + 10, optionY + h / 2);
      }
    }
  }
  
  // Toggles the dropdown to be open or not open.
  public void toggle() {
    isOpen = !isOpen;
  }

  // When dropdown is open, returns selected option.
  public void selectOption() {
    if (isOpen) {
      for (int i = 0; i < options.length; i++) {
        float optionY = y + h * (i + 1);
        if (mouseY > optionY && mouseY < optionY + h) {
          selectedIndex = i + scrollOffset;
          isOpen = false;
          break;
        }
      }
    }
  }
  
/**
 * Updates the hover state of the dropdown menu based on the provided mouse Y-coordinate.
 *
 * This method is likely called when the mouse is moved to update the visual indication of which option is being hovered over.
 *  - If the menu is open (`isOpen` is true):
 *      - Resets the `hoverIndex` to -1 (assuming no hover initially).
 *      - Calculates the number of visible options based on `maxDisplayedOptions` and scrolling.
 *      - Loops through the visible options:
 *          - Checks if the mouse Y-coordinate is within the bounds of the current option.
 *          - If there's a match, sets the `hoverIndex` to the corresponding option index (including scroll offset).
 *          - Breaks out of the loop since only one option can be hovered at a time.
 */

  public void updateHover(int mouseY) {
    if (isOpen) {
      hoverIndex = -1; // Reset hover index
      int numDisplayedOptions = Math.min(options.length - scrollOffset, maxDisplayedOptions);
      for (int i = 0; i < numDisplayedOptions; i++) {
        float optionY = y + h * (i + 1);
        if (mouseY > optionY && mouseY < optionY + h) {
          hoverIndex = i + scrollOffset; // Set hover index if mouse is over option
          break;
        }
      }
    }
  }
  
  // Scrolls through the tabs of options in the dropdown.
  public void scroll(int delta) {
    scrollOffset = PApplet.constrain(scrollOffset + delta, 0, PApplet.max(0, options.length - maxDisplayedOptions));
  }
  
  //Returns selected option.
  public String getSelectedOption() {
    if (selectedIndex != -1) {
      dataOption = options[selectedIndex];
      return options[selectedIndex];
    } else {
      return null;
    }
  }
  
  // Sets the options to whatever dropdown is pressed.
  public void setOptions(String[] newOptions) {
    options = newOptions;
    selectedIndex = -1;
    scrollOffset = 0;
  }
  
  // Updates hover based on mouse movement.
  public void mouseMoved() {
    updateHover(mouseY);
  }

  // Scrolls through the available options when mousewheel is scrolled. 
  public void mouseWheel(MouseEvent event) {
    int delta = event.getCount();

    scroll(delta);
  }
  
  // Gets selected option when mouse is pressed.
  public void mousePressed() {
    if (mouseX > x && mouseX < x + w &&
      mouseY > y && mouseY < y + h) {
      toggle();
    } else {
      selectOption();
    }
  }
}
