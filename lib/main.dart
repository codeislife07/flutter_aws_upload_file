import 'dart:io';

import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aws_upload_file/aws_config.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aws Upload File"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,width: 100,
              child: imageUrl==null?Container():Image.network(imageUrl!),
            ),
            FilledButton(onPressed: (){
                uploadFile();
            }, child: const Text("Upload In AWS"))
          ],
        ),
      ),
    );
  }

  void uploadFile () async{
      final ImagePicker picker = ImagePicker();
      final XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        //upload in aws
        var data=await AwsS3.uploadFile(
            accessKey: AwsConfig.access_key,
            secretKey: AwsConfig.secret_key,
            file: File(file.path),
            //filename: , custome filename for aws
            destDir: "demo/aws_upload",
            bucket: AwsConfig.bucket_name,
            region: AwsConfig.region,
            //metadata: {"test": "test"} // optional
        );
        setState(() {
          imageUrl=data;
          print("$imageUrl");
        });

      } else {
        print("File not Selected");
      }

  }
}

