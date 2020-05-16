import 'dart:convert'; 
import 'package:flutter/material.dart'; 
import 'package:http/http.dart' as http; 
import 'dart:async';
import 'package:project4/ui/inputpenjualan.dart'; 

class Home extends StatefulWidget {   
  @override 
  _HomeState createState() => _HomeState(); } 
 
class _HomeState extends State<Home> {   
  //membuat sebuah data list untuk menampung data penjualan   
  List penjualanList;    
  //untuk menampung jumlah data
   int count = 0;   
   Future<List> getData() async{     
     //request data penjualan     
     //sesuaikan dengan ip address, pastikan webserver aktif, dan fungsi sesuai dengan studi kasus     
     final response= await http.get('http://192.168.43.149/rest_api/index.php/penjualan/');     
      return json.decode(response.body);   
      }   //memanggil fungsi future pertama kali   
      
      @override   
      void initState() {       
        Future<List> penjualanListFuture=getData();       
        penjualanListFuture.then((penjualanList){         
          setState(() {        
            //menampung futre data dalam list penjualan yang telah dibentuk sebelumnya         
            this.penjualanList=penjualanList;         
            this.count=penjualanList.length;          
          });       
        });     
        super.initState();   
      }      
      @override   
      //membuat widget body   
      Widget build(BuildContext context) {     
        return Scaffold(       
          appBar: new AppBar(         
            title: Text("Penjualan Jam Tangan"),       
          ),       
          //menampilkan data dalam fungsi createListView       
          //sama seperti pada modul 2       
          body: createListView(),       
          //tombol add       
          floatingActionButton: FloatingActionButton(           
            child: Icon(Icons.add),           
            tooltip: 'Input Penjualan',           
            onPressed: ()=>Navigator.of(context).push(   
              new MaterialPageRoute(           
                //inisialisasi list dan index null, agar form input membaca sebagai inputan baru     
                builder: (BuildContext context)=> new InputPenjualan(list: null,index: null,)   
                )  
              )         
          ),     
        );   
      }   //sebuah fungsi untuk menampilkan data dalam listview   
      ListView createListView() {     
        TextStyle textStyle = Theme.of(context).textTheme.subhead;     
        //updateListView();     
        return ListView.builder(       
          itemCount: count,       
          itemBuilder: (BuildContext context, int index) {         
            return Card(           
              color: Colors.white,           
              elevation: 2.0,           
              //anggota list           
              child: ListTile(             
                title: Text(penjualanList[index]['nama'], style: textStyle,),             
                subtitle: Row(               
                  children: <Widget>[                 
                    Text(penjualanList[index]['tanggal'].toString().toString()),                 
                    Text(" | Rp. "+penjualanList[index]['jumlah'], style: TextStyle(fontWeight: FontWeight.bold),),
                    ],             
                  ),             
                  //icon delete             
                  trailing: GestureDetector(               
                    child: Icon(Icons.delete),               
                    onTap: ()=>confirm(penjualanList[index]['id'],penjualanList[index]['nama']),                
                  ),             
                  //klik list untuk tampilkan form update             
                  onTap: (){},           
                ),         
              );       
            },     
          );   
        }
        Future<http.Response> deletePenjualan(id) async {    
          final http.Response response = await http.delete(     
            'http://192.168.43.149/rest_api/index.php/penjualan/delete/$id');   
            return response; }
          void confirm(id,nama){   
        AlertDialog alertDialog = new AlertDialog(     
          content: new Text("Anda yakin hapus penjualan '$nama'"),     
          actions: <Widget>[       
            new RaisedButton(         
              child: new Text("OK Hapus!",style: new TextStyle(color: Colors.black),),         
              color: Colors.red,         
              onPressed: (){           
                deletePenjualan(id);           
                Navigator.of(context, rootNavigator: true).pop();           
                initState();           
              },       
            ),       
            new RaisedButton(         
              child: new Text("Batal",style: new TextStyle(color: Colors.black)),         
              color: Colors.green,         
              onPressed: ()=> Navigator.of(context, rootNavigator: true).pop(),       
            ),     
          ],   
        );
        showDialog(context: context, child: alertDialog);  
    }
}
      