// Define to enable or disable the log print in console.
//final boolean PRINT = true; 
final boolean PRINT = false; 

// Define screen width and height.
//int SCREEN_WIDTH = 1920;
//int SCREEN_HEIGHT = 1080;
int SCREEN_WIDTH = 1024;
int SCREEN_HEIGHT = 768;

// Define just font height variables.
int FONT_HEIGHT;

// Define just text area margin variables.
int TEXT_MARGIN;

// Define zoom factor variables.
float ZOOM_FACTOR = 100;

// Define rotate factor variables.
float ROTATE_FACTOR = 90;

// Define mirror variables.
boolean MIRROR_ENABLE = false;

// Get OS Name
final String OS = System.getProperty("os.name");

// Define default binary data filename and path 
String FILENAME = "data.bin";

// Define data array to load binary data
byte data[]; 

// Define old time stamp to check time stamp changed for detecting data changed or not
long old_time_stamp = -1;

int button_zoom_minus_x, button_zoom_minus_y;      // Position of square button zoom minus
int button_zoom_minus_width, button_zoom_minus_height;     // Diameter of rect
boolean button_zoom_minus_over = false;
int button_zoom_pluse_x, button_zoom_pluse_y;      // Position of square button zoom pluse
int button_zoom_pluse_width, button_zoom_pluse_height;     // Diameter of rect
boolean button_zoom_pluse_over = false;
int button_rotate_ccw_x, button_rotate_ccw_y;      // Position of square button rotate counter clock-wise
int button_rotate_ccw_width, button_rotate_ccw_height;     // Diameter of rect
boolean button_rotate_ccw_over = false;
int button_rotate_cw_x, button_rotate_cw_y;      // Position of square button rotate clock-wise
int button_rotate_cw_width, button_rotate_cw_height;     // Diameter of rect
boolean button_rotate_cw_over = false;
int button_mirror_en_x, button_mirror_en_y;      // Position of square button mirror enable
int button_mirror_en_width, button_mirror_en_height;     // Diameter of rect
boolean button_mirror_en_over = false;
color button_highlight;
color button_color, button_base_color;

// The settings() function is new with Processing 3.0. It's not needed in most sketches.
// It's only useful when it's absolutely necessary to define the parameters to size() with a variable. 
void settings() {
  // Defines the dimension of the display window width and height in units of pixels.
  size(SCREEN_WIDTH, SCREEN_HEIGHT);
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

  // Check OS
  if (OS.equals("Linux")) {
    // Define binary data filename and path for Linux OS
    FILENAME = "/tmp/data.bin";
  }
  // Assume Windows OS 
  else {
    // Define binary data filename and path for Windows OS
    //FILENAME = "C:\\work\\git\\PSDemoProgram\\Release-windows\\data.bin";
    FILENAME = "C:\\Temp\\data.bin";
  }

  // To set the background on the first frame of animation. 
  background(0);
  // Specifies the number of frames to be displayed every second. 
  frameRate(30);

  TEXT_MARGIN = SCREEN_WIDTH / 200;

  // Set font height of text to follow screen Height
  FONT_HEIGHT = SCREEN_HEIGHT / 60;
  textSize(FONT_HEIGHT);

  button_setup();
}

