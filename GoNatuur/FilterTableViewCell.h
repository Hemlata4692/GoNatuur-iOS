//
//  FilterTableViewCell.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 21/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceFilterLabel;
@property (weak, nonatomic) IBOutlet UIView *priceRangeSliderView;
@property (weak, nonatomic) IBOutlet UILabel *minimumPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *maximumPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *benefitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *certificatesLabel;
@property (weak, nonatomic) IBOutlet UILabel *productTypeLabel;

- (void)displaySlider:(CGSize)rectSize;
@end
