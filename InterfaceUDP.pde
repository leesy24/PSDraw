import hypermedia.net.*;

final boolean PRINT_UDP_READ_DBG = false; 
final boolean PRINT_UDP_READ_ERR = false; 
final boolean PRINT_UDP_LOAD_DBG = false; 
final boolean PRINT_UDP_LOAD_ERR = false; 

UDP UDP_handle = null;  // The handle of UDP

String UDP_remote_ip = "10.0.8.86";
int UDP_remote_port = 1024;
int UDP_local_port = 1025;

final int UDP_CMD_STATE_NONE = 0;
final int UDP_CMD_STATE_SENT = 1;
final int UDP_CMD_STATE_RECEIVED = 2;
final int UDP_CMD_STATE_ERROR = 3;

byte[] UDP_inBuffer = null;
int UDP_inLength = 0;  // Bytes length by readBytes()
int UDP_total = 0; // Init. total received data.
int UDP_state = 0; // Init. state machine for getting length data of UDP data format.
int UDP_len = 0x7fffffff - 12; // 12 = 4bytes Function code + 4bytes length + 4bytes CRC on UDP data format.
int UDP_CMD_inLength = 0;
int UDP_CMD_state = UDP_CMD_STATE_NONE;
int UDP_CMD_timeout = 0;
int UDP_CMD_start_time;
static String UDP_str_err_last = null;

boolean UDP_SCAN_DONE = false;

void interface_UDP_reset()
{
  if(PRINT_UDP_LOAD_DBG) println("UDP reset! " + UDP_remote_ip + "," + UDP_remote_port + "," + UDP_local_port);
  // Check UDP config changed
  if(UDP_handle != null) {
    UDP_handle.close();
    UDP_handle = null;
  }
  UDP_inBuffer = null;
  UDP_inLength = 0;  // Bytes length by readBytes()
  UDP_total = 0; // Init. total received data.
  UDP_state = 0; // Init. state machine for getting length data of UDP data format.
  UDP_len = 0x7fffffff - 12; // 12 = 4bytes Function code + 4bytes length + 4bytes CRC on UDP data format.
  UDP_CMD_inLength = 0;
  UDP_CMD_state = UDP_CMD_STATE_NONE;
  UDP_CMD_start_time = 0;
  UDP_str_err_last = null;
}

void interface_UDP_setup()
{
  Title += "(" + UDP_remote_ip + UDP_remote_port + ")";
  Title += ":" + UDP_local_port;

  UDP_SCAN_DONE = false;

  //UDP_config_timeout(10000); // timeout 10secs
  UDP_config_timeout(2000); // timeout 2secs

  // Create a new datagram connection on local port
  // and wait for incomming message
  UDP_handle = new UDP(this, UDP_local_port);
  UDP_handle.setReceiveHandler("UDP_receive_event");
  UDP_handle.listen( true );
}

String interface_UDP_get_error()
{
  return UDP_str_err_last;
}

boolean interface_UDP_load()
{
  int err;

  if(UDP_handle == null) {
    interface_UDP_setup();
    if(UDP_handle == null) {
      UDP_str_err_last = "Error: UDP local port open error! " + UDP_local_port;
      if(PRINT_UDP_LOAD_ERR) println(UDP_str_err_last);
      return false;
    }
  }

  if(UDP_SCAN_DONE == false) {
    err = UDP_PS_perform_SCAN(1);
    if(err < 0) {
      if(PRINT_UDP_LOAD_ERR) println("PS_perform_SCAN() error! " + err);
    }
    else if(err > 0) {
      //println("PS_perform_SCAN() pending! " + err);
    }
    else {
      //println("PS_perform_SCAN() ok! ");
      UDP_SCAN_DONE = true;
    }
    return false;
  }
  else {
    err = UDP_PS_perform_GSCN(0);
    if(err < 0) {
      if(PRINT_UDP_LOAD_ERR) println("PS_perform_GSCN() error! " + err);
      return false;
    }
    else if(err > 0) {
      //println("PS_perform_GSCN() pending! " + err);
      return false;
    }
    else {
      UDP_str_err_last = null;
      data_buf = UDP_inBuffer;
      //println("PS_perform_GSCN() ok! ");
      return true;
    }
  }
}