// Called directly after setup()
//  , the draw() function continuously executes the lines of code contained inside
//  its block until the program is stopped or noLoop() is called. draw() is called automatically
//  and should never be called explicitly.
// All Processing programs update the screen at the end of draw(), never earlier.
void draw() {
  String func;
  int len;
  int n_params;
  int i_scan = 0;
  int time_stamp = 0;
  float scan_angle_start = 0;
  float scan_angle_range = 0;
  int n_echos = 0;
  int i_encoder = 0;
  float temperature = 0;
  int status = 0;
  int content = 0;
  int n_points = 0;
  int distance;
  int pulse_width;
  int crc;
  int i = 0; // index for navigating data.
  String string;

  // Ready to draw from here!
  // To clear the display window at the beginning of each frame,
  background(0);

  // Check file exists to avoid exception error on loadBytes().
  File file = new File(FILENAME);
  if (file.exists() != true) {
    // Sets the color used to draw lines and borders around shapes.
    fill(255);
    stroke(255);
    string = "File not exist at " + FILENAME;
    textSize(FONT_HEIGHT*3);
    text(string, SCREEN_WIDTH / 2 - int(textWidth(string) / 2.0), SCREEN_HEIGHT / 2 - FONT_HEIGHT);
    textSize(FONT_HEIGHT);
    if (PRINT) println("File not exist!:" + FILENAME);
    return;
  }

  // Load binary data.
  data = loadBytes(FILENAME);
  if (PRINT) println("data.length = " + data.length);
  // Check binary data length is valid.
  // Must larger than Function code(4B) + Length(4B) + Number of parameters(4B) + Number of points(4B) + CRC(4B).
  if (data.length <= 4 + 4 + 4 + 4 + 4) {
    // Sets the color used to draw lines and borders around shapes.
    fill(255);
    stroke(255);
    string = "File size is invalid!: " + data.length;
    textSize(FONT_HEIGHT*3);
    text(string, SCREEN_WIDTH / 2 - int(textWidth(string) / 2.0), SCREEN_HEIGHT / 2 - FONT_HEIGHT);
    textSize(FONT_HEIGHT);
    if (PRINT) println("File size is invalid!:" + data.length);
    return;
  }

  // Get function code.
  func = str(char(data[i])) + str(char(data[i+1])) + str(char(data[i+2])) + str(char(data[i+3]));
  // Check function code is "GSCN".
  if (func.equals("GSCN") != true) {
    // Sets the color used to draw lines and borders around shapes.
    fill(255);
    stroke(255);
    string = "Function code is invalid!:" + func;
    textSize(FONT_HEIGHT*3);
    text(string, SCREEN_WIDTH / 2 - int(textWidth(string) / 2.0), SCREEN_HEIGHT / 2 - FONT_HEIGHT);
    textSize(FONT_HEIGHT);
    if (PRINT) println("Function code is invalid!:", func);
    return;
  }
  if (PRINT) println("index=" + i + ",func=" + func);
  i = i + 4;

  // Get data length.
  // : size of the following data record, without the CRC checksum
  len = get_int32_bytes(data, i);
  if (PRINT) println("index=" + i + ",length=" + len);
  i = i + 4;

  // Check data record length with binary data length
  if (data.length < (len + 12)) {
    // Sets the color used to draw lines and borders around shapes.
    fill(255);
    stroke(255);
    string = "Binary data length is invalid!:" + data.length + "," + len;
    textSize(FONT_HEIGHT*3);
    text(string, SCREEN_WIDTH / 2 - int(textWidth(string) / 2.0), SCREEN_HEIGHT / 2 - FONT_HEIGHT);
    textSize(FONT_HEIGHT);
    if (PRINT) println("Binary data length is invalid!:" + data.length + "," + len);
    return;
  }

  // TBD: Check CRC
  // ...

  // Get number of parameters.
  // : the number of following parameters. Becomes 0 if no scan is available.
  n_params = get_int32_bytes(data, i);
  if (PRINT) println("index=" + i + ",number of parameters=" + n_params);
  i = i + 4;

  if (n_params == 0) {
    // Sets the color used to draw lines and borders around shapes.
    fill(255);
    stroke(255);
    string = "No scan data is available!:Number of parameter is 0.";
    textSize(FONT_HEIGHT*3);
    text(string, SCREEN_WIDTH / 2 - int(textWidth(string) / 2.0), SCREEN_HEIGHT / 2 - FONT_HEIGHT);
    textSize(FONT_HEIGHT);
    if (PRINT) println("No scan data is available!:Number of parameter is 0.");
    return;
  }

  if (n_params >= 1) {
    // Get scan number(index).
    // : the number of the scan (starting with 1), should be the same as in the command request.
    i_scan = get_int32_bytes(data, i);
    if (PRINT) println("index=" + i + ",scan number=" + i_scan);
    i = i + 4;
  }

  if (n_params >= 2) {
    // Get time stamp.
    // : time stamp of the first measured point in the scan, given in milliseconds since the last SCAN command.
    time_stamp = get_int32_bytes(data, i);
    if (PRINT) println("index=" + i + ",time stamp=" + time_stamp);
    i = i + 4;
/*
    // Check time_stamp is changed
    if (old_time_stamp == time_stamp) {
      // Sets the color used to draw lines and borders around shapes.
      fill(255);
      stroke(255);
      string = "Scan data is not changed!:" + time_stamp;
      textSize(FONT_HEIGHT*3);
      text(string, SCREEN_WIDTH / 2 - int(textWidth(string) / 2.0), SCREEN_HEIGHT / 2 - FONT_HEIGHT);
      textSize(FONT_HEIGHT);
      if (PRINT) println("Scan data is not changed!:" + time_stamp);
      //return;
    }
    old_time_stamp = time_stamp;
*/
}

  grid_draw();

  button_update();
  button_draw();

  if (n_params >= 3) {
    // Get Scan start direction.
    // : direction to the first measured point, given in the user angle system (typical unit is 0,001 deg)
    scan_angle_start = get_int32_bytes(data, i) / 1000.0;
    if (PRINT) println("index=" + i + ",scan start angle=" + scan_angle_start);
    i = i + 4;
  }

  if (n_params >= 4) {
    // Get Scan angle
    // : the scan angle in the user angle system. Typically 90.000.
    scan_angle_range = get_int32_bytes(data, i) / 1000.0;
    if (PRINT) println("index=" + i + ",scan range angle=" + scan_angle_range);
    i = i + 4;
  }

  if (n_params >= 5) {
    // Get Number of echoes per point
    // : the number of echoes measured for each direction.
    n_echos = get_int32_bytes(data, i);
    if (PRINT) println("index=" + i + ",number of echos=" + n_echos);
    i = i + 4;
  }

  if (n_params >= 6) {
    // Get Incremental count
    // : a direction provided by an external incremental encoder.
    i_encoder = get_int32_bytes(data, i);
    if (PRINT) println("index=" + i + ",encoder value=" + i_encoder);
    i = i + 4;
  }

  if (n_params >= 7) {
    // Get system temperature
    // : the temperature as measured inside of the scanner.
    // : This information can be used to control an optional air condition.
    temperature = get_int32_bytes(data, i) / 10f;
    if (PRINT) println("index=" + i + ",system temperature=" + temperature);
    i = i + 4;
  }

  if (n_params >= 8) {
    // Get System status
    // : contains a bit field with about the status of peripheral devices.
    status = get_int32_bytes(data, i);
    if (PRINT) println("index=" + i + ",system status=" + status);
    i = i + 4;
  }

  if (n_params >= 9) {
    // Get Data content
    // : This parameter is built by the size of a single measurement record.
    // : It defines the content of the data section:
    //    o 4 Bytes: distances in 1/10 mm only.
    //    o 8 Bytes: distances in 1/10 mm and pulse widths in picoseconds
    //    o Any other value than 4 be read as "8 Bytes".
    content = get_int32_bytes(data, i);
    if (PRINT) println("index=" + i + ",data content=" + content);
    i = i + 4;
  }

  // Check number of parameters is larger than 9 such as unknown parameters.
  if (n_params > 9) {
    // Skip index for remained unknown parameters.
    i = i + 4 * (n_params - 9);
  }

  // Get Number of points
  // : the number of measurement points in the scan.
  n_points = get_int32_bytes(data, i);
  if (PRINT) println("index=" + i + ",number of points=" + n_points);
  i = i + 4;

  //params_draw();
  // Sets the color used to draw lines and borders around shapes.
  fill(255);
  stroke(255);
  string = "Scan number:" + i_scan;
  text(string, TEXT_MARGIN + FONT_HEIGHT * 3, TEXT_MARGIN + FONT_HEIGHT * 2);
  string = "Time stamp:" + time_stamp;
  //text(string, SCREEN_WIDTH - int(textWidth(string)) - 10, 10 + FONT_HEIGHT);
  text(string, TEXT_MARGIN + FONT_HEIGHT * 3, TEXT_MARGIN + FONT_HEIGHT * 3);
  string = "Scan start direction:" + scan_angle_start;
  text(string, TEXT_MARGIN + FONT_HEIGHT * 3, TEXT_MARGIN + FONT_HEIGHT * 4);
  string = "Scan angle range:" + scan_angle_range;
  text(string, TEXT_MARGIN + FONT_HEIGHT * 3, TEXT_MARGIN + FONT_HEIGHT * 5);
  string = "Number of echoes:" + n_echos;
  text(string, TEXT_MARGIN + FONT_HEIGHT * 3, TEXT_MARGIN + FONT_HEIGHT * 6);
  string = "Encoder count:" + i_encoder;
  text(string, TEXT_MARGIN + FONT_HEIGHT * 3, TEXT_MARGIN + FONT_HEIGHT * 7);
  string = "System temperature:" + temperature;
  text(string, TEXT_MARGIN + FONT_HEIGHT * 3, TEXT_MARGIN + FONT_HEIGHT * 8);
  string = "System status:" + status;
  text(string, TEXT_MARGIN + FONT_HEIGHT * 3, TEXT_MARGIN + FONT_HEIGHT * 9);
  string = "Data content:" + content;
  text(string, TEXT_MARGIN + FONT_HEIGHT * 3, TEXT_MARGIN + FONT_HEIGHT * 10);
  string = "Number of points:" + n_points;
  text(string, TEXT_MARGIN + FONT_HEIGHT * 3, TEXT_MARGIN + FONT_HEIGHT * 11);

  int p_x = -1, p_y = -1;
  for (int j = 0; j < n_points; j++) {
    // Get Distance
    // : units are 1/10 mm.
    // : The distance value is -2147483648 (0x80000000) in case that the echo signal was too low.
    // : The distance value is 2147483647 (0x7FFFFFFF) in case that the echo signal was noisy.
    distance = get_int32_bytes(data, i);
    // Check No echo
    if (distance == 0x80000000) {
      //println("index=" + i + ",point=", j, ",distance=" + "No echo");
      p_x = -1;
      p_y = -1;
    }
    // Check Noisy
    else if (distance == 0x7fffffff) {
      //println("index=" + i + ",point=", j, ",distance=" + "Noise");
      p_x = -1;
      p_y = -1;
    }
    else {
      //println("index=" + i + ",point=", j, ",distance=" + distance);
      int x, y;
      if (ROTATE_FACTOR == 0) {
        x = int(float(distance) * sin(radians((scan_angle_start + float(j) * scan_angle_range / float(n_points)))) / ZOOM_FACTOR);
        if (MIRROR_ENABLE)
          y = int(float(distance) * cos(radians((scan_angle_start + float(j) * scan_angle_range / float(n_points)))) / ZOOM_FACTOR);
        else
          y = int(float(distance) * cos(radians((scan_angle_start + float(n_points - j) * scan_angle_range / float(n_points)))) / ZOOM_FACTOR);
        //println("point=", j, ",distance=" + distance + ",angle=" + (scan_angle_start + float(j) * scan_angle_range / float(n_points)) + ",x=" + x + ",y=", y);
        y += SCREEN_HEIGHT / 2;
      }
      else if (ROTATE_FACTOR == 90) {
        if (MIRROR_ENABLE)
          x = int(float(distance) * cos(radians((scan_angle_start + float(n_points - j) * scan_angle_range / float(n_points)))) / ZOOM_FACTOR);
        else
          x = int(float(distance) * cos(radians((scan_angle_start + float(j) * scan_angle_range / float(n_points)))) / ZOOM_FACTOR);
        y = int(float(distance) * sin(radians((scan_angle_start + float(j) * scan_angle_range / float(n_points)))) / ZOOM_FACTOR);
        //println("point=", j, ",distance=" + distance + ",angle=" + (scan_angle_start + float(j) * scan_angle_range / float(n_points)) + ",x=" + x + ",y=", y);
        x += SCREEN_WIDTH / 2;
      }
      else if (ROTATE_FACTOR == 180) {
        x = int(float(distance) * sin(radians((scan_angle_start + float(j) * scan_angle_range / float(n_points)))) / ZOOM_FACTOR);
        if (MIRROR_ENABLE)
          y = int(float(distance) * cos(radians((scan_angle_start + float(n_points - j) * scan_angle_range / float(n_points)))) / ZOOM_FACTOR);
        else
          y = int(float(distance) * cos(radians((scan_angle_start + float(j) * scan_angle_range / float(n_points)))) / ZOOM_FACTOR);
        //println("point=", j, ",distance=" + distance + ",angle=" + (scan_angle_start + float(j) * scan_angle_range / float(n_points)) + ",x=" + x + ",y=", y);
        x = SCREEN_WIDTH - x; 
        y += SCREEN_HEIGHT / 2;
      }
      else /*if (ROTATE_FACTOR == 270)*/ {
        if (MIRROR_ENABLE)
          x = int(float(distance) * cos(radians((scan_angle_start + float(j) * scan_angle_range / float(n_points)))) / ZOOM_FACTOR);
        else
          x = int(float(distance) * cos(radians((scan_angle_start + float(n_points - j) * scan_angle_range / float(n_points)))) / ZOOM_FACTOR);
        y = int(float(distance) * sin(radians((scan_angle_start + float(j) * scan_angle_range / float(n_points)))) / ZOOM_FACTOR);
        //println("point=", j, ",distance=" + distance + ",angle=" + (scan_angle_start + float(j) * scan_angle_range / float(n_points)) + ",x=" + x + ",y=", y);
        x += SCREEN_WIDTH / 2;
        y = SCREEN_HEIGHT - y;
      }
      if (p_x != -1 && p_y != -1) {
        stroke(128);
        line(p_x, p_y, x, y);
      }
      stroke(255);
      point(x, y);
      p_x = x;
      p_y = y;
    }
    i = i + 4;

    // Check pulse width exist
    if (content != 4) {
      // Get Pulse width
      // : indications of the signal's strength and are provided in picoseconds.
      pulse_width = get_int32_bytes(data, i);
      //println("index=" + i + ",point=", j, ",pulse width=" + pulse_width);
      i = i + 4;
    }
  }

  // Get CRC
  // : Checksum
  crc = get_int32_bytes(data, i);
  if (PRINT) println("index=" + i + ",crc=" + crc);
  //i = i + 4;
} 

