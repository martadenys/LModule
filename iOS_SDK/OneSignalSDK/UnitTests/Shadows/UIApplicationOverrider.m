/**
 * Modified MIT License
 *
 * Copyright 2017 OneSignal
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * 1. The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * 2. All copies of substantial portions of the Software may only be used in connection
 * with services provided by OneSignal.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "UIApplicationOverrider.h"

#import "OneSignalSelectorHelpers.h"

#import "UNUserNotificationCenterOverrider.h"

@implementation UIApplicationOverrider

static BOOL calledRegisterForRemoteNotifications;
static BOOL calledCurrentUserNotificationSettings;

static NSInteger didFailRegistarationErrorCode;
static BOOL shouldFireDeviceToken;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
static UIApplicationState currentUIApplicationState;

static UILocalNotification* lastUILocalNotification;

static UIUserNotificationSettings* lastUIUserNotificationSettings;
#pragma clang diagnostic pop
static BOOL pendingRegisterBlock;

//mimics no response from APNS
static BOOL blockApnsResponse;

static NSURL* lastOpenedUrl;

static int apnsTokenLength = 32;

static UIApplication *sharedApplication;

+ (void)load {
    injectSelector(
        [UIApplication class],
        @selector(registerForRemoteNotifications),
        [UIApplicationOverrider class],
        @selector(overrideRegisterForRemoteNotifications)
    );
    injectSelector(
        [UIApplication class],
        @selector(currentUserNotificationSettings),
        [UIApplicationOverrider class],
        @selector(overrideCurrentUserNotificationSettings)
    );
    injectSelector(
        [UIApplication class],
        @selector(registerForRemoteNotificationTypes:),
        [UIApplicationOverrider class],
        @selector(overrideRegisterForRemoteNotificationTypes:)
    );
    injectSelector(
        [UIApplication class],
        @selector(registerUserNotificationSettings:),
        [UIApplicationOverrider class],
        @selector(overrideRegisterUserNotificationSettings:)
    );
    injectSelector(
        [UIApplication class],
        @selector(applicationState),
        [UIApplicationOverrider class],
        @selector(overrideApplicationState)
    );
    injectSelector(
        [UIApplication class],
        @selector(scheduleLocalNotification:),
        [UIApplicationOverrider class],
        @selector(overrideScheduleLocalNotification:)
    );
    injectSelector(
        [UIApplication class],
        @selector(openURL:options:completionHandler:),
        [UIApplicationOverrider class],
        @selector(overrideOpenURL:options:completionHandler:)
   );
}

+ (void)reset {
    blockApnsResponse = false;
    lastUILocalNotification = nil;
    pendingRegisterBlock = false;
    shouldFireDeviceToken = true;
    calledRegisterForRemoteNotifications = false;
    calledCurrentUserNotificationSettings = false;
    didFailRegistarationErrorCode = 0;
    currentUIApplicationState = UIApplicationStateActive;
    lastUIUserNotificationSettings = nil;
    apnsTokenLength = 32;
}

+ (void)setCurrentUIApplicationState:(UIApplicationState)value {
    currentUIApplicationState = value;
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
+ (UILocalNotification*)lastUILocalNotification {
    return lastUILocalNotification;
}
#pragma clang diagnostic pop
+ (BOOL)calledRegisterForRemoteNotifications {
    return calledRegisterForRemoteNotifications;
}
+ (BOOL)calledCurrentUserNotificationSettings {
    return calledCurrentUserNotificationSettings;
}

+ (void)setDidFailRegistarationErrorCode:(NSInteger)value {
    didFailRegistarationErrorCode = value;
}

+ (void)setBlockApnsResponse:(BOOL)block {
    blockApnsResponse = block;
}

+ (void)setAPNSTokenLength:(int)tokenLength {
    apnsTokenLength = tokenLength;
}

+ (NSString*)mockAPNSToken {
    NSMutableString *token = [NSMutableString new];

    for (int i = 0; i < apnsTokenLength * 2; i++)
        [token appendString:@"0"];

    return token;
}

// Keeps UIApplicationMain(...) from looping to continue to the next line.
- (void)override_run {
    NSLog(@"override_run!!!!!!");
}

+ (void)helperCallDidRegisterForRemoteNotificationsWithDeviceToken {
    dispatch_async(dispatch_get_main_queue(), ^{
        id app = [UIApplication sharedApplication];
        id appDelegate = [[UIApplication sharedApplication] delegate];
        
        if (didFailRegistarationErrorCode) {
            id error = [NSError errorWithDomain:@"any" code:didFailRegistarationErrorCode userInfo:nil];
            [appDelegate application:app didFailToRegisterForRemoteNotificationsWithError:error];
            return;
        }
        
        if (!shouldFireDeviceToken)
            return;
        
        pendingRegisterBlock = true;
    });
}

+ (UIApplication *)override_shared {
    if (!sharedApplication) {
        sharedApplication = [UIApplication new];
    }
    return sharedApplication;
}

// callPendingApplicationDidRegisterForRemoteNotificaitonsWithDeviceToken
+ (void)runBackgroundThreads {
    if (!pendingRegisterBlock || currentUIApplicationState != UIApplicationStateActive || blockApnsResponse)
        return;
    pendingRegisterBlock = false;
    
    id app = [UIApplication sharedApplication];
    id appDelegate = [[UIApplication sharedApplication] delegate];
    
    char bytes[apnsTokenLength];
    memset(bytes, 0, apnsTokenLength);
    id deviceToken = [NSData dataWithBytes:bytes length:apnsTokenLength];
    [appDelegate application:app didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)overrideRegisterForRemoteNotifications {
    calledRegisterForRemoteNotifications = true;
    [UIApplicationOverrider helperCallDidRegisterForRemoteNotificationsWithDeviceToken];
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
- (void)overrideRegisterForRemoteNotificationTypes: (UIUserNotificationType) types {
    //empty
}

// iOS 9 Only
- (UIUserNotificationSettings*) overrideCurrentUserNotificationSettings {
    calledCurrentUserNotificationSettings = true;
    
    // Check for this as it will create thread locks on a real device.
    [UNUserNotificationCenterOverrider failIfInNotificationSettingsWithCompletionHandler];
    
    return [UIUserNotificationSettings
            settingsForTypes:UNUserNotificationCenterOverrider.notifTypesOverride
            categories:lastUIUserNotificationSettings.categories];
}

// KEEP - Used to prevent xctest from fowarding to the iOS 10 equivalent.
- (void)overrideRegisterUserNotificationSettings:(UIUserNotificationSettings*)notificationSettings {
    lastUIUserNotificationSettings = notificationSettings;
}

- (UIApplicationState)overrideApplicationState {
    return currentUIApplicationState;
}

- (void)overrideScheduleLocalNotification:(UILocalNotification*)notification {
    lastUILocalNotification = notification;
}
#pragma clang diagnostic pop
- (void)overrideOpenURL:(NSURL*)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options completionHandler:(void (^ __nullable)(BOOL success))completion {
    lastOpenedUrl = url;
}

+ (NSURL*)lastOpenedUrl {
    return lastOpenedUrl;
}

@end
