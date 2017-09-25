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
@property (nonatomic) long selectedValue;
@property (strong, nonatomic) NSString *sortBasis;
@property (strong, nonatomic) NSMutableArray *sortArray;

+ (instancetype)sharedUser;

- (void)getSortData:(void (^)(SortFilterModel *))success onfailure:(void (^)(NSError *))failure;

@end
