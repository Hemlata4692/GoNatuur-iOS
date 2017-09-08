//
//  AddressListingCell.m
//  GoNatuur
//
//  Created by Monika on 9/4/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "AddressListingCell.h"
#import "DynamicHeightWidth.h"

@implementation AddressListingCell

#pragma mark - Cell life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

//Display profile data
- (void)displayData:(CGSize)rectSize {
    [_profileImageView setBorder:_profileImageView color:[UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1.0] borderWidth:3.0];
    [_profileImageView setCornerRadius:60.0];
    [ImageCaching downloadImages:_profileImageView imageUrl:[UserDefaultManager getValue:@"profilePicture"] placeholderImage:@"profile_placeholder" isDashboardCell:true];
    _emailLabel.text=[UserDefaultManager getValue:@"emailId"];
    _emailLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _emailLabel.numberOfLines=2;
    float newHeight =[DynamicHeightWidth getDynamicLabelHeight:_emailLabel.text font:[UIFont montserratSemiBoldWithSize:15] widthValue:rectSize.width-24 heightValue:60];
    _emailLabel.frame=CGRectMake(0, _emailLabel.frame.origin.y,[[UIScreen mainScreen] bounds].size.width-24, newHeight);
}

//Display address data
- (void)displayAddressData:(CGSize)rectSize addressData:(NSDictionary *)addressData {
    _addressLabel.text=NSLocalizedText(@"addressList");
    _userNameLabel.text = [NSString stringWithFormat:@"%@ %@",addressData[@"firstname"],addressData[@"lastname"]];
    _userNameLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _userNameLabel.numberOfLines=0;
    float newHeight =[DynamicHeightWidth getDynamicLabelHeight:_userNameLabel.text font:[UIFont montserratRegularWithSize:12] widthValue:rectSize.width-100 heightValue:500];
    NSString *addressType;
    if ([addressData[@"default_billing"]boolValue]==1 && [addressData[@"default_shipping"]boolValue]==1) {
        addressType = NSLocalizedText(@"bothAddressSelected");
    } else if ([addressData[@"default_shipping"]boolValue]==1) {
        addressType = NSLocalizedText(@"shippingAddress");
    } else if ([addressData[@"default_billing"]boolValue]==1) {
        addressType = NSLocalizedText(@"billingAddress");
    } else {
        addressType = @"";
    }
    _addressTypeLabel.translatesAutoresizingMaskIntoConstraints=YES;
    if ([addressType isEqualToString:@""]) {
        _addressTypeLabel.hidden = YES;
        _addressTypeLabel.frame=CGRectMake(15,5,rectSize.width-100, 0);
        _userNameLabel.frame=CGRectMake(15, 10,rectSize.width-100, newHeight);
    } else {
        _addressTypeLabel.text = addressType;
        _addressTypeLabel.hidden = NO;
        _addressTypeLabel.frame=CGRectMake(15, 10,rectSize.width-100, 20);
        _userNameLabel.frame=CGRectMake(15, _addressTypeLabel.frame.origin.y+_addressTypeLabel.frame.size.height +5,rectSize.width-100, newHeight);
    }
    NSString *streetString = [addressData[@"street"] componentsJoinedByString:@" "];
    _addressLabel.text = streetString;
    _addressLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _addressLabel.numberOfLines=0;
    float addressHeight =[DynamicHeightWidth getDynamicLabelHeight:_addressLabel.text font:[UIFont montserratRegularWithSize:12] widthValue:rectSize.width-100 heightValue:500];
    _addressLabel.frame=CGRectMake(15, _userNameLabel.frame.origin.y+_userNameLabel.frame.size.height +5,rectSize.width-100, addressHeight);
    _secondAddressLabel.text = [NSString stringWithFormat:@"%@ - %@, %@",addressData[@"city"],addressData[@"postcode"],[[addressData objectForKey:@"region"]objectForKey:@"region"]];
    _secondAddressLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _secondAddressLabel.numberOfLines=0;
    float secondAddressHeight =[DynamicHeightWidth getDynamicLabelHeight:_addressLabel.text font:[UIFont montserratRegularWithSize:12] widthValue:rectSize.width-100 heightValue:500];
    _secondAddressLabel.frame=CGRectMake(15, _addressLabel.frame.origin.y+_addressLabel.frame.size.height +5,rectSize.width-100, secondAddressHeight);
    _phoneNumberLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _phoneNumberLabel.numberOfLines=0;
    _phoneNumberLabel.text =  [NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%@",NSLocalizedText(@"phoneText")],addressData[@"telephone"]];
    float phoneNumberHeight =[DynamicHeightWidth getDynamicLabelHeight:_phoneNumberLabel.text font:[UIFont montserratRegularWithSize:12] widthValue:rectSize.width-100 heightValue:500];
    _phoneNumberLabel.frame=CGRectMake(15, _secondAddressLabel.frame.origin.y+_secondAddressLabel.frame.size.height +2,rectSize.width-100, phoneNumberHeight);
}
#pragma mark - end
@end
