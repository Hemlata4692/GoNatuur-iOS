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
//NSString * const BaseUrl = @"http://192.121.166.226/gopurpose/";
NSString * const productImageBaseUrl = @"media/catalog/category";
NSString * const productDetailImageBaseUrl = @"media/catalog/product";
NSString * const eventIdentifier = @"ticket";

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
    [numberFormatter setPositiveFormat:@",##,###.00"];
    numberFormatter.numberStyle = kCFNumberFormatterDecimalStyle;
    NSString *numberString = [numberFormatter stringFromNumber:@(number)];
    return  numberString;
}
@end