public void UDP_config_timeout(int msec)
{
  UDP_CMD_timeout = msec;
  if (PRINT_UDP_LOAD_DBG) println("UDP_CMD_timeout = " + UDP_CMD_timeout + " sec(s)");
}

void UDP_write(byte[] buf)
{
  if(UDP_handle == null) return;
  UDP_handle.send(buf, UDP_remote_ip, UDP_remote_port);
  UDP_CMD_start_time = millis();
}

void UDP_prepare_read(int buf_size)
{
  UDP_inBuffer = new byte[8*buf_size];
  UDP_inLength = 0;  // Bytes length by readBytes()
  UDP_total = 0; // Init. total received data.
  UDP_state = 0; // Init. state machine for getting length data of UDP data format.
  UDP_len = 0x7fffffff - 12; // 12 = 4bytes Function code + 4bytes length + 4bytes CRC on UDP data format.
}

void UDP_receive_event(byte[] data)
{
  try {
    //println("UDP_receive_event" + data.length);
    if(UDP_CMD_state == UDP_CMD_STATE_SENT) {
      int inLength = 0;  // Bytes length by readBytes()
  
      inLength = data.length;
      if(UDP_total + inLength > UDP_inBuffer.length) {
        inLength = UDP_inBuffer.length - UDP_total;
      }
      arrayCopy(data, 0, UDP_inBuffer, UDP_total, inLength);
      UDP_total += inLength;
      if (PRINT_UDP_READ_DBG) println("Read bytes and total! " + inLength + "," + UDP_total);
  
      // If state machine is getting length data.
      if (UDP_state == 0) {
        // If total received data is enough to get length data.
        if (UDP_total >= 8) {
          // Get length data from network endians data.
          UDP_len = get_int32_bytes(UDP_inBuffer, 4);
          if (PRINT_UDP_READ_DBG) println("Read format Length = " + UDP_len);
          if ((UDP_len > UDP_inBuffer.length - 12) ||
              (UDP_len < 4)) {
            UDP_str_err_last = "Error: UDP read protocol length error! " + UDP_len + "," + inLength + "," + UDP_total/* + "," + UDP_inBuffer*/;
            if (PRINT_UDP_READ_ERR) println(UDP_str_err_last);
            //printArray(UDP_inBuffer);
            //printArray(data);
            UDP_CMD_state = UDP_CMD_STATE_ERROR;
            return;
          }
          UDP_state = 1; // Set state machine to other.
        }
      }
      
      // Check received all data
      if(UDP_total >= UDP_len + 12) {
        UDP_CMD_inLength = UDP_len + 12;
        //println("Read SCAN state changed to UDP_CMD_STATE_RECEIVED! " + UDP_total + "," + UDP_len);
        UDP_CMD_state = UDP_CMD_STATE_RECEIVED;
        return;
      }
    }
  }
  catch (Exception e) {
    UDP_str_err_last = "Error: UDP_receive_event() error! " + e;
    if (PRINT_UDP_READ_ERR) println(UDP_str_err_last);
  }
} 

byte[] UDP_PS_make_cmd(String cmd, int param)
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

