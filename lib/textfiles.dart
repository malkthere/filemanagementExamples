import 'dart:convert';
import 'dart:io';
import 'main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:filemanagment/sqldb.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
 class Textfiles {
   SqlDb sqlDb = SqlDb();

  Future<String> readTextFile() async{
    final Directory tempDir = await getTemporaryDirectory();
    print(tempDir);

    final File file = File('${tempDir.path}/file_picker/hihihi.text');

    final String fileContent = (await file.readAsString()) ;

    print(fileContent.toString());


   return(fileContent);

  }
//this fuction will read a students list from text file (in the formate of comma Delimited CSV) to a table in a database
   Future<String> readStudentslist(File? filepath) async{


    final List<String> fileContent2 = await filepath!.readAsLines();

    print("=====================");
    int count=0;
String department;
String? departmentID;
String? level;
int? intlevel;


    for (var i in fileContent2){
      //print(i);
      if ((count==1)){
        List<String> s2=i.split(",");
        department=s2[4];
    //    print(department);

        List<Map> response2= await sqlDb.readData("SELECT DeptID FROM department WHERE DeptName = '${department}'");
        print(response2);

      //  print(departmentID+"hhh");
        if(response2.isEmpty){

          String sqlQ = "INSERT INTO department ('DeptName') VALUES ('${department}')";
          int response = await sqlDb.insertData(sqlQ);
          print("this department is not in the database, now is add "+response.toString());
          departmentID=response.toString();
          print(departmentID);

        }else{
          departmentID=response2[0]['DeptID'].toString();

        }
        //print(response2[0]['DeptID']);
//print(departmentID);
      }
      if ((count==2)){
        List<String> s2=i.split(",");
        level=s2[4];
        //print(s2[4].toString());
        if (level=="الاول") intlevel=1;
        else if (level=="الثاني") intlevel=2;
        else if (level=="الثالث") intlevel=3;
        else intlevel=4;
        //print(intlevel);
      }

      if ((count > 6)){
        List<String> s2=i.split(",");
        if(s2[0]!="") {
          print("ادخال بيانات الطالب "+s2[1] + "مسجلة برقم قيد " + s2[2]+"  الى قاعدة البيانات  ");
          String sqlQ = "INSERT INTO std_info2 ('StdID','DeptID','StdName','level') VALUES ('${s2[2]}','${departmentID}','${s2[1]}','${intlevel}')";
          int response = await sqlDb.insertData(sqlQ);
          print("");
        }

      }

      count++;
    }
   // String sqlQ="SELECT * FROM std_info2";
    //List<Map> response = await sqlDb.readData(sqlQ);
    //print(response);
    //sqlDb.insertData(sqlQ);
      //print("LINE001"+fileContent2[0].toString());
      // print("LINE002"+fileContent2[1].toString());
      // print("LINE003"+fileContent2[2].toString());


      x=fileContent2[2];

      return(fileContent2[2]);
    }

  saveTextFile(String filename, String containt) async{
    // this next 4 line to write a file in temp Directory
   // final Directory tempDir = await getTemporaryDirectory();
    final File file = File('/storage/emulated/0/Documents/'+filename+".text");
   // print(""+tempDir.toString());
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      print("no permistiom");
      await Permission.storage.request();
    }
    await file.writeAsString(containt);

  }

  creatDir(String dirname) async {

    ////////////here we creat a file in side our own Dir in temp folder
    final Directory tempDir = await getTemporaryDirectory();
    final Directory newDirectory = Directory('/storage/emulated/0/'+dirname);

// Always check that the directory exists
    if (await newDirectory.exists() == false) {
      await newDirectory.create();
    }

    final File file = File('${newDirectory.path}/sample_file.txt');
    print(""+tempDir.toString());
    await file.writeAsString('this file writen as the try ');
  }void

  getthepath() async {

// Put cache files in this directory
    final temporaryDirectory = await getTemporaryDirectory();

    print("the temporaryDirectory is :");
    print(temporaryDirectory);
// For files that our app uses but are not exposed to the user
    final appSupport = await getApplicationSupportDirectory();
    print(" the appSupport is :");
    print(appSupport);

    // For user-generated files
    final appDocuments = await getApplicationDocumentsDirectory();
    print("the appDocuments is :");
    print(appDocuments);

  }

}