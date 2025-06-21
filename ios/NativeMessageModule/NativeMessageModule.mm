//
//  NativeMessageModule.mm
//  newArchitectureBridge
//
//  Created by Amit Kumar on 21/06/25.
//

#import "NativeMessageModule.h"
#import <React-Codegen/NativeMessageModule.h>

@implementation NativeMessageModule {
  BOOL hasListeners;
}

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

- (void)sendMessage:(NSString *)message {
  NSLog(@"[iOS] Received from JS: %@", message);
}

- (void)getMessage:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject {
  NSString *response = @"Hello from iOS";
  NSLog(@"[iOS] Returning to JS (Promise): %@", response);
  resolve(response);
}

- (void)sendWithCallback:(RCTResponseSenderBlock)callback {
  NSString *response = @"Hello from iOS";
  NSLog(@"[iOS] Returning to JS (Callback): %@", response);
  callback(@[response]);
}

- (void)startSendingEvents {
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

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeMessageModuleSpecJSI>(params);
}

@end
