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
NSString * const BaseUrl = @"http://dev.gonatuur.com/";
NSString * const productImageBaseUrl = @"media/catalog/category";
NSString * const productDetailImageBaseUrl = @"media/catalog/product";
NSString * const eventIdentifier = @"ticket";
NSString * const zopimTicketAppId = @"e5dd7520b178e21212f5cc2751a28f4b5a7dc76698dc79bd";
NSString * const zopimAppId = @"54S60ESovtSg9glT9nUunk1oc7YKGWoi";
NSString * const zopimURL = @"https://rememberthedate.zendesk.com";
NSString * const zopimClientId = @"client_for_rtd_jwt_endpoint";

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
}@end
