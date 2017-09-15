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

//Shipping address view
@property (weak, nonatomic) IBOutlet UILabel *shippingAddressTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingAddressNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingAddressFirstStreetLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingAddressSecondStreetLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingAddressPhoneNumberLabel;

//Billing address view
@property (weak, nonatomic) IBOutlet UILabel *billingAddressTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *billingAddressNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *billingAddressFirstStreetLabel;
@property (weak, nonatomic) IBOutlet UILabel *billingAddressSecondStreetLabel;
@property (weak, nonatomic) IBOutlet UILabel *billingAddressPhoneNumberLabel;

//Method types
@property (weak, nonatomic) IBOutlet UILabel *shippingMethodHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingMethodLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentMethodHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentMethodLabel;

- (void)displayProductData:(CGSize)rectSize orderData:(OrderModel *)orderData ticketArray:(NSMutableArray *)ticketArray;
- (void)displayAddressData:(CGSize)rectSize orderData:(OrderModel *)orderData;
- (void)displayTotalAmountData:(CGSize)rectSize orderData:(OrderModel *)orderData;

@end
