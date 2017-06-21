//static color C_GRID_LINE = #808080; // Black + 0x80
static color C_GRID_LINE = #C0C0C0; // Black + 0xC0
static color C_GRID_TEXT = #404040; // Black + 0x40
//static color C_GRID_TEXT = #808080; //Black + 0x80

int GRID_OFFSET_X = 0;
int GRID_OFFSET_Y = 0;
PImage PS_image;

void grid_draw_rotate_0()
{
  final int const_screen_width_d_100 = SCREEN_width / 100;
  final int const_screen_height_d_2 = SCREEN_height / 2;
  final int const_screen_height_d_100 = SCREEN_height / 100;
  final int const_screen_height_d_100_m_2 = const_screen_height_d_100 % 2;
  final int const_screen_height_d_100_d_2 = const_screen_height_d_100 / 2;
  final boolean const_even_flag = (const_screen_height_d_100_m_2 == 0)?true:false;
  final float const_zoom_factor_d_100 = ZOOM_FACTOR / 100.0;
  final int const_grid_offset_y_m_100 = GRID_OFFSET_Y % 100;
  final int const_grid_offset_x_m_100 = GRID_OFFSET_X % 100;
  final int const_screen_height_m_100_d_2 = (SCREEN_height % 100) / 2;
  final int const_screen_width_start = TEXT_MARGIN;
  final int const_screen_width_end = SCREEN_width - TEXT_MARGIN;
  final int const_screen_height_start = TEXT_MARGIN + FONT_HEIGHT;
  final int const_screen_height_end = SCREEN_height - TEXT_MARGIN;
  final int const_font_height_d_2 = FONT_HEIGHT / 2;
  final int const_even_odd_offset = const_screen_height_m_100_d_2 + const_font_height_d_2;
  final int const_offset_x = TEXT_MARGIN + const_font_height_d_2;
  final int const_offset_ix = int(const_zoom_factor_d_100 * float(GRID_OFFSET_X / 100 * 100));
  final int const_offset_iy = int(const_zoom_factor_d_100 * float(GRID_OFFSET_Y / 100 * 100));
  final int const_grid_offset_x = const_offset_x + const_grid_offset_x_m_100;
  final int const_grid_offset_y = const_screen_height_m_100_d_2 + const_grid_offset_y_m_100;
  final int const_str_base_iy_x = TEXT_MARGIN + const_font_height_d_2 + GRID_OFFSET_X;
  final int const_str_base_ix_y = const_screen_height_d_2 + const_font_height_d_2 + GRID_OFFSET_Y;
  final int const_str_offset_iy_y = const_even_odd_offset + const_grid_offset_y_m_100;
  String string;
  int x, y;
  int ix, iy;
  int image_x = -1, image_y = -1;
  int offset_even_odd;

  // Images must be in the "data" directory to load correctly
  if (MIRROR_ENABLE) {
    PS_image = loadImage("PS_0_.png");
  }
  else {
    PS_image = loadImage("PS_0.png");
  }

  // Sets the color used to draw lines and borders around shapes.
  fill(C_GRID_LINE);
  stroke(C_GRID_LINE);
  if(const_even_flag)
    offset_even_odd = const_grid_offset_y;
  else
    offset_even_odd = const_grid_offset_y + 50;
  for (iy = -1; iy <= const_screen_height_d_100 + 1; iy ++) {
    line(0,            iy * 100 + offset_even_odd,
         SCREEN_width, iy * 100 + offset_even_odd);
  }
  for (ix = 0; ix <= const_screen_width_d_100 + 1; ix ++) {
    line(ix * 100 + const_grid_offset_x, 0,
         ix * 100 + const_grid_offset_x, SCREEN_height);
  }

  // Sets the color used to draw text and borders around shapes.
  fill(C_GRID_TEXT);
  stroke(C_GRID_TEXT);
  if(const_even_flag)
    offset_even_odd = const_str_offset_iy_y;
  else
    offset_even_odd = const_str_offset_iy_y + 50;
  for (iy = -1; iy <= const_screen_height_d_100 + 1; iy ++) {
    if (MIRROR_ENABLE) {
      string =
        (
          float(
            int(
              const_zoom_factor_d_100 * float((iy - const_screen_height_d_100_d_2) * 100)
            )
            -
            const_offset_iy
          )
          /
          100.0
        )
        +
        "m";
    }
    else {
      string =
        (
          float(
            int(
              const_zoom_factor_d_100 * float((const_screen_height_d_100_d_2 - iy) * 100)
            )
            +
            const_offset_iy
          )
          /
          100.0
        )
        +
        "m";
    }
    y = iy * 100 + offset_even_odd;
    x = const_str_base_iy_x - int(textWidth(string) / 2.0);
    if (x < const_screen_width_start) x = const_screen_width_start;
    if (x > const_screen_width_end - int(textWidth(string))) x = const_screen_width_end - int(textWidth(string));
    text(string, x, y);
    if(string.equals("0.0m")) {
      image_y = y - const_font_height_d_2;
    }
    //println("iy=" + iy + ", string=" + string + ", x=" + x + ", y=" + y);
  }

  y = const_str_base_ix_y;
  if (y < const_screen_height_start) y = const_screen_height_start;
  if (y > const_screen_height_end) y = const_screen_height_end;
  for (ix = 0; ix <= const_screen_width_d_100 + 1; ix ++) {
    if ((int(const_zoom_factor_d_100 * float(ix * 100)) - const_offset_ix) >= 0) {
      string =
        (
          float(
            int(
              const_zoom_factor_d_100 * float(ix * 100)
            )
            -
            const_offset_ix
          )
          / 100.0
        )
        +
        "m";
      x = ix * 100 + const_grid_offset_x - int(textWidth(string) / 2.0);
      text(string, x, y);
      if(string.equals("0.0m")) {
        image_x = ix * 100 + const_grid_offset_x;
      }
    }
  }

  if( (image_x >= 0 && image_x < SCREEN_width) && (image_y >= 0 && image_y < SCREEN_height) ) {
    //image(PS_image, image_x, image_y);
    image(PS_image, image_x - PS_image.width / 2, image_y - PS_image.height / 2);
  }
}

