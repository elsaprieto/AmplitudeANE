#import "AmplitudeANE.h"

FREContext AmplitudeANECtx = nil;

@implementation AmplitudeANE
@end

void customLog (NSString *format, ...) {
    va_list args;
    va_start(args, format);
    va_end(args);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    FREDispatchStatusEventAsync(AmplitudeANECtx, (const uint8_t *)"LOG", (const uint8_t *)[message UTF8String]);
}

FREObject initializeApiKey (FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    uint32_t apiKeyLength;
    const uint8_t *apiKeyValue;
    if (FREGetObjectAsUTF8(argv[0], &apiKeyLength, &apiKeyValue) == FRE_OK) {
        uint32_t userIDLength;
        const uint8_t *userIDValue = 0;
        NSString *userID = nil;
        if(FREGetObjectAsUTF8(argv[1], &userIDLength, &userIDValue) == FRE_OK) {
            userID = [NSString stringWithUTF8String:(char*)userIDValue];
        }
        NSString *apiKey = [NSString stringWithUTF8String:(char*)apiKeyValue];
        [[Amplitude instance] initializeApiKey:apiKey userId:userID];
        customLog(@"Starting Amplitude session with API key: %@ and userID; %@", apiKey, userID);
    } else {
        customLog(@"ERROR: problems whith API key.");
    }
    return nil;
}

FREObject logAmplitudeEvent (FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    /* Retreiving first arg: event ID */
    uint32_t stringLength;
    const uint8_t *value;
    if (FREGetObjectAsUTF8(argv[0], &stringLength, &value) != FRE_OK) {
        customLog(@"ERROR: problems with event ID.");
    }
    NSString *eventID = [NSString stringWithUTF8String:(char*)value];
    
    /* Retreiving eventual event properties*/
    NSMutableDictionary *properties;
    if (argc > 1 && argv[1] != NULL && argv[2] != NULL && argv[1] != nil && argv[2] != NULL) {
        FREObject keyList = argv[1];
        uint32_t keyLength = 0;
        FREObject valueList = argv[2];
        if (keyList != nil) {
            if (FREGetArrayLength(keyList, &keyLength) != FRE_OK) {
                keyLength = 0;
            }
            
            properties = [[NSMutableDictionary alloc] init];
            
            for (int32_t i = keyLength-1; i >= 0; i--) {
                FREObject key;
                if (FREGetArrayElementAt(keyList, i, &key) != FRE_OK) {
                    continue;
                }
                
                FREObject value;
                if (FREGetArrayElementAt(valueList, i, &value) != FRE_OK) {
                    continue;
                }
                
                uint32_t stringLength;
                const uint8_t *keyString;
                if (FREGetObjectAsUTF8(key, &stringLength, &keyString) != FRE_OK) {
                    continue;
                }
                
                const uint8_t *valueString;
                if (FREGetObjectAsUTF8(value, &stringLength, &valueString) != FRE_OK) {
                    continue;
                }
                
                [properties setValue:[NSString stringWithUTF8String:(char*)valueString] forKey:[NSString stringWithUTF8String:(char*)keyString]];
            }
        }
    }
    
    uint32_t outOfSession = 0;
    FREGetObjectAsBool(argv[3], &outOfSession);
    
    [[Amplitude instance] logEvent:eventID withEventProperties:properties outOfSession:outOfSession];
    customLog(@"Logged event with ID: %@, properties: %@ and out of session: %d", eventID, properties, outOfSession);
    return nil;
}

FREObject setUserID (FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    uint32_t stringLength;
    const uint8_t *value;
    
    if (FREGetObjectAsUTF8(argv[0], &stringLength, &value) == FRE_OK) {
        NSString *userID = [NSString stringWithUTF8String:(char*)value];
        [[Amplitude instance] setUserId:userID];
        customLog(@"Set user ID %@", userID);
    }
    
    return nil;
}

FREObject logRevenue (FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSString *productIdentifier = nil;
    int32_t quantity = 1;
    double price = 0;
    NSData *receipt = nil;
    
    if(FREGetObjectAsDouble(argv[0], &price) != FRE_OK) {
        customLog(@"ERROR - revenue price is not correct.");
        return nil;
    }
    
    uint32_t stringLength;
    const uint8_t *value;
    FREGetObjectAsUTF8(argv[1], &stringLength, &value);
    productIdentifier = [NSString stringWithUTF8String:(char*)value];
    
    FREGetObjectAsInt32(argv[2], &quantity);
    
    customLog(@"Log revenue - $%f, %d, %@", price, quantity, productIdentifier);
    [[Amplitude instance] logRevenue:productIdentifier quantity:quantity price:[NSNumber numberWithDouble:price] receipt:receipt];
    
    return nil;
}

FREObject setUserProperties (FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    FREObject keyList = argv[0];
    uint32_t keyLength = 0;
    FREObject valueList = argv[1];
    if (keyList != nil) {
        if (FREGetArrayLength(keyList, &keyLength) != FRE_OK) {
            keyLength = 0;
        }
        
        for (int32_t i = keyLength-1; i >= 0; i--) {
            FREObject key;
            if (FREGetArrayElementAt(keyList, i, &key) != FRE_OK) {
                continue;
            }
                
            FREObject value;
            if (FREGetArrayElementAt(valueList, i, &value) != FRE_OK) {
                continue;
            }
                
            uint32_t stringLength;
            const uint8_t *keyString;
            if (FREGetObjectAsUTF8(key, &stringLength, &keyString) != FRE_OK) {
                continue;
            }
                
            const uint8_t *valueString;
            if (FREGetObjectAsUTF8(value, &stringLength, &valueString) != FRE_OK) {
                continue;
            }
            AMPIdentify *identify = [[AMPIdentify identify] set:[NSString stringWithUTF8String:(char*)keyString] value:[NSString stringWithUTF8String:(char*)valueString]];
            [[Amplitude instance] identify:identify];
            customLog(@"User set property - key: %@, value: %@", [NSString stringWithUTF8String:(char*)keyString], [NSString stringWithUTF8String:(char*)valueString]);
        }
    }
    return nil;
}



