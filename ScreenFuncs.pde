import java.awt.Dimension;

//final static boolean PRINT_SCREENFUNC_DBG_ALL = true;
final static boolean PRINT_SCREENFUNC_DBG_ALL = false;

// Define minimum screen width and height.
final static int MIN_SCREEN_WIDTH = 100;
final static int MIN_SCREEN_HEIGHT = 100;

static int SCREEN_BORDER_WIDTH = 4; //8;
static int SCREEN_TITLE_HEIGHT = 27; //31;

static int SCREEN_X_OFFSET = 1; //3;
static int SCREEN_Y_OFFSET = 1; //5;


// Define default screen x, y, width and height.
static int SCREEN_x = 0;
static int SCREEN_y = 0;
//static int SCREEN_width = 1920;
//static int SCREEN_height = 1080;
//static int SCREEN_width = 1024;
//static int SCREEN_height = 768;
static int SCREEN_width = 640;
static int SCREEN_height = 480;

static float SCREEN_x_ratio = 0.0;
static float SCREEN_y_ratio = 0.0;
static float SCREEN_width_ratio = 0.5;
static float SCREEN_height_ratio = 0.5;


// Define just font height variables.
int FONT_HEIGHT;

// Define just text area margin variables.
int TEXT_MARGIN;
PFont SCREEN_PFront;

void screen_settings() {
  //println("getContentPane()=", getJFrame(surface).getContentPane());
  // Defines the dimension of the display window width and height in units of pixels.
  SCREEN_x = int(displayWidth * SCREEN_x_ratio) + SCREEN_X_OFFSET;
  //if(SCREEN_x >= SCREEN_BORDER_WIDTH) SCREEN_x += SCREEN_BORDER_WIDTH;
  SCREEN_y = int(displayHeight * SCREEN_y_ratio) + SCREEN_Y_OFFSET;
  //if(SCREEN_y >= SCREEN_TITLE_HEIGHT)  SCREEN_y += SCREEN_TITLE_HEIGHT/2;
  SCREEN_width = int(displayWidth * SCREEN_width_ratio) - SCREEN_BORDER_WIDTH * 2;
  SCREEN_height = int(displayHeight * SCREEN_height_ratio) - (SCREEN_TITLE_HEIGHT + SCREEN_BORDER_WIDTH);
  
  if(PRINT_SCREENFUNC_DBG_ALL) println("displayWidth="+displayWidth+",displayHeight="+displayHeight);
  if(PRINT_SCREENFUNC_DBG_ALL) println("SCREEN_x="+SCREEN_x+",SCREEN_y="+SCREEN_y+",SCREEN_width="+SCREEN_width+",SCREEN_height="+SCREEN_height);
  size(SCREEN_width, SCREEN_height);
}

/*
boolean SCREEN_surface_set = false; // Needs to set one time.
*/
void screen_setup()
{
/*
  if(!SCREEN_surface_set)
  {
    // This is only pertains to the desktop version of Processing (not JavaScript or Android),
    //  because it's the only one to use windows and frames.
    // It's possible to make the window resizable.
    surface.setResizable(true);
    surface.setLocation(SCREEN_x, SCREEN_y);
    SCREEN_surface_set = true;
  }
*/
  // Set text margin to follow min(Width, Height) of screen.
  TEXT_MARGIN = (SCREEN_width < SCREEN_height) ? (SCREEN_width / 200) : (SCREEN_height / 200);
  if (PRINT_SCREENFUNC_DBG_ALL) println("TEXT_MARGIN=" + TEXT_MARGIN);

  // Set font height of text to follow min(Width, Height) of screen.
  FONT_HEIGHT = (SCREEN_width < SCREEN_height) ? (SCREEN_width / 60) : (SCREEN_height / 60);
  if (FONT_HEIGHT > 15) FONT_HEIGHT = 15;
  if (FONT_HEIGHT < 10) FONT_HEIGHT = 10;
  if (PRINT_SCREENFUNC_DBG_ALL) println("FONT_HEIGHT=" + FONT_HEIGHT);
  textSize(FONT_HEIGHT);
}

/*
static final javax.swing.JFrame getJFrame(final PSurface surf) {
  return
    (javax.swing.JFrame)
    ((processing.awt.PSurfaceAWT.SmoothCanvas)
    surf.getNative()).getFrame();
}
*/

