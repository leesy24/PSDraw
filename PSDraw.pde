// Open a file and read its binary data 
byte data[]; 

void setup() 
{
  size(640, 480);
  background(0);
  frameRate(30);
  data = loadBytes("data.bin");
  println("data.length = ", data.length);
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

  // Print each value, from 0 to 255 
  for (int i = 0; i < data.length - 4; i++) { 
    func = str(char(data[i])) + str(char(data[i+1])) + str(char(data[i+2])) + str(char(data[i+3]));
    //println("s.length() = ", s.length(), s);
    if (func.equals("GSCN") == true) {
      println("index=" + i + ",func=" + func + ")");
      i = i + 4;

      len = get_int32_bytes(data, i);
      println("index=" + i + ",length=" + len);
      i = i + 4;

      n_params = get_int32_bytes(data, i);
      println("index=" + i + ",number of parameters=" + n_params);
      i = i + 4;

      i_scan = get_int32_bytes(data, i);
      println("index=" + i + ",scan number=" + i_scan);
      i = i + 4;

      time_stamp = get_int32_bytes(data, i);
      println("index=" + i + ",time stamp=" + time_stamp);
      i = i + 4;

      scan_angle_start = get_int32_bytes(data, i) / 1000f;
      println("index=" + i + ",scan start angle=" + scan_angle_start);
      i = i + 4;

      scan_angle_range = get_int32_bytes(data, i) / 1000f;
      println("index=" + i + ",scan range angle=" + scan_angle_range);
      i = i + 4;

      n_echos = get_int32_bytes(data, i);
      println("index=" + i + ",number of echos=" + n_echos);
      i = i + 4;

      i_encoder = get_int32_bytes(data, i);
      println("index=" + i + ",encoder value=" + i_encoder);
      i = i + 4;

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