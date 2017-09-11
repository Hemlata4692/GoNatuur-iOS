//
//  OrderListingCell.m
//  GoNatuur
//
//  Created by Monika on 9/8/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "OrderListingCell.h"
#import "DynamicHeightWidth.h"
#import "CurrencyDataModel.h"

@implementation OrderListingCell

#pragma mark - Cell life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)displayData:(CGSize)rectSize {
    [_trackShippingButton setCornerRadius:17.0];
    [_trackShippingButton addShadow:_trackShippingButton color:[UIColor blackColor]];
    [_userProfileImage setBorder:_userProfileImage color:[UIColor colorWithRed:138.0/255.0 green:28.0/255.0 blue:53.0/255.0 alpha:1.0] borderWidth:3.0];
    _totalPointsHeadingLabel.text=NSLocalizedText(@"totalPoints");
    _recentlyEarnedHeadingLabel.text=NSLocalizedText(@"recentEarned");
    [_trackShippingButton setTitle:NSLocalizedText(@"trackShippingTitle") forState:UIControlStateNormal];
    
    _totalPointsLabel.attributedText=[self setAttributesText:[NSString stringWithFormat:@"%@ip",[UserDefaultManager getValue:@"TotalPoints"]]];
    _recentlyEarnedLabel.attributedText=[self setAttributesText:[NSString stringWithFormat:@"%@ip",[UserDefaultManager getValue:@"RecentEarned"]]];
    
    [_userProfileImage setBorder:_userProfileImage color:[UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1.0] borderWidth:3.0];
    [_userProfileImage setCornerRadius:60.0];
    [ImageCaching downloadImages:_userProfileImage imageUrl:[UserDefaultManager getValue:@"profilePicture"] placeholderImage:@"profile_placeholder" isDashboardCell:true];
    _userEmailLabel.text=[UserDefaultManager getValue:@"emailId"];
    _userEmailLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _userEmailLabel.numberOfLines=2;
    float newHeight =[DynamicHeightWidth getDynamicLabelHeight:_userEmailLabel.text font:[UIFont montserratSemiBoldWithSize:15] widthValue:rectSize.width-24 heightValue:60];
    _userEmailLabel.frame=CGRectMake(0, _userEmailLabel.frame.origin.y,[[UIScreen mainScreen] bounds].size.width-24, newHeight);
}

- (void)displayOrderData:(CGSize)rectSize orderData:(OrderModel *)orderData {
    [self setHeadingData];
    //    [self removeAutolayouts];
    //    _shippingAddressLabel.text = orderData.shippingAddress;
    //    _shippingAddressLabel.numberOfLines=0;
    //    float height =[DynamicHeightWidth getDynamicLabelHeight:_shippingAddressLabel.text font:[UIFont montserratRegularWithSize:12] widthValue:rectSize.width-100 heightValue:50];
    //    _shippingAddressLabel.frame=CGRectMake(15, 10,rectSize.width-130, height);
    //    _shippingAddressLabel.backgroundColor = [UIColor redColor];
    
    if ((nil==orderData.shippingAddress)||[orderData.shippingAddress isEqualToString:@""]) {
        _shippingAddressLabel.text = NSLocalizedText(@"dataNotAdded");
    } else {
        _shippingAddressLabel.text = orderData.shippingAddress;
    }
    if ((nil==orderData.BillingAddress)||[orderData.BillingAddress isEqualToString:@""]) {
        _billingAddressLabel.text = NSLocalizedText(@"dataNotAdded");
    } else {
        _billingAddressLabel.text = orderData.BillingAddress;
    }
    _orderStatusLabel.text = orderData.orderStatus;
    _priceLabel.text = [NSString stringWithFormat:@"%@",orderData.orderPrice];
    
    NSMutableArray *ratesArray=[NSMutableArray new];
    for (int i =0; i<[[UserDefaultManager getValue:@"availableCurrencyRatesArray"] count]; i++) {
        NSDictionary * footerDataDict =[[UserDefaultManager getValue:@"availableCurrencyRatesArray"] objectAtIndex:i];
        CurrencyDataModel * exchangeData = [[CurrencyDataModel alloc]init];
        exchangeData.currencyExchangeCode = footerDataDict[@"currency_to"];
        exchangeData.currencyExchangeRates = footerDataDict[@"rate"];
        exchangeData.currencysymbol = footerDataDict[@"currency_symbol"];
        [ratesArray addObject:exchangeData];
    }
    for (int i=0; i<ratesArray.count; i++) {
        if ([orderData.currencyCode containsString:[[ratesArray objectAtIndex:i] currencyExchangeCode]]) {
            //            [UserDefaultManager setValue:[[ratesArray objectAtIndex:i] currencyExchangeRates] key:@"ExchangeRates"];
            if ([[[ratesArray objectAtIndex:i] currencysymbol] isEqualToString:@""] || [[ratesArray objectAtIndex:i] currencysymbol]==nil) {
                _priceLabel.text = [NSString stringWithFormat:@"%@ %@",[[UserDefaultManager getValue:@"DefaultCurrencyCode"] currencysymbol],orderData.orderPrice];
            }
            else {
                _priceLabel.text = [NSString stringWithFormat:@"%@ %@",[[ratesArray objectAtIndex:i] currencysymbol],orderData.orderPrice];
            }
        }
    }
}

- (void)setHeadingData {
    _shippingAddressHeadingLabel.text = NSLocalizedText(@"shipHeading");
    _billingAddressHeadingLabel.text = NSLocalizedText(@"billHeading");
    _orderStatusLabel.text = NSLocalizedText(@"statusHeading");
    _priceHeadingLabel.text = NSLocalizedText(@"priceHeading");
}

- (void)removeAutolayouts {
    _shippingAddressLabel.translatesAutoresizingMaskIntoConstraints=YES;
    //    _orderStatusLabel.translatesAutoresizingMaskIntoConstraints=YES;
    //    _shippingAddressLabel.translatesAutoresizingMaskIntoConstraints=YES;
    //    _shippingAddressLabel.translatesAutoresizingMaskIntoConstraints=YES;
}

//set attributed string
- (NSAttributedString *)setAttributesText:(NSString *)labelText {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:labelText];
    NSRange registerTextRange = [labelText rangeOfString:@"ip"];
    [string setAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName: [UIFont montserratRegularWithSize:14]} range:registerTextRange];
    return string;
}

#pragma mark - end

@end