FREObject unsetUserProperties (FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    FREObject keyList = argv[0];
    uint32_t keyLength = 0;
    if (keyList != nil) {
        if (FREGetArrayLength(keyList, &keyLength) != FRE_OK) {
            keyLength = 0;
        }
        
        for (int32_t i = keyLength-1; i >= 0; i--) {
            FREObject key;
            if (FREGetArrayElementAt(keyList, i, &key) != FRE_OK) {
                continue;
            }
            
            uint32_t stringLength;
            const uint8_t *keyString;
            if (FREGetObjectAsUTF8(key, &stringLength, &keyString) != FRE_OK) {
                continue;
            }
            AMPIdentify *identify = [[AMPIdentify identify] unset:[NSString stringWithUTF8String:(char*)keyString]];
            [[Amplitude instance] identify:identify];
            customLog(@"User unset property - %@", [NSString stringWithUTF8String:(char*)keyString]);
        }
    }
    
    return nil;
}

FREObject setOnceUserProperties (FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    FREObject keyList = argv[0];
    uint32_t keyLength = 0;
    FREObject valueList = argv[1];
    if (keyList != nil) {
        if (FREGetArrayLength(keyList, &keyLength) != FRE_OK) {
            keyLength = 0;
        }
        
        for (int32_t i = keyLength-1; i >= 0; i--) {
            FREObject key;
            if (FREGetArrayElementAt(keyList, i, &key) != FRE_OK) {
                continue;
            }
            
            FREObject value;
            if (FREGetArrayElementAt(valueList, i, &value) != FRE_OK) {
                continue;
            }
            
            uint32_t stringLength;
            const uint8_t *keyString;
            if (FREGetObjectAsUTF8(key, &stringLength, &keyString) != FRE_OK) {
                continue;
            }
            
            const uint8_t *valueString;
            if (FREGetObjectAsUTF8(value, &stringLength, &valueString) != FRE_OK) {
                continue;
            }
            AMPIdentify *identify = [[AMPIdentify identify] setOnce:[NSString stringWithUTF8String:(char*)keyString] value:[NSString stringWithUTF8String:(char*)valueString]];
            [[Amplitude instance] identify:identify];
            customLog(@"User setOnce property - key: %@, value: %@", [NSString stringWithUTF8String:(char*)keyString], [NSString stringWithUTF8String:(char*)valueString]);
        }
    }
    
    return nil;
}

FREObject setOptOut (FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    uint32_t optOutActivated;
    if (FREGetObjectAsBool(argv[0], &optOutActivated) == FRE_OK) {
        [[Amplitude instance] setOptOut:optOutActivated];
        if(optOutActivated) {
            customLog(@"Opt-out: stopping all event and session logging");
        } else {
            customLog(@"Opt-in: re-enabling all event and session logging");
        }
    }
    return nil;
}

FREObject setSecondsBetweenSessions (FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    
    int32_t seconds = 0;
    if(FREGetObjectAsInt32(argv[0], &seconds) == FRE_OK) {
        [Amplitude instance].minTimeBetweenSessionsMillis = seconds * 1000;
        customLog(@"Changed max time between sessions to %d seconds", seconds);
    } else {
        customLog(@"ERROR - revenue price is not correct.");
    }
    return nil;
}

void AmplitudeANEContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx,uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) {
    NSInteger nbFunctionsToLink = 9;
    *numFunctionsToTest = nbFunctionsToLink;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * nbFunctionsToLink);
    
    func[0].name = (const uint8_t*) "initializeApiKey";
    func[0].functionData = NULL;
    func[0].function = &initializeApiKey;
    
    func[1].name = (const uint8_t*) "logAmplitudeEvent";
    func[1].functionData = NULL;
    func[1].function = &logAmplitudeEvent;
    
    func[2].name = (const uint8_t*) "setUserID";
    func[2].functionData = NULL;
    func[2].function = &setUserID;
    
    func[3].name = (const uint8_t*) "logRevenue";
    func[3].functionData = NULL;
    func[3].function = &logRevenue;
    
    func[4].name = (const uint8_t*) "setUserProperties";
    func[4].functionData = NULL;
    func[4].function = &setUserProperties;
    
    func[5].name = (const uint8_t*) "unsetUserProperties";
    func[5].functionData = NULL;
    func[5].function = &unsetUserProperties;
    
    func[6].name = (const uint8_t*) "setOnceUserProperties";
    func[6].functionData = NULL;
    func[6].function = &setOnceUserProperties;
    
    func[7].name = (const uint8_t*) "setOptOut";
    func[7].functionData = NULL;
    func[7].function = &setOptOut;
    
    func[8].name = (const uint8_t*) "setSecondsBetweenSessions";
    func[8].functionData = NULL;
    func[8].function = &setSecondsBetweenSessions;
    
    AmplitudeANECtx = ctx;
    
    *functionsToSet = func;
}

void AmplitudeANEContextFinalizer(FREContext ctx) {}

void AmplitudeANEInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet ) {
    *extDataToSet = NULL;
    *ctxInitializerToSet = &AmplitudeANEContextInitializer;
    *ctxFinalizerToSet = &AmplitudeANEContextFinalizer;
}

void AmplitudeANEFinalizer(void *extData) {}
