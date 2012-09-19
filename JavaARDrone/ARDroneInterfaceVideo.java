/*
Author: MAPGPS on
	https://projects.ardrone.org/projects/ardrone-api/boards
	http://bbs.5imx.com/bbs/forumdisplay.php?fid=453
Initial: 2010.09.20
Updated: 2010.10.09

UI_BIT:
00010001010101000000000000000000
   |   | | | |        || | ||||+--0: Button turn to left
   |   | | | |        || | |||+---1: Button altitude down (ah - ab)
   |   | | | |        || | ||+----2: Button turn to right
   |   | | | |        || | |+-----3: Button altitude up (ah - ab)
   |   | | | |        || | +------4: Button - z-axis (r1 - l1)
   |   | | | |        || +--------6: Button + z-axis (r1 - l1)
   |   | | | |        |+----------8: Button emergency reset all
   |   | | | |        +-----------9: Button Takeoff / Landing
   |   | | | +-------------------18: y-axis trim +1 (Trim increase at +/- 1??/s)
   |   | | +---------------------20: x-axis trim +1 (Trim increase at +/- 1??/s)
   |   | +-----------------------22: z-axis trim +1 (Trim increase at +/- 1??/s)
   |   +-------------------------24: x-axis +1
   +-----------------------------28: y-axis +1

AT*REF=<sequence>,<UI>
AT*PCMD=<sequence>,<enable>,<pitch>,<roll>,<gaz>,<yaw>
	(float)0.05 = (int)1028443341		(float)-0.05 = (int)-1119040307
	(float)0.1  = (int)1036831949		(float)-0.1  = (int)-1110651699
	(float)0.2  = (int)1045220557		(float)-0.2  = (int)-1102263091
	(float)0.5  = (int)1056964608		(float)-0.5  = (int)-1090519040
AT*ANIM=<sequence>,<animation>,<duration>
AT*CONFIG=<sequence>,\"<name>\",\"<value>\"

########## Commandline mode ############
Usage: java ARDrone <IP> <AT command>

altitude max2m:	java ARDrone 192.168.1.1 AT*CONFIG=1,\"control:altitude_max\",\"2000\"
Takeoff:	java ARDrone 192.168.1.1 AT*REF=1,290718208
Landing:	java ARDrone 192.168.1.1 AT*REF=1,290717696
Hovering:	java ARDrone 192.168.1.1 AT*PCMD=1,1,0,0,0,0
gaz 0.1:	java ARDrone 192.168.1.1 AT*PCMD=1,1,0,0,1036831949,0
gaz -0.1:	java ARDrone 192.168.1.1 AT*PCMD=1,1,0,0,-1110651699,0
pitch 0.1:	java ARDrone 192.168.1.1 AT*PCMD=1,1,1036831949,0,0,0
pitch -0.1:	java ARDrone 192.168.1.1 AT*PCMD=1,1,-1110651699,0,0,0
yaw 0.1:	java ARDrone 192.168.1.1 AT*PCMD=1,1,0,0,0,1036831949
yaw -0.1:	java ARDrone 192.168.1.1 AT*PCMD=1,1,0,0,0,-1110651699
roll 0.1:	java ARDrone 192.168.1.1 AT*PCMD=1,1,0,1036831949,0,0
roll -0.1:	java ARDrone 192.168.1.1 AT*PCMD=1,1,0,-1110651699,0,0
pitch -30 deg:	java ARDrone 192.168.1.1 AT*ANIM=1,0,1000
pitch 30 deg:	java ARDrone 192.168.1.1 AT*ANIM=1,1,1000
Emergency	java ARDrone 192.168.1.1 AT*REF=1,290717952

########## Keyboad mode ############
Usage: java ARDrone [IP]

Takeoff/Landing: Space bar (toggle)
Hovering: Pause key

Arrow keys:
        Go Forward
            ^
            |
Go Left <---+---> Go Right
            |
            v
       Go Backward

Arrow keys with Shift key pressed:
              Go Up
                ^
                |
Rotate Left <---+---> Rotate Right
                |
                v
             Go Down
             
Digital keys 1~9: Change speed (rudder rate 5%~99%), 1 is min and 9 is max.
*/

