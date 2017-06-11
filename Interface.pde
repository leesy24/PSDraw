/**
 * ControlP5 ScrollableList
 *
 * replaces DropdownList and and ListBox. 
 * List can be scrolled by dragging the list or using the scroll-wheel. 
 *
 * by Andreas Schlegel, 2014
 * www.sojamo.de/libraries/controlp5
 *
 */
import controlP5.*;
import java.util.*;

final static color C_INTERFACE_NORMAL = #FFFFFF; // White
final static color C_INTERFACE_HIGHLIGHT = #C0C0C0; //
final static color C_INTERFACE_TEXT = #000000; // Black

boolean INTERFACE_changed = false;
int INTERFACE_dropdown_w;

ControlFont cf1 = null;
ControlP5 cp5 = null;
controlP5.ScrollableList ddl = null;

void interface_setup()
{
  INTERFACE_changed = false;

  if(cf1 == null) {
    cf1 = new ControlFont(createFont("SansSerif",12),12);
  }
  if(cp5 == null) {
    cp5 = new ControlP5(this, cf1);
  }
  else {
    cp5.remove("interface_dropdown");
    cp5.remove("interface_filename");
    cp5.remove("interface_UARTport");
    cp5.remove("interface_UARTbaud");
    
    cp5.setGraphics(this,0,0);
  }

  List l = Arrays.asList("File", "UART", "UDP Client");
  INTERFACE_dropdown_w = int(max(textWidth(l.get(0).toString()), textWidth(l.get(1).toString()), textWidth(l.get(2).toString())));
  INTERFACE_dropdown_w += 20;

  /* add a ScrollableList, by default it behaves like a DropdownList */
  ddl = cp5.addScrollableList("interface_dropdown"/*l.get(0).toString()*/);
  ddl.setBackgroundColor( color(255,0,255) /*color( 255 , 128 )*/ )
     .setColorBackground( color(255,255,0) /*color(200)*/ )
     .setColorForeground( color(0,255,255) /*color(235)*/ )
     .setColorActive( color(255,0,0) /*(color(255)*/ )
     .setColorValueLabel( color(0,255,0) /*color(100)*/ )
     .setColorCaptionLabel( color(0,0,255) /*color(50)*/ )
     .setPosition(SCREEN_WIDTH - TEXT_MARGIN - FONT_HEIGHT * 3 - INTERFACE_dropdown_w, TEXT_MARGIN + FONT_HEIGHT * 2 + TEXT_MARGIN)
     .setSize(INTERFACE_dropdown_w, FONT_HEIGHT + TEXT_MARGIN*2 + (FONT_HEIGHT + TEXT_MARGIN*2 + 1) * 3)
     .setBarHeight(FONT_HEIGHT + TEXT_MARGIN*2)
     .setItemHeight(FONT_HEIGHT + TEXT_MARGIN*2 + 1)
     //.setBarHeight(100)
     //.setItemHeight(100)
     .setOpen(false)
     .addItems(l)
     //.setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
     ;
  ddl.setCaptionLabel(l.get(DATA_interface).toString());
  ddl.getCaptionLabel()
      //.setFont(cf1)
      .setSize(FONT_HEIGHT)
      .toUpperCase(false)
      ;
  ddl.getCaptionLabel()
      .getStyle()
        //.setPaddingTop(32/2 - 4)
        //.setPaddingTop((32 - 12 ) / 2)
        //.padding(10,10,10,10)
        .marginTop = int(float(FONT_HEIGHT)/2.0-float(FONT_HEIGHT)/6.0);
        ;
  ddl.getValueLabel()
      //.setFont(cf1)
      .setSize(FONT_HEIGHT)
      .toUpperCase(false)
      ;
  ddl.getValueLabel()
      .getStyle()
        //.setPaddingTop(32/2 - 4)
        //.setPaddingTop((32 - 12 ) / 2)
        //.padding(10,10,10,10)
        //.marginTop = 32/2-4;
        .marginTop = int(float(FONT_HEIGHT)/2.0-float(FONT_HEIGHT)/6.0) - 1;
        ;
/*
  println("margin =",
    ddl.getCaptionLabel()
        .getStyle()
          .marginTop
    ,
    ddl.getCaptionLabel()
        .getStyle()
          .marginBottom
    ,
    ddl.getCaptionLabel()
        .getStyle()
          .marginLeft
    ,
    ddl.getCaptionLabel()
        .getStyle()
          .marginRight
  );
*/
  //ddl.getValueLabel().getStyle().padding(4,4,3,3);

  CColor c = new CColor();
  c.setBackground(color(255,0,0));
  ddl.getItem(DATA_interface).put("color", c);

  if(DATA_interface == 0) {
    Textfield tf;
    int x, w;
    w = int(textWidth(FILE_name));
    x = SCREEN_WIDTH - TEXT_MARGIN - FONT_HEIGHT * 3 - w - 1;
    tf = cp5.addTextfield("interface_filename");
    tf.setPosition(x, TEXT_MARGIN + FONT_HEIGHT * 3 + TEXT_MARGIN*2 + TEXT_MARGIN*2)
      .setSize(w, FONT_HEIGHT + TEXT_MARGIN*2)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      ;
    //println("tf.getText() = ", tf.getText());
    tf.setCaptionLabel("");
    tf.setText(FILE_name);
    tf.getValueLabel()
        //.setFont(cf1)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
  }
  else if(DATA_interface == 1) {
    Textfield tf1, tf2;
    int x, w;
    w = int(textWidth(UART_port_name));
    x = SCREEN_WIDTH - TEXT_MARGIN - FONT_HEIGHT * 3 - w - 1;
    tf1 = cp5.addTextfield("interface_UARTport");
    tf1.setPosition(x, TEXT_MARGIN + FONT_HEIGHT * 3 + TEXT_MARGIN*2 + TEXT_MARGIN*2)
      .setSize(w, FONT_HEIGHT + TEXT_MARGIN*2)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      ;
    //println("tf.getText() = ", tf.getText());
    tf1.setCaptionLabel("");
    tf1.setText(UART_port_name);
    tf1.getValueLabel()
        //.setFont(cf1)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    w = int(textWidth(Integer.toString(UART_baud_rate)));
    x = SCREEN_WIDTH - TEXT_MARGIN - FONT_HEIGHT * 3 - w - 1;
    tf2 = cp5.addTextfield("interface_UARTbaud");
    tf2.setPosition(x, TEXT_MARGIN + FONT_HEIGHT * 4 + TEXT_MARGIN*2*2 + TEXT_MARGIN*2 + TEXT_MARGIN)
      .setSize(w, FONT_HEIGHT + TEXT_MARGIN*2)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      ;
    //println("tf.getText() = ", tf.getText());
    tf2.setCaptionLabel("");
    tf2.setText(Integer.toString(UART_baud_rate));
    tf2.getValueLabel()
        //.setFont(cf1)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
  }
  else /*if(DATA_interface == 2)*/ {
  }
  
  ddl.bringToFront();
  //println(ddl.getBackgroundColor());
  //printArray(PFont.list());
}

