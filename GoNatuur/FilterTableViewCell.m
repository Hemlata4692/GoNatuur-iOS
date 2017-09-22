//
//  FilterTableViewCell.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 21/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "FilterTableViewCell.h"
#import "TwoThumbRangeSlider.h"

@implementation FilterTableViewCell {
    TwoThumbRangeSlider *slider1;
    UILabel *leftLabel;
    UILabel *rightLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displaySlider:(CGSize)rectSize {
    [self layoutCustomSlider];
}

-(void)layoutCustomSlider {
    
    [slider1 removeFromSuperview];
    [leftLabel removeFromSuperview];
    [rightLabel removeFromSuperview];
    slider1 = [TwoThumbRangeSlider doubleSlider];
    _priceRangeSliderView.backgroundColor=[UIColor blueColor];
    //sliderContainer.translatesAutoresizingMaskIntoConstraints=YES;
    //sliderContainer.frame=CGRectMake(10, sliderContainer.frame.origin.y, self.view.frame.size.width- 0, sliderContainer.frame.size.height);
    [slider1 addTarget:self action:@selector(valueChangedForDoubleSlider:) forControlEvents:UIControlEventValueChanged];
    //    slider1.center = hourSelectionView.center;
    slider1.frame=CGRectMake(10, 20, [[UIScreen mainScreen] bounds].size.width-52, 50);
    //slider1.tag = SLIDER_VIEW_TAG; //for testing purposes only
    [_priceRangeSliderView addSubview:slider1];
    
    leftLabel = [[UILabel alloc] initWithFrame:CGRectOffset(slider1.frame, 0, -slider1.frame.size.height)];
    leftLabel.textAlignment =NSTextAlignmentCenter;
    leftLabel.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    leftLabel.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    leftLabel.layer.shadowOffset = CGSizeMake(2, 2);
    leftLabel.layer.shadowOpacity = 1.0;
    leftLabel.frame = CGRectMake(_priceRangeSliderView.frame.origin.x+10, slider1.frame.origin.y-45, 50, 30);
    leftLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
    leftLabel.textColor = [UIColor colorWithRed:106.0/255.0 green:106.0/255.0 blue:106.0/255.0 alpha:1.0];
    leftLabel.layer.masksToBounds = NO;
    [_priceRangeSliderView addSubview:leftLabel];
    
    rightLabel = [[UILabel alloc] initWithFrame:CGRectOffset(slider1.frame, 0, -slider1.frame.size.height)];
    rightLabel.textAlignment =NSTextAlignmentCenter;
    rightLabel.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    rightLabel.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    rightLabel.layer.shadowOffset =  CGSizeMake(2, 2);
    rightLabel.layer.shadowOpacity = 1.0;
    rightLabel.frame = CGRectMake(160, slider1.frame.origin.y-45, 50, 30);
    rightLabel.textColor = [UIColor colorWithRed:106.0/255.0 green:106.0/255.0 blue:106.0/255.0 alpha:1.0];
    rightLabel.layer.masksToBounds = NO;
    rightLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
    [_priceRangeSliderView addSubview:rightLabel];
    
    [self valueChangedForDoubleSlider:slider1];
    
    
    
}

- (void)valueChangedForDoubleSlider:(TwoThumbRangeSlider *)slider  {
    
    CGPoint sliderMinHandle= [slider.minHandle.superview convertPoint:slider.minHandle.frame.origin toView:_priceRangeSliderView];
    CGPoint sliderMaxHandle= [slider.maxHandle.superview convertPoint:slider.maxHandle.frame.origin toView:_priceRangeSliderView];
    
    leftLabel.frame=CGRectMake(sliderMinHandle.x-13, sliderMinHandle.y-35, leftLabel.frame.size.width, leftLabel.frame.size.height);
    rightLabel.frame=CGRectMake(sliderMaxHandle.x-13, sliderMaxHandle.y-35, leftLabel.frame.size.width, leftLabel.frame.size.height);
    leftLabel.text = [NSString stringWithFormat:@"0%0.1f", (slider.minSelectedValue/2)-0.5];
    NSArray *items = [leftLabel.text componentsSeparatedByString:@"."];
    if ([[items objectAtIndex:1] isEqualToString:@"5"])
    {
        leftLabel.text=[NSString stringWithFormat:@"%@:30",[items objectAtIndex:0]];
    }
    else
    {
        leftLabel.text=[NSString stringWithFormat:@"%@:00",[items objectAtIndex:0]];
    }
    rightLabel.text = [NSString stringWithFormat:@"%0.1f", (slider.maxSelectedValue/2)-0.5];
    items = [rightLabel.text componentsSeparatedByString:@"."];
    if ([[items objectAtIndex:1] isEqualToString:@"5"])
    {
        rightLabel.text=[NSString stringWithFormat:@"%@:30",[items objectAtIndex:0]];
    }
    else
    {
        if ([[items objectAtIndex:0] isEqualToString:@"24"])
        {
            rightLabel.text=[NSString stringWithFormat:@"24:00"];
        }
        else
            rightLabel.text=[NSString stringWithFormat:@"%@:00",[items objectAtIndex:0]];
    }
    
}

@end
