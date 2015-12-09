#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"
#import "Amplitude.h"

@interface AmplitudeANE : NSObject
@end

void customLog (NSString *format, ...);
FREObject initializeApiKey (FREContext context, void* functionData, uint32_t argc, FREObject argv[]);
FREObject logAmplitudeEvent (FREContext context, void* functionData, uint32_t argc, FREObject argv[]);
FREObject setUserID (FREContext context, void* functionData, uint32_t argc, FREObject argv[]);
FREObject logRevenue (FREContext context, void* functionData, uint32_t argc, FREObject argv[]);
FREObject setUserProperties (FREContext context, void* functionData, uint32_t argc, FREObject argv[]);
FREObject unsetUserProperties (FREContext context, void* functionData, uint32_t argc, FREObject argv[]);
FREObject setOnceUserProperties (FREContext context, void* functionData, uint32_t argc, FREObject argv[]);
FREObject setOptOut (FREContext context, void* functionData, uint32_t argc, FREObject argv[]);
FREObject setSecondsBetweenSessions (FREContext context, void* functionData, uint32_t argc, FREObject argv[]);



void AmplitudeANEContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet);
void AmplitudeANEContextFinalizer(FREContext ctx);
void AmplitudeANEInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet );
void AmplitudeANEFinalizer(void *extData);