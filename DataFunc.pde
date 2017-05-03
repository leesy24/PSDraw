//final boolean PRINT_DataFunc_Load = true; 
final boolean PRINT_DataFunc_Load = false;

//final boolean PRINT_DataFunc_Parse = true; 
final boolean PRINT_DataFunc_Parse = false;

//final boolean PRINT_DataFunc_Draw = true; 
final boolean PRINT_DataFunc_Draw = false;

final int MAX_POINTS = 1000; 

// Get OS Name
final String OS = System.getProperty("os.name");

// Define default binary data_buf filename and path 
String FILENAME = "data_buf.bin";

// Define data_buf array to load binary data_buf
byte data_buf[]; 

// Define old time stamp to check time stamp changed for detecting data_buf changed or not
long old_time_stamp = -1;

void data_setup() {
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
}

// A Data class
class Data {
  String func;
  int len;
  int n_params;
  int i_scan = 0;
  int time_stamp = 0;
  float scan_angle_start = 0;
  float scan_angle_size = 0;
  int n_echos = 0;
  int i_encoder = 0;
  float temperature = 0;
  int status = 0;
  int content = 0;
  int n_points = 0;
  int[] distances = new int[MAX_POINTS];
  int[] pulse_widths = new int[MAX_POINTS];
  int crc;

  // Create the Data
  Data() {
  }

  // Load data_buf
  boolean load() {
    String string;

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
      if (PRINT_DataFunc_Load) println("File not exist!:" + FILENAME);
      return false;
    } // End of load()
  
