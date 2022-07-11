import processing.net.*;

class Socket{
  Server server;
  Client client;
  
  String data = "";
  String recieveData = "";
  
  Socket(Server server){
    this.server = server;
    println("server start at Address: " + server.ip());
  }
  
  Socket(Client client){
    this.client = client;
  }
  
  void setData(String data){
    this.data = data;
  }
  
  String getRecieveData(){
    return recieveData;
  }
  
  void update(){
    if(server != null){
        //println("send: " + data);
        server.write(data);
        Client client = server.available();
        client.write(data);
        String s = client.readString();
        if (s != null && s.length() > 1) {
          println("recieve: " + s);
          recieveData = s;
        }
    }
    else if(client != null){
      //client.write(data);
      //println("send: " + data);
      String s = client.readString();
      if (s != null && s.length() > 1) {
        println("recieve: " + s);
        recieveData = s;
      }
    }
  }
}
