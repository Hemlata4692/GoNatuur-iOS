//
//  ShareViewController.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 12/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewController : GoNatuurViewController
@property(nonatomic, strong) NSString *shareURL;
@property(nonatomic, strong) NSString *mediaURL;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *productDescription;
@property(nonatomic, strong) NSString *shareType;
@end