void interface_draw()
{
  String string;

  // Sets the color used to draw lines and borders around shapes.
  stroke(C_INTERFACE_TEXT);
  fill(C_INTERFACE_TEXT);
  
  string = "Interface";
  text(string, SCREEN_WIDTH - TEXT_MARGIN - FONT_HEIGHT * 3 - int(textWidth(string)), TEXT_MARGIN + FONT_HEIGHT * 2);
}

public void controlEvent(ControlEvent ce)
{
  //println(ce);
}

void interface_dropdown(int n)
{
  /* request the selected item based on index n */
  //println("dropdown", n, cp5.get(ScrollableList.class, "dropdown").getItem(n));
  
  /* here an item is stored as a Map  with the following key-value pairs:
   * name, the given name of the item
   * text, the given text of the item by default the same as name
   * value, the given value of the item, can be changed by using .getItem(n).put("value", "abc"); a value here is of type Object therefore can be anything
   * color, the given color of the item, how to change, see below
   * view, a customizable view, is of type CDrawable 
   */
/*
  for(int i = 0; i < 3; i ++) {
    CColor c = new CColor();
    if(i == n)
      c.setBackground(color(255,0,0));
    else
      c.setBackground(color(255,255,0));
    cp5.get(ScrollableList.class, "dropdown").getItem(i).put("color", c);
  }
*/

  if( DATA_interface != n ) {
    DATA_interface = n;
    config_save();
    INTERFACE_changed = true;
  }
}

