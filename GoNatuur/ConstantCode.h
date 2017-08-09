//
//  ConstantCode.h
//  CustomProductListBar
//
//  Created by Ranosys on 03/08/17.
//  Copyright © 2017 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, ConstantType){
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
extern NSString * const privacyPolicyText;
extern NSString * const loginNewUserText;
extern NSString * const alertTitle;
extern NSString * const alertOk;
extern NSString * const emptyFieldMessage;
extern NSString * const validEmailMessage;
extern NSString * const passwordMatchMessage;
extern NSString * const somethingWrondMessage;
//end

+ (ConstantType)checkDeviceType;
+ (NSString *)localeCountryCode;
@end
