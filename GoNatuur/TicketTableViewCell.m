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


- (void) displayData:(NSDictionary *)ticketDict {
    _ticketName.translatesAutoresizingMaskIntoConstraints=YES;
    _ticketPrice.translatesAutoresizingMaskIntoConstraints=YES;
    [_mainView setCornerRadius:2.0];
    [_mainView addShadow:_mainView color:[UIColor blackColor]];
    _ticketName.text=[ticketDict objectForKey:@"title"];
   
    float nameHeight=[DynamicHeightWidth getDynamicLabelHeight:_ticketName.text font:[UIFont montserratLightWithSize:13] widthValue:_mainView.frame.size.width-144];
    _ticketName.frame=CGRectMake(16, 25, _mainView.frame.size.width-144, nameHeight);
    _ticketName.backgroundColor=[UIColor redColor];
   
    double productCalculatedPrice =[[ticketDict objectForKey:@"price"] doubleValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue];
    _ticketPrice.text=[NSString stringWithFormat:@"%@ %@",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],[ConstantCode decimalFormatter:productCalculatedPrice]];
    
    float priceHeight=[DynamicHeightWidth getDynamicLabelHeight:_ticketPrice.text font:[UIFont montserratLightWithSize:13] widthValue:_mainView.frame.size.width-144];
    _ticketPrice.frame=CGRectMake(_ticketName.frame.size.width+19, 25, _mainView.frame.size.width-116, priceHeight);
    _ticketPrice.backgroundColor=[UIColor blueColor];

}

@end
