//
//  Functions
//  InventoryManager
//
//  Created by Alex Grimes on 3/7/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

// configure algolia
const algoliasearch = require('algoliasearch');
const dotenv = require('dotenv');
dotenv.config();

const algolia = algoliasearch(
  process.env.ALGOLIA_APP_ID,
  process.env.ALGOLIA_API_KEY
);
const index = algolia.initIndex(process.env.ALGOLIA_INDEX_NAME);

// configure firebase
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

/**
 * Triggers when a new product is added to the cache, so it can be searchable by all users
 *
 * Cache stored at `/users/cache`.
 * The product keys in firebase represents the upc code for the product
 */
exports.newProductAdded = functions.database.ref('/users/cache/{newProductUpc}').onCreate((created_child, context) => {

	const record = created_child.val();
	record.objectID = created_child.key;


	index
		.saveObject(record)
		.then(() => {
			console.log('Firebase object indexed in Algolia', record.objectID);
			return Promise.all([]);
		})
		.catch(error => {
			console.error('Error when indexing product into Algolia', error);
			process.exit(1);
		})

	return Promise.all([]);
});

/**
 * Triggers when a product is deleted from the cache, so users will no longer be able to search
 *
 * Cache stored at `/users/cache`.
 * The product keys in firebase represents the upc code for the product
 */
exports.productDeleted = functions.database.ref('/users/cache/{deletedProductUpc}').onDelete((deleted_child, context) => {
	// Get Algolia's objectID from the Firebase object key
	const objectID = deleted_child.key;

	// Remove the object from Algolia
	index
	    .deleteObject(objectID)
	    .then(() => {
	    	console.log('Firebase object deleted from Algolia', objectID);
	    	return Promise.all([]);
	    })
	    .catch(error => {
			console.error('Error when deleting contact from Algolia', error);
			process.exit(1);
	    });

    return Promise.all([]);
});
