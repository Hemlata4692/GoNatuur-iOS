//
//  TicketTableViewCell.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 11/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *ticketingHeading;
@property (weak, nonatomic) IBOutlet UILabel *priceHeading;
@property (weak, nonatomic) IBOutlet UILabel *ticketName;
@property (weak, nonatomic) IBOutlet UILabel *ticketPrice;

- (void) displayData:(NSDictionary *)dataDict rectSize:(CGSize)rectSize;
@end
