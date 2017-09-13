//
//  CheckoutTableViewCell.m
//  GoNatuur
//
//  Created by Ranosys on 11/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "CheckoutTableViewCell.h"
#define selectedStepColor   [UIColor colorWithRed:182.0/255.0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0]
#define unSelectedStepColor [UIColor lightGrayColor]

@implementation CheckoutTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displayCellData:(NSDictionary *)shippingMethodData isSelected:(BOOL)isSelected totalPrice:(float)totalPrice {
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
    _shippingMethodLabel.text=[NSString stringWithFormat:@"%@\n%@",shippingMethodData[@"method_title"],shippingMethodData[@"method_title"]];
    _shippingMethodPriceLabel.text=[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([shippingMethodData[@"amount"] floatValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])];
}
@end
