//
//  ConstantCode.m
//  CustomProductListBar
//
//  Created by Ranosys on 03/08/17.
//  Copyright © 2017 Apple. All rights reserved.
//

#import "ConstantCode.h"

@implementation ConstantCode


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