import java.net.*;
import java.util.*;
import java.awt.*; 
import java.awt.event.*;
import java.nio.*;

class ARDrone extends Frame implements KeyListener {
    static final int NAVDATA_PORT = 5554;
    static final int VIDEO_PORT   = 5555;
    static final int AT_PORT 	  = 5556;

    //NavData offset
    static final int NAVDATA_STATE    =  4;
    static final int NAVDATA_BATTERY  = 24;
    static final int NAVDATA_ALTITUDE = 40;

    InetAddress inet_addr;
    DatagramSocket socket_at;
    int seq = 1; //Send AT command with sequence number 1 will reset the counter
    int seq_last = 1;
    String at_cmd_last = "";
    float speed = (float)0.1;
    boolean shift = false;
    FloatBuffer fb;
    IntBuffer ib;
    boolean space_bar = false; //true = Takeoff, false = Landing
    final static int INTERVAL = 100;

    public ARDrone(String name, String args[], InetAddress inet_addr) throws Exception {
        super(name);

	this.inet_addr = inet_addr;

        ByteBuffer bb = ByteBuffer.allocate(4);
        fb = bb.asFloatBuffer();
        ib = bb.asIntBuffer();

	socket_at = new DatagramSocket(ARDrone.AT_PORT);
	socket_at.setSoTimeout(3000);

	if (args.length == 2) { //Commandline mode
	    send_at_cmd(args[1]);
	    System.exit(0);
	}
	
    	System.out.println("Speed: " + speed);    	

	send_at_cmd("AT*PMODE=" + get_seq() + ",2");	
	Thread.sleep(INTERVAL);
	send_at_cmd("AT*MISC=" + get_seq() + ",2,20,2000,3000");
	Thread.sleep(INTERVAL);
	send_at_cmd("AT*REF=" + get_seq() + ",290717696");
	Thread.sleep(INTERVAL);
	send_at_cmd("AT*COMWDG=" + get_seq());
	Thread.sleep(INTERVAL);
	send_at_cmd("AT*CONFIG=" + get_seq() + ",\"control:altitude_max\",\"2000\""); //altitude max 2m
	Thread.sleep(INTERVAL);
	send_at_cmd("AT*CONFIG=" + get_seq() + ",\"control:control_level\",\"0\""); //0:BEGINNER, 1:ACE, 2:MAX
	Thread.sleep(INTERVAL);
	send_at_cmd("AT*CONFIG=" + get_seq() + ",\"general:navdata_demo\",\"TRUE\"");
	Thread.sleep(INTERVAL);
	send_at_cmd("AT*CONFIG=" + get_seq() + ",\"general:video_enable\",\"TRUE\"");
	Thread.sleep(INTERVAL);
	//send_at_cmd("AT*CONFIG=" + get_seq() + ",\"network:owner_mac\",\"00:18:DE:9D:E9:5D\""); //my PC
	//send_at_cmd("AT*CONFIG=" + get_seq() + ",\"network:owner_mac\",\"00:23:CD:5D:92:37\""); //AP
	//Thread.sleep(INTERVAL);
	send_at_cmd("AT*CONFIG=" + get_seq() + ",\"pic:ultrasound_freq\",\"8\"");
	Thread.sleep(INTERVAL);
	//send_at_cmd("AT*FTRIM=" + get_seq()); //flat trim
	//Thread.sleep(INTERVAL);

	send_at_cmd("AT*REF=" + get_seq() + ",290717696");
	Thread.sleep(INTERVAL);
    	send_pcmd(0, 0, 0, 0, 0);
	Thread.sleep(INTERVAL);
	send_at_cmd("AT*REF=" + get_seq() + ",290717696");
	Thread.sleep(INTERVAL);
	//send_at_cmd("AT*REF=" + get_seq() + ",290717952"); //toggle Emergency
	//Thread.sleep(INTERVAL);
	send_at_cmd("AT*REF=" + get_seq() + ",290717696");
	
	addKeyListener(this); 
	setSize(320, 160);
	setVisible(true);
	addWindowListener(new WindowAdapter() {
	    public void windowClosing(WindowEvent e) {
		System.exit(0);
	    }
  	});
    }