void button_setup()
{
  button_zoom_minus_width = FONT_HEIGHT * 2;
  button_zoom_minus_height = FONT_HEIGHT * 2;
  button_zoom_minus_x = TEXT_MARGIN + FONT_HEIGHT * 3;
  button_zoom_minus_y = SCREEN_HEIGHT - button_zoom_minus_height - TEXT_MARGIN - FONT_HEIGHT * 2;

  button_zoom_pluse_width = FONT_HEIGHT * 2;
  button_zoom_pluse_height = FONT_HEIGHT * 2;
  button_zoom_pluse_x = TEXT_MARGIN + FONT_HEIGHT * 3;
  button_zoom_pluse_y = SCREEN_HEIGHT - button_zoom_pluse_height - TEXT_MARGIN - FONT_HEIGHT * 4;

  button_rotate_ccw_width = FONT_HEIGHT * 2;
  button_rotate_ccw_height = FONT_HEIGHT * 2;
  button_rotate_ccw_x = TEXT_MARGIN + FONT_HEIGHT * 6;
  button_rotate_ccw_y = SCREEN_HEIGHT - button_rotate_ccw_height - TEXT_MARGIN - FONT_HEIGHT * 2;

  button_rotate_cw_width = FONT_HEIGHT * 2;
  button_rotate_cw_height = FONT_HEIGHT * 2;
  button_rotate_cw_x = TEXT_MARGIN + FONT_HEIGHT * 6;
  button_rotate_cw_y = SCREEN_HEIGHT - button_rotate_cw_height - TEXT_MARGIN - FONT_HEIGHT * 4;

  button_mirror_en_width = FONT_HEIGHT * 2;
  button_mirror_en_height = FONT_HEIGHT * 2;
  button_mirror_en_x = TEXT_MARGIN + FONT_HEIGHT * 9;
  button_mirror_en_y = SCREEN_HEIGHT - button_mirror_en_height - TEXT_MARGIN - FONT_HEIGHT * 2;

  button_color = color(0);
  button_highlight = color(51);
  button_base_color = color(102);
}

