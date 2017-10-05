//
//  CardListTableViewCell.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 09/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "CardListTableViewCell.h"

@implementation CardListTableViewCell

#pragma mark - Cell life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//Display card data
- (void)displayOrderData:(CGSize)rectSize orderData:(PaymentModel *)paymentData {
    if ([UIImage imageNamed:paymentData.cardType]==nil) {
        _cardImage.image = [UIImage imageNamed:@"defaultCard"];
    }
    else {
         _cardImage.image = [UIImage imageNamed:paymentData.cardType];
    }
    _cardNumber.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedText(@"cardNumberList"),paymentData.cardLastFourDigit];
}
#pragma mark - end
@end