    public static void main(String args[]) throws Exception {
        InetAddress inet_addr;
	String ip = "192.168.1.1";

	if (args.length >= 1) {
	    ip = args[0];
	}

	StringTokenizer st = new StringTokenizer(ip, ".");

	byte[] ip_bytes = new byte[4];
	if (st.countTokens() == 4){
 	    for (int i = 0; i < 4; i++){
		ip_bytes[i] = (byte)Integer.parseInt(st.nextToken());
	    }
	}
	else {
	    System.out.println("Incorrect IP address format: " + ip);
	    System.exit(-1);
	}

	System.out.println("IP: " + ip);
        inet_addr = InetAddress.getByAddress(ip_bytes);

        ARDrone ardrone = new ARDrone("ARDrone", args, inet_addr);
        Thread.sleep(ARDrone.INTERVAL);
        NavData nd = new NavData(ardrone, inet_addr);
        nd.start();
        Thread.sleep(ARDrone.INTERVAL);
        Video v = new Video(ardrone, inet_addr);
        v.start();

        Thread.sleep(ARDrone.INTERVAL);
	ardrone.send_at_cmd("AT*REF=" + ardrone.get_seq() + ",290717696");
        
        while (true) {
            ardrone.seq_last = ardrone.seq;
            Thread.sleep(200);
            if (ardrone.seq == ardrone.seq_last) ardrone.send_at_cmd(ardrone.at_cmd_last);
	}
    }

    public void keyTyped(KeyEvent e) {
        ;
    }
    
