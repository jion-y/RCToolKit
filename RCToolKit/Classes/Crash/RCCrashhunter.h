//
//  RCCrashhunter.h
//  RCToolKit
//
//  Created by yoyo on 2022/9/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCCrashhunter : NSObject
+ (NSArray *)backtrace;
+ (instancetype)share;
- (void)start:(void(^)(NSString *))callBack;
@end

NS_ASSUME_NONNULL_END