void grid_draw_rotate_90()
{
  final int const_screen_width_d_2 = SCREEN_width / 2;
  final int const_screen_width_d_100 = SCREEN_width / 100;
  final int const_screen_width_d_100_d_2 = const_screen_width_d_100 / 2;
  final int const_screen_height_d_100 = SCREEN_height / 100;
  final int const_screen_height_d_100_m_2 = const_screen_height_d_100 % 2;
  final int const_screen_height_d_100_d_2 = const_screen_height_d_100 / 2;
  final boolean const_even_flag = ((const_screen_width_d_100) % 2 == 0)?true:false;
  final float const_zoom_factor_d_100 = ZOOM_FACTOR / 100.0;
  final int const_screen_width_m_100_d_2 = (SCREEN_width % 100) / 2;
  final int const_screen_width_start = TEXT_MARGIN;
  final int const_screen_width_end = SCREEN_width - TEXT_MARGIN;
  final int const_screen_height_start = TEXT_MARGIN + FONT_HEIGHT;
  final int const_screen_height_end = SCREEN_height - TEXT_MARGIN;
  final int const_font_height_d_2 = FONT_HEIGHT / 2;
  final int const_grid_offset_y_m_100 = GRID_OFFSET_Y % 100;
  final int const_grid_offset_x_m_100 = GRID_OFFSET_X % 100;
  final int const_offset_y = TEXT_MARGIN + const_font_height_d_2;
  final int const_offset_ix = int(const_zoom_factor_d_100 * float(GRID_OFFSET_X / 100 * 100));
  final int const_offset_iy = int(const_zoom_factor_d_100 * float(GRID_OFFSET_Y / 100 * 100));
  final int const_grid_base_x = const_screen_width_m_100_d_2 + const_grid_offset_x_m_100;
  final int const_grid_offset_y = const_offset_y + const_grid_offset_y_m_100;
  final int const_str_base_ix_y = const_screen_height_start + GRID_OFFSET_Y;
  final int const_str_base_iy_x = const_screen_width_d_2 + GRID_OFFSET_X;
  String string;
  int x, y;
  int ix, iy;
  int image_x = -1, image_y = -1;
  int offset_even_odd;

  // Images must be in the "data" directory to load correctly
  if (MIRROR_ENABLE) {
    PS_image = loadImage("PS_90_.png");
  }
  else {
    PS_image = loadImage("PS_90.png");
  }

  // Sets the color used to draw lines and borders around shapes.
  fill(C_GRID_LINE);
  stroke(C_GRID_LINE);
  if(const_even_flag)
    offset_even_odd = const_grid_base_x;
  else
    offset_even_odd = const_grid_base_x + 50;
  for (ix = -1; ix <= const_screen_width_d_100 + 1; ix ++) {
    line(ix * 100 + offset_even_odd, 0,
         ix * 100 + offset_even_odd, SCREEN_height);
  }
  for (iy = 0; iy <= const_screen_height_d_100 + 1; iy ++) {
    line(0,            iy * 100 + const_grid_offset_y,
         SCREEN_width, iy * 100 + const_grid_offset_y);
  }

  // Sets the color used to draw text and borders around shapes.
  fill(C_GRID_TEXT);
  stroke(C_GRID_TEXT);
  y = const_str_base_ix_y;
  if (y < const_screen_height_start) y = const_screen_height_start;
  if (y > const_screen_height_end) y = const_screen_height_end;
  for (ix = -1; ix <= const_screen_width_d_100 + 1; ix ++) {
    if (MIRROR_ENABLE) {
      string =
        (
          float(
            int(
              const_zoom_factor_d_100 * float((const_screen_width_d_100_d_2 - ix) * 100)
            )
            +
            const_offset_ix
          )
          /
          100.0
        )
        +
        "m";
    }
    else {
      string =
        (
          float(
            int(
              const_zoom_factor_d_100 * float((ix - const_screen_width_d_100_d_2) * 100)
            )
            -
            const_offset_ix
          )
          /
          100.0
        )
        +
        "m";
    }
    x = ix * 100 + offset_even_odd - int(textWidth(string) / 2.0);
    text(string, x, y);
    if(string.equals("0.0m")) {
      image_x = x + int(textWidth(string) / 2.0);
    }
    //println("ix=" + ix + ", string=" + string + ", x=" + x + ", y=" + y);
  }

  for (iy = 0; iy <= const_screen_height_d_100 + 1; iy ++) {
    if ((int(const_zoom_factor_d_100 * float(iy * 100)) - const_offset_iy) >= 0) {
      string =
        (
          float(
            int(
              const_zoom_factor_d_100 * float(iy * 100)
            )
            -
            const_offset_iy
          )
          / 100.0
        )
        +
        "m";
      x = const_str_base_iy_x - int(textWidth(string)/2);
      if (x < const_screen_width_start) x = const_screen_width_start;
      if (x > const_screen_width_end - int(textWidth(string))) x = const_screen_width_end - int(textWidth(string));
      y = iy * 100 + const_grid_offset_y + const_font_height_d_2;
      text(string, x, y);
      if(string.equals("0.0m")) {
        image_y = iy * 100 + const_grid_offset_y;
      }
    }
  }

  if( (image_x >= 0 && image_x < SCREEN_width) && (image_y >= 0 && image_y < SCREEN_height) ) {
    //image(PS_image, image_x, image_y);
    image(PS_image, image_x - PS_image.width / 2, image_y - PS_image.height / 2);
  }
}

