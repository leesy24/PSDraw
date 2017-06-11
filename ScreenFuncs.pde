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
//int SCREEN_WIDTH = 640;
//int SCREEN_HEIGHT = 480;


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
  if (FONT_HEIGHT < 12) FONT_HEIGHT = 12;
  if (PRINT_ScreenFunc) println("FONT_HEIGHT=" + FONT_HEIGHT);
  textSize(FONT_HEIGHT);
}

boolean screen_check_update() {
  int new_width, new_height;

  //println("screen size width=" + width + ", height=" + height);
  
  // Check screen size changed.
  if (SCREEN_WIDTH != width || SCREEN_HEIGHT != height) {
    new_width = width;
    new_height = height;
    if (PRINT_ScreenFunc) println("screen size changed! width " + SCREEN_WIDTH + "->" + new_width + ", height " + SCREEN_HEIGHT + "->" + new_height);

    // Check screen size too small.
    if (new_width < MIN_SCREEN_WIDTH || new_height < MIN_SCREEN_HEIGHT) {
      if (PRINT_ScreenFunc) println("screen size changed too small! width " + new_width + ", height " + new_height);
      
      if (new_width < MIN_SCREEN_WIDTH && new_height < MIN_SCREEN_HEIGHT) {
        new_width = MIN_SCREEN_WIDTH;
        new_height = MIN_SCREEN_HEIGHT;
      }
      else if (new_width < MIN_SCREEN_WIDTH) {
        new_width = MIN_SCREEN_WIDTH;
      }
      else if (new_height < MIN_SCREEN_HEIGHT) {
        new_height = MIN_SCREEN_HEIGHT;
      }
      surface.setSize(new_width, new_height);
    }
  
    //println("old GRID_OFFSET_X=" + GRID_OFFSET_X + ", GRID_OFFSET_Y=" + GRID_OFFSET_Y);
    if (ROTATE_FACTOR == 0) { // OK
      GRID_OFFSET_X = int(GRID_OFFSET_X - (float(SCREEN_WIDTH)  / 2.0) + (float(new_width)  / 2.0));
    }
    else if (ROTATE_FACTOR == 90) { // OK
      GRID_OFFSET_Y = int(GRID_OFFSET_Y - (float(SCREEN_HEIGHT) / 2.0) + (float(new_height) / 2.0));
    }
    else if (ROTATE_FACTOR == 180) { // OK
      GRID_OFFSET_X = int(GRID_OFFSET_X + (float(SCREEN_WIDTH)  / 2.0) - (float(new_width)  / 2.0));
    }
    else /*if (ROTATE_FACTOR == 270)*/ { // OK
      GRID_OFFSET_Y = int(GRID_OFFSET_Y + (float(SCREEN_HEIGHT) / 2.0) - (float(new_height) / 2.0));
    }
    //println("new GRID_OFFSET_X=" + GRID_OFFSET_X + ", GRID_OFFSET_Y=" + GRID_OFFSET_Y);
    SCREEN_WIDTH = new_width;
    SCREEN_HEIGHT = new_height;

    config_save();

    return true;
  }

  return false;
}