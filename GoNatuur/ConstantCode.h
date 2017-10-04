//
//  ConstantCode.h
//  CustomProductListBar
//
//  Created by Ranosys on 03/08/17.
//  Copyright © 2017 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kCellsPerRow 3
#define kProductCellsPerRow 2

typedef NS_ENUM (NSInteger, ConstantType) {
    SignUp,
    FacebookLogin,
    WeChatLogin,
    WeiboLogin,
    GoogleLogin,
    Device5s,
    Device6,
    Device7Plus
};

@interface ConstantCode : NSObject
//Set constant values
extern NSString * const iOS_Version;
extern NSString * const BaseUrl;
extern NSString * const productImageBaseUrl;
extern NSString * const productDetailImageBaseUrl;
extern NSString * const eventIdentifier;
extern NSString * const zopimTicketAppId;
extern NSString * const zopimAppId;
extern NSString * const zopimURL;
extern NSString * const zopimClientId;
extern NSString * const ASC;
extern NSString * const DESC;

extern NSString * const dateFormatterService;
extern NSString * const dateFormatterConverted;
extern NSString * const dateFormatterDate;
//end

+ (ConstantType)checkDeviceType;
+ (NSString *)localeCountryCode;
+ (NSString *)decimalFormatter:(double)number;
@end
