//final boolean PRINT_DataFunc_Load = true; 
final boolean PRINT_DataFunc_Load = false;

//final boolean PRINT_DataFunc_Parse = true; 
final boolean PRINT_DataFunc_Parse = false;

//final boolean PRINT_DataFunc_Draw = true; 
final boolean PRINT_DataFunc_Draw = false;

//final static color C_DATA_LINE = #808080; //
//final static color C_DATA_POINT = #000000; //
final static color C_DATA_TEXT = #404040; //
final static color C_DATA_LINE = #0000FF; // Blue
final static color C_DATA_POINT = #FF0000; // Red

final int DATA_MAX_POINTS = 1000;
final int DATA_POINT_WH = 3;

final int DATA_MAX_PULSE_WIDTH = 12000;
final int DATA_MIN_PULSE_WIDTH = 4096;

Data PS_Data;

// Define data_buf array to load binary data_buf
byte[] data_buf; 

// Define old time stamp to check time stamp changed for detecting data_buf changed or not
long old_time_stamp = -1;

void data_setup() {
  // Append interface name to window title
  Title += ((DATA_interface == 0)?"File":"UART");

  interface_file_reset();
  interface_UART_reset();
  if(DATA_interface == 0) {
    interface_file_setup();
  }
  else {
    interface_UART_setup();
  }

  PS_Data = new Data();
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
  int[] distances = new int[DATA_MAX_POINTS];
  int[] pulse_widths = new int[DATA_MAX_POINTS];
  int crc;

  // Create the Data
  Data() {
  }

  // Load data_buf
  boolean load() {
    if(DATA_interface == 0) {
      return interface_file_load();
    }
    else {
      return interface_UART_load();
    }
  }

  // Parsing data_buf
  boolean parse() {
    String string;
    int i = 0; // index for navigating data_buf.

    // Get function code.
    func = get_str_bytes(data_buf, i, 4);
    // Check function code is "GSCN".
    if (func.equals("GSCN") != true) {
      // Sets the color used to draw lines and borders around shapes.
      fill(C_TEXT);
      stroke(C_TEXT);
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
      fill(C_TEXT);
      stroke(C_TEXT);
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
      fill(C_TEXT);
      stroke(C_TEXT);
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
        fill(C_TEXT);
        stroke(C_TEXT);
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
    if (n_points > DATA_MAX_POINTS || n_points <= 0) {
      // Sets the color used to draw lines and borders around shapes.
      fill(C_TEXT);
      stroke(C_TEXT);
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
    fill(C_DATA_TEXT);
    stroke(C_DATA_TEXT);
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
    int pulse_width = -1, p_pulse_width = -1;
    int x, y;
    int wh = DATA_POINT_WH; // Set width and height point rect
    float cx, cy;
    float angle;
    int p_x = -1, p_y = -1;
    color c_draw_point, p_c_draw_point = 0;
    color c_draw_line;
    int range = DATA_POINT_WH; // Range for mouse over point rect.

    // Adjust mouse over range by ZOOM_FACTOR.
    if( ZOOM_FACTOR < 50 ) {
      range += (50 - ZOOM_FACTOR)/10;
    }

    for (int j = 0; j < n_points; j++) {
      // Get Distance
      // : units are 1/10 mm.
      // : The distance value is -2147483648 (0x80000000) in case that the echo signal was too low.
      // : The distance value is 2147483647 (0x7FFFFFFF) in case that the echo signal was noisy.
      distance = distances[j];
      // Check pulse width exist
      if (content != 4) {
        pulse_width = pulse_widths[j];
      }
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
        angle = scan_angle_start + float(j) * scan_angle_size / float(n_points);
        if (ROTATE_FACTOR == 0) {
          cx = float(distance) * sin(radians(angle));
          cy = float(distance) * cos(radians(angle));
          x = int(cx / ZOOM_FACTOR);
          y = int(cy / ZOOM_FACTOR);
          if (PRINT_DataFunc_Draw) println("point=", j, ",distance=" + distance + ",angle=" + (scan_angle_start + float(j) * scan_angle_size / float(n_points)) + ",x=" + x + ",y=", y);
          x += TEXT_MARGIN + FONT_HEIGHT / 2;
          if (MIRROR_ENABLE)
            y += SCREEN_HEIGHT / 2;
          else
            y = SCREEN_HEIGHT / 2 - y;
        }
        else if (ROTATE_FACTOR == 90) {
          cx = float(distance) * cos(radians(angle));
          cy = float(distance) * sin(radians(angle));
          x = int(cx / ZOOM_FACTOR);
          y = int(cy / ZOOM_FACTOR);
          if (PRINT_DataFunc_Draw) println("point=", j, ",distance=" + distance + ",angle=" + (scan_angle_start + float(j) * scan_angle_size / float(n_points)) + ",x=" + x + ",y=", y);
          if (MIRROR_ENABLE)
            x = SCREEN_WIDTH / 2 - x;
          else
            x += SCREEN_WIDTH / 2;
          y += TEXT_MARGIN + FONT_HEIGHT / 2;
        }
        else if (ROTATE_FACTOR == 180) {
          cx = float(distance) * sin(radians(angle));
          cy = float(distance) * cos(radians(angle));
          x = int(cx / ZOOM_FACTOR);
          y = int(cy / ZOOM_FACTOR);
          if (PRINT_DataFunc_Draw) println("point=", j, ",distance=" + distance + ",angle=" + (scan_angle_start + float(j) * scan_angle_size / float(n_points)) + ",x=" + x + ",y=", y);
          x = SCREEN_WIDTH - x; 
          x -= TEXT_MARGIN + FONT_HEIGHT / 2;
          if (MIRROR_ENABLE)
            y = SCREEN_HEIGHT / 2 - y;
          else
            y += SCREEN_HEIGHT / 2;
        }
        else /*if (ROTATE_FACTOR == 270)*/ {
          cx = float(distance) * cos(radians(angle));
          cy = float(distance) * sin(radians(angle));
          x = int(cx / ZOOM_FACTOR);
          y = int(cy / ZOOM_FACTOR);
          if (PRINT_DataFunc_Draw) println("point=", j, ",distance=" + distance + ",angle=" + (scan_angle_start + float(j) * scan_angle_size / float(n_points)) + ",x=" + x + ",y=", y);
          if (MIRROR_ENABLE)
            x += SCREEN_WIDTH / 2;
          else
            x = SCREEN_WIDTH / 2 - x;
          y = SCREEN_HEIGHT - y;
          y -= TEXT_MARGIN + FONT_HEIGHT / 2;
        }
        // Check pulse width exist
        if (content != 4) {
          colorMode(HSB, DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH);
          //print("[" + j + "]=" + pulse_widths[j] + " ");
          if(pulse_width > DATA_MAX_PULSE_WIDTH) {
            c_draw_point =
              color(
                (DATA_MAX_PULSE_WIDTH + int(float(DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH) * 5.0 / 6.0) - DATA_MAX_PULSE_WIDTH) % (DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH + 1),
                DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH,
                DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH);
          }
          else if(pulse_width < DATA_MIN_PULSE_WIDTH) {
            c_draw_point =
              color(
                (DATA_MAX_PULSE_WIDTH + int(float(DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH) * 5.0 / 6.0) - DATA_MIN_PULSE_WIDTH) % (DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH + 1),
                DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH,
                DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH);
          }
          else {
            c_draw_point =
              color(
                (DATA_MAX_PULSE_WIDTH + int(float(DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH) * 5.0 / 6.0) - pulse_width) % (DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH + 1),
                DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH,
                DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH);
          }
          c_draw_line =
            color(
              (DATA_MAX_PULSE_WIDTH + int((float(DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH) * 5.0 / 6.0) - (float(pulse_width + p_pulse_width) / 2.0))) % (DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH + 1),
              DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH,
              DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH);
          colorMode(RGB, 255);
        }
        else {
          c_draw_point = C_DATA_POINT;
          p_c_draw_point = C_DATA_POINT;
          c_draw_line = C_DATA_LINE;
        }

        // Reset width and height point rect
        wh = DATA_POINT_WH;
        // Check mouse pointer over point rect.
        if( BUBBLEINFO_AVAILABLE != true &&
            (x + GRID_OFFSET_X > mouseX - range && x + GRID_OFFSET_X < mouseX + range) &&
            (y + GRID_OFFSET_Y > mouseY - range && y + GRID_OFFSET_Y < mouseY + range) ) {
          //println("point=" + j + ",distance=" + (float(distance)/10000.0) + "m(" + (cx/10000.0) + "," + (cy/10000.0) + ")" + ",pulse width=" + pulse_width);
          BUBBLEINFO_AVAILABLE = true;
          BUBBLEINFO_POINT = j;
          BUBBLEINFO_DISTANCE = float(distance)/10000.0;
          BUBBLEINFO_COR_X = (int(cx)/10000.0);
          BUBBLEINFO_COR_Y = (int(cy)/10000.0);
          BUBBLEINFO_BOX_X = x + GRID_OFFSET_X;
          BUBBLEINFO_BOX_Y = y + GRID_OFFSET_Y;
          BUBBLEINFO_ANGLE = float(int(angle*100.0))/100.0;
          BUBBLEINFO_PULSE_WIDTH = pulse_width;
          wh = BUBBLEINFO_POINT_WH;
        }
        
        if (p_x != -1 && p_y != -1) {
          //print(j + ":" + p_pulse_width + "," + pulse_width + " ");
          fill(c_draw_line);
          stroke(c_draw_line);
          line(p_x + GRID_OFFSET_X, p_y + GRID_OFFSET_Y, x + GRID_OFFSET_X, y + GRID_OFFSET_Y);
          fill(p_c_draw_point);
          stroke(p_c_draw_point);
          //point(p_x + GRID_OFFSET_X, p_y + GRID_OFFSET_Y);
          rect(p_x + GRID_OFFSET_X - 1, p_y + GRID_OFFSET_Y - 1, DATA_POINT_WH, DATA_POINT_WH );
        }
        fill(c_draw_point);
        stroke(c_draw_point);
        //point(x + GRID_OFFSET_X, y + GRID_OFFSET_Y);
        rect(x + GRID_OFFSET_X - wh / 2, y + GRID_OFFSET_Y - wh / 2, wh, wh );

        // Save data for drawing line with points. 
        p_x = x;
        p_y = y;
        p_c_draw_point = c_draw_point;
        p_pulse_width = pulse_width;
      }
/*
      // Check pulse width exist
      if (content != 4) {
        // Get Pulse width
        // : indications of the signal's strength and are provided in picoseconds.
        pulse_width = pulse_widths[j];
        if (PRINT_DataFunc_Draw) println("point=", j, ",pulse width=" + pulse_width);
      }
*/
    } // End of for (int j = 0; j < n_points; j++)
  } // End of draw_points()
}