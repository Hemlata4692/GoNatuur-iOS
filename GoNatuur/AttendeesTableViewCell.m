//
//  AttendeesTableViewCell.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 11/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "AttendeesTableViewCell.h"

@implementation AttendeesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) displayData:(NSDictionary *)dataDict {
    _attendeeName.text=[dataDict objectForKey:@"customer_name"];
    [_attendeeImageView setCornerRadius:_attendeeImageView.frame.size.width/2];
    [_attendeeImageView setBorder:_attendeeImageView color:[UIColor colorWithRed:248.0/255.0 green:198.0/255.0 blue:217.0/255.0 alpha:1.0] borderWidth:1.0];
    [ImageCaching downloadImages:_attendeeImageView imageUrl:[dataDict objectForKey:@"profile_pic"] placeholderImage:@"profile_placeholder" isDashboardCell:true];
}
@end
