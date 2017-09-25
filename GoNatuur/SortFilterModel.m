//
//  SortFilterModel.m
//  GoNatuur
//
//  Created by Monika on 21/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "SortFilterModel.h"
#import "ConnectionManager.h"

@implementation SortFilterModel

#pragma mark - Shared instance
+ (instancetype)sharedUser {
    static SortFilterModel *userData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userData = [[[self class] alloc] init];
    });
    return userData;
}
#pragma mark - end

#pragma mark - Sorting
- (void)getSortData:(void (^)(SortFilterModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getSortData:self onSuccess:^(SortFilterModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
    }];
}
#pragma mark - end

@end
