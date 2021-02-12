import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../essentials.dart';

class NodesPage extends StatefulWidget {
  NodesPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _NodesPageState createState() => _NodesPageState();
}

class _NodesPageState extends State<NodesPage> {
  Box nodeBox;
  String filterText = "";
  TextEditingController keyController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  List<Map> nodes = new List();
  Map dataMap = new Map();

  void addToList(int level,Map parent,String key,List path){
    if(parent[key] is String){
      setState(() {
        nodes.add({"key":key,"value":parent[key],"level":level,"path":path});
      });
    }
    else{
      if(key != "data"){
        nodes.add({"key":key,"value":null,"level":level,"path":path});
      }
      parent[key].forEach((k,v){
        addToList(level+1,parent[key],k,path+[key]);
      });
    }
  }

  void createNodeList(){
    setState(() => nodes.clear() );
    addToList(0, dataMap, "data",[]);
  }

  @override
  void initState() {
    super.initState();
    hiveSetup().then((value) { 
      setState(() { 
        nodeBox = globalBox;
        dataMap["data"] = nodeBox.get("data"); 
      });
      createNodeList();
    });
  }

  Widget searchBar(){
    return Container(
      height: 100,
      padding: EdgeInsets.only(bottom:30),
      child:TextField(
        onChanged: (input)=> setState((){ filterText = input; }),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          prefixIcon: Icon(Icons.search),
        )
      )
    );
  }



/*
  void addNode(){
    String key = keyController.text; 
    String value = valueController.text; 
    nodeBox.put(key, value);
    updateNodes();
  }

  Widget nodeDialog(String operationType,Map data){
    keyController.text = data["key"] != null ? data["key"] : "";
    valueController.text = data["value"] != null ? data["value"] : "";
    return AlertDialog(
      title: Text("$operationType Node"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children:[
          TextField(controller: keyController),
          TextField(controller: valueController,),
        ]
      ),
      actions : [
        FlatButton(
          onPressed: () {
            keyController.clear();
            valueController.clear();
            Navigator.of(context).pop();
          },
          child: Text("Close"),
        ),
        FlatButton(
          onPressed: () {
            addNode();
            keyController.clear();
            valueController.clear();
            Navigator.of(context).pop();
          },
          child: Text("Submit"),
        )
      ]
    );
  }

  void showNodeDialog(BuildContext context,String operationType,Map data){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return nodeDialog(operationType,data);
      },
    );
  }

  */
  
  
  Widget listCard(int level,String key,String value,List path,BuildContext context){
    return Container(
      margin: EdgeInsets.only(bottom:10,left:(level-1)*20.0),
      padding: EdgeInsets.all(5),
      decoration: new BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(),],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:[
          Container(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(key,style: TextStyle(fontSize:20),),
                SizedBox(height:5),
                value==null?Container():Text(value,style: TextStyle(fontSize:15),)
              ],
            )
          ),
          Row(
            children:[
              value!=null?Container():
              IconButton(
                onPressed: () => {},
                icon: Icon(Icons.add),
              ),
              IconButton(
                onPressed: () {
                  print(flattenMap(dataMap));

                },
                // showNodeDialog(context, "Edit",{"key":key,"value":value}),
                icon: Icon(Icons.edit),
              ),
              IconButton(
                onPressed: (){
                  createNodeList();
                },
                icon: Icon(Icons.delete),
              ),
            ]
          )
          
        ]
      ),
    );
  }
  
  

  Widget nodeList(BuildContext context){
    return Expanded(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: ListView.builder(
          itemCount: nodes.length,
          itemBuilder: (BuildContext ctxt, int i) {
            String key = nodes[i]["key"];
            String value = nodes[i]["value"];
            int level = nodes[i]["level"];
            List path = nodes[i]["path"];
            Widget item = Container();
            if(key.toLowerCase().contains(filterText.toLowerCase()) || filterText==""){
              item = listCard(level,key,value,path,context);
            }
            return item;
          }  
        ),
      ),
    );
  }


  

  @override
  Widget build(BuildContext context) {
    double screenHeight =  MediaQuery.of(context).size.height;
    double screenWidth =  MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text("Save Nodes"),),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        padding: EdgeInsets.symmetric(vertical:10,horizontal:20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            searchBar(),
            nodeList(context),
          ] 
        ),
      ),
    );
  }

}