boolean screen_check_update()
{
  boolean updated = false;

/*
  javax.swing.JFrame f;
  
  f = getJFrame(surface);
  //f.pack();
  // This is not the actual-sized frame. get the actual size
  //Dimension actualSize = getJFrame(getSurface()).getContentPane().getSize();
  Dimension actualSize = f.getContentPane().getSize();
  //Dimension actualSize = frame.getContentPane().getSize();
  
  //println("border=" + SCREEN_width, actualSize.width + "," + SCREEN_height, actualSize.height);
*/
/*
  int new_x = 0, new_y = 0;
  new_x = getJFrame(surface).getX();
  new_y = getJFrame(surface).getY();
  //new_x = getJFrame(getSurface()).getX();
  //new_y = getJFrame(getSurface()).getY();
  //new_x = surface.getLocation();
  //new_y = surface.getLocation();
  //new_x = frame.getX();
  //new_y = frame.getY();
  //new_x = surface.getNative().getFrame().getX();
  //new_y = surface.getLocationOnScreen().y;
  //if(PRINT_SCREENFUNC_DBG_ALL) println("screen pos xy saved(" + SCREEN_x + ",y=" + SCREEN_y + ") new(" + new_x + ",y=" + new_y + ")");
  if(PRINT_SCREENFUNC_DBG_ALL) println("display wh(" + displayWidth + ",y=" + displayHeight + ")");
  // Check screen position x or y changed.
  if(new_x != SCREEN_x || new_y != SCREEN_y) {
    if(new_x < 0 || new_y < 0) {
      if(new_x < 0) new_x = 0;
      if(new_y < 0) new_y = 0;
      surface.setLocation(new_x, new_y);
    }
    SCREEN_x = new_x;
    SCREEN_y = new_y;

    updated = true;
  }
*/

  int new_width, new_height;
  if(PRINT_SCREENFUNC_DBG_ALL) println("screen size width=" + width + ", height=" + height);
  // Check screen size changed.
  if (SCREEN_width != width || SCREEN_height != height) {
    new_width = width;
    new_height = height;
    if (PRINT_SCREENFUNC_DBG_ALL) println("screen size changed! width " + SCREEN_width + "->" + new_width + ", height " + SCREEN_height + "->" + new_height);

    // Check screen size too small.
    if (new_width < MIN_SCREEN_WIDTH || new_height < MIN_SCREEN_HEIGHT) {
      if (PRINT_SCREENFUNC_DBG_ALL) println("screen size changed too small! width " + new_width + ", height " + new_height);
      
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
      if(PRINT_SCREENFUNC_DBG_ALL) println("surface.setSize(new_width=" + new_width + ", new_height=" + new_height + ")");
      surface.setSize(new_width, new_height);
    }
  
    //println("old GRID_OFFSET_X=" + GRID_OFFSET_X + ", GRID_OFFSET_Y=" + GRID_OFFSET_Y);
    if (ROTATE_FACTOR == 0)
    { // OK
      GRID_OFFSET_X = int(GRID_OFFSET_X - (float(SCREEN_width)  / 2.0) + (float(new_width)  / 2.0));
    }
    else if (ROTATE_FACTOR == 90)
    { // OK
      GRID_OFFSET_Y = int(GRID_OFFSET_Y - (float(SCREEN_height) / 2.0) + (float(new_height) / 2.0));
    }
    else if (ROTATE_FACTOR == 180)
    { // OK
      GRID_OFFSET_X = int(GRID_OFFSET_X + (float(SCREEN_width)  / 2.0) - (float(new_width)  / 2.0));
    }
    else //if (ROTATE_FACTOR == 270)
    { // OK
      GRID_OFFSET_Y = int(GRID_OFFSET_Y + (float(SCREEN_height) / 2.0) - (float(new_height) / 2.0));
    }
    //println("new GRID_OFFSET_X=" + GRID_OFFSET_X + ", GRID_OFFSET_Y=" + GRID_OFFSET_Y);
    SCREEN_width = new_width;
    SCREEN_height = new_height;

    updated = true;
  }

/*
  if(updated) {
    config_save();
  }
*/

  return updated;
}