//
//  CurrencyDataModel.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 14/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "CurrencyDataModel.h"
#import "ConnectionManager.h"

@implementation CurrencyDataModel
@synthesize userCurrency;
@synthesize availableCurrencyArray;
@synthesize availableCurrencyRatesArray;
@synthesize currentCurrencyCode;
@synthesize currencyExchangeRates;
@synthesize currencyExchangeCode;
@synthesize currencysymbol;

#pragma mark - Shared instance
+ (instancetype)sharedUser{
    static CurrencyDataModel *currencyData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currencyData = [[[self class] alloc] init];
    });
    
    return currencyData;
}
#pragma mark - end

#pragma mark - Get currency data
- (void)getCurrencyData:(void (^)(CurrencyDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getDefaultCurrency:self onSuccess:^(CurrencyDataModel *userData) {
        if (success) {
            [UserDefaultManager setValue:userData.currentCurrencyCode key:@"DefaultCurrencyCode"];
            [UserDefaultManager setValue:userData.availableCurrencyArray key:@"AvailableCurrencyCodes"];
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

@end
