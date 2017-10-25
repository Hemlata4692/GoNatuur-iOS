//
//  AddressListingCell.h
//  GoNatuur
//
//  Created by Monika on 9/4/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileModel.h"

@interface AddressListingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressListLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *editAddressButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteAddressButton;
@property (weak, nonatomic) IBOutlet UIButton *editProfileImageButton;
@property (weak, nonatomic) IBOutlet UIButton *defaultEditAddress;
@property (weak, nonatomic) IBOutlet UILabel *listingSeparatorLabel;

- (void)displayData:(CGSize)rectSize;
- (void)displayAddressData:(CGSize)rectSize addressData:(NSDictionary *)addressData;
@end
