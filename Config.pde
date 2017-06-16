// Define default binary buf filename and path 
final static String CONFIG_FILE_NAME = "config";
final static String CONFIG_FILE_EXT = ".csv";
static String CONFIG_file_full_name;
static int CONFIG_instance_number = 0;

// A Table object
static Table config;

void config_settings()
{
  CONFIG_file_full_name = CONFIG_FILE_NAME + CONFIG_FILE_EXT;
  
  try {
    if(CONFIG_instance_number != 0) {
      CONFIG_file_full_name = CONFIG_FILE_NAME + "_" + CONFIG_instance_number + CONFIG_FILE_EXT;
    }
    // Load config file(CSV type) into a Table object
    // "header" option indicates the file has a header row
    config = loadTable(CONFIG_file_full_name, "header");
  
    for (TableRow variable : config.rows()) {
      // You can access the fields via their column name (or index)
      String name = variable.getString("Name");
      if(name.equals("DATA_interface"))
        DATA_interface = variable.getInt("Value");
      else if(name.equals("ROTATE_FACTOR"))
        ROTATE_FACTOR = variable.getFloat("Value"); 
      else if(name.equals("MIRROR_ENABLE"))
        MIRROR_ENABLE = (variable.getString("Value").equals("true"))?true:false; 
      else if(name.equals("ZOOM_FACTOR"))
        ZOOM_FACTOR = variable.getFloat("Value"); 
      else if(name.equals("GRID_OFFSET_X"))
        GRID_OFFSET_X = variable.getInt("Value");
      else if(name.equals("GRID_OFFSET_Y"))
        GRID_OFFSET_Y = variable.getInt("Value");
      else if(name.equals("FILE_name"))
        FILE_name = variable.getString("Value");
      else if(name.equals("UART_port_name"))
        UART_port_name = variable.getString("Value");
      else if(name.equals("UART_baud_rate"))
        UART_baud_rate = variable.getInt("Value");
      else if(name.equals("UART_parity"))
        UART_parity = variable.getString("Value").charAt(0);
      else if(name.equals("UART_data_bits"))
        UART_data_bits = variable.getInt("Value");
      else if(name.equals("UART_stop_bits"))
        UART_stop_bits = variable.getFloat("Value"); 
      else if(name.equals("UDP_remote_ip"))
        UDP_remote_ip = variable.getString("Value");
      else if(name.equals("UDP_remote_port"))
        UDP_remote_port = variable.getInt("Value");
      else if(name.equals("UDP_local_port"))
        UDP_local_port = variable.getInt("Value");
    }
  }
  catch (Exception e) {
    TableRow variable;

    //println("loadTable exception! " + e);

    config = new Table();
    config.addColumn("Name");
    config.addColumn("Value");

    variable = config.addRow();
    variable.setString("Name", "DATA_interface");
    variable.setInt("Value", DATA_interface);

    variable = config.addRow();
    variable.setString("Name", "ROTATE_FACTOR");
    variable.setFloat("Value", ROTATE_FACTOR);

    variable = config.addRow();
    variable.setString("Name", "MIRROR_ENABLE");
    variable.setString("Value", ((MIRROR_ENABLE)?"true":"flase"));

    variable = config.addRow();
    variable.setString("Name", "ZOOM_FACTOR");
    variable.setFloat("Value", ZOOM_FACTOR);

    variable = config.addRow();
    variable.setString("Name", "GRID_OFFSET_X");
    variable.setInt("Value", GRID_OFFSET_X);

    variable = config.addRow();
    variable.setString("Name", "GRID_OFFSET_Y");
    variable.setInt("Value", GRID_OFFSET_Y);

    variable = config.addRow();
    variable.setString("Name", "FILE_name");
    variable.setString("Value", FILE_name);

    variable = config.addRow();
    variable.setString("Name", "UART_port_name");
    variable.setString("Value", UART_port_name);

    variable = config.addRow();
    variable.setString("Name", "UART_baud_rate");
    variable.setInt("Value", UART_baud_rate);

    variable = config.addRow();
    variable.setString("Name", "UART_parity");
    variable.setString("Value", Character.toString(UART_parity));

    variable = config.addRow();
    variable.setString("Name", "UART_data_bits");
    variable.setInt("Value", UART_data_bits);

    variable = config.addRow();
    variable.setString("Name", "UART_stop_bits");
    variable.setFloat("Value", UART_stop_bits);

    variable = config.addRow();
    variable.setString("Name", "UDP_remote_ip");
    variable.setString("Value", UDP_remote_ip);

    variable = config.addRow();
    variable.setString("Name", "UDP_remote_port");
    variable.setInt("Value", UDP_remote_port);

    variable = config.addRow();
    variable.setString("Name", "UDP_local_port");
    variable.setInt("Value", UDP_local_port);

    saveTable(config, "data/" + CONFIG_file_full_name);
  }
}