int UDP_PS_perform_SCAN(int on)
{
  byte[] outBuffer;

  if(UDP_CMD_state == UDP_CMD_STATE_NONE) {
    // Make command buffer
    outBuffer = UDP_PS_make_cmd("SCAN", on);
    // Prepare read
    UDP_prepare_read(16);
    // Prepare UDP CMD state
    UDP_CMD_state = UDP_CMD_STATE_SENT;
    // Write buffer
    UDP_write(outBuffer);
    return UDP_CMD_state;
  }
  else if(UDP_CMD_state == UDP_CMD_STATE_SENT) {
    // Check time out
    if(millis() - UDP_CMD_start_time > UDP_CMD_timeout) {
      UDP_CMD_state = UDP_CMD_STATE_NONE;
      UDP_str_err_last = "Error: UDP SCAN timeout! " + UDP_CMD_inLength + "," + UDP_total;
      if(PRINT_UDP_LOAD_ERR) println(UDP_str_err_last);
      return -1;
    }
    return UDP_CMD_state;
  }
  else if(UDP_CMD_state == UDP_CMD_STATE_RECEIVED) {
    String func;
    int crc, crc_c;

    // Check CRC
    crc = get_int32_bytes(UDP_inBuffer, UDP_CMD_inLength - 4);
    crc_c = get_crc32(UDP_inBuffer, 0, UDP_CMD_inLength - 4);
    if(crc != crc_c) {
      UDP_CMD_state = UDP_CMD_STATE_NONE;
      UDP_str_err_last = "Error: UDP SCAN CRC error! " + crc + "," + crc_c + "," + UDP_CMD_inLength + "," + UDP_total;
      if(PRINT_UDP_LOAD_ERR) println(UDP_str_err_last);
      return -1;
    }
    // Check function code
    func = get_str_bytes(UDP_inBuffer, 0, 4);
    if(func.equals("SCAN") == false) {
      // Get error code and return
      int err = get_int32_bytes(UDP_inBuffer, 8);
      UDP_CMD_state = UDP_CMD_STATE_NONE;
      UDP_str_err_last = "Error: UDP SCAN error return! " + err;
      if(PRINT_UDP_LOAD_ERR) println(UDP_str_err_last);
      // Get error code and return
      return err;
    }
    UDP_CMD_state = UDP_CMD_STATE_NONE;
    return 0;
  }
  else if(UDP_CMD_state == UDP_CMD_STATE_ERROR) {
    UDP_CMD_state = UDP_CMD_STATE_NONE;
    return -1;
  }

  return UDP_CMD_state;
}

int UDP_PS_perform_GSCN(int scan_number)
{
  byte[] outBuffer;

  if(UDP_CMD_state == UDP_CMD_STATE_NONE) {
    // Make command buffer
    outBuffer = UDP_PS_make_cmd("GSCN", scan_number);
    // Prepare read
    UDP_prepare_read(8*1024);
    // Flush buffer
    // Prepare UDP CMD state
    UDP_CMD_state = UDP_CMD_STATE_SENT;
    // Write buffer
    UDP_write(outBuffer);
    return UDP_CMD_state;
  }
  else if(UDP_CMD_state == UDP_CMD_STATE_SENT) {
    // Check time out
    if(millis() - UDP_CMD_start_time > UDP_CMD_timeout) {
      UDP_str_err_last = "Error: UDP GSCN timeout! " + UDP_CMD_inLength + "," + UDP_total;
      if(PRINT_UDP_LOAD_ERR) println(UDP_str_err_last);
      UDP_CMD_state = UDP_CMD_STATE_NONE;
      return -1;
    }
    return UDP_CMD_state;
  }
  else if(UDP_CMD_state == UDP_CMD_STATE_RECEIVED) {
    String func;
    int crc, crc_c;

    // Check CRC
    crc = get_int32_bytes(UDP_inBuffer, UDP_CMD_inLength - 4);
    crc_c = get_crc32(UDP_inBuffer, 0, UDP_CMD_inLength - 4);
    if(crc != crc_c) {
      UDP_CMD_state = UDP_CMD_STATE_NONE;
      UDP_str_err_last = "Error: UDP GSCN CRC error! " + crc + "," + crc_c + "," + UDP_CMD_inLength + "," + UDP_total;
      if(PRINT_UDP_LOAD_ERR) println(UDP_str_err_last);
      return -1;
    }
    // Check function code
    func = get_str_bytes(UDP_inBuffer, 0, 4);
    if(func.equals("GSCN") == false) {
      // Get error code and return
      int err = get_int32_bytes(UDP_inBuffer, 8);
      UDP_CMD_state = UDP_CMD_STATE_NONE;
      UDP_str_err_last = "Error: UDP GSCN error return! " + err;
      if(PRINT_UDP_LOAD_ERR) println(UDP_str_err_last);
      // Get error code and return
      return err;
    }
    UDP_CMD_state = UDP_CMD_STATE_NONE;
    return 0;
  }
  else if(UDP_CMD_state == UDP_CMD_STATE_ERROR) {
    UDP_CMD_state = UDP_CMD_STATE_NONE;
    return -1;
  }

  return UDP_CMD_state;
}