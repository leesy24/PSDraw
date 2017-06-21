// Define default binary buf filename and path 
final static String CONST_FILE_NAME = "const";
final static String CONST_FILE_EXT = ".csv";
static String CONST_file_full_name;

// A Table object
static Table CONST_table;


void const_settings()
{
  CONST_file_full_name = CONST_FILE_NAME + CONST_FILE_EXT;

  try {
    // Load config file(CSV type) into a Table object
    // "header" option indicates the file has a header row
    CONST_table = loadTable(CONST_file_full_name, "header");
  
    for (TableRow variable : CONST_table.rows()) {
      // You can access the fields via their column name (or index)
      String name = variable.getString("Name");
      if(name.equals("FRAME_RATE"))
        FRAME_RATE = variable.getInt("Value");
      else if(name.equals("C_BG"))
        C_BG = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_TEXT"))
        C_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_BUBBLEINFO_RECT_FILL"))
        C_BUBBLEINFO_RECT_FILL = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_BUBBLEINFO_RECT_STROKE"))
        C_BUBBLEINFO_RECT_STROKE = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_BUBBLEINFO_TEXT"))
        C_BUBBLEINFO_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_BTN_NORMAL"))
        C_BTN_NORMAL = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_BTN_HIGHLIGHT"))
        C_BTN_HIGHLIGHT = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_BTN_TEXT"))
        C_BTN_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_COLORBAR_RECT_FILL"))
        C_COLORBAR_RECT_FILL = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_COLORBAR_RECT_STROKE"))
        C_COLORBAR_RECT_STROKE = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_COLORBAR_TEXT"))
        C_COLORBAR_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_DATA_LINE"))
        C_DATA_LINE = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_DATA_POINT"))
        C_DATA_POINT = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_DATA_RECT_FILL"))
        C_DATA_RECT_FILL = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_DATA_RECT_STROKE"))
        C_DATA_RECT_STROKE = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_DATA_RECT_TEXT"))
        C_DATA_RECT_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_GRID_LINE"))
        C_GRID_LINE = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_GRID_TEXT"))
        C_GRID_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_INTERFACE_NORMAL"))
        C_INTERFACE_NORMAL = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_INTERFACE_HIGHLIGHT"))
        C_INTERFACE_HIGHLIGHT = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_INTERFACE_TEXT"))
        C_INTERFACE_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_INTERFACE_TL_TEXT"))
        C_INTERFACE_TL_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_INTERFACE_DD_TEXT"))
        C_INTERFACE_DD_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_INTERFACE_DD_BORDER_FILL"))
        C_INTERFACE_DD_BORDER_FILL = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_INTERFACE_DD_BORDER_NORMAL"))
        C_INTERFACE_DD_BORDER_NORMAL = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_INTERFACE_DD_BORDER_HIGHLIGHT"))
        C_INTERFACE_DD_BORDER_HIGHLIGHT = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_INTERFACE_DD_NORMAL"))
        C_INTERFACE_DD_NORMAL = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_INTERFACE_DD_FOREGROUND"))
        C_INTERFACE_DD_FOREGROUND = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_INTERFACE_DD_ACTIVE"))
        C_INTERFACE_DD_ACTIVE = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_INTERFACE_TF_TEXT"))
        C_INTERFACE_TF_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_INTERFACE_TF_FILL"))
        C_INTERFACE_TF_FILL = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_INTERFACE_TF_NORMAL"))
        C_INTERFACE_TF_NORMAL = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_INTERFACE_TF_HIGHLIGHT"))
        C_INTERFACE_TF_HIGHLIGHT = (int)Long.parseLong(variable.getString("Value"), 16);
      else if(name.equals("C_INTERFACE_TF_CURSOR"))
        C_INTERFACE_TF_CURSOR = (int)Long.parseLong(variable.getString("Value"), 16);
    }
  }
  catch (Exception e) {
    TableRow variable;

    //println("loadTable exception! " + e);

    CONST_table = new Table();
    CONST_table.addColumn("Name");
    CONST_table.addColumn("Value");

    variable = CONST_table.addRow();
    variable.setString("Name", "FRAME_RATE");
    variable.setInt("Value", FRAME_RATE);

    variable = CONST_table.addRow();
    variable.setString("Name", "C_BG");
    variable.setString("Value", String.format("%08X", C_BG));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_TEXT");
    variable.setString("Value", String.format("%08X", C_TEXT));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_BUBBLEINFO_RECT_FILL");
    variable.setString("Value", String.format("%08X", C_BUBBLEINFO_RECT_FILL));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_BUBBLEINFO_RECT_STROKE");
    variable.setString("Value", String.format("%08X", C_BUBBLEINFO_RECT_STROKE));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_BUBBLEINFO_TEXT");
    variable.setString("Value", String.format("%08X", C_BUBBLEINFO_TEXT));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_BTN_NORMAL");
    variable.setString("Value", String.format("%08X", C_BTN_NORMAL));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_BTN_HIGHLIGHT");
    variable.setString("Value", String.format("%08X", C_BTN_HIGHLIGHT));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_BTN_TEXT");
    variable.setString("Value", String.format("%08X", C_BTN_TEXT));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_COLORBAR_RECT_FILL");
    variable.setString("Value", String.format("%08X", C_COLORBAR_RECT_FILL));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_COLORBAR_RECT_STROKE");
    variable.setString("Value", String.format("%08X", C_COLORBAR_RECT_STROKE));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_COLORBAR_TEXT");
    variable.setString("Value", String.format("%08X", C_COLORBAR_TEXT));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_DATA_LINE");
    variable.setString("Value", String.format("%08X", C_DATA_LINE));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_DATA_POINT");
    variable.setString("Value", String.format("%08X", C_DATA_POINT));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_DATA_RECT_FILL");
    variable.setString("Value", String.format("%08X", C_DATA_RECT_FILL));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_DATA_RECT_STROKE");
    variable.setString("Value", String.format("%08X", C_DATA_RECT_STROKE));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_DATA_RECT_TEXT");
    variable.setString("Value", String.format("%08X", C_DATA_RECT_TEXT));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_GRID_LINE");
    variable.setString("Value", String.format("%08X", C_GRID_LINE));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_GRID_TEXT");
    variable.setString("Value", String.format("%08X", C_GRID_TEXT));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_INTERFACE_NORMAL");
    variable.setString("Value", String.format("%08X", C_INTERFACE_NORMAL));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_INTERFACE_HIGHLIGHT");
    variable.setString("Value", String.format("%08X", C_INTERFACE_HIGHLIGHT));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_INTERFACE_TEXT");
    variable.setString("Value", String.format("%08X", C_INTERFACE_TEXT));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_INTERFACE_TL_TEXT");
    variable.setString("Value", String.format("%08X", C_INTERFACE_TL_TEXT));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_INTERFACE_DD_TEXT");
    variable.setString("Value", String.format("%08X", C_INTERFACE_DD_TEXT));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_INTERFACE_DD_BORDER_FILL");
    variable.setString("Value", String.format("%08X", C_INTERFACE_DD_BORDER_FILL));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_INTERFACE_DD_BORDER_NORMAL");
    variable.setString("Value", String.format("%08X", C_INTERFACE_DD_BORDER_NORMAL));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_INTERFACE_DD_BORDER_HIGHLIGHT");
    variable.setString("Value", String.format("%08X", C_INTERFACE_DD_BORDER_HIGHLIGHT));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_INTERFACE_DD_NORMAL");
    variable.setString("Value", String.format("%08X", C_INTERFACE_DD_NORMAL));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_INTERFACE_DD_FOREGROUND");
    variable.setString("Value", String.format("%08X", C_INTERFACE_DD_FOREGROUND));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_INTERFACE_DD_ACTIVE");
    variable.setString("Value", String.format("%08X", C_INTERFACE_DD_ACTIVE));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_INTERFACE_TF_TEXT");
    variable.setString("Value", String.format("%08X", C_INTERFACE_TF_TEXT));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_INTERFACE_TF_FILL");
    variable.setString("Value", String.format("%08X", C_INTERFACE_TF_FILL));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_INTERFACE_TF_NORMAL");
    variable.setString("Value", String.format("%08X", C_INTERFACE_TF_NORMAL));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_INTERFACE_TF_HIGHLIGHT");
    variable.setString("Value", String.format("%08X", C_INTERFACE_TF_HIGHLIGHT));

    variable = CONST_table.addRow();
    variable.setString("Name", "C_INTERFACE_TF_CURSOR");
    variable.setString("Value", String.format("%08X", C_INTERFACE_TF_CURSOR));

    saveTable(CONST_table, "data/" + CONST_file_full_name);
  }
}
