void grid_draw_rotate_0()
{
  final int const_screen_width_d_100 = SCREEN_width / 100;
  final int const_screen_height_d_100 = SCREEN_height / 100;
  final int const_screen_height_d_100_d_2 = const_screen_height_d_100 / 2;
  final int const_screen_x_start = TEXT_MARGIN;
  final int const_screen_x_end = SCREEN_width - TEXT_MARGIN;
  final int const_screen_y_start = TEXT_MARGIN + FONT_HEIGHT;
  final int const_screen_y_end = SCREEN_height - TEXT_MARGIN;
  final int const_font_height_d_2 = FONT_HEIGHT / 2;
  final float const_zoom_factor_d_100 = ZOOM_FACTOR / 100.0;
  final int const_offset_ix = int(const_zoom_factor_d_100 * float(GRID_OFFSET_X / 100 * 100));
  final int const_offset_iy = int(const_zoom_factor_d_100 * float(GRID_OFFSET_Y / 100 * 100));
  final int const_grid_offset_x = TEXT_MARGIN + const_font_height_d_2 + (GRID_OFFSET_X % 100);
  final int const_grid_offset_y = ((SCREEN_height % 100) / 2) + (GRID_OFFSET_Y % 100) + (((const_screen_height_d_100 % 2) == 0)?0:50);
  final int const_str_base_ix_y = SCREEN_height / 2 + const_font_height_d_2 + GRID_OFFSET_Y;
  final int const_str_base_iy_x = TEXT_MARGIN + const_font_height_d_2 + GRID_OFFSET_X;
  String string;
  int x, y;
  int ix, iy;
  int image_x = -1, image_y = -1;

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
  for (iy = -100; iy <= SCREEN_height + 100; iy += 100) {
    line(0,            iy + const_grid_offset_y,
         SCREEN_width, iy + const_grid_offset_y);
  }
  for (ix = 0; ix <= SCREEN_width + 100; ix += 100) {
    line(ix + const_grid_offset_x, 0,
         ix + const_grid_offset_x, SCREEN_height);
  }

  // Sets the color used to draw text and borders around shapes.
  fill(C_GRID_TEXT);
  stroke(C_GRID_TEXT);
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
    x = const_str_base_iy_x - int(textWidth(string) / 2.0);
    if (x < const_screen_x_start) x = const_screen_x_start;
    if (x > const_screen_x_end - int(textWidth(string))) x = const_screen_x_end - int(textWidth(string));
    y = iy * 100 + const_grid_offset_y;
    if(string.equals("0.0m")) {
      image_y = y;
    }
    y += const_font_height_d_2;
    text(string, x, y);
    //println("iy=" + iy + ":x=" + x + ",y=" + y + "," + string);
  }

  y = const_str_base_ix_y;
  if (y < const_screen_y_start) y = const_screen_y_start;
  if (y > const_screen_y_end) y = const_screen_y_end;
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
      x = ix * 100 + const_grid_offset_x;
      if(string.equals("0.0m")) {
        image_x = x;
      }
      x -= int(textWidth(string) / 2.0);
      text(string, x, y);
      //println("ix=" + ix + ":x=" + x + ",y=" + y + "," + string);
    }
  }

  if( (image_x >= 0 && image_x < SCREEN_width) && (image_y >= 0 && image_y < SCREEN_height) ) {
    //image(PS_image, image_x, image_y);
    image(PS_image, image_x - PS_image.width / 2, image_y - PS_image.height / 2);
  }
}