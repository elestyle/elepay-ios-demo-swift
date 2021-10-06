//
//  ElepayWXPayModule.h
//  Elepay-ChinesePayments-Plugin
//
//  Created by xuzhe on 2020/01/19.
//  Copyright © 2020 ELESTYLE, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*! @brief 错误码
 *
 */
enum  ElepayWXErrCode: NSInteger {
    ElepayWXSuccess         = 0,    /**< 成功*/
    ElepayWXErrCodeOther    = -1,   /**< 普通错误类型*/
    ElepayWXCancel          = -2,   /**< 用户点击取消并返回*/
};

@interface ElepayWXPayModule : NSObject

+ (instancetype)shared;

+ (BOOL)isWXAppInstalled;
+ (BOOL)isWXAppSupportAPI;

+ (BOOL)registerWXApp:(NSString *)appid universalLink:(NSString *)universalLink;
+ (BOOL)handleWXOpenURL:(NSURL *)url;
+ (BOOL)handleWXOpenUniversalLink:(NSUserActivity *)userActivity;
- (void)makeWXPayment:(NSDictionary *)params callback:(void(^)(enum ElepayWXErrCode errCode, NSString *errMessage))onResult;

@end

NS_ASSUME_NONNULL_END
