/*
Author: MAPGPS on
	https://projects.ardrone.org/projects/ardrone-api/boards
	http://bbs.5imx.com/bbs/forumdisplay.php?fid=453
Initial: 2010.09.20
Updated: 2010.09.27

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
Takeoff:	java ARDrone 192.168.1.1 AT*REF=101,290718208
Landing:	java ARDrone 192.168.1.1 AT*REF=102,290717696
Hovering:	java ARDrone 192.168.1.1 AT*PCMD=201,1,0,0,0,0
gaz 0.1:	java ARDrone 192.168.1.1 AT*PCMD=301,1,0,0,1036831949,0
gaz -0.1:	java ARDrone 192.168.1.1 AT*PCMD=302,1,0,0,-1110651699,0
pitch 0.1:	java ARDrone 192.168.1.1 AT*PCMD=303,1,1036831949,0,0,0
pitch -0.1:	java ARDrone 192.168.1.1 AT*PCMD=304,1,-1110651699,0,0,0
yaw 0.1:	java ARDrone 192.168.1.1 AT*PCMD=305,1,0,0,0,1036831949
yaw -0.1:	java ARDrone 192.168.1.1 AT*PCMD=306,1,0,0,0,-1110651699
roll 0.1:	java ARDrone 192.168.1.1 AT*PCMD=307,1,0,1036831949,0,0
roll -0.1:	java ARDrone 192.168.1.1 AT*PCMD=308,1,0,-1110651699,0,0
pitch -30 deg:	java ARDrone 192.168.1.1 AT*ANIM=401,0,1000
pitch 30 deg:	java ARDrone 192.168.1.1 AT*ANIM=402,1,1000

########## Keyboad mode ############
Usage: java ARDrone [IP]

PgUp key:     Takeoff
PgDn key:     Landing
SpaceBar key: Hovering

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
    InetAddress inet_addr;
    DatagramSocket socket;
    int seq = 1; //Send AT command with sequence number 1 will reset the counter
    float speed = (float)0.1, speed_old = speed;
    float pitch = 0, roll = 0, gaz = 0, yaw = 0;
    boolean pcmd = false;
    boolean shift = false;
    boolean skip = false;
    String action = "";
    FloatBuffer fb;
    IntBuffer ib;

    public ARDrone(String name, String args[]) throws Exception {
        super(name);

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
    	System.out.println("Speed: " + speed);    	

        ByteBuffer bb = ByteBuffer.allocate(4);
        fb = bb.asFloatBuffer();
        ib = bb.asIntBuffer();

        inet_addr = InetAddress.getByAddress(ip_bytes);
	socket = new DatagramSocket();
	socket.setSoTimeout(3000);
	
	send_at_cmd("AT*CONFIG=1,\"control:altitude_max\",\"2000\""); //altitude max 2m

	if (args.length == 2) { //Commandline mode
	    send_at_cmd(args[1]);
	    System.exit(0);
	}

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
        new ARDrone("ARDrone", args);
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

    public void set_pcmd_values() {
	if (!pcmd) action = "";

    	if (speed == speed_old) {
    	    skip = true;
    	    return;
    	}
    	skip = false;
    	speed_old = speed;
    	
    	if (pitch != 0) {if (pitch > 0) pitch = speed; else pitch = -speed;}
    	else if (roll != 0) {if (roll > 0) roll = speed; else roll = -speed;}
    	else if (gaz != 0) {if (gaz > 0) gaz = speed; else gaz = -speed;}
    	else if (yaw != 0) {if (yaw > 0) yaw = speed; else yaw = -speed;}
    }
    
    public void send_at_cmd(String at_cmd) throws Exception {
    	System.out.println("AT command: " + at_cmd);    	
	byte[] buffer = (at_cmd + "\r").getBytes();
	DatagramPacket packet = new DatagramPacket(buffer, buffer.length, inet_addr, 5556);
	socket.send(packet);
	//socket.receive(packet); //AR.Drone does not send back ack message (like "OK")
	//System.out.println(new String(packet.getData(),0,packet.getLength()));   	
    }

    //Control AR.Drone via AT commands per key code
    public void control(int keyCode) throws Exception {
    	String at_cmd = "";
    	
    	switch (keyCode) {
     	    case KeyEvent.VK_1:
    	        speed = (float)0.05;
    	        set_pcmd_values();
    	    	break;
    	    case KeyEvent.VK_2:
    	        speed = (float)0.1;
    	        set_pcmd_values();
    	    	break;
    	    case KeyEvent.VK_3:
    	        speed = (float)0.15;
    	        set_pcmd_values();
    	    	break;
    	    case KeyEvent.VK_4:
    	        speed = (float)0.25;
    	        set_pcmd_values();
    	    	break;
    	    case KeyEvent.VK_5:
    	        speed = (float)0.35;
    	        set_pcmd_values();
    	    	break;
    	    case KeyEvent.VK_6:
    	        speed = (float)0.45;
    	        set_pcmd_values();
    	    	break;
    	    case KeyEvent.VK_7:
    	        speed = (float)0.6;
    	        set_pcmd_values();
    	    	break;
    	    case KeyEvent.VK_8:
    	        speed = (float)0.8;
    	        set_pcmd_values();
    	    	break;
    	    case KeyEvent.VK_9:
    	        speed = (float)0.99;
    	        set_pcmd_values();
    	    	break;
    	    case KeyEvent.VK_SHIFT:
    	        shift = true;
    	        skip = true;
    	    	break;
    	    case KeyEvent.VK_UP:
    	    	if (shift) {
    	    	    action = "Go Up (gaz+)";
    	    	    pitch = 0; roll = 0; gaz = speed; yaw = 0;
    	    	} else {
    	    	    action = "Go Forward (pitch+)";
    	    	    pitch = speed; roll = 0; gaz = 0; yaw = 0;
    	    	}
    	    	pcmd = true;
    	    	skip = false;
    	    	break;
    	    case KeyEvent.VK_DOWN:
    	    	if (shift) {
    	    	    action = "Go Down (gaz-)";
    	    	    pitch = 0; roll = 0; gaz = -speed; yaw = 0;
    	    	} else {
    	    	    action = "Go Backward (pitch-)";
    	    	    pitch = -speed; roll = 0; gaz = 0; yaw = 0;
    	    	}
    	    	pcmd = true;
    	    	skip = false;
       	    	break;
    	    case KeyEvent.VK_LEFT:
    	        if (shift) {
    	            action = "Rotate Left (yaw-)";
    	            pitch = 0; roll = 0; gaz = 0; yaw = -speed;
		} else {
		    action = "Go Left (roll-)";
		    pitch = 0; roll = -speed; gaz = 0; yaw = 0;
		}
    	    	pcmd = true;
    	    	skip = false;
    	    	break;
    	    case KeyEvent.VK_RIGHT:
    		if (shift) {
    		    action = "Rotate Right (yaw+)";
    		    pitch = 0; roll = 0; gaz = 0; yaw = speed;
		} else {
		    action = "Go Right (roll+)";
		    pitch = 0; roll = speed; gaz = 0; yaw = 0;
		}
    	    	pcmd = true;
    	    	skip = false;
    	    	break;
    	    case KeyEvent.VK_SPACE:
    	    	action = "Hovering";
		pitch = 0; roll = 0; gaz = 0; yaw = 0;
		speed = (float)0.1; //Reset speed
    	    	pcmd = true;
    	    	skip = false;
    	    	break;
    	    case KeyEvent.VK_PAGE_UP:
    	    	action = "Takeoff";
    	    	at_cmd = "AT*REF=" + (seq++) + ",290718208";
    	    	pcmd = false;
    	    	skip = false;
    	    	break;
    	    case KeyEvent.VK_PAGE_DOWN:
    	    	action = "Landing";
    	    	at_cmd = "AT*REF=" + (seq++) + ",290717696";
    	    	pcmd = false;
    	    	skip = false;
    	    	break;
    	    default:
    	    	break;
    	}

	if (skip) return;

    	if (pcmd) {
    	    at_cmd = "AT*PCMD=" + (seq++) + ",1," + intOfFloat(pitch) + "," + intOfFloat(roll)
    	    				+ "," + intOfFloat(gaz) + "," + intOfFloat(yaw);
	}

        System.out.println("Key: " + keyCode + " (" + KeyEvent.getKeyText(keyCode) + ")");
    	System.out.println("Speed: " + speed);
    	System.out.println("Action: " + action);
	send_at_cmd(at_cmd);
    }
}