void button_draw()
{
  String string;

  // Sets the color used to draw lines and borders around shapes.
  stroke(255);

  if (button_zoom_minus_over) {
    fill( button_highlight);
  } else {
    fill( button_color);
  }
  rect(button_zoom_minus_x, button_zoom_minus_y, button_zoom_minus_width, button_zoom_minus_height);
  fill(255);
  string = "-";
  text(string, button_zoom_minus_x + button_zoom_minus_width / 2 - int(textWidth(string)) / 2, button_zoom_minus_y + button_zoom_minus_height / 2 + FONT_HEIGHT / 2);

  if (button_zoom_pluse_over) {
    fill( button_highlight);
  } else {
    fill( button_color);
  }
  rect(button_zoom_pluse_x, button_zoom_pluse_y, button_zoom_pluse_width, button_zoom_pluse_height);
  fill(255);
  string = "+";
  text(string, button_zoom_pluse_x + button_zoom_pluse_width / 2 - int(textWidth(string)) / 2, button_zoom_pluse_y + button_zoom_pluse_height / 2 + FONT_HEIGHT / 2);

  string = "Zoom";
  text(string, button_zoom_pluse_x + button_zoom_pluse_width / 2 - int(textWidth(string)) / 2, button_zoom_pluse_y - FONT_HEIGHT / 2);

  if (button_rotate_ccw_over) {
    fill( button_highlight);
  } else {
    fill( button_color);
  }
  rect(button_rotate_ccw_x, button_rotate_ccw_y, button_rotate_ccw_width, button_rotate_ccw_height);
  fill(255);
  string = "↺";
  text(string, button_rotate_ccw_x + button_rotate_ccw_width / 2 - int(textWidth(string)) / 2, button_rotate_ccw_y + button_rotate_ccw_height / 2 + FONT_HEIGHT / 2);

  if (button_rotate_cw_over) {
    fill( button_highlight);
  } else {
    fill( button_color);
  }
  rect(button_rotate_cw_x, button_rotate_cw_y, button_rotate_cw_width, button_rotate_cw_height);
  fill(255);
  string = "↻";
  text(string, button_rotate_cw_x + button_rotate_cw_width / 2 - int(textWidth(string)) / 2, button_rotate_cw_y + button_rotate_cw_height / 2 + FONT_HEIGHT / 2);

  string = "Rotate";
  text(string, button_rotate_cw_x + button_rotate_cw_width / 2 - int(textWidth(string)) / 2, button_rotate_cw_y - FONT_HEIGHT / 2);

  if (button_mirror_en_over) {
    fill( button_highlight);
  } else {
    fill( button_color);
  }
  rect(button_mirror_en_x, button_mirror_en_y, button_mirror_en_width, button_mirror_en_height);
  fill(255);
  if (ROTATE_FACTOR == 0 || ROTATE_FACTOR == 180)  string = "⇅";
  else string = "⇄";
  text(string, button_mirror_en_x + button_mirror_en_width / 2 - int(textWidth(string)) / 2, button_mirror_en_y + button_mirror_en_height / 2 + FONT_HEIGHT / 2);

  string = "Mirror";
  text(string, button_mirror_en_x + button_mirror_en_width / 2 - int(textWidth(string)) / 2, button_mirror_en_y - FONT_HEIGHT / 2);
}

