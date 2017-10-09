//
//  FilterTableViewCell.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 21/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "FilterTableViewCell.h"

@implementation FilterTableViewCell {

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)displaySlider:(NSString *)maxPrice {
    _minimumPriceLabel.text=[NSString stringWithFormat:@"$%s","0"];
    _maximumPriceLabel.text=[NSString stringWithFormat:@"$%.01f",[maxPrice floatValue]];
    
    _priceRangeSliderView.requireSegments = NO;
    _priceRangeSliderView.sliderSize = CGSizeMake(20, 20);
    
    _priceRangeSliderView.rangeSliderForegroundColor = [UIColor colorWithRed:182.0/255.0 green:37.0/255.0 blue:70.0/255.0 alpha:1.0];
    
    _priceRangeSliderView.rangeSliderButtonImage = [UIImage imageNamed:@"slide-arrow"];
    [_priceRangeSliderView setDelegate:self];
    
    [_priceRangeSliderView scrollStartSliderToStartRange:[[NSString stringWithFormat:@"%.01f", [_minimumPriceLabel.text floatValue]] floatValue] andEndRange:[[NSString stringWithFormat:@"%.01f", [maxPrice floatValue]] floatValue]];
}

- (void)sliderScrolling:(VPRangeSlider *)slider withMinPercent:(CGFloat)minPercent andMaxPercent:(CGFloat)maxPercent {
    _priceRangeSliderView.minRangeText = [NSString stringWithFormat:@"%.01f", minPercent];
    _priceRangeSliderView.maxRangeText = [NSString stringWithFormat:@"%.01f", maxPercent];
    _minPriceValue = _priceRangeSliderView.minRangeText;
    _maxPriceValue = _priceRangeSliderView.maxRangeText;
}

- (void)displayCountry:(SortFilterModel *)data {
    _countryLabel.text=data.filterLabelValue;
}
@end
