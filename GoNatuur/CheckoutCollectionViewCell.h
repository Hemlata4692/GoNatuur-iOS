//
//  CheckoutCollectionViewCell.h
//  GoNatuur
//
//  Created by Ranosys on 11/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckoutCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *radioLabel;
@property (strong, nonatomic) IBOutlet UIImageView *promoImageView;
@property (strong, nonatomic) IBOutlet UILabel *promoInfoLabel;
- (void)displayPromoData:(NSDictionary *)promoData isSelected:(BOOL)isSelected;
@end
