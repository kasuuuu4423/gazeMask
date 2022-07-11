import oscP5.*;
import netP5.*;

class Osc{
    OscP5 oscP5;
    NetAddress location;
    String recieveAddr;
    String[] recieveData;

    Osc(OscP5 oscP5, String address, int sendPort){
        this.oscP5 = oscP5;
        location = new NetAddress(address, sendPort);
    }

    String getRecieveAddr(){
        return recieveAddr;
    }

    String[] getRecieveData(){
        return recieveData;
    }

    void send(String address, String data){
        OscMessage msg = new OscMessage(address);
        msg.add(data);
        oscP5.send(msg, location); 
    }

    void recieve(OscMessage msg){
        recieveData = msg.get(0).stringValue().split(",");
        recieveAddr = msg.addrPattern();
        println(recieveData);
    }
}