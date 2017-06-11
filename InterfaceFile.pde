// Get OS Name
final String OS = System.getProperty("os.name");

// Define default binary buf filename and path 
final static String FILE_NAME = "data.bin";
static String FILE_name;
static long FILE_last_modified_time = 0;

void interface_file_reset()
{
  FILE_last_modified_time = 0;

}

void interface_file_setup()
{
  // 
  if (FILE_name.equals(FILE_NAME) == true) {
    // Check OS
    if (OS.equals("Linux")) {
      // Define binary data filename and path for Linux OS
      FILE_name = "/tmp/data.bin";
    }
    // Assume Windows OS 
    else {
      // Define binary data filename and path for Windows OS
      //FILE_name = "C:\\work\\git\\PSDemoProgram\\Release-windows\\data.bin";
      FILE_name = "C:\\Temp\\data.bin";
    }
    config_save();
  }
  Title += "(" + FILE_name + ")";
}

boolean interface_file_load()
{
  String string;
  byte[] buf;

  // Check file exists to avoid exception error on loadBytes().
  File file = new File(FILE_name);
  if (file.exists() != true || file.isDirectory()) {
    // Sets the color used to draw lines and borders around shapes.
    fill(C_TEXT);
    stroke(C_TEXT);
    string = "Error: File not exist! " + FILE_name;
    textSize(FONT_HEIGHT*3);
    text(string, SCREEN_WIDTH / 2 - int(textWidth(string) / 2.0), SCREEN_HEIGHT / 2 - FONT_HEIGHT);
    textSize(FONT_HEIGHT);
    if (PRINT_DataFunc_Load) println("File not exist!:" + FILE_name);
    return false;
  } // End of load()

  // Check file changed
  if (FILE_last_modified_time == file.lastModified())
  {
    if (PRINT_DataFunc_Load) println("File not changed!:" + FILE_name + "," + FILE_last_modified_time);
    return false;
  }
  
  // Update time_last_modified
  FILE_last_modified_time = file.lastModified();

  // Load binary buf.
  data_buf = loadBytes(FILE_name);
  if (PRINT_DataFunc_Load) println("buf.length = " + buf.length);
  // Check binary buf length is valid.
  // Must larger than Function code(4B) + Length(4B) + Number of parameters(4B) + Number of points(4B) + CRC(4B).
  if (data_buf.length <= 4 + 4 + 4 + 4 + 4) {
    // Sets the color used to draw lines and borders around shapes.
    fill(C_TEXT);
    stroke(C_TEXT);
    string = "Error: File size is invalid! " + data_buf.length;
    textSize(FONT_HEIGHT*3);
    text(string, SCREEN_WIDTH / 2 - int(textWidth(string) / 2.0), SCREEN_HEIGHT / 2 - FONT_HEIGHT);
    textSize(FONT_HEIGHT);
    if (PRINT_DataFunc_Load) println("File size is invalid!:" + data_buf.length);
    return false;
  }
  
  return true;
}