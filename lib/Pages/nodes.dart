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
  List nodes = new List();
  String valueType="String";

  @override
  void initState() {
    super.initState();
    hiveSetup().then((value) { 
      setState(() { 
        nodeBox = globalBox;
        nodes = nodeBox.get("data");
      });
      updateNodes();
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

  void updateNodes()=>setState((){
    nodes.sort((a, b) => a["path"].compareTo(b["path"]));
    nodeBox.put("data",nodes);
  });

  void addNode(path,String operationType){
    Map obj = new Map();
    String key = keyController.text;
    if(operationType == "Edit"){
      setState(() => nodes.removeWhere((element) => element["path"]==path) );    
      obj["path"]=path;
      obj["key"]=keyController.text;
      obj["value"]=(valueType=="String")?valueController.text:null;
    }
    else{
      obj["path"]=path+"/"+key;
      obj["key"]=keyController.text;
      obj["value"]=(valueType=="String")?valueController.text:null;
    }
    setState(() => nodes.add(obj));
    updateNodes();
  }

  Widget nodeDialog(String operationType,node){
    if(operationType=="Edit"){
      keyController.text=node["key"];
      if(node["value"]!=null){
        valueController.text=node["value"];
      }
    }
    return AlertDialog(
      title: Text("$operationType Node"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children:[
          TextField(controller: keyController),
          (valueType=="Map")?Container():TextField(controller: valueController,),
        ]
      ),
      actions : [
        FlatButton(
          onPressed: () {
            keyController.clear();
            valueController.clear();
            setState(()=>valueType=(valueType=="String")?"Map":"String");
            Navigator.of(context).pop();
          },
          child: Text("${valueType=='Map'?'String':'Map'}"),
        ),
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
            addNode(node["path"],operationType);
            keyController.clear();
            valueController.clear();
            Navigator.of(context).pop();
          },
          child: Text("Submit"),
        )
      ]
    );
  }

  void showNodeDialog(BuildContext context,String operationType,node){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return nodeDialog(operationType,node);
      },
    );
  }

  
  
  Widget listCard(node,BuildContext context){
    String path = node["path"];
    String key = node["key"];
    String value = node["value"];
    int level = path.split("/").length-2; 
    return Container(
      margin: EdgeInsets.only(bottom:0,left:level*10.0),
      padding: EdgeInsets.all(5),
      decoration: new BoxDecoration(
        color: Colors.orange[800-100*(level+1)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:[
          Container(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  key,
                  style: TextStyle(
                    fontSize:15,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(height:5),
                value==null?Container():
                  Text(
                    value,
                    style: TextStyle(
                      fontSize:13,
                      fontWeight: FontWeight.bold
                    ),
                  )
              ],
            )
          ),
          Row(
            children:[
              value!=null?Container():
              GestureDetector( 
                onTap: () => showNodeDialog(context, "Add", node), 
                child: Icon(Icons.add,size: 30) 
              ),
              GestureDetector( 
                onTap: () => showNodeDialog(context, "Edit", node), 
                child: Icon(Icons.edit,size: 30) 
              ),
              (path =="/data")?Container():GestureDetector( 
                onTap: (){
                  setState(() => nodes.removeWhere((item) => item["path"].contains(path)));
                },
                child: Icon(Icons.delete,size: 30),
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
            Widget item = Container();
            String path = nodes[i]["path"];
            if(path.toLowerCase().contains(filterText.toLowerCase()) || filterText==""){
              item = listCard(nodes[i],context);
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
        padding: EdgeInsets.symmetric(vertical:10,horizontal:12),
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