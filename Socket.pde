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
        println("send: " + data);
        server.write(data);
    }
    else if(client != null){
      String s = client.readString();
      if (s != null) {
        println("recieve: " + s);
        recieveData = s;
      }
    }
  }
}
