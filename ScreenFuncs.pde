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
  // Set text margin to follow min(Width, Height) of screen.
  TEXT_MARGIN = (SCREEN_WIDTH < SCREEN_HEIGHT) ? (SCREEN_WIDTH / 200) : (SCREEN_HEIGHT / 200);
  if (PRINT_ScreenFunc) println("TEXT_MARGIN=" + TEXT_MARGIN);

  // Set font height of text to follow min(Width, Height) of screen.
  FONT_HEIGHT = (SCREEN_WIDTH < SCREEN_HEIGHT) ? (SCREEN_WIDTH / 60) : (SCREEN_HEIGHT / 60);
  if (FONT_HEIGHT > 15) FONT_HEIGHT = 15;
  if (FONT_HEIGHT < 10) FONT_HEIGHT = 10;
  if (PRINT_ScreenFunc) println("FONT_HEIGHT=" + FONT_HEIGHT);
  textSize(FONT_HEIGHT);
}

boolean screen_check_update() {
  //println("screen size width=" + width + ", height=" + height);
  
  // Check screen size changed.
  if (SCREEN_WIDTH != width || SCREEN_HEIGHT != height) {
    if (PRINT_ScreenFunc) println("screen size changed! width " + SCREEN_WIDTH + "->" + width + ", height " + SCREEN_HEIGHT + "->" + height);
    SCREEN_WIDTH = width;
    SCREEN_HEIGHT = height;
    return true;
  }

  // Check screen size too small.
  if (width < MIN_SCREEN_WIDTH || height < MIN_SCREEN_HEIGHT) {
    if (PRINT_ScreenFunc) println("screen size changed too small! width " + width + ", height " + height);
    if (width < MIN_SCREEN_WIDTH) {
      SCREEN_WIDTH = MIN_SCREEN_WIDTH;
    }
    if (height < MIN_SCREEN_HEIGHT) {
      SCREEN_HEIGHT = MIN_SCREEN_HEIGHT;
    }
    surface.setSize(SCREEN_WIDTH, SCREEN_HEIGHT);
    return true;
  }
  
  return false;
}