void button_update() {
  if ( overRect(button_zoom_minus_x, button_zoom_minus_y, button_zoom_minus_width, button_zoom_minus_height) ) {
    button_zoom_minus_over = true;
    button_zoom_pluse_over = false;
    button_rotate_ccw_over = false;
    button_rotate_cw_over = false;
    button_mirror_en_over = false;
  }
  else if ( overRect(button_zoom_pluse_x, button_zoom_pluse_y, button_zoom_pluse_width, button_zoom_pluse_height) ) {
    button_zoom_minus_over = false;
    button_zoom_pluse_over = true;
    button_rotate_ccw_over = false;
    button_rotate_cw_over = false;
    button_mirror_en_over = false;
  }
  else if ( overRect(button_rotate_ccw_x, button_rotate_ccw_y, button_rotate_ccw_width, button_rotate_ccw_height) ) {
    button_zoom_minus_over = false;
    button_zoom_pluse_over = false;
    button_rotate_ccw_over = true;
    button_rotate_cw_over = false;
    button_mirror_en_over = false;
  }
  else if ( overRect(button_rotate_cw_x, button_rotate_cw_y, button_rotate_cw_width, button_rotate_cw_height) ) {
    button_zoom_minus_over = false;
    button_zoom_pluse_over = false;
    button_rotate_ccw_over = false;
    button_rotate_cw_over = true;
    button_mirror_en_over = false;
  }
  else if ( overRect(button_mirror_en_x, button_mirror_en_y, button_mirror_en_width, button_mirror_en_height) ) {
    button_zoom_minus_over = false;
    button_zoom_pluse_over = false;
    button_rotate_ccw_over = false;
    button_rotate_cw_over = false;
    button_mirror_en_over = true;
  }
  else {
    button_zoom_minus_over = button_zoom_pluse_over = button_rotate_ccw_over = button_rotate_cw_over = button_mirror_en_over = false;
  }
}

