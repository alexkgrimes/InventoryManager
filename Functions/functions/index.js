const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

/**
 * Triggers when one of a users product in their inventory falls below 10 count
 *
 * Inventory stored at `/users/{userUid}/{productUpc}/quantity`.
 * Users save their device notification tokens to `/users/{userUid}/notificationTokens/{notificationToken}`.
 */
exports.sendLowStockNotification = functions.database.ref('/users/{userUid}/products/{productUpc}/quantity')
    .onWrite(async (change, context) => {
		const userUid = context.params.userUid;
		const productUpc = context.params.productUpc;

		// If the change in inventory is not low-stock, 
		let beforeQuantity = change.before.val() === null ? 0 : change.before.val()
		if (beforeQuantity < change.after.val() || change.after.val() > 10) {
			return console.log('User: ', userUid, ' with product: ', productUpc);
		}
		console.log('Low stock alert for user:', userUid, ' for product: ', productUpc);

		// Get the product name
		const getProductNamePromise = admin.database().ref(`/users/${userUid}/products/${productUpc}/name`).once('value');

		// Get the notification tokens
		const getNotificationTokenPromise = admin.database().ref(`/users/${userUid}/notificationTokens`).once('value');

		const results = await Promise.all([getNotificationTokenPromise, getProductNamePromise]);

		// Product name
		const productName = results[1].val();
		console.log('Product name: ', productName);

		if (productName === null) {
			return console.log('Product has been removed.')
		}

		// Tokens
		const tokensSnapshot = results[0];

		// Check if there are any device tokens.
		if (!tokensSnapshot.hasChildren()) {
		  return console.log('There are no notification tokens to send to.');
		}

		// Notification details.
		const payload = {
			notification: {
			  title: 'Low Stock Alert',
			  body: `Only ${change.after.val()} left of ${productName}.`
			}
		};

		// Listing all tokens as an array.
		let tokens = Object.keys(tokensSnapshot.val());
		// Send notifications to all tokens.
		const response = await admin.messaging().sendToDevice(tokens, payload);

		// For each message check if there was an error.
		const tokensToRemove = [];
		response.results.forEach((result, index) => {
		  const error = result.error;
		  if (error) {
		    console.error('Failure sending notification to', token, error);
		    // Cleanup the tokens who are not registered anymore.
		    if (error.code === 'messaging/invalid-registration-token' ||
		        error.code === 'messaging/registration-token-not-registered') {
		      tokensToRemove.push(tokensSnapshot.ref.child(token).remove());
		    }
		  }
		});


		// Record notification
		let timestamp = Date.now()

		admin.database().ref(`/users/${userUid}/notifications/${timestamp}`).update({
			title: payload.notification.title,
			body : payload.notification.body
		});


		return Promise.all([]);
    });