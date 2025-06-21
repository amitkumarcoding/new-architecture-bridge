//
//  NativeMessageModule.mm
//  newArchitectureBridge
//
//  Created by Amit Kumar on 21/06/25.
//

#import "NativeMessageModule.h"

@implementation NativeMessageModule {
  BOOL hasListeners;
}

RCT_EXPORT_MODULE();

+ (BOOL)requiresMainQueueSetup {
  return YES;
}

- (NSArray<NSString *> *)supportedEvents {
  return @[@"onTimerTick"];
}

// Called when the first JS listener is added
- (void)startObserving {
  hasListeners = YES;
}

// Called when the last JS listener is removed
- (void)stopObserving {
  hasListeners = NO;
}

RCT_EXPORT_METHOD(sendMessage:(NSString *)message) {
  NSLog(@"[iOS] Received from JS: %@", message);
}

RCT_EXPORT_METHOD(getMessage:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  NSString *response = @"Hello from iOS";
  NSLog(@"[iOS] Returning to JS (Promise): %@", response);
  resolve(response);
}

RCT_EXPORT_METHOD(sendWithCallback:(RCTResponseSenderBlock)callback) {
  NSString *response = @"Hello from iOS";
  NSLog(@"[iOS] Returning to JS (Callback): %@", response);
  callback(@[response]);
}

RCT_EXPORT_METHOD(startSendingEvents) {
  if (!hasListeners) {
    NSLog(@"[iOS] No listeners, not sending events");
    return;
  }

  for (int i = 1; i <= 8; i++) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
      if (!hasListeners) return;
      NSString *msg = [NSString stringWithFormat:@"Event at %f", [[NSDate date] timeIntervalSince1970]];
      [self sendEventWithName:@"onTimerTick" body:@{@"message": msg}];
    });
  }
}

@end
