// Define default binary buf filename and path 
final static String LINES_FILE_NAME = "lines";
final static String LINES_FILE_EXT = ".csv";
static String LINES_file_full_name;

static color C_LINES_LINE = #000000;
static int W_LINES_LINE = 3;

// A Table object
static Table LINES_table = null;
int[][] LINES_points;

void lines_settings()
{
  if(CONFIG_instance_number != null) {
    LINES_file_full_name = LINES_FILE_NAME + "_" + CONFIG_instance_number + LINES_FILE_EXT;
  }
  else {
    LINES_file_full_name = LINES_FILE_NAME + LINES_FILE_EXT;
  }

  // Load lines file(CSV type) into a Table object
  // "header" option indicates the file has a header row
  LINES_table = loadTable(LINES_file_full_name, "header");
  // Check loadTable failed.
  if(LINES_table == null)
  {
    if(CONFIG_instance_number == null)
    {
      return;
    }

    // Load default lines file.
    LINES_file_full_name = LINES_FILE_NAME + LINES_FILE_EXT;
    LINES_table = loadTable(LINES_file_full_name, "header");
    // Check loadTable failed.
    if(LINES_table == null)
    {
      return;
    }
  }

  //println("LINES_table.getRowCount()=" + LINES_table.getRowCount());
  LINES_points = new int[LINES_table.getRowCount()][2];
  //println("LINES_points.length=" + LINES_points.length);

  int i = 0;
  for (TableRow variable : LINES_table.rows())
  {
    // You can access the fields via their column name (or index)
    LINES_points[i][0] = variable.getInt("X") * 100;
    LINES_points[i][1] = variable.getInt("Y") * 100;
    //println("LINES_points[" + i + "].x=" + LINES_points[i][0] + ",LINES_points[" + i + "].y=" + LINES_points[i][1]); 
    i ++;
  }
}

void lines_draw()
{
  if(LINES_points == null) return;

  int point_x, point_y;
  int x_curr, y_curr;
  int x_prev = -1, y_prev = -1;
  int offset_x, offset_y;

  // Ready constant values for performance.
  if (ROTATE_FACTOR == 0) {
    offset_x = TEXT_MARGIN + FONT_HEIGHT / 2;
    offset_y = SCREEN_height / 2;
  }
  else if (ROTATE_FACTOR == 90) {
    offset_x = SCREEN_width / 2;
    offset_y = TEXT_MARGIN + FONT_HEIGHT / 2;
  }
  else if (ROTATE_FACTOR == 180) {
    offset_x = SCREEN_width - (TEXT_MARGIN + FONT_HEIGHT / 2);
    offset_y = SCREEN_height / 2;
  }
  else /*if (ROTATE_FACTOR == 270)*/ {
    offset_x = SCREEN_width / 2;
    offset_y = SCREEN_height - (TEXT_MARGIN + FONT_HEIGHT / 2);
  }

  fill(C_LINES_LINE);
  stroke(C_LINES_LINE);
  strokeWeight(W_LINES_LINE);
  for(int i = 0; i < LINES_points.length; i ++)
  {
    if (ROTATE_FACTOR == 0) {
      point_y = LINES_points[i][0];
      point_x = LINES_points[i][1];
      x_curr = int(point_x / ZOOM_FACTOR);
      y_curr = int(point_y / ZOOM_FACTOR);
      x_curr += offset_x;
      if (MIRROR_ENABLE)
        y_curr += offset_y;
      else
        y_curr = offset_y - y_curr;
    }
    else if (ROTATE_FACTOR == 90) {
      point_x = LINES_points[i][0];
      point_y = LINES_points[i][1];
      x_curr = int(point_x / ZOOM_FACTOR);
      y_curr = int(point_y / ZOOM_FACTOR);
      if (MIRROR_ENABLE)
        x_curr = offset_x - x_curr;
      else
        x_curr += offset_x;
      y_curr += offset_y;
    }
    else if (ROTATE_FACTOR == 180) {
      point_y = LINES_points[i][0];
      point_x = LINES_points[i][1];
      x_curr = int(point_x / ZOOM_FACTOR);
      y_curr = int(point_y / ZOOM_FACTOR);
      x_curr = offset_x - x_curr; 
      if (MIRROR_ENABLE)
        y_curr = offset_y - y_curr;
      else
        y_curr += offset_y;
    }
    else /*if (ROTATE_FACTOR == 270)*/ {
      point_x = LINES_points[i][0];
      point_y = LINES_points[i][1];
      x_curr = int(point_x / ZOOM_FACTOR);
      y_curr = int(point_y / ZOOM_FACTOR);
      if (MIRROR_ENABLE)
        x_curr += offset_x;
      else
        x_curr = offset_x - x_curr;
      y_curr = offset_y - y_curr;
    }
    //println("point_x=" + point_x + ",point_y=" + point_y);
    //println("x_curr=" + x_curr + ",y_curr=" + y_curr + ",x_prev=" + x_prev + ",y_prev=" + y_prev);
    if (x_prev != -1 && y_prev != -1) {
      line(x_prev + GRID_OFFSET_X, y_prev + GRID_OFFSET_Y, x_curr + GRID_OFFSET_X, y_curr + GRID_OFFSET_Y);
    }
    // Save data for drawing line between previous and current points. 
    x_prev = x_curr;
    y_prev = y_curr;
  }
  strokeWeight(1);
}
