//
//  ConstantCode.m
//  CustomProductListBar
//
//  Created by Ranosys on 03/08/17.
//  Copyright © 2017 Apple. All rights reserved.
//

#import "ConstantCode.h"

@implementation ConstantCode

NSString * const iOS_Version = @"10.0";
NSString * const loginNewUserText = @"If you are a new uesr, you can Register an account with us and start shopping with GoPurpose.";
NSString * const privacyPolicyText = @"By signing up, you agree to our terms & conditions and privacy policy. If you already have an account, Log In here";
NSString * const alertTitle = @"Alert";
NSString * const alertOk = @"OK";
NSString * const emptyFieldMessage = @"Please fill in all the required fields.";
NSString * const validEmailMessage = @"Please fill in all the required fields.";
NSString * const passwordMatchMessage = @"Password does't match.";
NSString * const somethingWrondMessage = @"Some thing went wrong, Please try again later.";

//Check device type
+ (ConstantType)checkDeviceType {
    switch ((int)[[UIScreen mainScreen] bounds].size.height) {
        case 568:
            return Device5s;
            break;
        case 667:
            return Device6;
            break;
        default:
            return Device7Plus;
    }
}

//Get country code
+ (NSString *)localeCountryCode {

    NSLocale *countryLocale = [NSLocale currentLocale];
    return [countryLocale objectForKey:NSLocaleCountryCode];
}
@end
