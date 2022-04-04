import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  Future writeSubjects(String? classcode, String? subject, String? videoname,
      String? videolink) async {
    try {
      String collecId = '${classcode!}_${subject}_videolinks';
      String docId =
          subject! + '_' + classcode + '_' + DateTime.now().hashCode.toString();
      CollectionReference collectionReference =
          await FirebaseFirestore.instance.collection(collecId);
      await collectionReference.doc(docId).set({
        'name': videoname,
        'link': videolink,
      });
      return 'succesfull';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //to read the video links
  Future readLinks(String? classcode, String? subject) async {
    List<Map> videoMap = [];
    List? docs;
    Map? video;

    String collecId = '${classcode!}_${subject}_videolinks';
    try {
      FirebaseFirestore instance = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await instance.collection(collecId).get();
      if (querySnapshot.docs.isNotEmpty) {
        docs = await querySnapshot.docs.toList();
        for (var doc in docs) {
          video = {'name': doc['name'], 'link': doc['link']};
          videoMap.add(video);
        }
        return videoMap;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future writeAnnouncement(String? classcode, String? title,
      String? description, String? dateAndTime, String? url) async {
    try {
      String collectionID = classcode! + '_' + 'announcement';
      String docID = collectionID + DateTime.now().toString();
      CollectionReference collectionReference =
          await FirebaseFirestore.instance.collection(collectionID);
      print(dateAndTime);
      await collectionReference.doc(docID).set({
        'title': title,
        'description': description,
        'deadline': dateAndTime,
        'url': url
      });
      return 'succesfull';
    } catch (e) {
      return null;
    }
  }

  //to read notifications
  Future readNotifications(String? classcode) async {
    List<Map> notificationsMapList = [];
    List? docs;
    Map? notifications;

    String collecId = classcode! + '_' + 'announcement';
    try {
      FirebaseFirestore instance = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await instance.collection(collecId).get();
      if (querySnapshot.docs.isNotEmpty) {
        docs = await querySnapshot.docs.toList();
        docs.sort((mapA, mapB) =>
            mapA['deadline'].toString().compareTo(mapB['deadline']));
        for (var doc in docs) {
          if (DateTime.parse(doc['deadline']).isBefore(DateTime.now()) ||
              DateTime.parse(doc['deadline'])
                  .isAtSameMomentAs(DateTime.now())) {
            await instance.collection(collecId).doc(doc.id).delete();
          } else {}
          notifications = {
            'title': doc['title'],
            'description': doc['description'],
            'lastdate': doc['deadline'].toString().substring(0, 10),
            'endtime': doc['deadline'].toString().substring(11),
            'url': doc['url'],
          };
          notificationsMapList.add(notifications);
        }
        return notificationsMapList;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  //to ask question
  Future askQuestions(
      String? classcode, String? subject, String? question, String? uid) async {
    try {
      bool answered = false;
      String collectionID = classcode! + '_' + subject! + '_' + 'questions';
      String docID = collectionID + DateTime.now().toString();
      CollectionReference collectionReference =
          await FirebaseFirestore.instance.collection(collectionID);
      await collectionReference.doc(docID).set({
        'question': question,
        'answered': answered,
        'author': uid,
        'doc': docID,
      });
      return 'succesfull';
    } catch (e) {
      return null;
    }
  }

  Future<List<Map>?> viewQuestions(String classcode, String subject) async {
    List<Map> questions = [];
    List? documents;
    Map? question;
    String? collectionID;
    collectionID = '${classcode}_${subject}_questions';

    try {
      print('reached');
      print(collectionID);
      FirebaseFirestore instance = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot =
          await instance.collection(collectionID).get();
      if (querySnapshot.docs.isNotEmpty) {
        documents = await querySnapshot.docs.toList();
        for (var doc in documents) {
          question = {
            'question': doc['question'],
            'answered': doc['answered'],
            'uid': doc['author'],
            'doc': doc['doc'],
          };
          questions.add(question);
        }
        print(questions);
        return questions;
      } else {
        return [];
      }
    } catch (e) {
      return null;
    }
  }
}
