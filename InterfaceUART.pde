import processing.serial.*;

final boolean UART_READ_PRINT = false; 
final boolean UART_LOAD_PRINT = false; 

Serial UART_handle = null;  // The handle of serial port

String UART_port_name = "COM1"; // String: name of the port (COM1 is the default)
int UART_baud_rate = 115200; // int: 9600 is the default
char UART_parity = 'N'; // char: 'N' for none, 'E' for even, 'O' for odd, 'M' for mark, 'S' for space ('N' is the default)
int UART_data_bits = 8; // int: 8 is the default
float UART_stop_bits = 1.0; // float: 1.0, 1.5, or 2.0 (1.0 is the default)

final int UART_CMD_STATE_NONE = 0;
final int UART_CMD_STATE_SENT = 1;
final int UART_CMD_STATE_RECEIVED = 2;
final int UART_CMD_STATE_ERROR = 3;

byte[] UART_inBuffer = null;
int UART_inLength = 0;  // Bytes length by readBytes()
int UART_total = 0; // Init. total received data.
int UART_state = 0; // Init. state machine for getting length data of UDP data format.
int UART_len = 0x7fffffff - 12; // 12 = 4bytes Function code + 4bytes length + 4bytes CRC on UDP data format.
int UART_CMD_inLength = 0;
int UART_CMD_state = UART_CMD_STATE_NONE;
int UART_CMD_timeout = 0;
int UART_CMD_start_time;

boolean SCAN_DONE = false;

void interface_UART_reset()
{
  println("UART reset! " + UART_port_name);
  // Check UART port config changed
  if(UART_handle != null) {
    UART_handle.stop();
    UART_handle = null;
  }
  UART_inBuffer = null;
  UART_inLength = 0;  // Bytes length by readBytes()
  UART_total = 0; // Init. total received data.
  UART_state = 0; // Init. state machine for getting length data of UDP data format.
  UART_len = 0x7fffffff - 12; // 12 = 4bytes Function code + 4bytes length + 4bytes CRC on UDP data format.
  UART_CMD_inLength = 0;
  UART_CMD_state = UART_CMD_STATE_NONE;
  UART_CMD_start_time = 0;
}

void interface_UART_setup()
{
  boolean found = false;

  // Check UART_port_name with the available serial ports
  for( String port : Serial.list() ) {
    if(port.equals(UART_port_name)) {
      found = true;
      break;
    }
  }
  if(!found) {
    println("Can not find com port error! " + UART_port_name);
    return;
  }

  SCAN_DONE = false;

  UART_config_timeout(10000); // timeout 10secs

  // Open the port you are using at the rate you want:
  UART_handle = new Serial(this, UART_port_name, UART_baud_rate, UART_parity, UART_data_bits, UART_stop_bits);
  UART_handle.clear();
  UART_handle.buffer(1);
}

boolean interface_UART_load()
{
  int err;

  if(SCAN_DONE == false) {
    err = PS_perform_SCAN(1);
    if(err < 0) {
      println("PS_perform_SCAN() error! " + err);
    }
    else if(err > 0) {
      //println("PS_perform_SCAN() pending! " + err);
    }
    else {
      //println("PS_perform_SCAN() ok! ");
      SCAN_DONE = true;
    }
    return false;
  }
  else {
    err = PS_perform_GSCN(0);
    if(err < 0) {
      println("PS_perform_GSCN() error! " + err);
      return false;
    }
    else if(err > 0) {
      //println("PS_perform_GSCN() pending! " + err);
      return false;
    }
    else {
      data_buf = UART_inBuffer;
      //println("PS_perform_GSCN() ok! ");
      return true;
    }
  }
}

void UART_config_timeout(int msec)
{
  UART_CMD_timeout = msec;
  println("UART_CMD_timeout = " + UART_CMD_timeout + " sec(s)");
}

void UART_clear()
{
  UART_handle.clear();
}

void UART_write(byte[] buf)
{
  UART_handle.write(buf);
  UART_CMD_start_time = millis();
}

void UART_prepare_read(int buf_size)
{
  UART_inBuffer = new byte[8*buf_size];
  UART_inLength = 0;  // Bytes length by readBytes()
  UART_total = 0; // Init. total received data.
  UART_state = 0; // Init. state machine for getting length data of UDP data format.
  UART_len = 0x7fffffff - 12; // 12 = 4bytes Function code + 4bytes length + 4bytes CRC on UDP data format.
}

void serialEvent(Serial p)
{
  try {
    //println("serialEvent" + p.available());
    if(UART_CMD_state == UART_CMD_STATE_SENT) {
      byte[] data;
      int inLength = 0;  // Bytes length by readBytes()
  
      inLength = p.available();
      if(UART_total + inLength > UART_inBuffer.length) {
        inLength = UART_inBuffer.length - UART_total;
      }
      data = p.readBytes(inLength);
      if(inLength != data.length) {
        println("Read inLength error! " + inLength + "," + data.length);
        UART_CMD_state = UART_CMD_STATE_ERROR;
        return;
      }
      arrayCopy(data, 0, UART_inBuffer, UART_total, inLength);
      UART_total += inLength;
      if (UART_READ_PRINT) println("Read bytes and total! " + inLength + "," + UART_total);
  
      // If state machine is getting length data.
      if (UART_state == 0) {
        // If total received data is enough to get length data.
        if (UART_total >= 8) {
          // Get length data from network endians data.
          UART_len = get_int32_bytes(UART_inBuffer, 4);
          if (UART_READ_PRINT) println("Read format Length = " + UART_len);
          if ((UART_len > UART_inBuffer.length - 12) ||
              (UART_len < 4)) {
            println("Read format Length error! " + UART_len + "," + inLength + "," + UART_total + "," + p.available()/* + "," + UART_inBuffer*/);
            //printArray(UART_inBuffer);
            //printArray(data);
            UART_CMD_state = UART_CMD_STATE_ERROR;
            return;
          }
          UART_state = 1; // Set state machine to other.
        }
      }
      
      // Check received all data
      if(UART_total >= UART_len + 12) {
        UART_CMD_inLength = UART_len + 12;
        //println("Read SCAN state changed to UART_CMD_STATE_RECEIVED! " + UART_total + "," + UART_len);
        UART_CMD_state = UART_CMD_STATE_RECEIVED;
        return;
      }
    }
  }
  catch (Exception e) {
    println("Initialization exception! " + e);
  }
} 