void grid_draw_rotate_180()
{
  final int const_screen_width_d_100 = SCREEN_width / 100;
  final int const_screen_height_d_2 = SCREEN_height / 2;
  final int const_screen_height_d_100 = SCREEN_height / 100;
  final int const_screen_height_d_100_m_2 = const_screen_height_d_100 % 2;
  final int const_screen_height_d_100_d_2 = const_screen_height_d_100 / 2;
  final boolean const_even_flag = (const_screen_height_d_100_m_2 == 0)?true:false;
  final float const_zoom_factor_d_100 = ZOOM_FACTOR / 100.0;
  final int const_grid_offset_y_m_100 = GRID_OFFSET_Y % 100;
  final int const_grid_offset_x_m_100 = GRID_OFFSET_X % 100;
  final int const_screen_height_m_100_d_2 = (SCREEN_height % 100) / 2;
  final int const_screen_width_start = TEXT_MARGIN;
  final int const_screen_width_end = SCREEN_width - TEXT_MARGIN;
  final int const_screen_height_start = TEXT_MARGIN + FONT_HEIGHT;
  final int const_screen_height_end = SCREEN_height - TEXT_MARGIN;
  final int const_font_height_d_2 = FONT_HEIGHT / 2;
  final int const_even_odd_offset = const_screen_height_m_100_d_2 + const_font_height_d_2;
  final int const_base_x = SCREEN_width + GRID_OFFSET_X;
  final int const_offset_x = TEXT_MARGIN + const_font_height_d_2;
  final int const_grid_offset_x = const_offset_x - const_grid_offset_x_m_100;
  final int const_grid_offset_y = const_screen_height_m_100_d_2 + const_grid_offset_y_m_100;
  final int const_offset_ix = int(const_zoom_factor_d_100 * float(GRID_OFFSET_X / 100 * 100));
  final int const_offset_iy = int(const_zoom_factor_d_100 * float(GRID_OFFSET_Y / 100 * 100));
  final int const_str_base_ix_x = SCREEN_width - const_offset_x + const_grid_offset_x_m_100;
  final int const_str_base_ix_y = const_screen_height_d_2 + const_font_height_d_2 + GRID_OFFSET_Y;
  final int const_str_offset_iy_y = const_even_odd_offset + const_grid_offset_y_m_100;
  String string;
  int x, y;
  int ix, iy;
  int image_x = -1, image_y = -1;
  int offset_even_odd;

  // Images must be in the "data" directory to load correctly
  if (MIRROR_ENABLE) {
    PS_image = loadImage("PS_180_.png");
  }
  else {
    PS_image = loadImage("PS_180.png");
  }

  // Sets the color used to draw lines and borders around shapes.
  fill(C_GRID_LINE);
  stroke(C_GRID_LINE);
  if(const_even_flag)
    offset_even_odd = const_grid_offset_y;
  else
    offset_even_odd = const_grid_offset_y + 50;
  for (iy = -1; iy <= const_screen_height_d_100 + 1; iy ++) {
    line(0,            iy * 100 + offset_even_odd,
         SCREEN_width, iy * 100 + offset_even_odd);
  }
  for (ix = 0; ix <= const_screen_width_d_100 + 1; ix ++) {
    line(SCREEN_width - ix * 100 - const_grid_offset_x, 0,
         SCREEN_width - ix * 100 - const_grid_offset_x, SCREEN_height);
  }

  // Sets the color used to draw text and borders around shapes.
  fill(C_GRID_TEXT);
  stroke(C_GRID_TEXT);
  if(const_even_flag)
    offset_even_odd = const_str_offset_iy_y;
  else
    offset_even_odd = const_str_offset_iy_y + 50;
  for (iy = -1; iy <= const_screen_height_d_100 + 1; iy ++) {
    if (MIRROR_ENABLE) {
      string =
        (
          float(
            int(
              const_zoom_factor_d_100 * float((const_screen_height_d_100_d_2 - iy) * 100)
            )
            +
            const_offset_iy
          )
          /
          100.0
        )
        +
        "m";
    }
    else {
      string =
        (
          float(
            int(
              const_zoom_factor_d_100 * float((iy - const_screen_height_d_100_d_2) * 100)
            )
            -
            const_offset_iy
          )
          /
          100.0
        )
        +
        "m";
    }
    y = iy * 100 + offset_even_odd;
    x = const_base_x - const_offset_x - int(textWidth(string) / 2.0);
    if (x < const_screen_width_start) x = const_screen_width_start;
    if (x > const_screen_width_end - int(textWidth(string))) x = const_screen_width_end - int(textWidth(string));
    text(string, x, y);
    if(string.equals("0.0m")) {
      image_y = y - const_font_height_d_2;
    }
    //println("iy=" + iy + ", string=" + string + ", x=" + x + ", y=" + y);
  }

  y = const_str_base_ix_y;
  if (y < const_screen_height_start) y = const_screen_height_start;
  if (y > const_screen_height_end) y = const_screen_height_end;
  for (ix = 0; ix <= const_screen_width_d_100 + 1; ix ++) {
    if ((int(const_zoom_factor_d_100 * float(ix * 100)) + const_offset_ix) >= 0) {
      string =
        (
          float(
            int(
              const_zoom_factor_d_100 * float(ix * 100)
            )
            +
            const_offset_ix
          )
          / 100.0
        )
        +
        "m";
      x = const_str_base_ix_x - ix * 100 - int(textWidth(string) / 2.0);
      text(string, x, y);
      if(string.equals("0.0m")) {
        image_x = const_str_base_ix_x - ix * 100;
      }
    }
  }

  if( (image_x >= 0 && image_x < SCREEN_width) && (image_y >= 0 && image_y < SCREEN_height) ) {
    //image(PS_image, image_x, image_y);
    image(PS_image, image_x - PS_image.width / 2, image_y - PS_image.height / 2);
  }
}

