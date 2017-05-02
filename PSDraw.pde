// Define to enable or disable the log print in console.
//final boolean PRINT = true; 
final boolean PRINT = false; 

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

  surface.setResizable(true);

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

  screen_setup();
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

  if (screen_check_update()) {
    screen_setup();
    button_setup();
  }

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