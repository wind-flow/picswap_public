import 'package:firebase_admin/firebase_admin.dart';

class FirebaseFunction {
  static void init() {
    FirebaseAdmin.instance.cert(
        projectId: 'picswappublic',
        clientEmail: 'windflow.100@gmail.com',
        privateKey: 'privateKey');
    // FirebaseAdmin.initializeApp(FirebaseAdmin.(
    //   projectId: 'my-project-id',
    //   credential:
    //       FirebaseAdmin.certFromPath('path/to/serviceAccountCredentials.json'),
    // ));
  }
}
