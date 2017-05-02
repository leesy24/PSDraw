//final boolean PRINT_ScreenFunc = true; 
final boolean PRINT_ScreenFunc = false; 

// Define minimum screen width and height.
final int MIN_SCREEN_WIDTH = 640;
final int MIN_SCREEN_HEIGHT = 480;

// Define default screen width and height.
//int SCREEN_WIDTH = 1920;
//int SCREEN_HEIGHT = 1080;
int SCREEN_WIDTH = 1024;
int SCREEN_HEIGHT = 768;

// Define just font height variables.
int FONT_HEIGHT;

// Define just text area margin variables.
int TEXT_MARGIN;

void screen_settings() {
  // Defines the dimension of the display window width and height in units of pixels.
  size(SCREEN_WIDTH, SCREEN_HEIGHT);
}

void screen_setup() {
  // Set text margin to follow screen Width
  TEXT_MARGIN = SCREEN_WIDTH / 200;

  // Set font height of text to follow screen Height
  FONT_HEIGHT = SCREEN_HEIGHT / 60;
  textSize(FONT_HEIGHT);
}

boolean screen_check_update() {
  // Check screen size changed.
  if (SCREEN_WIDTH != width || SCREEN_HEIGHT != height)
  {
/*
    if (width < MIN_SCREEN_WIDTH || height < MIN_SCREEN_HEIGHT) {
      if (PRINT_ScreenFunc) println("screen size changed too small! width " + SCREEN_WIDTH + "->" + width + ", height " + SCREEN_HEIGHT + "->" + height);
      if (width < MIN_SCREEN_WIDTH) {
        SCREEN_WIDTH = MIN_SCREEN_WIDTH;
      }
      if (height < MIN_SCREEN_HEIGHT) {
        SCREEN_HEIGHT = MIN_SCREEN_HEIGHT;
      }
      surface.setSize(SCREEN_WIDTH, SCREEN_HEIGHT);
      return true;
    }
*/
    if (PRINT_ScreenFunc) println("screen size changed! width " + SCREEN_WIDTH + "->" + width + ", height " + SCREEN_HEIGHT + "->" + height);
    SCREEN_WIDTH = width;
    SCREEN_HEIGHT = height;
    return true;
  }
  return false;
}