const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNewEventNotification = functions.firestore
    .document("groups/{groupId}/events/{eventId}")
    .onCreate(async (snapshot, context) => {
        const event = snapshot.data();
        const groupId = context.params.groupId;

        // Get group details to show name in notification
        const groupSnapshot = await admin.firestore().collection("groups").doc(groupId).get();
        const groupName = groupSnapshot.exists ? groupSnapshot.data().name : "Group";

        // Format time (simple)
        const date = event.startTime ? event.startTime.toDate().toLocaleString() : "";

        const message = {
            notification: {
                title: `New Event in ${groupName}`,
                body: `${event.title} at ${date}`,
            },
            topic: `group_${groupId}`,
        };

        return admin.messaging().send(message);
    });
