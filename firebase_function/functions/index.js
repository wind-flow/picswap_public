const functions = require("firebase-functions");
const firebase = require("firebase-admin");
firebase.initializeApp()
const firestore = firebase.firestore()

exports.resetTokenForUsers = functions.pubsub
    .schedule('0 0 1 * *')
    .onRun(async (context) => {
        const users = firestore.collection('userItem')
        const user = await users.get()
        user.forEach(snapshot => {
            snapshot.ref.update({ 'token.tokenFree': 10 })
        })
        return null;
    })

exports.forceExit = functions.https.onCall((request) => {
    console.log(request)
    roomId = request['roomId']
    console.log(roomId)
    return null;
});

exports.sendInAppMessagePeriodically = functions.pubsub
    .schedule('*/3 * * * *') // 3분마다 실행
    .timeZone('Asia/Seoul') // 해당 시간대에 맞게 설정
    .onRun(async (context) => {
        const roomRtdbRef = admin.database().ref('rooms');
        const conditionValue = 180; // 조건에 맞는 값을 설정하세요
        
        return roomRtdbRef.once('hostActive').then((snapshot) => {
            const currentValue = snapshot.val();

            // 만약 int 값이 조건에 맞으면 In-App Messaging 보내기
        });
    });