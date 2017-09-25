//
//  FilterTableViewCell.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 21/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SortFilterModel.h"
#import "VPRangeSlider.h"

@interface FilterTableViewCell : UITableViewCell<VPRangeSliderDelegate>
@property (weak, nonatomic) IBOutlet UILabel *priceFilterLabel;
@property (weak, nonatomic) IBOutlet VPRangeSlider *priceRangeSliderView;
@property (weak, nonatomic) IBOutlet UILabel *minimumPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *maximumPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *benefitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *certificatesLabel;
@property (weak, nonatomic) IBOutlet UILabel *productTypeLabel;

- (void)displaySlider:(NSString *)maxPrice;

- (void)displayCountry:(SortFilterModel *)data;
@end