void interface_filename(String theText)
{
  // automatically receives results from controller input
  //println("a textfield event for controller 'input' : "+theText);

  if(theText.equals(FILE_name) != true) {
    FILE_name = theText;
    config_save();
    INTERFACE_changed = true;
  }
}

void interface_UARTport(String theText)
{
  // automatically receives results from controller input
  //println("a textfield event for controller 'input' : "+theText);

  if(theText.equals(UART_port_name) != true) {
    UART_port_name = theText;
    config_save();
    INTERFACE_changed = true;
  }
}

void interface_UARTbaud(String theText)
{
  // automatically receives results from controller input
  //println("a textfield event for controller 'input' : "+theText);

  if(theText.equals(Integer.toString(UART_baud_rate)) != true) {
    UART_baud_rate = Integer.parseInt(theText);
    config_save();
    INTERFACE_changed = true;
  }
}

/*
void keyPressed() {
  switch(key) {
    case('1'):
    // make the ScrollableList behave like a ListBox
    cp5.get(ScrollableList.class, "dropdown").setType(ControlP5.LIST);
    break;
    case('2'):
    // make the ScrollableList behave like a DropdownList
    cp5.get(ScrollableList.class, "dropdown").setType(ControlP5.DROPDOWN);
    break;
    case('3'):
    // change content of the ScrollableList
    List l = Arrays.asList("a-1", "b-1", "c-1", "d-1", "e-1", "f-1", "g-1", "h-1", "i-1", "j-1", "k-1");
    cp5.get(ScrollableList.class, "dropdown").setItems(l);
    break;
    case('4'):
    // remove an item from the ScrollableList
    cp5.get(ScrollableList.class, "dropdown").removeItem("k-1");
    break;
    case('5'):
    // clear the ScrollableList
    cp5.get(ScrollableList.class, "dropdown").clear();
    break;
  }
}
*/
/*
a list of all methods available for the ScrollableList Controller
use ControlP5.printPublicMethodsFor(ScrollableList.class);
to print the following list into the console.

You can find further details about class ScrollableList in the javadoc.

Format:
ClassName : returnType methodName(parameter type)


controlP5.Controller : CColor getColor() 
controlP5.Controller : ControlBehavior getBehavior() 
controlP5.Controller : ControlWindow getControlWindow() 
controlP5.Controller : ControlWindow getWindow() 
controlP5.Controller : ControllerProperty getProperty(String) 
controlP5.Controller : ControllerProperty getProperty(String, String) 
controlP5.Controller : ControllerView getView() 
controlP5.Controller : Label getCaptionLabel() 
controlP5.Controller : Label getValueLabel() 
controlP5.Controller : List getControllerPlugList() 
controlP5.Controller : Pointer getPointer() 
controlP5.Controller : ScrollableList addCallback(CallbackListener) 
controlP5.Controller : ScrollableList addListener(ControlListener) 
controlP5.Controller : ScrollableList addListenerFor(int, CallbackListener) 
controlP5.Controller : ScrollableList align(int, int, int, int) 
controlP5.Controller : ScrollableList bringToFront() 
controlP5.Controller : ScrollableList bringToFront(ControllerInterface) 
controlP5.Controller : ScrollableList 1() 
controlP5.Controller : ScrollableList linebreak() 
controlP5.Controller : ScrollableList listen(boolean) 
controlP5.Controller : ScrollableList lock() 
controlP5.Controller : ScrollableList onChange(CallbackListener) 
controlP5.Controller : ScrollableList onClick(CallbackListener) 
controlP5.Controller : ScrollableList onDoublePress(CallbackListener) 
controlP5.Controller : ScrollableList onDrag(CallbackListener) 
controlP5.Controller : ScrollableList onDraw(ControllerView) 
controlP5.Controller : ScrollableList onEndDrag(CallbackListener) 
controlP5.Controller : ScrollableList onEnter(CallbackListener) 
controlP5.Controller : ScrollableList onLeave(CallbackListener) 
controlP5.Controller : ScrollableList onMove(CallbackListener) 
controlP5.Controller : ScrollableList onPress(CallbackListener) 
controlP5.Controller : ScrollableList onRelease(CallbackListener) 
controlP5.Controller : ScrollableList onReleaseOutside(CallbackListener) 
controlP5.Controller : ScrollableList onStartDrag(CallbackListener) 
controlP5.Controller : ScrollableList onWheel(CallbackListener) 
controlP5.Controller : ScrollableList plugTo(Object) 
controlP5.Controller : ScrollableList plugTo(Object, String) 
controlP5.Controller : ScrollableList plugTo(Object[]) 
controlP5.Controller : ScrollableList plugTo(Object[], String) 
controlP5.Controller : ScrollableList registerProperty(String) 
controlP5.Controller : ScrollableList registerProperty(String, String) 
controlP5.Controller : ScrollableList registerTooltip(String) 
controlP5.Controller : ScrollableList removeBehavior() 
controlP5.Controller : ScrollableList removeCallback() 
controlP5.Controller : ScrollableList removeCallback(CallbackListener) 
controlP5.Controller : ScrollableList removeListener(ControlListener) 
controlP5.Controller : ScrollableList removeListenerFor(int, CallbackListener) 
controlP5.Controller : ScrollableList removeListenersFor(int) 
controlP5.Controller : ScrollableList removeProperty(String) 
controlP5.Controller : ScrollableList removeProperty(String, String) 
controlP5.Controller : ScrollableList setArrayValue(float[]) 
controlP5.Controller : ScrollableList setArrayValue(int, float) 
controlP5.Controller : ScrollableList setBehavior(ControlBehavior) 
controlP5.Controller : ScrollableList setBroadcast(boolean) 
controlP5.Controller : ScrollableList setCaptionLabel(String) 
controlP5.Controller : ScrollableList setColor(CColor) 
controlP5.Controller : ScrollableList setColorActive(int) 
controlP5.Controller : ScrollableList setColorBackground(int) 
controlP5.Controller : ScrollableList setColorCaptionLabel(int) 
controlP5.Controller : ScrollableList setColorForeground(int) 
controlP5.Controller : ScrollableList setColorLabel(int) 
controlP5.Controller : ScrollableList setColorValue(int) 
controlP5.Controller : ScrollableList setColorValueLabel(int) 
controlP5.Controller : ScrollableList setDecimalPrecision(int) 
controlP5.Controller : ScrollableList setDefaultValue(float) 
controlP5.Controller : ScrollableList setHeight(int) 
controlP5.Controller : ScrollableList setId(int) 
controlP5.Controller : ScrollableList setImage(PImage) 
controlP5.Controller : ScrollableList setImage(PImage, int) 
controlP5.Controller : ScrollableList setImages(PImage, PImage, PImage) 
controlP5.Controller : ScrollableList setImages(PImage, PImage, PImage, PImage) 
controlP5.Controller : ScrollableList setLabel(String) 
controlP5.Controller : ScrollableList setLabelVisible(boolean) 
controlP5.Controller : ScrollableList setLock(boolean) 
controlP5.Controller : ScrollableList setMax(float) 
controlP5.Controller : ScrollableList setMin(float) 
controlP5.Controller : ScrollableList setMouseOver(boolean) 
controlP5.Controller : ScrollableList setMoveable(boolean) 
controlP5.Controller : ScrollableList setPosition(float, float) 
controlP5.Controller : ScrollableList setPosition(float[]) 
controlP5.Controller : ScrollableList setSize(PImage) 
controlP5.Controller : ScrollableList setSize(int, int) 
controlP5.Controller : ScrollableList setStringValue(String) 
controlP5.Controller : ScrollableList setUpdate(boolean) 
controlP5.Controller : ScrollableList setValue(float) 
controlP5.Controller : ScrollableList setValueLabel(String) 
controlP5.Controller : ScrollableList setValueSelf(float) 
controlP5.Controller : ScrollableList setView(ControllerView) 
controlP5.Controller : ScrollableList setVisible(boolean) 
controlP5.Controller : ScrollableList setWidth(int) 
controlP5.Controller : ScrollableList show() 
controlP5.Controller : ScrollableList unlock() 
controlP5.Controller : ScrollableList unplugFrom(Object) 
controlP5.Controller : ScrollableList unplugFrom(Object[]) 
controlP5.Controller : ScrollableList unregisterTooltip() 
controlP5.Controller : ScrollableList update() 
controlP5.Controller : ScrollableList updateSize() 
controlP5.Controller : String getAddress() 
controlP5.Controller : String getInfo() 
controlP5.Controller : String getName() 
controlP5.Controller : String getStringValue() 
controlP5.Controller : String toString() 
controlP5.Controller : Tab getTab() 
controlP5.Controller : boolean isActive() 
controlP5.Controller : boolean isBroadcast() 
controlP5.Controller : boolean isInside() 
controlP5.Controller : boolean isLabelVisible() 
controlP5.Controller : boolean isListening() 
controlP5.Controller : boolean isLock() 
controlP5.Controller : boolean isMouseOver() 
controlP5.Controller : boolean isMousePressed() 
controlP5.Controller : boolean isMoveable() 
controlP5.Controller : boolean isUpdate() 
controlP5.Controller : boolean isVisible() 
controlP5.Controller : float getArrayValue(int) 
controlP5.Controller : float getDefaultValue() 
controlP5.Controller : float getMax() 
controlP5.Controller : float getMin() 
controlP5.Controller : float getValue() 
controlP5.Controller : float[] getAbsolutePosition() 
controlP5.Controller : float[] getArrayValue() 
controlP5.Controller : float[] getPosition() 
controlP5.Controller : int getDecimalPrecision() 
controlP5.Controller : int getHeight() 
controlP5.Controller : int getId() 
controlP5.Controller : int getWidth() 
controlP5.Controller : int listenerSize() 
controlP5.Controller : void remove() 
controlP5.Controller : void setView(ControllerView, int) 
controlP5.ScrollableList : List getItems() 
controlP5.ScrollableList : Map getItem(String) 
controlP5.ScrollableList : Map getItem(int) 
controlP5.ScrollableList : ScrollableList addItem(String, Object) 
controlP5.ScrollableList : ScrollableList addItems(List) 
controlP5.ScrollableList : ScrollableList addItems(Map) 
controlP5.ScrollableList : ScrollableList addItems(String[]) 
controlP5.ScrollableList : ScrollableList clear() 
controlP5.ScrollableList : ScrollableList close() 
controlP5.ScrollableList : ScrollableList open() 
controlP5.ScrollableList : ScrollableList removeItem(String) 
controlP5.ScrollableList : ScrollableList removeItems(List) 
controlP5.ScrollableList : ScrollableList setBackgroundColor(int) 
controlP5.ScrollableList : ScrollableList setBarHeight(int) 
controlP5.ScrollableList : ScrollableList setBarVisible(boolean) 
controlP5.ScrollableList : ScrollableList setItemHeight(int) 
controlP5.ScrollableList : ScrollableList setItems(List) 
controlP5.ScrollableList : ScrollableList setItems(Map) 
controlP5.ScrollableList : ScrollableList setItems(String[]) 
controlP5.ScrollableList : ScrollableList setOpen(boolean) 
controlP5.ScrollableList : ScrollableList setScrollSensitivity(float) 
controlP5.ScrollableList : ScrollableList setType(int) 
controlP5.ScrollableList : boolean isBarVisible() 
controlP5.ScrollableList : boolean isOpen() 
controlP5.ScrollableList : int getBackgroundColor() 
controlP5.ScrollableList : int getBarHeight() 
controlP5.ScrollableList : int getHeight() 
controlP5.ScrollableList : void controlEvent(ControlEvent) 
controlP5.ScrollableList : void keyEvent(KeyEvent) 
controlP5.ScrollableList : void setDirection(int) 
controlP5.ScrollableList : void updateItemIndexOffset() 
java.lang.Object : String toString() 
java.lang.Object : boolean equals(Object) 

created: 2015/03/24 12:21:22

*/