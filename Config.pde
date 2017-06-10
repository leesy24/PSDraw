// Define default binary buf filename and path 
final static String CONFIG_file_name = "config.csv";

// A Table object
static Table config;

void config_settings()
{
  try {
    // Load config file(CSV type) into a Table object
    // "header" option indicates the file has a header row
    config = loadTable(CONFIG_file_name, "header");
  
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

    saveTable(config, "data/" + CONFIG_file_name);
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
  }

  // Check config changed
  if(changed) {
    // Writing the config file(CSV type) back to the same file
    saveTable(config, "data/" + CONFIG_file_name);
  }
}