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
  TEXT_MARGIN = SCREEN_WIDTH / 200;

  // Set font height of text to follow screen Height
  FONT_HEIGHT = SCREEN_HEIGHT / 60;
  textSize(FONT_HEIGHT);
}

boolean screen_check_update() {
  if (SCREEN_WIDTH != width || SCREEN_HEIGHT != height)
  {
    if (PRINT) println("screen size changed! width " + SCREEN_WIDTH + "->" + width + ", height " + SCREEN_HEIGHT + "->" + height);
    SCREEN_WIDTH = width;
    SCREEN_HEIGHT = height;

    return true;
  }
  return false;
}