void button_zoom_minus() {
  if (ZOOM_FACTOR <= 3000.0) {
    if (ZOOM_FACTOR < 100.0) ZOOM_FACTOR += 10.0;
    else ZOOM_FACTOR = int(ZOOM_FACTOR + ZOOM_FACTOR / 10.0 + 5.0) / 10 * 10;
  }
  if (PRINT) println("ZOOM_FACTOR=" + ZOOM_FACTOR);
}

void button_zoom_pluse() {
    if (ZOOM_FACTOR > 10.0) {
      if (ZOOM_FACTOR < 100.0) ZOOM_FACTOR -= 10.0;
      else ZOOM_FACTOR = int(ZOOM_FACTOR - ZOOM_FACTOR / 10.0 + 5.0) / 10 * 10;
    }
  if (PRINT) println("ZOOM_FACTOR=" + ZOOM_FACTOR);
}

float mouseXPressed = 0.0; 
float mouseYPressed = 0.0; 
float mouseXDragged = 0.0; 
float mouseYDragged = 0.0; 

void mousePressed() {
  mouseXPressed = mouseX; 
  mouseYPressed = mouseY; 

  if (button_zoom_minus_over) {
    button_zoom_minus();
  }
  if (button_zoom_pluse_over) {
    button_zoom_pluse();
  }

  if (button_rotate_ccw_over) {
    ROTATE_FACTOR -= 90;
    if (ROTATE_FACTOR == -90) ROTATE_FACTOR = 270;
  }
  if (button_rotate_cw_over) {
    ROTATE_FACTOR += 90;
    if (ROTATE_FACTOR == 360) ROTATE_FACTOR = 0;
  }
  if (PRINT) println("ROTATE_FACTOR=" + ROTATE_FACTOR);

  if (button_mirror_en_over) {
    MIRROR_ENABLE = !MIRROR_ENABLE;
  }
  if (PRINT) println("MIRROR_ENABLE=" + MIRROR_ENABLE);
}

