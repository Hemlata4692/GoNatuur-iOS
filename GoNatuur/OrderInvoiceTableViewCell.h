//
//  OrderInvoiceTableViewCell.h
//  GoNatuur
//
//  Created by Ranosys on 15/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface OrderInvoiceTableViewCell : UITableViewCell

//Product list labels
@property (weak, nonatomic) IBOutlet UILabel *productNameHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UIView *productView;
@property (weak, nonatomic) IBOutlet UILabel *skuHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;

@property (weak, nonatomic) IBOutlet UIView *eventView;
@property (weak, nonatomic) IBOutlet UILabel *eventSkuHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventSkuLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketOptionHeadingLanbel;
@property (weak, nonatomic) IBOutlet UILabel *ticketOptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtotalHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtotalLabel;

// Order total label
@property (weak, nonatomic) IBOutlet UILabel *orderSubTotalHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderSubtotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingTotalHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *taxHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *taxLabel;
@property (weak, nonatomic) IBOutlet UILabel *grangTotalHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *grandTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *grandTotalChargedHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *grandTotalChargedLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;

//Shippment track view
@property (strong, nonatomic) IBOutlet UILabel *trackTItle;
@property (strong, nonatomic) IBOutlet UIButton *trackNumberButton;

- (void)displayProductData:(float)rectSizeWidth orderData:(OrderModel *)orderData currencyCode:(NSString *)currencyCode;
- (void)displayTotalAmountData:(float)rectSizeWidth orderData:(OrderModel *)orderData;
- (void)displayTrackShippment:(float)rectSizeWidth orderData:(OrderModel *)orderData;
@end