    public void keyPressed(KeyEvent e) {
        int keyCode = e.getKeyCode();

        try {
            control(keyCode);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
    
    public void keyReleased(KeyEvent e) {
        int keyCode = e.getKeyCode();
        //if (keyCode >= KeyEvent.VK_1 && keyCode <= KeyEvent.VK_9) speed = (float)0.1; //Reset speed
        if (keyCode == KeyEvent.VK_SHIFT) shift = false;
    }

    public int intOfFloat(float f) {
        fb.put(0, f);
        return ib.get(0);
    }

    public static String byte2hex(byte[] data, int offset, int len) {
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < len; i++) {
            String tmp = Integer.toHexString(((int) data[offset + i]) & 0xFF);
            for(int t = tmp.length();t<2;t++)
            {
                sb.append("0");
            }
            sb.append(tmp);
            sb.append(" ");
        }
        return sb.toString();
    }

    public static int get_int(byte[] data, int offset) {
	int tmp = 0, n = 0;

	System.out.println("get_int(): data = " + byte2hex(data, offset, 4));  
	for (int i=3; i>=0; i--) {   
	    n <<= 8;
	    tmp = data[offset + i] & 0xFF;   
	    n |= tmp;   
	}

        return n;   
    }  

    public synchronized int get_seq() {
    	return seq++;
    }

    public void send_pcmd(int enable, float pitch, float roll, float gaz, float yaw) throws Exception {
    	System.out.println("Speed: " + speed);
	send_at_cmd("AT*PCMD=" + get_seq() + "," + enable + "," + intOfFloat(pitch) + "," + intOfFloat(roll)
    	    				+ "," + intOfFloat(gaz) + "," + intOfFloat(yaw));
    }
/*
    public void send_pcmd(int enable, float pitch, float roll, float gaz, float yaw) throws Exception {
    	System.out.println("Speed: " + speed);
	send_at_cmd("AT*SEQ=" + get_seq());
	send_at_cmd("AT*RADGP=" + (short)(pitch*25000) + ", " + (short)(roll*25000) + ", "
				 	+ (short)(gaz*25000) + ", " + (short)(yaw*25000));
    }
*/
    public synchronized void send_at_cmd(String at_cmd) throws Exception {
    	System.out.println("AT command: " + at_cmd);    
    	at_cmd_last = at_cmd;
	byte[] buf_snd = (at_cmd + "\r").getBytes();
	DatagramPacket packet_snd = new DatagramPacket(buf_snd, buf_snd.length, inet_addr, ARDrone.AT_PORT);
	socket_at.send(packet_snd);

 	/* AR.Drone does not send back ack message (like "OK")
 	byte[] buf_rcv = new byte[64];
	DatagramPacket packet_rcv = new DatagramPacket(buf_rcv, buf_rcv.length);           
	socket_at.receive(packet_rcv);
	System.out.println(new String(packet_rcv.getData(),0,packet_rcv.getLength()));
	*/  	
    }

    //Control AR.Drone via AT commands per key code
    public void control(int keyCode) throws Exception {
        //System.out.println("Key: " + keyCode + " (" + KeyEvent.getKeyText(keyCode) + ")");
    	
    	switch (keyCode) {
     	    case KeyEvent.VK_1:
    	        speed = (float)0.05;
    	    	break;
    	    case KeyEvent.VK_2:
    	        speed = (float)0.1;
    	    	break;
    	    case KeyEvent.VK_3:
    	        speed = (float)0.15;
    	    	break;
    	    case KeyEvent.VK_4:
    	        speed = (float)0.25;
    	    	break;
    	    case KeyEvent.VK_5:
    	        speed = (float)0.35;
    	    	break;
    	    case KeyEvent.VK_6:
    	        speed = (float)0.45;
    	    	break;
    	    case KeyEvent.VK_7:
    	        speed = (float)0.6;
    	    	break;
    	    case KeyEvent.VK_8:
    	        speed = (float)0.8;
    	    	break;
    	    case KeyEvent.VK_9:
    	        speed = (float)0.99;
    	    	break;
    	    case KeyEvent.VK_SHIFT:
    	        shift = true;
    	    	break;
    	    case KeyEvent.VK_UP:
    	    	if (shift) {
    		    System.out.println("Go Up (gaz+)");
    	    	    send_pcmd(1, 0, 0, speed, 0);
    	    	} else {
    	    	    System.out.println("Go Forward (pitch+)");
    	    	    send_pcmd(1, speed, 0, 0, 0);
    	    	}
    	    	break;
    	    case KeyEvent.VK_DOWN:
    	    	if (shift) {
    	    	    System.out.println("Go Down (gaz-)");
    	    	    send_pcmd(1, 0, 0, -speed, 0);
    	    	} else {
    	    	    System.out.println("Go Backward (pitch-)");
    	    	    send_pcmd(1, -speed, 0, 0, 0);
    	    	}
       	    	break;
    	    case KeyEvent.VK_LEFT:
    	        if (shift) {
    	            System.out.println("Rotate Left (yaw-)");
    	            send_pcmd(1, 0, 0, 0, -speed);
		} else {
		    System.out.println("Go Left (roll-)");
		    send_pcmd(1, 0, -speed, 0, 0);
		}
   	    	break;
    	    case KeyEvent.VK_RIGHT:
    		if (shift) {
    		    System.out.println("Rotate Right (yaw+)");
    		    send_pcmd(1, 0, 0, 0, speed);
		} else {
		    System.out.println("Go Right (roll+)");
		    send_pcmd(1, 0, speed, 0, 0);
		}
    	    	break;
    	    case KeyEvent.VK_SPACE:
    	    	space_bar = !space_bar;

   	    	if (space_bar) {
    	    	    //System.out.println("Takeoff");
    	    	    //send_at_cmd("AT*REF=" + get_seq() + ",290718208");
   		} else {
    	    	    System.out.println("Landing");
    	    	    send_at_cmd("AT*REF=" + get_seq() + ",290717696");
    		}

    	    	break;   	    			    		
    	    case KeyEvent.VK_PAUSE:
    	    	System.out.println("Hovering");
    	    	send_pcmd(1, 0, 0, 0, 0);
		speed = (float)0.1; //Reset speed
    	    	break;
    	    default:
    	    	break;
    	}
    	
    	if (keyCode >= KeyEvent.VK_1 && keyCode <= KeyEvent.VK_9) System.out.println("Speed: " + speed);
    }
}

class NavData extends Thread { 
    DatagramSocket socket_nav;
    InetAddress inet_addr;
    ARDrone ardrone;