void mouseDragged() 
{
  mouseXDragged = mouseX-mouseXPressed; 
  mouseYDragged = mouseY-mouseYPressed;
  /*if (PRINT)*/ println("Mouse dragged = dx:" + mouseXDragged + ",dy:" + mouseYDragged);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();

  if (PRINT) println("Mouse wheel =" + e);
  if (e == 1)
    button_zoom_minus();
  else if (e == -1)
    button_zoom_pluse();
}

boolean overRect(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

void grid_draw()
{
  String string;

  if (ROTATE_FACTOR == 0) {
    // Sets the color used to draw lines and borders around shapes.
    stroke(64);
    line(0, SCREEN_HEIGHT / 2, SCREEN_WIDTH, SCREEN_HEIGHT / 2);
    stroke(128);
    string = "0m";
    text(string, TEXT_MARGIN, SCREEN_HEIGHT / 2 + FONT_HEIGHT / 2);
    for (int j = 100; j < SCREEN_HEIGHT / 2; j += 100) {
      stroke(64);
      line(0, SCREEN_HEIGHT / 2 - j, SCREEN_WIDTH, SCREEN_HEIGHT / 2 - j);
      line(0, SCREEN_HEIGHT / 2 + j, SCREEN_WIDTH, SCREEN_HEIGHT / 2 + j);
      stroke(128);
      if (MIRROR_ENABLE)
        string = "-" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      else
        string = "+" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      text(string, TEXT_MARGIN, SCREEN_HEIGHT / 2 + FONT_HEIGHT / 2 - j);
      if (MIRROR_ENABLE)
        string = "+" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      else
        string = "-" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      text(string, TEXT_MARGIN, SCREEN_HEIGHT / 2 + FONT_HEIGHT / 2 + j);
    }

    for (int j = 100; j < SCREEN_WIDTH; j += 100) {
      stroke(64);
      line(j, 0, j, SCREEN_HEIGHT);
      stroke(128);
      string = (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      text(string, j - int(textWidth(string) / 2.0), TEXT_MARGIN + FONT_HEIGHT);
    }
  } else if (ROTATE_FACTOR == 90) {
    // Sets the color used to draw lines and borders around shapes.
    stroke(64);
    line(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2, SCREEN_HEIGHT);
    stroke(128);
    string = "0m";
    text(string, SCREEN_WIDTH / 2 - int(textWidth(string) / 2.0), TEXT_MARGIN + FONT_HEIGHT);
    for (int j = 100; j < SCREEN_WIDTH / 2; j += 100) {
      stroke(64);
      line(SCREEN_WIDTH / 2 + j, 0, SCREEN_WIDTH / 2 + j, SCREEN_HEIGHT);
      line(SCREEN_WIDTH / 2 - j, 0, SCREEN_WIDTH / 2 - j, SCREEN_HEIGHT);
      stroke(128);
      if (MIRROR_ENABLE)
        string = "-" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      else
        string = "+" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      text(string, SCREEN_WIDTH / 2 - int(textWidth(string) / 2.0) + j, TEXT_MARGIN + FONT_HEIGHT);
      if (MIRROR_ENABLE)
        string = "+" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      else
        string = "-" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      text(string, SCREEN_WIDTH / 2 - int(textWidth(string) / 2.0) - j, TEXT_MARGIN + FONT_HEIGHT);
    }

    for (int j = 100; j < SCREEN_HEIGHT; j += 100) {
      stroke(64);
      line(0, j, SCREEN_WIDTH, j);
      stroke(128);
      string = (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      text(string, SCREEN_WIDTH - int(textWidth(string)) - TEXT_MARGIN, j + FONT_HEIGHT / 2);
    }
  } else if (ROTATE_FACTOR == 180) {
    // Sets the color used to draw lines and borders around shapes.
    stroke(64);
    line(0, SCREEN_HEIGHT / 2, SCREEN_WIDTH, SCREEN_HEIGHT / 2);
    stroke(128);
    string = "0m";
    text(string, SCREEN_WIDTH - TEXT_MARGIN - int(textWidth(string)), SCREEN_HEIGHT / 2 + FONT_HEIGHT / 2);
    for (int j = 100; j < SCREEN_HEIGHT / 2; j += 100) {
      stroke(64);
      line(0, SCREEN_HEIGHT / 2 + j, SCREEN_WIDTH, SCREEN_HEIGHT / 2 + j);
      line(0, SCREEN_HEIGHT / 2 - j, SCREEN_WIDTH, SCREEN_HEIGHT / 2 - j);
      stroke(128);
      if (MIRROR_ENABLE)
        string = "-" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      else
        string = "+" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      text(string, SCREEN_WIDTH - TEXT_MARGIN - int(textWidth(string)), SCREEN_HEIGHT / 2 + FONT_HEIGHT / 2 + j);
      if (MIRROR_ENABLE)
        string = "+" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      else
        string = "-" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      text(string, SCREEN_WIDTH - TEXT_MARGIN - int(textWidth(string)), SCREEN_HEIGHT / 2 + FONT_HEIGHT / 2 - j);
    }

    for (int j = SCREEN_WIDTH - 100; j >= 0; j -= 100) {
      stroke(64);
      line(j, 0, j, SCREEN_HEIGHT);
      stroke(128);
      string = (float(int(ZOOM_FACTOR / 100.0 * float(SCREEN_WIDTH - j))) / 100.0) + "m";
      text(string, j - int(textWidth(string) / 2.0), SCREEN_HEIGHT - TEXT_MARGIN);
    }
  } else /*if (ROTATE_FACTOR == 270)*/ {
    // Sets the color used to draw lines and borders around shapes.
    stroke(64);
    line(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2, SCREEN_HEIGHT);
    stroke(128);
    string = "0m";
    text(string, SCREEN_WIDTH / 2 - int(textWidth(string) / 2.0), SCREEN_HEIGHT - TEXT_MARGIN);
    for (int j = 100; j < SCREEN_WIDTH / 2; j += 100) {
      stroke(64);
      line(SCREEN_WIDTH / 2 - j, 0, SCREEN_WIDTH / 2 - j, SCREEN_HEIGHT);
      line(SCREEN_WIDTH / 2 + j, 0, SCREEN_WIDTH / 2 + j, SCREEN_HEIGHT);
      stroke(128);
      if (MIRROR_ENABLE)
        string = "-" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      else
        string = "+" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      text(string, SCREEN_WIDTH / 2 - int(textWidth(string) / 2.0) - j, SCREEN_HEIGHT - TEXT_MARGIN);
      if (MIRROR_ENABLE)
        string = "+" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      else
        string = "-" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      text(string, SCREEN_WIDTH / 2 - int(textWidth(string) / 2.0) + j, SCREEN_HEIGHT - TEXT_MARGIN);
    }

    for (int j = SCREEN_HEIGHT - 100; j >= 0; j -= 100) {
      stroke(64);
      line(0, j, SCREEN_WIDTH, j);
      stroke(128);
      string = (float(int(ZOOM_FACTOR / 100.0 * float(SCREEN_HEIGHT - j))) / 100.0) + "m";
      text(string, TEXT_MARGIN, j + FONT_HEIGHT / 2);
    }
  }
}

// Get 32bits data by network byte order(bigendian)
int get_int32_bytes(byte data[], int i) {
  return ((data[i + 0] & 0xff) << 24) +
    ((data[i + 1] & 0xff) << 16) +
    ((data[i + 2] & 0xff) << 8) +
    ((data[i + 3] & 0xff) << 0);
}