//
//  ProductGuideService.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 14/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProductGuideDataModel;

@interface ProductGuideService : Webservice

- (void)getGuideCategoryService:(ProductGuideDataModel *)profileData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure;

- (void)getGuideCategoryDetailsService:(ProductGuideDataModel *)profileData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure;
@end
