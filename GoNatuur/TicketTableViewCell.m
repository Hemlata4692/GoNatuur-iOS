//
//  TicketTableViewCell.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 11/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "TicketTableViewCell.h"
#import "DynamicHeightWidth.h"

@implementation TicketTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) displayData:(NSDictionary *)ticketDict rectSize:(CGSize)rectSize {
    _ticketName.translatesAutoresizingMaskIntoConstraints=YES;
    _ticketPrice.translatesAutoresizingMaskIntoConstraints=YES;
    _ticketingHeading.translatesAutoresizingMaskIntoConstraints=YES;
    _priceHeading.translatesAutoresizingMaskIntoConstraints=YES;
    
    _ticketingHeading.text=NSLocalizedText(@"ticketing");
    _priceHeading.text=NSLocalizedText(@"price");
    
    _ticketName.text=[ticketDict objectForKey:@"title"];
    float nameHeight=[DynamicHeightWidth getDynamicLabelHeight:_ticketName.text font:[UIFont montserratLightWithSize:13] widthValue:(rectSize.width-20)/2-16];
    _ticketName.frame=CGRectMake(10, 30, (rectSize.width-20)/2-16, nameHeight);
    _ticketingHeading.frame=CGRectMake(10, 5, 88, 19);
   
    double productCalculatedPrice =[[ticketDict objectForKey:@"price"] doubleValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue];
    _ticketPrice.text=[NSString stringWithFormat:@"+%@ %@",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],[ConstantCode decimalFormatter:productCalculatedPrice]];
    float priceHeight=[DynamicHeightWidth getDynamicLabelHeight:_ticketPrice.text font:[UIFont montserratLightWithSize:13] widthValue:rectSize.width/2-16];
    _ticketPrice.frame=CGRectMake((rectSize.width-20)/2+8, 30, (rectSize.width-20)/2-16, priceHeight);
    _priceHeading.frame=CGRectMake(((rectSize.width-20)/2)+8, 5, 88, 19);
}

@end
