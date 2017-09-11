//
//  AddressViewController.h
//  GoNatuur
//
//  Created by Monika on 8/30/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileModel.h"
#import "AddressListingViewController.h"
#import "CheckoutAddressViewController.h"

@interface AddressViewController : GoNatuurViewController
@property(nonatomic,strong)AddressListingViewController *addressListView;
@property(nonatomic,strong)ProfileModel *profileData;
@property(nonatomic)BOOL isEditScreen;
@property(nonatomic)NSNumber *addressIndex;
@property(nonatomic,strong)CheckoutAddressViewController *checkoutAddressViewObj;
@end
