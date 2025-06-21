//
//  NativeMessageModule.h
//  newArchitectureBridge
//
//  Created by Amit Kumar on 21/06/25.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

NS_ASSUME_NONNULL_BEGIN

@interface NativeMessageModule : RCTEventEmitter <RCTBridgeModule>

@end

NS_ASSUME_NONNULL_END
