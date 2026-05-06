#if __has_include("AppDelegate.h")
    #import "AppDelegate.h"
#else
    #if __has_include(<Cordova/AppDelegate.h>)
        #import <Cordova/AppDelegate.h>
    #endif
#endif

@interface AppDelegate (OSFirebaseCloudMessaging) <UIApplicationDelegate>
@end
