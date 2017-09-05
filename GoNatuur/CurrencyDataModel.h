//
//  CurrencyDataModel.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 14/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrencyDataModel : NSObject
@property (strong, nonatomic) NSString *userCurrency;
@property (strong, nonatomic) NSMutableArray *availableCurrencyRatesArray;
@property (strong, nonatomic) NSMutableArray *availableCurrencyArray;
@property (strong, nonatomic) NSString *currentCurrencyCode;
@property (strong, nonatomic) NSString *currencyExchangeRates;
@property (strong, nonatomic) NSString *currencyExchangeCode;
@property (strong, nonatomic) NSString *currencysymbol;

//Singleton method
+ (instancetype)sharedUser;

//Fetch currency data
- (void)getCurrencyData:(void (^)(CurrencyDataModel *))success onfailure:(void (^)(NSError *))failure;
@end
