//
//  ShareDataModel.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 19/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareDataModel : NSObject
@property (strong, nonatomic) NSString *deeplinkURL;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *productDescription;

+ (instancetype)sharedUser;

- (void)getShareDataWebView:(void (^)(ShareDataModel *))success onfailure:(void (^)(NSError *))failure;
@end
