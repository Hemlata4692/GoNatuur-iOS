//
//  ShareDataService.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 19/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ShareDataService.h"
#import "ShareDataModel.h"

@implementation ShareDataService

static NSString *kShareData=@"socailsharing/product/share/?";//http://192.121.166.226:81/gopurpose/en/socailsharing/product/share/?

#pragma mark - Share service
- (void)shareDataService:(ShareDataModel *)shareData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"url":shareData.deeplinkURL,@"media":shareData.imageURL,@"name":shareData.name,@"description":shareData.productDescription};
    NSLog(@"share product request %@",parameters);
    [super getSearchData:kShareData parameters:parameters onSuccess:success onFailure:failure];
}
#pragma mark - end

@end
