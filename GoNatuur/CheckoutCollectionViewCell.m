//
//  CheckoutCollectionViewCell.m
//  GoNatuur
//
//  Created by Ranosys on 11/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "CheckoutCollectionViewCell.h"
#define selectedStepColor   [UIColor blackColor]
#define unSelectedStepColor [UIColor lightGrayColor]

@implementation CheckoutCollectionViewCell

- (void)displayPromoData:(NSDictionary *)promoData isSelected:(BOOL)isSelected {
    _radioLabel.layer.borderColor=[UIColor whiteColor].CGColor;
    _radioLabel.layer.borderWidth=1.0;
    _radioLabel.layer.masksToBounds=true;
    _radioLabel.layer.cornerRadius=5.0;
    if (isSelected) {
        _radioLabel.backgroundColor=selectedStepColor;
    }
    else {
        _radioLabel.backgroundColor=[UIColor whiteColor];
        _radioLabel.layer.borderColor=unSelectedStepColor.CGColor;
    }
    if ([promoData[@"HiddenPromo"] boolValue]) {
        self.alpha=0.5;
    }
    else {
        self.alpha=1.0;
    }
    if ([promoData[@"promo_category"] isEqualToString:@"rebate"]) {
        _promoImageView.image=[UIImage imageNamed:@"checkoutBadge"];
    }
    else if ([promoData[@"promo_category"] isEqualToString:@"percent_discount"]) {
        _promoImageView.image=[UIImage imageNamed:@"checkoutDiscount"];
    }
    else {
        _promoImageView.image=[UIImage imageNamed:@"checkoutDelivery-truck"];
    }
    _promoInfoLabel.text=[NSString stringWithFormat:@"%@\n(%@ip)",promoData[@"promo_name"],promoData[@"promo_points"]];
}
@end
