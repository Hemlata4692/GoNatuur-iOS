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
//Client
//NSString * const BaseUrl = @"http://dev.gonatuur.com/";
//Beta
NSString * const BaseUrl = @"http://192.121.166.226:81/gopurpose/";
NSString * const productImageBaseUrl = @"pub/media/catalog/category";//remove pub when using in live
NSString * const productDetailImageBaseUrl = @"pub/media/catalog/product";//remove pub when using in live
NSString * const eventIdentifier = @"ticket";
NSString * const payPalClientId = @"AZR_diRWoS3qEWpUDyI6_K6iRHjKkOMwC93488tbFjugQIxL6OLjg6ces1FwsnR8Bv6F107if32vofmP";
NSString * const zopimTicketAppId = @"e5dd7520b178e21212f5cc2751a28f4b5a7dc76698dc79bd";
NSString * const zopimAppId = @"571Xf6PB7wWOhtIJHbTNXjMLHk8A0Qzk";
NSString * const zopimURL = @"https://rememberthedate.zendesk.com";
NSString * const zopimClientId = @"client_for_rtd_jwt_endpoint";
NSString * const dateFormatterService=@"MM/yyyy";
NSString * const dateFormatterConverted=@"MMMM yyyy";
NSString * const dateFormatterDate=@"dd/MM/yyyy";

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

+ (NSString *)decimalFormatter:(double)number {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.maximumFractionDigits = 2;
    if (number==0) {
       [numberFormatter setPositiveFormat:@"0.00"];
    }
    else {
    [numberFormatter setPositiveFormat:@",##,###.00"];
    }
    numberFormatter.numberStyle = kCFNumberFormatterDecimalStyle;
    NSString *numberString = [numberFormatter stringFromNumber:@(number)];
    return  numberString;
}
@end
