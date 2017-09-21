//
//  ShareDataService.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 19/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShareDataModel;

@interface ShareDataService : Webservice
//Share data
- (void)shareDataService:(ShareDataModel *)profileData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure ;
@end
