Air Native Extension for Amplitude (iOS only for the moment)
======================================

This AIR Native Extension let you use [Amplitude](http://amplitude.com) analytics tools in your AIR application.


# Setup #

The ANE binary (AmplitudeANE.ane) is located in the *bin* folder. Add it to your application's Build Path and package it with your app.

``` actionscript3
	var amplitudeInstance : AmplitudeANE = AmplitudeANE.getInstance();
	amplitudeInstance.initializeApiKey("YOUR_API_KEY");    
```
If you want logs to be displayed at the Actionsctip level, just enable the debug mode.
``` actionscript3
	amplitudeInstance.debug = true;    
```


Tracking Events
---------
Here is the simplest way to track an event. Events are savec locally and uploaded by batch every 30 seconds, or when the app is closed. You should see your event in your Amplitude profile almost immediately.
```actionscript3
    amplitudeInstance.logEvent("EVENT_ID");
```
You can also add properties to an event.
```actionscript3
	var properties:Object = new Object;
	properties.property1 = "hello world";
    amplitudeInstance.logEvent("EVENT_ID", properties);
```

Tracking Revenues
---------
You can track In-App Purchases and revenues. *WARNING* : I did not implement Amplitude's revenue verification feature yet. It means that if you add your iTunes Connect IAP Shared Secret to your Amplitude profile, revenues won't be verified and won't be tracked. It also means that revenues will appear as unverified in Amplitude. Prices should always be tracked in the same currency.
```actionscript3
	var price : Number = 0.5;
	var quantity : int = 1;
	amplitudeInstance.logRevenue(price, "PRODUCT_ID", quantity);
```

Tracking Users
---------
If you have your own user identification system, you can use it with Amplitude to track each user individually. If you don't, Ampltidue will automatically create a random ID per user.

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
    var properties:Object = new Object;
	properties.description = "this user is cool";
	properties.coolRatio = 11;
    amplitudeInstance.setUserProperties(properties);
```
And if you change your mind, you can delete user properties. In this case the value of the property is useless, it will just be deleted anyway.
```actionscript3
    var properties:Object = new Object;
	properties.description = "";
    amplitudeInstance.unsetUserProperties(properties);
```
You also have the *setOnceUserProperties* function that will only save the property once, all next *setOnceUserProperties* on this property will be ignored. However, if you use *setUserProperties* on this property, it will be updated.

Advanced
--------
You can manually opt-out a user from any tracking. All events tracking or user properties will be ignored afterwards.
```actionscript3
    amplitudeInstance.setOptOut(true);
```
You can set the number of seconds max between two sessions to consider them as separate sessions. Default is 300 seconds (5 minutes)
```actionscript3
    amplitudeInstance.setSecondsBetweenSessions(40);
```

# Documentation #


Actionscript documentation is available in HTML format in the *docs* folder.


# Build script #

If you want to build or recompile the extension, the build script is located in the *build* folder. Create a copy of the *example-build.config* file with the paths to the different SDKs, name it *build.config* and run ant.

```bash
    cd /path/to/the/ane

    # Setup build configuration
    cd build
    mv example-build.config build.config
    # Edit build.config file to provide your machine-specific paths
    # Build the ANE
    ant
```


# Authors #

This ANE has been written by myself, Elsa PRIETO, for [Pili Pop Labs](http://pilipop.com) and is distributed under the [MIT Licence](https://opensource.org/licenses/MIT). If you have any question or remark, don't hesitate to contact me!

