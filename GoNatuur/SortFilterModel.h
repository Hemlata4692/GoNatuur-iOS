//
//  SortFilterModel.h
//  GoNatuur
//
//  Created by Monika on 21/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SortFilterModel : NSObject

@property (strong, nonatomic) NSString *requestValues;
@property (strong, nonatomic) NSString *ascValue;
@property (strong, nonatomic) NSString *descValue;
@property (strong, nonatomic) NSString *attributeValue;
@property (strong, nonatomic) NSMutableArray *sortArray;
@property (strong, nonatomic) NSMutableArray *filterOptionsArray;
@property (strong, nonatomic) NSString *filterCountry;
@property (strong, nonatomic) NSString *filterCountryValue;
@property (strong, nonatomic) NSString *filterLabelValue;
@property (strong, nonatomic) NSString *filterAttributeCode;
@property (strong, nonatomic) NSMutableArray *filterArray;

+ (instancetype)sharedUser;

- (void)getSortData:(void (^)(SortFilterModel *))success onfailure:(void (^)(NSError *))failure;
- (void)getFilterServiceData:(void (^)(SortFilterModel *))success onfailure:(void (^)(NSError *))failure;
@end
