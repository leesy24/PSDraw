// Open a file and read its binary data 
byte data[]; 
final int screen_width = 640;
final int screen_height = 480;

void settings() {
  size(screen_width, screen_height);
}

void setup() {
  background(0);
  stroke(255);
  frameRate(1);
}

void draw() {
  String func;
  int len;
  int n_params;
  int i_scan;
  int time_stamp;
  float scan_angle_start;
  float scan_angle_range;
  int n_echos;
  int i_encoder;
  float temperature;
  int status;
  int content = 0;
  int n_points;
  int distance;
  int pulse_width;
  int crc;

  data = loadBytes("data.bin");
  println("data.length = ", data.length);

  // Print each value, from 0 to 255 
  for (int i = 0; i < data.length - 4; i++) { 
    func = str(char(data[i])) + str(char(data[i+1])) + str(char(data[i+2])) + str(char(data[i+3]));
    if (func.equals("GSCN") == true) {
      println("index=" + i + ",func=" + func);
      i = i + 4;

      len = get_int32_bytes(data, i);
      println("index=" + i + ",length=" + len);
      i = i + 4;

      n_params = get_int32_bytes(data, i);
      println("index=" + i + ",number of parameters=" + n_params);
      i = i + 4;

      if (n_params >= 1) {
        i_scan = get_int32_bytes(data, i);
        println("index=" + i + ",scan number=" + i_scan);
        i = i + 4;
      }

      if (n_params >= 2) {
        time_stamp = get_int32_bytes(data, i);
        println("index=" + i + ",time stamp=" + time_stamp);
        i = i + 4;
      }

      if (n_params >= 3) {
        scan_angle_start = get_int32_bytes(data, i) / 1000f;
        println("index=" + i + ",scan start angle=" + scan_angle_start);
        i = i + 4;
      }

      if (n_params >= 4) {
        scan_angle_range = get_int32_bytes(data, i) / 1000f;
        println("index=" + i + ",scan range angle=" + scan_angle_range);
        i = i + 4;
      }

      if (n_params >= 5) {
        n_echos = get_int32_bytes(data, i);
        println("index=" + i + ",number of echos=" + n_echos);
        i = i + 4;
      }

      if (n_params >= 6) {
        i_encoder = get_int32_bytes(data, i);
        println("index=" + i + ",encoder value=" + i_encoder);
        i = i + 4;
      }

      if (n_params >= 7) {
        temperature = get_int32_bytes(data, i) / 10f;
        println("index=" + i + ",system temperature=" + temperature);
        i = i + 4;
      }

      if (n_params >= 8) {
        status = get_int32_bytes(data, i);
        println("index=" + i + ",system status=" + status);
        i = i + 4;
      }

      if (n_params >= 9) {
        content = get_int32_bytes(data, i);
        println("index=" + i + ",data content=" + content);
        i = i + 4;
      }

      n_points = get_int32_bytes(data, i);
      println("index=" + i + ",number of points=" + n_points);
      i = i + 4;

      for (int j = 0; j < n_points; j++) {
        distance = get_int32_bytes(data, i);
        if (distance == 0x80000000) {
          //println("index=" + i + ",point=", j, ",distance=" + "No echo");
        }
        else if (distance == 0x7fffffff) {
          //println("index=" + i + ",point=", j, ",distance=" + "Noise");
        }
        else {
          //println("index=" + i + ",point=", j, ",distance=" + distance);
          point(j*screen_width/n_points, distance/100);
        }
        i = i + 4;
  
        if (content != 4) {
          pulse_width = get_int32_bytes(data, i);
          //println("index=" + i + ",point=", j, ",pulse width=" + pulse_width);
          i = i + 4;
        }
      }

      crc = get_int32_bytes(data, i);
      println("index=" + i + ",crc=" + crc);
      i = i + 4;

      i = i - 1;
    }
  }
  // Print a blank line at the end 
  println();
} 

int get_int32_bytes(byte data[], int i) {
  return ((data[i + 0] & 0xff) << 24) +
         ((data[i + 1] & 0xff) << 16) +
         ((data[i + 2] & 0xff) << 8) +
         ((data[i + 3] & 0xff) << 0);
}