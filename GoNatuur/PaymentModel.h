//
//  PaymentModel.h
//  GoNatuur
//
//  Created by Ranosys on 19/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentModel : NSObject

//Card listing
@property (strong, nonatomic) NSMutableArray *cardListArray;
@property (strong, nonatomic) NSString *cardId;
@property (strong, nonatomic) NSString *subscriptionId;
@property (strong, nonatomic) NSString *firstname;
@property (strong, nonatomic) NSString *lastname;
@property (strong, nonatomic) NSString *postcode;
@property (strong, nonatomic) NSString *countryId;
@property (strong, nonatomic) NSString *regionId;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) NSString *street;
@property (strong, nonatomic) NSString *telephone;
@property (strong, nonatomic) NSString *cardExpMonth;
@property (strong, nonatomic) NSString *cardLastFourDigit;
@property (strong, nonatomic) NSString *cardType;
@property (strong, nonatomic) NSString *cardExpYear;

//Singleton instanse
+ (instancetype)sharedUser;

//Card listing data
- (void)getCardListing:(void (^)(PaymentModel *))success onfailure:(void (^)(NSError *))failure;
//Delete card
- (void)deleteCard:(void (^)(PaymentModel *))success onfailure:(void (^)(NSError *))failure;
@end