void grid_draw_rotate_270()
{
  final int const_screen_width_d_2 = SCREEN_width / 2;
  final int const_screen_width_d_100 = SCREEN_width / 100;
  final int const_screen_width_d_100_d_2 = const_screen_width_d_100 / 2;
  final int const_screen_height_d_100 = SCREEN_height / 100;
  final int const_screen_height_d_100_m_2 = const_screen_height_d_100 % 2;
  final int const_screen_height_d_100_d_2 = const_screen_height_d_100 / 2;
  final boolean const_even_flag = ((const_screen_width_d_100) % 2 == 0)?true:false;
  final float const_zoom_factor_d_100 = ZOOM_FACTOR / 100.0;
  final int const_screen_width_m_100_d_2 = (SCREEN_width % 100) / 2;
  final int const_screen_width_start = TEXT_MARGIN;
  final int const_screen_width_end = SCREEN_width - TEXT_MARGIN;
  final int const_screen_height_start = TEXT_MARGIN + FONT_HEIGHT;
  final int const_screen_height_end = SCREEN_height - TEXT_MARGIN;
  final int const_font_height_d_2 = FONT_HEIGHT / 2;
  final int const_grid_offset_x_m_100 = GRID_OFFSET_X % 100;
  final int const_grid_offset_y_m_100 = GRID_OFFSET_Y % 100;
  final int const_grid_offset_x = const_screen_width_m_100_d_2 + const_grid_offset_x_m_100;
  final int const_grid_offset_y = TEXT_MARGIN + const_font_height_d_2 - const_grid_offset_y_m_100;
  final int const_offset_ix = int(const_zoom_factor_d_100 * float(GRID_OFFSET_X / 100 * 100));
  final int const_offset_iy = int(const_zoom_factor_d_100 * float(GRID_OFFSET_Y / 100 * 100));
  final int const_str_base_ix_y = const_screen_height_end + GRID_OFFSET_Y;
  final int const_str_base_iy_x = const_screen_width_d_2 + GRID_OFFSET_X;
  final int const_str_base_iy_y = const_screen_height_end + const_grid_offset_y_m_100;
  String string;
  int x, y;
  int ix, iy;
  int image_x = -1, image_y = -1;
  int offset_even_odd;

  // Images must be in the "data" directory to load correctly
  if (MIRROR_ENABLE) {
    PS_image = loadImage("PS_270_.png");
  }
  else {
    PS_image = loadImage("PS_270.png");
  }

  // Sets the color used to draw lines and borders around shapes.
  fill(C_GRID_LINE);
  stroke(C_GRID_LINE);
  if(const_even_flag)
    offset_even_odd = const_grid_offset_x;
  else
    offset_even_odd = const_grid_offset_x + 50;
  for (ix = -1; ix <= const_screen_width_d_100 + 1; ix ++) {
    line(ix * 100 + offset_even_odd, 0,
         ix * 100 + offset_even_odd, SCREEN_height);
  }
  for (iy = 0; iy <= const_screen_height_d_100 + 1; iy ++) {
    line(0,            SCREEN_height - iy * 100 - const_grid_offset_y,
         SCREEN_width, SCREEN_height - iy * 100 - const_grid_offset_y);
  }

  // Sets the color used to draw text and borders around shapes.
  fill(C_GRID_TEXT);
  stroke(C_GRID_TEXT);
  y = const_str_base_ix_y;
  if (y < const_screen_height_start) y = const_screen_height_start;
  if (y > const_screen_height_end) y = const_screen_height_end;
  for (ix = -1; ix <= const_screen_width_d_100 + 1; ix ++) {
    if (MIRROR_ENABLE) {
      string =
        (
          float(
            int(
              const_zoom_factor_d_100 * float((ix - const_screen_width_d_100_d_2) * 100)
            )
            -
            const_offset_ix
          )
          /
          100.0
        )
        +
        "m";
    }
    else {
      string =
        (
          float(
            int(
              const_zoom_factor_d_100 * float((const_screen_width_d_100_d_2 - ix) * 100)
            )
            +
            const_offset_ix
          )
          /
          100.0
        )
        +
        "m";
    }
    x = ix * 100 + offset_even_odd - int(textWidth(string) / 2.0);
    text(string, x, y);
    if(string.equals("0.0m")) {
      image_x = x + int(textWidth(string) / 2.0);
    }
    //println("ix=" + ix + ", string=" + string + ", x=" + x + ", y=" + y);
  }

  for (iy = 0; iy <= const_screen_height_d_100 + 1; iy ++) {
    if ((int(const_zoom_factor_d_100 * float(iy * 100)) + const_offset_iy) >= 0) {
      string =
        (
          float(
            int(
              const_zoom_factor_d_100 * float(iy * 100)
            )
            +
            const_offset_iy
          )
          / 100.0
        )
        +
        "m";
      x = const_str_base_iy_x - int(textWidth(string)/2);
      if (x < const_screen_width_start) x = const_screen_width_start;
      if (x > const_screen_width_end - int(textWidth(string))) x = const_screen_width_end - int(textWidth(string));
      y = const_str_base_iy_y - iy * 100;
      text(string, x, y);
      if(string.equals("0.0m")) {
        image_y = const_str_base_iy_y - const_font_height_d_2 - iy * 100;
      }
    }
  }

  if( (image_x >= 0 && image_x < SCREEN_width) && (image_y >= 0 && image_y < SCREEN_height) ) {
    //image(PS_image, image_x, image_y);
    image(PS_image, image_x - PS_image.width / 2, image_y - PS_image.height / 2);
  }
}

void grid_draw()
{
  if (ROTATE_FACTOR == 0) {
    grid_draw_rotate_0();
  } else if (ROTATE_FACTOR == 90) {
    grid_draw_rotate_90();
  } else if (ROTATE_FACTOR == 180) {
    grid_draw_rotate_180();
  } else /*if (ROTATE_FACTOR == 270)*/ {
    grid_draw_rotate_270();
  }
}