void config_save()
{
  int value_int;
  float value_float;
  boolean value_boolean;
  String value_string;
  boolean changed = false;

  for (TableRow variable : config.rows()) {
    // You can access the fields via their column name (or index)
    String name = variable.getString("Name");
    if(name.equals("DATA_interface")) {
      value_int = variable.getInt("Value");
      if(value_int != DATA_interface) {
        variable.setInt("Value", DATA_interface);
        changed = true;
      }
    }
    else if(name.equals("ROTATE_FACTOR")) {
      value_float = variable.getFloat("Value");
      if(value_float != ROTATE_FACTOR) {
        variable.setFloat("Value", ROTATE_FACTOR);
        changed = true;
      }
    }
    else if(name.equals("MIRROR_ENABLE")) {
      value_boolean = variable.getString("Value").equals("true")?true:false;
      if(value_boolean != MIRROR_ENABLE) {
        variable.setString("Value", ((MIRROR_ENABLE)?"true":"false"));
        changed = true;
      }
    }
    else if(name.equals("ZOOM_FACTOR")) {
      value_float = variable.getFloat("Value");
      if(value_float != ZOOM_FACTOR) {
        variable.setFloat("Value", ZOOM_FACTOR);
        changed = true;
      }
    }
    else if(name.equals("GRID_OFFSET_X")) {
      value_int = variable.getInt("Value");
      if(value_int != GRID_OFFSET_X) {
        variable.setInt("Value", GRID_OFFSET_X);
        changed = true;
      }
    }
    else if(name.equals("GRID_OFFSET_Y")) {
      value_int = variable.getInt("Value");
      if(value_int != GRID_OFFSET_Y) {
        variable.setInt("Value", GRID_OFFSET_Y);
        changed = true;
      }
    }
    else if(name.equals("FILE_name")) {
      value_string = variable.getString("Value");
      if(value_string.equals(FILE_name) != true) {
        variable.setString("Value", FILE_name);
        changed = true;
      }
    }
    else if(name.equals("UART_port_name")) {
      value_string = variable.getString("Value");
      if(value_string.equals(UART_port_name) != true) {
        variable.setString("Value", UART_port_name);
        changed = true;
      }
    }
    else if(name.equals("UART_baud_rate")) {
      value_int = variable.getInt("Value");
      if(value_int != UART_baud_rate) {
        variable.setInt("Value", UART_baud_rate);
        changed = true;
      }
    }
    else if(name.equals("UART_parity")) {
      value_string = variable.getString("Value");
      if(value_string.charAt(0) != UART_parity) {
        variable.setString("Value", Character.toString(UART_parity));
        changed = true;
      }
    }
    else if(name.equals("UART_data_bits")) {
      value_int = variable.getInt("Value");
      if(value_int != UART_data_bits) {
        variable.setInt("Value", UART_data_bits);
        changed = true;
      }
    }
    else if(name.equals("UART_stop_bits")) {
      value_float = variable.getFloat("Value");
      if(value_float != UART_stop_bits) {
        variable.setFloat("Value", UART_stop_bits);
        changed = true;
      }
    }
    else if(name.equals("UDP_remote_ip")) {
      value_string = variable.getString("Value");
      if(value_string.equals(UDP_remote_ip) != true) {
        variable.setString("Value", UDP_remote_ip);
        changed = true;
      }
    }
    else if(name.equals("UDP_remote_port")) {
      value_int = variable.getInt("Value");
      if(value_int != UDP_remote_port) {
        variable.setInt("Value", UDP_remote_port);
        changed = true;
      }
    }
    else if(name.equals("UDP_local_port")) {
      value_int = variable.getInt("Value");
      if(value_int != UDP_local_port) {
        variable.setInt("Value", UDP_local_port);
        changed = true;
      }
    }
  }

  // Check config changed
  if(changed) {
    // Writing the config file(CSV type) back to the same file
    saveTable(config, "data/" + CONFIG_file_full_name);
  }
}