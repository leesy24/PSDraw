// Define to enable or disable the log print in console.
//final boolean PRINT = true; 
final boolean PRINT = false; 

int DATA_interface = 1; // 0 = File, 1 = UART

//final color C_BG = #FFFFFF; // White
final color C_BG = #F8F8F8; // White - 0x8
final color C_TEXT = #000000; // Black

// Define window title string.
String Title = "DASAN-InfoTEK - PSDraw - ";

// Define zoom factor variables.
float ZOOM_FACTOR = 100;

// Define rotate factor variables.
float ROTATE_FACTOR = /*0;*/90;/*180;*//*270;*/

// Define mirror variables.
boolean MIRROR_ENABLE = false;

// The settings() function is new with Processing 3.0. It's not needed in most sketches.
// It's only useful when it's absolutely necessary to define the parameters to size() with a variable. 
void settings() {
  screen_settings();
}

// The setup() function is run once, when the program starts.
// It's used to define initial enviroment properties such as screen size
//  and to load media such as images and fonts as the program starts.
// There can only be one setup() function for each program
//  and it shouldn't be called again after its initial execution.
void setup() {
/*
  // fullScreen() opens a sketch using the full size of the computer's display.
  // This function must be the first line in setup().
  // The size() and fullScreen() functions cannot both be used in the same program,
  //  just choose one.
  fullScreen();

  // Assign full screen width and height
  SCREEN_WIDTH = width;
  SCREEN_HEIGHT = height;
*/

  // This is only pertains to the desktop version of Processing (not JavaScript or Android),
  //  because it's the only one to use windows and frames.
  // It's possible to make the window resizable.
  surface.setResizable(true);

  // To set the background on the first frame of animation. 
  background(C_BG);
  // Specifies the number of frames to be displayed every second. 
  frameRate(30);

  data_setup();

  screen_setup();
  button_setup();

  // Set window title
  surface.setTitle(Title);
}

// Called directly after setup()
//  , the draw() function continuously executes the lines of code contained inside
//  its block until the program is stopped or noLoop() is called. draw() is called automatically
//  and should never be called explicitly.
// All Processing programs update the screen at the end of draw(), never earlier.
void draw() {

  // Ready to draw from here!
  // To clear the display window at the beginning of each frame,
  background(C_BG);

  if (screen_check_update()) {
    //data_setup();
    screen_setup();
    button_setup();
  }

  grid_draw();

  button_update();
  button_draw();

  colorbar_draw();

  if (PS_Data.load() == true) {
    if (PS_Data.parse() == false) {
      return;
    }
  }
  PS_Data.draw_params();
  PS_Data.draw_points();

  bubbleinfo_draw();
  colorbar_info_draw();
} 