    // Load binary data_buf.
    data_buf = loadBytes(FILENAME);
    if (PRINT_DataFunc_Load) println("data_buf.length = " + data_buf.length);
    // Check binary data_buf length is valid.
    // Must larger than Function code(4B) + Length(4B) + Number of parameters(4B) + Number of points(4B) + CRC(4B).
    if (data_buf.length <= 4 + 4 + 4 + 4 + 4) {
      // Sets the color used to draw lines and borders around shapes.
      fill(255);
      stroke(255);
      string = "File size is invalid!: " + data_buf.length;
      textSize(FONT_HEIGHT*3);
      text(string, SCREEN_WIDTH / 2 - int(textWidth(string) / 2.0), SCREEN_HEIGHT / 2 - FONT_HEIGHT);
      textSize(FONT_HEIGHT);
      if (PRINT_DataFunc_Load) println("File size is invalid!:" + data_buf.length);
      return false;
    }
    return true;
  }

  // Parsing data_buf
  boolean parse() {
    String string;
    int i = 0; // index for navigating data_buf.

    // Get function code.
    func = str(char(data_buf[i])) + str(char(data_buf[i+1])) + str(char(data_buf[i+2])) + str(char(data_buf[i+3]));
    // Check function code is "GSCN".
    if (func.equals("GSCN") != true) {
      // Sets the color used to draw lines and borders around shapes.
      fill(255);
      stroke(255);
      string = "Function code is invalid!:" + func;
      textSize(FONT_HEIGHT*3);
      text(string, SCREEN_WIDTH / 2 - int(textWidth(string) / 2.0), SCREEN_HEIGHT / 2 - FONT_HEIGHT);
      textSize(FONT_HEIGHT);
      if (PRINT_DataFunc_Parse) println("Function code is invalid!:", func);
      return false;
    }
    if (PRINT_DataFunc_Parse) println("index=" + i + ",func=" + func);
    i = i + 4;
  
    // Get data_buf length.
    // : size of the following data_buf record, without the CRC checksum
    len = get_int32_bytes(data_buf, i);
    if (PRINT_DataFunc_Parse) println("index=" + i + ",length=" + len);
    i = i + 4;
  
    // Check data_buf record length with binary data_buf length
    if (data_buf.length < (len + 12)) {
      // Sets the color used to draw lines and borders around shapes.
      fill(255);
      stroke(255);
      string = "Binary data length is invalid!:" + data_buf.length + "," + len;
      textSize(FONT_HEIGHT*3);
      text(string, SCREEN_WIDTH / 2 - int(textWidth(string) / 2.0), SCREEN_HEIGHT / 2 - FONT_HEIGHT);
      textSize(FONT_HEIGHT);
      if (PRINT_DataFunc_Parse) println("Binary data length is invalid!:" + data_buf.length + "," + len);
      return false;
    }
  
    // TBD: Check CRC
    // ...
  
    // Get number of parameters.
    // : the number of following parameters. Becomes 0 if no scan is available.
    n_params = get_int32_bytes(data_buf, i);
    if (PRINT_DataFunc_Parse) println("index=" + i + ",number of parameters=" + n_params);
    i = i + 4;
    if (n_params == 0) {
      // Sets the color used to draw lines and borders around shapes.
      fill(255);
      stroke(255);
      string = "No scan data is available!:Number of parameter is 0.";
      textSize(FONT_HEIGHT*3);
      text(string, SCREEN_WIDTH / 2 - int(textWidth(string) / 2.0), SCREEN_HEIGHT / 2 - FONT_HEIGHT);
      textSize(FONT_HEIGHT);
      if (PRINT_DataFunc_Parse) println("No scan data is available!:Number of parameter is 0.");
      return false;
    }
  
    if (n_params >= 1) {
      // Get scan number(index).
      // : the number of the scan (starting with 1), should be the same as in the command request.
      i_scan = get_int32_bytes(data_buf, i);
      if (PRINT_DataFunc_Parse) println("index=" + i + ",scan number=" + i_scan);
      i = i + 4;
    }
  
    if (n_params >= 2) {
      // Get time stamp.
      // : time stamp of the first measured point in the scan, given in milliseconds since the last SCAN command.
      time_stamp = get_int32_bytes(data_buf, i);
      if (PRINT_DataFunc_Parse) println("index=" + i + ",time stamp=" + time_stamp);
      i = i + 4;
/*
      // Check time_stamp is changed
      if (old_time_stamp == time_stamp) {
        // Sets the color used to draw lines and borders around shapes.
        fill(255);
        stroke(255);
        string = "Scan data_buf is not changed!:" + time_stamp;
        textSize(FONT_HEIGHT*3);
        text(string, SCREEN_WIDTH / 2 - int(textWidth(string) / 2.0), SCREEN_HEIGHT / 2 - FONT_HEIGHT);
        textSize(FONT_HEIGHT);
        if (PRINT_DataFunc_Parse) println("Scan data_buf is not changed!:" + time_stamp);
        //return false;
      }
      old_time_stamp = time_stamp;
*/
    }

    if (n_params >= 3) {
      // Get Scan start direction.
      // : direction to the first measured point, given in the user angle system (typical unit is 0,001 deg)
      scan_angle_start = get_int32_bytes(data_buf, i) / 1000.0;
      if (PRINT_DataFunc_Parse) println("index=" + i + ",scan start angle=" + scan_angle_start);
      i = i + 4;
    }
  
    if (n_params >= 4) {
      // Get Scan angle
      // : the scan angle in the user angle system. Typically 90.000.
      scan_angle_size = get_int32_bytes(data_buf, i) / 1000.0;
      if (PRINT_DataFunc_Parse) println("index=" + i + ",scan range angle=" + scan_angle_size);
      i = i + 4;
    }
  
    if (n_params >= 5) {
      // Get Number of echoes per point
      // : the number of echoes measured for each direction.
      n_echos = get_int32_bytes(data_buf, i);
      if (PRINT_DataFunc_Parse) println("index=" + i + ",number of echos=" + n_echos);
      i = i + 4;
    }
  
    if (n_params >= 6) {
      // Get Incremental count
      // : a direction provided by an external incremental encoder.
      i_encoder = get_int32_bytes(data_buf, i);
      if (PRINT_DataFunc_Parse) println("index=" + i + ",encoder value=" + i_encoder);
      i = i + 4;
    }
  
    if (n_params >= 7) {
      // Get system temperature
      // : the temperature as measured inside of the scanner.
      // : This information can be used to control an optional air condition.
      temperature = get_int32_bytes(data_buf, i) / 10f;
      if (PRINT_DataFunc_Parse) println("index=" + i + ",system temperature=" + temperature);
      i = i + 4;
    }
  
    if (n_params >= 8) {
      // Get System status
      // : contains a bit field with about the status of peripheral devices.
      status = get_int32_bytes(data_buf, i);
      if (PRINT_DataFunc_Parse) println("index=" + i + ",system status=" + status);
      i = i + 4;
    }
  
    if (n_params >= 9) {
      // Get Data content
      // : This parameter is built by the size of a single measurement record.
      // : It defines the content of the data_buf section:
      //    o 4 Bytes: distances in 1/10 mm only.
      //    o 8 Bytes: distances in 1/10 mm and pulse widths in picoseconds
      //    o Any other value than 4 be read as "8 Bytes".
      content = get_int32_bytes(data_buf, i);
      if (PRINT_DataFunc_Parse) println("index=" + i + ",data content=" + content);
      i = i + 4;
    }
  
    // Check number of parameters is larger than 9 such as unknown parameters.
    if (n_params > 9) {
      // Skip index for remained unknown parameters.
      i = i + 4 * (n_params - 9);
    }
  
    // Get Number of points
    // : the number of measurement points in the scan.
    n_points = get_int32_bytes(data_buf, i);
    if (PRINT_DataFunc_Parse) println("index=" + i + ",number of points=" + n_points);
    i = i + 4;
    if (n_points > MAX_POINTS || n_points <= 0) {
      // Sets the color used to draw lines and borders around shapes.
      fill(255);
      stroke(255);
      string = "Number of points invalide!:Number of points is" + n_points + ".";
      textSize(FONT_HEIGHT*3);
      text(string, SCREEN_WIDTH / 2 - int(textWidth(string) / 2.0), SCREEN_HEIGHT / 2 - FONT_HEIGHT);
      textSize(FONT_HEIGHT);
      if (PRINT_DataFunc_Parse) println("Number of points invalide!:Number of points is" + n_points + ".");
      return false;
    }
  

    for (int j = 0; j < n_points; j++) {
      // Get Distance
      // : units are 1/10 mm.
      // : The distance value is -2147483648 (0x80000000) in case that the echo signal was too low.
      // : The distance value is 2147483647 (0x7FFFFFFF) in case that the echo signal was noisy.
      distances[j] = get_int32_bytes(data_buf, i);
      i = i + 4;
  
      // Check pulse width exist
      if (content != 4) {
        // Get Pulse width
        // : indications of the signal's strength and are provided in picoseconds.
        pulse_widths[j] = get_int32_bytes(data_buf, i);
        //println("index=" + i + ",point=", j, ",pulse width=" + pulse_width);
        i = i + 4;
      }
    }
  
    // Get CRC
    // : Checksum
    crc = get_int32_bytes(data_buf, i);
    if (PRINT_DataFunc_Parse) println("index=" + i + ",crc=" + crc);
    //i = i + 4;
    
    return true;
  } // End of parse()
  
  // Draw params of parsed data_buf
  void draw_params() {
    String string;

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
    string = "Scan angle size:" + scan_angle_size;
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
  } // End of draw_params()
  
  // Draw points of parsed data_buf
  void draw_points() {
    int distance;
    int pulse_width;
    int x, y;
    int p_x = -1, p_y = -1;

    for (int j = 0; j < n_points; j++) {
      // Get Distance
      // : units are 1/10 mm.
      // : The distance value is -2147483648 (0x80000000) in case that the echo signal was too low.
      // : The distance value is 2147483647 (0x7FFFFFFF) in case that the echo signal was noisy.
      distance = distances[j];
      // Check No echo
      if (distance == 0x80000000) {
        if (PRINT_DataFunc_Draw) println("point=", j, ",distance=" + "No echo");
        p_x = -1;
        p_y = -1;
      }
      // Check Noisy
      else if (distance == 0x7fffffff) {
        if (PRINT_DataFunc_Draw) println("point=", j, ",distance=" + "Noise");
        p_x = -1;
        p_y = -1;
      }
      else {
        if (PRINT_DataFunc_Draw) println("point=", j, ",distance=" + distance);
        if (ROTATE_FACTOR == 0) {
          x = int(float(distance) * sin(radians((scan_angle_start + float(j) * scan_angle_size / float(n_points)))) / ZOOM_FACTOR);
          if (MIRROR_ENABLE)
            y = int(float(distance) * cos(radians((scan_angle_start + float(j) * scan_angle_size / float(n_points)))) / ZOOM_FACTOR);
          else
            y = int(float(distance) * cos(radians((scan_angle_start + float(n_points - j) * scan_angle_size / float(n_points)))) / ZOOM_FACTOR);
          if (PRINT_DataFunc_Draw) println("point=", j, ",distance=" + distance + ",angle=" + (scan_angle_start + float(j) * scan_angle_size / float(n_points)) + ",x=" + x + ",y=", y);
          x += TEXT_MARGIN + FONT_HEIGHT / 2;
          y += SCREEN_HEIGHT / 2;
        }
        else if (ROTATE_FACTOR == 90) {
          if (MIRROR_ENABLE)
            x = int(float(distance) * cos(radians((scan_angle_start + float(n_points - j) * scan_angle_size / float(n_points)))) / ZOOM_FACTOR);
          else
            x = int(float(distance) * cos(radians((scan_angle_start + float(j) * scan_angle_size / float(n_points)))) / ZOOM_FACTOR);
          y = int(float(distance) * sin(radians((scan_angle_start + float(j) * scan_angle_size / float(n_points)))) / ZOOM_FACTOR);
          if (PRINT_DataFunc_Draw) println("point=", j, ",distance=" + distance + ",angle=" + (scan_angle_start + float(j) * scan_angle_size / float(n_points)) + ",x=" + x + ",y=", y);
          x += SCREEN_WIDTH / 2;
          y += TEXT_MARGIN + FONT_HEIGHT / 2;
        }
        else if (ROTATE_FACTOR == 180) {
          x = int(float(distance) * sin(radians((scan_angle_start + float(j) * scan_angle_size / float(n_points)))) / ZOOM_FACTOR);
          if (MIRROR_ENABLE)
            y = int(float(distance) * cos(radians((scan_angle_start + float(n_points - j) * scan_angle_size / float(n_points)))) / ZOOM_FACTOR);
          else
            y = int(float(distance) * cos(radians((scan_angle_start + float(j) * scan_angle_size / float(n_points)))) / ZOOM_FACTOR);
          if (PRINT_DataFunc_Draw) println("point=", j, ",distance=" + distance + ",angle=" + (scan_angle_start + float(j) * scan_angle_size / float(n_points)) + ",x=" + x + ",y=", y);
          x = SCREEN_WIDTH - x; 
          x -= TEXT_MARGIN + FONT_HEIGHT / 2;
          y += SCREEN_HEIGHT / 2;
        }
        else /*if (ROTATE_FACTOR == 270)*/ {
          if (MIRROR_ENABLE)
            x = int(float(distance) * cos(radians((scan_angle_start + float(j) * scan_angle_size / float(n_points)))) / ZOOM_FACTOR);
          else
            x = int(float(distance) * cos(radians((scan_angle_start + float(n_points - j) * scan_angle_size / float(n_points)))) / ZOOM_FACTOR);
          y = int(float(distance) * sin(radians((scan_angle_start + float(j) * scan_angle_size / float(n_points)))) / ZOOM_FACTOR);
          if (PRINT_DataFunc_Draw) println("point=", j, ",distance=" + distance + ",angle=" + (scan_angle_start + float(j) * scan_angle_size / float(n_points)) + ",x=" + x + ",y=", y);
          x += SCREEN_WIDTH / 2;
          y = SCREEN_HEIGHT - y;
          y -= TEXT_MARGIN + FONT_HEIGHT / 2;
        }
        if (p_x != -1 && p_y != -1) {
          stroke(128);
          line(p_x + GRID_OFFSET_X, p_y + GRID_OFFSET_Y, x + GRID_OFFSET_X, y + GRID_OFFSET_Y);
        }
        stroke(255);
        point(x + GRID_OFFSET_X, y + GRID_OFFSET_Y);
        p_x = x;
        p_y = y;
      }
  
      // Check pulse width exist
      if (content != 4) {
        // Get Pulse width
        // : indications of the signal's strength and are provided in picoseconds.
        pulse_width = pulse_widths[j];
        if (PRINT_DataFunc_Draw) println("point=", j, ",pulse width=" + pulse_width);
      }
    } // End of for (int j = 0; j < n_points; j++)
  } // End of draw_points()
}