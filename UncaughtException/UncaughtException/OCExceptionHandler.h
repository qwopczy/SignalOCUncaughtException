//
//  OCExceptionHandler.h
//  UncaughtException
//
//  Created by chenyi on 2020/7/23.
//  Copyright © 2020 chenyi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCExceptionHandler : NSObject

@end
void InstallUncaughtExceptionHandler(void);
NS_ASSUME_NONNULL_END
