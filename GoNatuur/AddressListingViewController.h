//
//  AddressListingViewController.h
//  GoNatuur
//
//  Created by Monika on 9/4/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileModel.h"
#import "CheckoutAddressViewController.h"

@interface AddressListingViewController : GoNatuurViewController
@property(nonatomic,strong)ProfileModel *profileData;
@property(nonatomic,strong)CheckoutAddressViewController *checkoutAddressViewObj;
@end
