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
//end

+ (ConstantType)checkDeviceType;
+ (NSString *)localeCountryCode;
@end
