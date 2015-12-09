//////////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2015 Elsa Prieto for Pili Pop Labs ̵ http://pilipop.com ̵ elsa@pilipop.com
//  
//  NOTICE: you are permited to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//  
//////////////////////////////////////////////////////////////////////////////////////

package com.pilipoplabs
{
    import flash.events.EventDispatcher;
    import flash.events.StatusEvent;
    import flash.external.ExtensionContext;
    import flash.system.Capabilities;

    /** 
	* Amplitude ANE is an AIR Native extension that let you use Amplitude (www.amplitude.com) analytics tools in your AIR application. 
	*/ 
    public class AmplitudeANE extends EventDispatcher
    {
       /** 
        * Indicates if current device supports Amplitude ANE. Amplitude ANE is only supported on iOS devices for now
        */
        public static function get isSupported() : Boolean {
            return isAndroid || isIOS;
        }

        /** 
		* @private 
		*/ 
        public static function getInstance() : AmplitudeANE {
            return _instance ? _instance : new AmplitudeANE();
        }
        
        /** 
        * Use getInstance() to instanciate AmplitudeANE
        */
        public function AmplitudeANE() : void {
            if (!_instance) {
                _context = ExtensionContext.createExtensionContext(ANE_ID, null);
                if (!_context) {
                    log("ERROR - Extension context is null.");
                    return;
                }
                _context.addEventListener(StatusEvent.STATUS, onStatus);
                _instance = this;
            } else {
                throw Error("This is a singleton, use getInstance() instead.");
            }
        }     

        /** 
		* If set to true, logs will be displayed at the Actionscript level
		*  
		* @default false  
		*/ 
        public function get debug() : Boolean {
            return _debugActivated;
        }
        
        /** 
		* @private 
		*/ 
        public function set debug( value : Boolean ) : void {
            _debugActivated = value;
        }        
        
        /**
        * Start Amplitude session and event logging
        *
        * @param apiKey Your Amplitude API key
        * @param userID Provide a userID if you have your own user identification system
        *
        */
        public function initializeApiKey(apiKey : String, userID : String = null) : void {
            if (isSupported) {
                    _context.call("initializeApiKey", apiKey, userID);
            } else {
                log("AmplitudeANE is not supported on this platform");
            }
        }

        /**
        * Log an event
        *
        * @param eventID An ID/description of the event you want to log
        * @param properties An object with a set of properties you want to associate to that event
        * @param outOfSession If you want this event to be logged as an out of session event
        *
        */
        public function logEvent(eventID : String, properties : Object = null, outOfSession : Boolean = false) : void {
            var propKeys:Array = [];
            var propValues:Array = [];
            if (properties) {
                var value:String;
                for (var key:String in properties) {                    
                    value = properties[key].toString();
                    propKeys.push(key);
                    propValues.push(value);
                }
            }
            if (isSupported) {
                _context.call("logAmplitudeEvent", eventID, propKeys, propValues, outOfSession);
            }
        }

        /**
        * Identify a user with your own user identification system
        *
        * @param userID Your custom user ID
        *
        */
        public function setUserID(userID:String) : void {
            if (isSupported) {
                _context.call("setUserID", userID)
            }
        }

        /**
        * Log a revenue
        * <p>WARNING: Don't add your iTunes Connect IAP Shared Secret key to your Amplitude app settings or it won't be able to verify the purchase and won't take the revenue into account</p>
        * <p>TODO: add receipt verification</p>
		*
        * @param price The price of the product, use always the same currency
        * @param productID The ID of the product bought (product_id in the App Store receipt)
        * @param quantity The quantity of the product bought
        *
        */
        public function logRevenue(price : Number, productID : String = null, quantity : int = 1) : void {
           if (isSupported) {
                _context.call("logRevenue", price, productID, quantity);
            } 
        }

        /**
        * Set custom properties for current user. Calling this twice on the same property will replace its value.
        *
        * @param properties An object with a set of properties you want to associate to that user
        *
        */
        public function setUserProperties(properties:Object) : void {
            var propKeys:Array = [];
            var propValues:Array = [];            
            for (var key:String in properties) {  
                var value:String = "";              
                if(properties[key]){
                   
                    value = properties[key].toString();
                }             
                propKeys.push(key);
                propValues.push(value);
            }
            
            if (isSupported) {
                _context.call("setUserProperties", propKeys, propValues);
            } 
        }

        /**
        * Remove custom properties for current user
        *
        * @param properties An object with a set of properties you want to remove from that user
        *
        */
        public function unsetUserProperties(properties:Object) : void {
            var propKeys:Array = [];
            for (var key:String in properties) {
                propKeys.push(key);
            }
            
            if (isSupported) {
                _context.call("unsetUserProperties", propKeys);
            } 
        }

        /**
        * Set custom constant for current user. Calling this twice on the same property will do nothing. 
        * Calling setUserProperties on the same property will replace its value.
        *
        * @param properties An object with a set of properties you want to associate to that user
        *
        */
        public function setOnceUserProperties(properties:Object) : void {
            var propKeys:Array = [];
            var propValues:Array = [];
            for (var key:String in properties) {
                var value:String = "";              
                if(properties[key]){
                   
                    value = properties[key].toString();
                } 
                propKeys.push(key);
                propValues.push(value);
            }
            
            if (isSupported) {
                _context.call("setOnceUserProperties", propKeys, propValues);
            } 
        }

        /**
        *  Opt-in or opt-out the user from event logging
        *
        * @param optOutActivated If set to true, prevent any event to be logged
        *
        */
        public function setOptOut(optOutActivated : Boolean) : void {
           if (isSupported) {
                _context.call("setOptOut", optOutActivated);
            } 
        }

        /**
        *  Set the number of seconds max between two sessions to consider them as separate sessions. 
        *  Default to 300 seconds (5 minutes)
        *
        * @param seconds number of seconds max
        *
        */
        public function setSecondsBetweenSessions(seconds : int) : void {
           if (isSupported) {
                _context.call("setSecondsBetweenSessions", seconds);
            } 
        }

        private static const ANE_ID : String = "com.pilipoplabs.AmplitudeANE";        
        private static var _instance : AmplitudeANE;        
        private var _context : ExtensionContext;
        private var _debugActivated : Boolean = false;

        private function onStatus(event : StatusEvent) : void {
            if(_debugActivated){
                log(event.level);
            }
            
        }

        private function log(message : String) : void {
            trace("[AmplitudeANE] " + message);
        }
        
        private static function get isAndroid() : Boolean {
            return Capabilities.manufacturer.indexOf("Android") > -1;
        }
        
        private static function get isIOS() : Boolean {
            return Capabilities.manufacturer.indexOf("iOS") > -1;
        }
    }
}