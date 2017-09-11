//
//  OrderDetailCell.h
//  
//
//  Created by Monika on 9/9/17.
//
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface OrderDetailCell : UITableViewCell


- (void)displayOrderData:(CGSize)rectSize orderData:(OrderModel *)orderData;

@end
