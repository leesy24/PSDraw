void grid_draw_rotate_270()
{
  final int const_screen_width_d_100 = SCREEN_width / 100;
  final int const_screen_height_d_100 = SCREEN_height / 100;
  final int const_screen_width_d_100_d_2 = const_screen_width_d_100 / 2;
  final int const_screen_x_start = TEXT_MARGIN;
  final int const_screen_x_end = SCREEN_width - TEXT_MARGIN;
  final int const_screen_y_start = TEXT_MARGIN + FONT_HEIGHT;
  final int const_screen_y_end = SCREEN_height - TEXT_MARGIN;
  final int const_font_height_d_2 = FONT_HEIGHT / 2;
  final float const_zoom_factor_d_100 = ZOOM_FACTOR / 100.0;
  final int const_offset_ix = int(const_zoom_factor_d_100 * float(GRID_OFFSET_X / 100 * 100));
  final int const_offset_iy = int(const_zoom_factor_d_100 * float(GRID_OFFSET_Y / 100 * 100));
  final int const_grid_offset_x = ((SCREEN_width % 100) / 2) + (GRID_OFFSET_X % 100) + (((const_screen_width_d_100) % 2 == 0)?0:50);
  final int const_grid_offset_y = const_screen_y_end - const_font_height_d_2 + (GRID_OFFSET_Y % 100);
  final int const_str_base_ix_y = const_screen_y_end + GRID_OFFSET_Y;
  final int const_str_base_iy_x = (SCREEN_width / 2) + GRID_OFFSET_X;
  int x, y;
  int ix, iy;
  String string;
  float distance;
  int image_x = MIN_INT, image_y = MIN_INT;

  // Sets the color used to draw lines and borders around shapes.
  fill(C_GRID_LINE);
  stroke(C_GRID_LINE);
  for (ix = -100; ix <= SCREEN_width + 100; ix += 100) {
    line(ix + const_grid_offset_x, 0,
         ix + const_grid_offset_x, SCREEN_height);
    //println("ix="+ix+":offset_x="+const_grid_offset_x);
  }
  for (iy = 0; iy <= SCREEN_height + 100; iy += 100) {
    line(0,            const_grid_offset_y - iy,
         SCREEN_width, const_grid_offset_y - iy);
    //println("iy="+iy+":offset_y="+const_grid_offset_y);
  }

  // Sets the color used to draw text and borders around shapes.
  fill(C_GRID_TEXT);
  stroke(C_GRID_TEXT);
  y = const_str_base_ix_y;
  if (y < const_screen_y_start) y = const_screen_y_start;
  if (y > const_screen_y_end) y = const_screen_y_end;
  for (ix = -1; ix <= const_screen_width_d_100 + 1; ix ++) {
    if (MIRROR_ENABLE) {
      distance =
        float(
          int(
            const_zoom_factor_d_100 * float((ix - const_screen_width_d_100_d_2) * 100)
          )
          -
          const_offset_ix
        )
        /
        100.0;
    }
    else {
      distance =
        float(
          int(
            const_zoom_factor_d_100 * float((const_screen_width_d_100_d_2 - ix) * 100)
          )
          +
          const_offset_ix
        )
        /
        100.0;
    }
    string = distance + "m";
    x = ix * 100 + const_grid_offset_x;
    if(distance == 0.0) image_x = x;
    x -= int(textWidth(string) / 2.0);
    text(string, x, y);
    //println("iy=" + iy + ":x=" + x + ",y=" + y + "," + string);
  }

  for (iy = 0; iy <= const_screen_height_d_100 + 1; iy ++) {
    if ((int(const_zoom_factor_d_100 * float(iy * 100)) + const_offset_iy) >= 0) {
      distance =
        float(
          int(
            const_zoom_factor_d_100 * float(iy * 100)
          )
          +
          const_offset_iy
        )
        / 100.0;
      string = distance + "m";
      x = const_str_base_iy_x - int(textWidth(string)/2);
      if (x < const_screen_x_start) x = const_screen_x_start;
      if (x > const_screen_x_end - int(textWidth(string))) x = const_screen_x_end - int(textWidth(string));
      y = const_grid_offset_y - iy * 100;
      if(distance == 0.0) image_y = y;
      y += const_font_height_d_2;
      text(string, x, y);
      //println("ix=" + ix + ":x=" + x + ",y=" + y + "," + string);
    }
  }

  if( (image_x >= 0 - PS_image.width / 2 && image_x < SCREEN_width + PS_image.width / 2)
      &&
      (image_y >= 0 - PS_image.height / 2 && image_y < SCREEN_height + PS_image.height / 2)
    )
  {
    //println("image xy=" + image_x + "," + image_y);
    //image(PS_image, image_x, image_y);
    image(PS_image, image_x - PS_image.width / 2, image_y - PS_image.height / 2);
  }
}