byte[] PS_make_cmd(String cmd, int param)
{
  byte[] buf = new byte[16];

  // Set function code
  set_str_bytes(buf, 0, cmd);
  // Set data_buf length 4
  set_int32_bytes(buf, 4, 4);
  // Set Scan on(1)
  set_int32_bytes(buf, 8, param);
  // Set CRC
  set_int32_bytes(buf, 12, get_crc32(buf, 0, 12));

  return buf;
}

int PS_perform_SCAN(int on)
{
  byte[] outBuffer;

  if(UART_CMD_state == UART_CMD_STATE_NONE) {
    // Make command buffer
    outBuffer = PS_make_cmd("SCAN", on);
    // Prepare read
    UART_prepare_read(16);
    // Flush buffer
    UART_clear();
    // Prepare UART CMD state
    UART_CMD_state = UART_CMD_STATE_SENT;
    // Write buffer
    UART_write(outBuffer);
    return UART_CMD_state;
  }
  else if(UART_CMD_state == UART_CMD_STATE_SENT) {
    // Check time out
    if(millis() - UART_CMD_start_time > UART_CMD_timeout) {
      println("PS_perform_SCAN timeout! " + UART_CMD_inLength + "," + UART_total);
      UART_CMD_state = UART_CMD_STATE_NONE;
      return -1;
    }
    return UART_CMD_state;
  }
  else if(UART_CMD_state == UART_CMD_STATE_RECEIVED) {
    String func;
    int crc, crc_c;

    // Check CRC
    crc = get_crc32(UART_inBuffer, 0, UART_CMD_inLength - 4);
    crc_c = get_int32_bytes(UART_inBuffer, UART_CMD_inLength - 4);
    if(crc != crc_c) {
      UART_CMD_state = UART_CMD_STATE_NONE;
      println("get_crc32 error! " + crc + "," + crc_c + "," + UART_CMD_inLength + "," + UART_total);
      return -1;
    }
    // Check function code
    func = get_str_bytes(UART_inBuffer, 0, 4);
    if(func.equals("SCAN") == false) {
      UART_CMD_state = UART_CMD_STATE_NONE;
      // Get error code and return
      return get_int32_bytes(UART_inBuffer, 8);
    }
    UART_CMD_state = UART_CMD_STATE_NONE;
    return 0;
  }
  else if(UART_CMD_state == UART_CMD_STATE_ERROR) {
    UART_CMD_state = UART_CMD_STATE_NONE;
    return -1;
  }

  return UART_CMD_state;
}

int PS_perform_GSCN(int scan_number)
{
  byte[] outBuffer;

  if(UART_CMD_state == UART_CMD_STATE_NONE) {
    // Make command buffer
    outBuffer = PS_make_cmd("GSCN", scan_number);
    // Prepare read
    UART_prepare_read(8*1024);
    // Flush buffer
    UART_clear();
    // Prepare UART CMD state
    UART_CMD_state = UART_CMD_STATE_SENT;
    // Write buffer
    UART_write(outBuffer);
    return UART_CMD_state;
  }
  else if(UART_CMD_state == UART_CMD_STATE_SENT) {
    // Check time out
    if(millis() - UART_CMD_start_time > UART_CMD_timeout) {
      println("PS_perform_SCAN timeout! " + UART_CMD_inLength + "," + UART_total);
      UART_CMD_state = UART_CMD_STATE_NONE;
      return -1;
    }
    return UART_CMD_state;
  }
  else if(UART_CMD_state == UART_CMD_STATE_RECEIVED) {
    String func;
    int crc, crc_c;

    // Check CRC
    crc = get_crc32(UART_inBuffer, 0, UART_CMD_inLength - 4);
    crc_c = get_int32_bytes(UART_inBuffer, UART_CMD_inLength - 4);
    if(crc != crc_c) {
      UART_CMD_state = UART_CMD_STATE_NONE;
      println("get_crc32 error! " + crc + "," + crc_c + "," + UART_CMD_inLength + "," + UART_total);
      return -1;
    }
    // Check function code
    func = get_str_bytes(UART_inBuffer, 0, 4);
    if(func.equals("GSCN") == false) {
      UART_CMD_state = UART_CMD_STATE_NONE;
      // Get error code and return
      return get_int32_bytes(UART_inBuffer, 8);
    }
    UART_CMD_state = UART_CMD_STATE_NONE;
    return 0;
  }
  else if(UART_CMD_state == UART_CMD_STATE_ERROR) {
    UART_CMD_state = UART_CMD_STATE_NONE;
    return -1;
  }

  return UART_CMD_state;
}