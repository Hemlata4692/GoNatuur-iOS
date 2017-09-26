//
//  CardListTableViewCell.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 09/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentModel.h"

@interface CardListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cardImage;
@property (weak, nonatomic) IBOutlet UILabel *cardNumber;
@property (weak, nonatomic) IBOutlet UIButton *deleteCardButton;
- (void)displayOrderData:(CGSize)rectSize orderData:(PaymentModel *)paymentData;
@end
