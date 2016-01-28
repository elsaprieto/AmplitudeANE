AIR Native Extension for Amplitude
======================================

This AIR Native Extension lets you use [Amplitude](http://amplitude.com) analytics tools in your AIR application.


# Setup #

The ANE binary (AmplitudeANE.ane) is located in the *bin* folder. Add it to your application's build path and package it with your app.

``` actionscript3
	var amplitudeInstance : AmplitudeANE = AmplitudeANE.getInstance();
	amplitudeInstance.initializeApiKey("YOUR_API_KEY");    
```
If you want logs to be displayed at the Actionscript level, just enable the debug mode.
``` actionscript3
	amplitudeInstance.debug = true;    
```


Tracking Events
---------
Here is the simplest way to track an event. Events are saved locally and uploaded by batch every 30 seconds, or when the app is closed. You should see your event in your Amplitude profile almost immediately.
```actionscript3
    amplitudeInstance.logEvent("EVENT_ID");
```
You can also add properties to an event.
```actionscript3
	var properties : Object = new Object();
	properties.category = "Awesome events";
    amplitudeInstance.logEvent("EVENT_ID", properties);
```

Tracking Revenues
---------
If your app contains In-App Purchases, you can track revenues and LTV with Amplitude. Prices should always be tracked in the same currency and will be displayed as dollars in Amplitude.
```actionscript3
	var price : Number = 0.5;
	var quantity : int = 1;
	amplitudeInstance.logRevenue(price, "PRODUCT_ID", quantity);
```
*WARNING* : I did not implement Amplitude's [revenue verification feature](https://amplitude.zendesk.com/hc/en-us/articles/207150887-Revenue) yet. Do not add your iTunes Connect IAP Shared Secret/Google Play License Public Key to your Amplitude profile, or your revenues won't be tracked. Revenues should appear as "Unverified" in Amplitude.

Tracking Users
---------
If you have your own user identification system, you can use it with Amplitude to track each user individually. If you don't, Amplitude will automatically create a random ID per user.

You can set the User ID when initializing Amplitude:
```actionscript3
    amplitudeInstance.initializeApiKey("YOUR_API_KEY", "UNIQUE_USER_ID");
```
Or you can set it later:
```actionscript3
    amplitudeInstance.setUserID("UNIQUE_USER_ID");
```
You can also set user properties:
```actionscript3
    var properties : Object = new Object();
	properties.description = "this user is cool";
	properties.coolRatio = 11;
    amplitudeInstance.setUserProperties(properties);
```
And if you change your mind, you can delete user properties. In this case the value of the property is ignored, it will just delete it.
```actionscript3
    var properties : Object = new Object();
	properties.description = "";
    amplitudeInstance.unsetUserProperties(properties);
```
You also have the *setOnceUserProperties* function that will only set these properties once, all next *setOnceUserProperties* on the same properties will be ignored. However, if you use *setUserProperties* on any of these, they will be updated.

Advanced
--------
You can manually opt-out a user from any tracking. All events tracking or user properties will be ignored afterwards.
```actionscript3
    amplitudeInstance.setOptOut(true);
```
You can set the number of seconds max between two sessions to consider them as separate sessions. Default is 300 seconds (5 minutes)
```actionscript3
    amplitudeInstance.setSecondsBetweenSessions(30);
```

# Documentation #


Actionscript documentation is available in HTML format in the *docs* folder.


# Build script #

If you want to build or recompile the extension, the build script is located in the *build* folder. Create a copy of the *example-build.config* file with the paths to the different SDKs, name it *build.config* and run ant.

```bash
    cd /to/the/ane
	cd build
    mv example-build.config build.config
    # Edit build.config file
    ant
```


# Authors #

This ANE has been written by myself, Elsa PRIETO, for [Pili Pop Labs](http://pilipop.com) and is distributed under the [MIT Licence](https://opensource.org/licenses/MIT). If you have any question or remark, don't hesitate to contact me!
