//
//  NewsCentreDetailTableViewCell.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 13/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "NewsCentreDetailTableViewCell.h"
#import "DynamicHeightWidth.h"

@implementation NewsCentreDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


- (void)displayNewsTitleImage:(NSString *)imageUrl title:(NSString *)title {
     [ImageCaching downloadImages:_newsImageView imageUrl:imageUrl placeholderImage:@"banner_placeholder" isDashboardCell:true];
    _newsTitleLabel.text=title;
}

- (void)displayNewsDate:(NSString *)date {
    _dateHeading.text=NSLocalizedText(@"dateHeading");
    _dateLabel.translatesAutoresizingMaskIntoConstraints=YES;
    float tempHeight= [DynamicHeightWidth getDynamicLabelHeight:date font:[UIFont montserratRegularWithSize:15] widthValue:[[UIScreen mainScreen] bounds].size.width-68];
    _dateLabel.frame=CGRectMake(58, 1, [[UIScreen mainScreen] bounds].size.width-68, tempHeight);
    _dateLabel.text=date;
}

- (void)displayNewsCategory:(NSString *)category  {
    _categoriesHeading.text=NSLocalizedText(@"categoryHeading");
    _categoriesLabel.translatesAutoresizingMaskIntoConstraints=YES;
    float tempHeight= [DynamicHeightWidth getDynamicLabelHeight:category font:[UIFont montserratRegularWithSize:15] widthValue:[[UIScreen mainScreen] bounds].size.width-113];
    _categoriesLabel.frame=CGRectMake(103, 1, [[UIScreen mainScreen] bounds].size.width-113, tempHeight);
    _categoriesLabel.text=category;
}

- (void)displayNewsTags:(NSString *)tags {
    _tagsHeading.text=NSLocalizedText(@"tagsHeading");
    _tagsLabel.translatesAutoresizingMaskIntoConstraints=YES;
    float tempHeight= [DynamicHeightWidth getDynamicLabelHeight:tags font:[UIFont montserratRegularWithSize:15] widthValue:[[UIScreen mainScreen] bounds].size.width-65];
    _tagsLabel.frame=CGRectMake(55, 1, [[UIScreen mainScreen] bounds].size.width-65, tempHeight);
    _tagsLabel.text=tags;
}

- (void)displayNewsAuthor:(NSString *)authorName {
    _byHeading.text=NSLocalizedText(@"byHeading");
    _authorName.translatesAutoresizingMaskIntoConstraints=YES;
    float tempHeight= [DynamicHeightWidth getDynamicLabelHeight:authorName font:[UIFont montserratRegularWithSize:15] widthValue:[[UIScreen mainScreen] bounds].size.width-55];
    _authorName.frame=CGRectMake(41, 1, [[UIScreen mainScreen] bounds].size.width-51, tempHeight);
    _authorName.text=authorName;
}

- (void)displayWebView:(NSString *)newsContent {
   // _contentWebView.translatesAutoresizingMaskIntoConstraints=YES;
    _contentWebView.backgroundColor = [UIColor clearColor];
    _contentWebView.opaque=NO;
   // float dynamicHeight= [DynamicHeightWidth getDynamicLabelHeight:newsContent font:[UIFont montserratLightWithSize:16] widthValue:[[UIScreen mainScreen] bounds].size.width-8];
   // _contentWebView.frame=CGRectMake(3, 0, [[UIScreen mainScreen] bounds].size.width-8, dynamicHeight);
    _contentWebView.scrollView.scrollEnabled = NO;
    _contentWebView.scrollView.bounces = NO;
}
@end
