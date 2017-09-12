//
//  AttendeesTableViewCell.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 11/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendeesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *attendeeImageView;
@property (weak, nonatomic) IBOutlet UILabel *attendeeName;

- (void) displayData:(NSDictionary *)dataDict;
@end
