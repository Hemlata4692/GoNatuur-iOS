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

- (void)displaySlider:(NSString *)maxPrice minLabelPrice:(NSString *)minLabelPrice maxLabelPrice:(NSString *)maxLabelPrice {
    _priceFilterLabel.text=NSLocalizedText(@"rangeSlider");
     _filterApplied=@"1";
    _minimumPriceLabel.text=[NSString stringWithFormat:@"$%s","0"];
    _maximumPriceLabel.text=[NSString stringWithFormat:@"$%.0f",[maxPrice floatValue]];
    if ([maxLabelPrice floatValue]==0 || maxLabelPrice==nil) {
        maxLabelPrice =[NSString stringWithFormat:@"%.0f",[maxPrice floatValue]];
    }
    //custom number formatter range slider
    self.priceRangeSliderView.delegate = self;
    self.priceRangeSliderView.minValue = 0;
    self.priceRangeSliderView.maxValue = [maxPrice floatValue];
    self.priceRangeSliderView.selectedMinimum = [minLabelPrice floatValue];
    self.priceRangeSliderView.selectedMaximum = [maxLabelPrice floatValue];
    self.priceRangeSliderView.handleImage = [UIImage imageNamed:@"slide-arrow"];
    self.priceRangeSliderView.selectedHandleDiameterMultiplier = 1;
    self.priceRangeSliderView.tintColorBetweenHandles = [UIColor colorWithRed:182.0/255.0 green:37.0/255.0 blue:70.0/255.0 alpha:1.0];
    self.priceRangeSliderView.lineBorderWidth = 0.5;
    self.priceRangeSliderView.lineBorderColor = [UIColor grayColor];
}

#pragma mark TTRangeSliderViewDelegate
-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum{
    if (sender == self.priceRangeSliderView) {
        _maxPriceValue=[NSString stringWithFormat:@"%.0f",selectedMaximum];
        _minPriceValue=[NSString stringWithFormat:@"%.0f",selectedMinimum];
    }
}

- (void)displayCountry:(SortFilterModel *)data {
    if ([NSLocalizedText(data.filterAttributeCode) isEqualToString:@""] || NSLocalizedText(data.filterAttributeCode)==nil) {
       _countryLabel.text=data.filterLabelValue;
    }
    else {
         _countryLabel.text=NSLocalizedText(data.filterAttributeCode);
    }
}
@end