    public NavData(ARDrone ardrone, InetAddress inet_addr) throws Exception {
    	this.ardrone = ardrone;
	this.inet_addr = inet_addr;

	socket_nav = new DatagramSocket(ARDrone.NAVDATA_PORT);
	socket_nav.setSoTimeout(3000);
    }

    public void run() {
    	int cnt = 0;
    	
	try {
	    byte[] buf_snd = {0x01, 0x00, 0x00, 0x00};
	    DatagramPacket packet_snd = new DatagramPacket(buf_snd, buf_snd.length, inet_addr, ARDrone.NAVDATA_PORT);
	    socket_nav.send(packet_snd);
    	    System.out.println("Sent trigger flag to UDP port " + ARDrone.NAVDATA_PORT);    	

	    ardrone.send_at_cmd("AT*CONFIG=" + ardrone.get_seq() + ",\"general:navdata_demo\",\"TRUE\"");

 	    byte[] buf_rcv = new byte[10240];
	    DatagramPacket packet_rcv = new DatagramPacket(buf_rcv, buf_rcv.length);            

	    while(true) {
		try {
		    socket_nav.receive(packet_rcv);
		    
		    cnt++;
		    if (cnt >= 5) {
		    	cnt = 0;
		    	System.out.println("NavData Received: " + packet_rcv.getLength() + " bytes"); 
		    	//System.out.println(ARDrone.byte2hex(buf_rcv, 0, packet_rcv.getLength()));
		    	System.out.println("Battery: " + ARDrone.get_int(buf_rcv, ARDrone.NAVDATA_BATTERY)
		    			+ "%, Altitude: " + ((float)ARDrone.get_int(buf_rcv, ARDrone.NAVDATA_ALTITUDE)/1000) + "m");
		    }
		} catch(SocketTimeoutException ex3) {
	    	    System.out.println("socket_nav.receive(): Timeout");
		} catch(Exception ex1) { 
		    ex1.printStackTrace(); 
		}
	    }
	} catch(Exception ex2) {
	    ex2.printStackTrace(); 
	}
    }
}

class Video extends Thread { 
    DatagramSocket socket_video;
    InetAddress inet_addr;
    ARDrone ardrone;

    public Video(ARDrone ardrone, InetAddress inet_addr) throws Exception {
    	this.ardrone = ardrone;
	this.inet_addr = inet_addr;

	socket_video = new DatagramSocket(ARDrone.VIDEO_PORT);
	socket_video.setSoTimeout(3000);
    }

    public void run() { 
	try {
	    byte[] buf_snd = {0x01, 0x00, 0x00, 0x00};
	    DatagramPacket packet_snd = new DatagramPacket(buf_snd, buf_snd.length, inet_addr, ARDrone.VIDEO_PORT);
	    socket_video.send(packet_snd);
    	    System.out.println("Sent trigger flag to UDP port " + ARDrone.VIDEO_PORT);    	

	    ardrone.send_at_cmd("AT*CONFIG=" + ardrone.get_seq() + ",\"general:video_enable\",\"TRUE\"");

 	    byte[] buf_rcv = new byte[64000];
	    DatagramPacket packet_rcv = new DatagramPacket(buf_rcv, buf_rcv.length);           

	    while(true) {
		try {
		    socket_video.receive(packet_rcv);
		    System.out.println("Video Received: " + packet_rcv.getLength() + " bytes"); 
		    //System.out.println(ARDrone.byte2hex(buf_rcv, 0, packet_rcv.getLength()));  
		} catch(SocketTimeoutException ex3) {
	    	    System.out.println("socket_video.receive(): Timeout");
	    	    socket_video.send(packet_snd);
		} catch(Exception ex1) { 
		    ex1.printStackTrace(); 
		}
	    }
	} catch(Exception ex2) {
	    ex2.printStackTrace(); 
	}
    }
}
