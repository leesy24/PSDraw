// Define to enable or disable the log print in console.
//final boolean PRINT = true; 
final boolean PRINT = false; 

// Define just screen width and height variables.
int SCREEN_WIDTH;
int SCREEN_HEIGHT;

// Define just font height variables.
int FONT_HEIGHT;

// Define just text area margin variables.
int TEXT_MARGIN;

// Define zoom factor variables.
int ZOOM_FACTOR = 100;

// Get OS Name
final String OS = System.getProperty("os.name");

// Define default binary data filename and path 
String FILENAME = "data.bin";

// Define data array to load binary data
byte data[]; 

// Define old time stamp to check time stamp changed for detecting data changed or not
long old_time_stamp = -1;

int button_1_x, button_1_y;      // Position of square button 1
int button_1_width, button_1_height;     // Diameter of rect
boolean button_1_over = false;
int button_2_x, button_2_y;      // Position of square button 2
int button_2_width, button_2_height;     // Diameter of rect
boolean button_2_over = false;
color button_highlight;
color button_color, button_base_color;

// The setup() function is run once, when the program starts.
// It's used to define initial enviroment properties such as screen size
//  and to load media such as images and fonts as the program starts.
// There can only be one setup() function for each program
//  and it shouldn't be called again after its initial execution.
void setup() {
  // fullScreen() opens a sketch using the full size of the computer's display.
  // This function must be the first line in setup().
  // The size() and fullScreen() functions cannot both be used in the same program,
  //  just choose one.
  fullScreen();

  // Assign full screen width and height
  SCREEN_WIDTH = width;
  SCREEN_HEIGHT = height;

  // Check OS
  if (OS.equals("Linux")) {
    // Define binary data filename and path for Linux OS
    FILENAME = "/tmp/data.bin";
  }
  // Assume Windows OS 
  else {
    // Define binary data filename and path for Windows OS
    FILENAME = "C:\\work\\git\\PSDemoProgram\\Release-windows\\data.bin";
  }

  // To set the background on the first frame of animation. 
  background(0);
  // Specifies the number of frames to be displayed every second. 
  frameRate(30);
  
  TEXT_MARGIN = SCREEN_WIDTH / 100;

  // Set font height of text to follow screen Height
  FONT_HEIGHT = SCREEN_HEIGHT / 80;
  textSize(FONT_HEIGHT);

  button_1_width = FONT_HEIGHT * 3;
  button_1_height = FONT_HEIGHT * 3;
  button_1_x = TEXT_MARGIN;
  button_1_y = SCREEN_HEIGHT - button_1_height - TEXT_MARGIN;
  
  button_2_width = FONT_HEIGHT * 3;
  button_2_height = FONT_HEIGHT * 3;
  button_2_x = TEXT_MARGIN;
  button_2_y = SCREEN_HEIGHT - button_2_height - button_1_height - TEXT_MARGIN;

  button_color = color(0);
  button_highlight = color(51);
  button_base_color = color(102);
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

  // Check file exists to avoid exception error on loadBytes().
  File file = new File(FILENAME);
  if (file.exists() != true) {
    if (PRINT) println("File not exist!:" + FILENAME);
    return;
  }

  // Load binary data.
  data = loadBytes(FILENAME);
  if (PRINT) println("data.length = " + data.length);
  // Check binary data length is valid.
  // Must larger than Function code(4B) + Length(4B) + Number of parameters(4B) + Number of points(4B) + CRC(4B).
  if (data.length <= 4 + 4 + 4 + 4 + 4) {
    if (PRINT) println("File size is invalid!:" + data.length);
    return;
  }

  // Get function code.
  func = str(char(data[i])) + str(char(data[i+1])) + str(char(data[i+2])) + str(char(data[i+3]));
  // Check function code is "GSCN".
  if (func.equals("GSCN") != true) {
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
    if (PRINT) println("No scan data is available!");
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
      if (PRINT) println("Time stamp is not changed!:" + time_stamp);
      return;
    }
    old_time_stamp = time_stamp;
*/
  }
  
  // Ready to draw from here!
  // To clear the display window at the beginning of each frame,
  background(0);

  update(mouseX, mouseY);

  if (button_1_over) {
    fill( button_highlight);
  } else {
    fill( button_color);
  }
  rect(button_1_x, button_1_y, button_1_width, button_1_height);
  fill(255);
  text("-", button_1_x + FONT_HEIGHT, button_1_y + FONT_HEIGHT*2);
  
  if (button_2_over) {
    fill( button_highlight);
  } else {
    fill( button_color);
  }
  rect(button_2_x, button_2_y, button_2_width, button_2_height);
  fill(255);
  text("+", button_2_x + FONT_HEIGHT, button_2_y + FONT_HEIGHT*2);
  
  // Sets the color used to draw lines and borders around shapes.
  fill(255);
  stroke(255);

  if (n_params >= 3) {
    // Get Scan start direction.
    // : direction to the first measured point, given in the user angle system (typical unit is 0,001 deg)
    scan_angle_start = get_int32_bytes(data, i) / 1000f;
    if (PRINT) println("index=" + i + ",scan start angle=" + scan_angle_start);
    i = i + 4;
  }

  if (n_params >= 4) {
    // Get Scan angle
    // : the scan angle in the user angle system. Typically 90.000.
    scan_angle_range = get_int32_bytes(data, i) / 1000f;
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
    // : In PAC sensors with more than one scan lines, ?œIncremental count??contains the number of the scan line.
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

  string = "Scan number:" + i_scan;
  text(string, TEXT_MARGIN, TEXT_MARGIN + FONT_HEIGHT * 1);
  string = "Time stamp:" + time_stamp;
  //text(string, SCREEN_WIDTH - int(textWidth(string)) - 10, 10 + FONT_HEIGHT);
  text(string, TEXT_MARGIN, TEXT_MARGIN + FONT_HEIGHT * 2);
  string = "Scan start direction:" + scan_angle_start;
  text(string, TEXT_MARGIN, TEXT_MARGIN + FONT_HEIGHT * 3);
  string = "Scan angle range:" + scan_angle_range;
  text(string, TEXT_MARGIN, TEXT_MARGIN + FONT_HEIGHT * 4);
  string = "Number of echoes:" + n_echos;
  text(string, TEXT_MARGIN, TEXT_MARGIN + FONT_HEIGHT * 5);
  string = "Encoder count:" + i_encoder;
  text(string, TEXT_MARGIN, TEXT_MARGIN + FONT_HEIGHT * 6);
  string = "System temperature:" + temperature;
  text(string, TEXT_MARGIN, TEXT_MARGIN + FONT_HEIGHT * 7);
  string = "System status:" + status;
  text(string, TEXT_MARGIN, TEXT_MARGIN + FONT_HEIGHT * 8);
  string = "Data content:" + content;
  text(string, TEXT_MARGIN, TEXT_MARGIN + FONT_HEIGHT * 9);
  string = "Number of points:" + n_points;
  text(string, TEXT_MARGIN, TEXT_MARGIN + FONT_HEIGHT * 10);

  for (int j = 0; j < n_points; j++) {
    // Get Distance
    // : units are 1/10 mm.
    // : The distance value is -2147483648 (0x80000000) in case that the echo signal was too low.
    // : The distance value is 2147483647 (0x7FFFFFFF) in case that the echo signal was noisy.
    distance = get_int32_bytes(data, i);
    // Check No echo
    if (distance == 0x80000000) {
      //println("index=" + i + ",point=", j, ",distance=" + "No echo");
    }
    // Check Noisy
    else if (distance == 0x7fffffff) {
      //println("index=" + i + ",point=", j, ",distance=" + "Noise");
    }
    else {
      //println("index=" + i + ",point=", j, ",distance=" + distance);
      point(j * SCREEN_WIDTH / n_points, distance / ZOOM_FACTOR);
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

void update(int x, int y) {
  if ( overRect(button_1_x, button_1_y, button_1_width, button_1_height) ) {
    button_1_over = true;
    button_2_over = false;
  } else if ( overRect(button_2_x, button_2_y, button_2_width, button_2_height) ) {
    button_2_over = true;
    button_1_over = false;
  } else {
    button_1_over = button_2_over = false;
  }
}

void mousePressed() {
  if (button_1_over) {
    ZOOM_FACTOR += 10;
  }
  if (button_2_over) {
    ZOOM_FACTOR -= 10;
    if (ZOOM_FACTOR <= 0) ZOOM_FACTOR = 1;
  }
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

// Get 32bits data by network byte order(bigendian)
int get_int32_bytes(byte data[], int i) {
  return ((data[i + 0] & 0xff) << 24) +
         ((data[i + 1] & 0xff) << 16) +
         ((data[i + 2] & 0xff) << 8) +
         ((data[i + 3] & 0xff) << 0);
}