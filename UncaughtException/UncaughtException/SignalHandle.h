//
//  SignalHandle.h
//  UncaughtException
//
//  Created by chenyi on 2020/7/23.
//  Copyright © 2020 chenyi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignalHandle : NSObject
+(void)saveCreash:(NSString *)exceptionInfo;
@end
void InstallSignalHandler(void);
NS_ASSUME_NONNULL_END
