//
//  OrderDetailCell.m
//
//
//  Created by Monika on 9/9/17.
//
//

#import "OrderDetailCell.h"
#import "DynamicHeightWidth.h"
#import "CurrencyDataModel.h"

@implementation OrderDetailCell

#pragma mark - Cell life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//Display product detail data
- (void)displayProductData:(CGSize)rectSize orderData:(OrderModel *)orderData ticketArray:(NSMutableArray *)ticketArray {
    [self removeAutolayouts];
    _productNameLabel.text = orderData.productName;
    _priceLabel.text = orderData.productPrice;
    _subtotalLabel.text = orderData.productSubTotal;
    _quantityLabel.text = [NSString stringWithFormat:@"%@",orderData.productQuantity];
    _productNameLabel.numberOfLines=0;
    float height =[DynamicHeightWidth getDynamicLabelHeight:_productNameLabel.text font:[UIFont montserratLightWithSize:13] widthValue:rectSize.width-20 heightValue:500];
    _productNameLabel.frame=CGRectMake(10, 28,rectSize.width-20, height);
    if ([orderData.productType isEqualToString:NSLocalizedText(@"ticket")]) {
        for (int i=0; i<ticketArray.count; i++) {
            if ([[NSString stringWithFormat:@"%@",orderData.productId] containsString:[[ticketArray objectAtIndex:i] ticketProductId]]) {
                if ([[[ticketArray objectAtIndex:i] ticketName] isEqualToString:@""] || [[ticketArray objectAtIndex:i] ticketName]==nil) {
                    _ticketOptionLabel.text = NSLocalizedText(@"dataNotAdded");
                } else {
                    _ticketOptionLabel.text = [[ticketArray objectAtIndex:i] ticketName];
                }
            }
        }
        _eventView.hidden = NO;
        _productView.hidden = YES;
        _eventSkuLabel.text = orderData.productSku;
        _eventSkuLabel.numberOfLines=0;
        height =[DynamicHeightWidth getDynamicLabelHeight:_eventSkuLabel.text font:[UIFont montserratLightWithSize:13] widthValue:(rectSize.width/2)-10 heightValue:500];
        _eventSkuLabel.frame=CGRectMake(0, 20,(rectSize.width/2)-10, height);
        _ticketOptionLabel.numberOfLines=0;
        height =[DynamicHeightWidth getDynamicLabelHeight:_ticketOptionLabel.text font:[UIFont montserratLightWithSize:13] widthValue:(rectSize.width/2)-10 heightValue:500];
        _ticketOptionLabel.frame=CGRectMake(_eventSkuLabel.frame.origin.x + _eventSkuLabel.frame.size.width +10, 20,(rectSize.width/2)-10, height);
        _eventView.frame=CGRectMake(10, 0,rectSize.width-10, height);
        
        
    } else {
        _productView.hidden = NO;
        _eventView.hidden = YES;
        _skuLabel.text = orderData.productSku;
        _skuLabel.numberOfLines=0;
        height =[DynamicHeightWidth getDynamicLabelHeight:_skuLabel.text font:[UIFont montserratLightWithSize:13] widthValue:rectSize.width-20 heightValue:500];
        _skuLabel.frame=CGRectMake(0, 20,rectSize.width-20, height);
        _productView.frame=CGRectMake(10, 0,rectSize.width-10, height);
    }
}

- (void)displayTotalAmountData:(CGSize)rectSize orderData:(OrderModel *)orderData {
    [self setLocalisedText];
    _orderSubtotalLabel.text = orderData.orderSubTotal;
    _shippingTotalLabel.text = orderData.shippingAmount;
    _discountLabel.text = orderData.discountAmount;
    _taxLabel.text = orderData.taxAmount;
    _grandTotalLabel.text = orderData.orderPrice;
    _grandTotalChargedLabel.text = orderData.baseGrandTotal;
    _grandTotalChargedHeadingLabel.text = NSLocalizedText(@"baseGrandTotal");

    _discountHeadingLabel.text = orderData.discountDescription;
    _discountHeadingLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _discountHeadingLabel.numberOfLines = 0;
    float height =[DynamicHeightWidth getDynamicLabelHeight:_discountHeadingLabel.text font:[UIFont montserratRegularWithSize:14] widthValue:rectSize.width-120 heightValue:500];
    _discountHeadingLabel.frame=CGRectMake(10, 5,rectSize.width-120, height);
    
    _grandTotalChargedHeadingLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _grandTotalChargedHeadingLabel.numberOfLines = 0;
    height =[DynamicHeightWidth getDynamicLabelHeight:NSLocalizedText(@"baseGrandTotal") font:[UIFont montserratRegularWithSize:14] widthValue:rectSize.width-120 heightValue:500];
    _grandTotalChargedHeadingLabel.frame=CGRectMake(10, 28,rectSize.width-120, height);
    
    _orderSubtotalLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _orderSubtotalLabel.numberOfLines = 0;
    height =[DynamicHeightWidth getDynamicLabelHeight:_orderSubtotalLabel.text font:[UIFont montserratRegularWithSize:14] widthValue:100 heightValue:500];
    _orderSubtotalLabel.frame=CGRectMake(rectSize.width - 110, 5,100, height);
    
    _shippingTotalLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _shippingTotalLabel.numberOfLines = 0;
    height =[DynamicHeightWidth getDynamicLabelHeight:_shippingTotalLabel.text font:[UIFont montserratRegularWithSize:14] widthValue:100 heightValue:500];
    _shippingTotalLabel.frame=CGRectMake(rectSize.width - 110, _orderSubtotalLabel.frame.origin.y + _orderSubtotalLabel.frame.size.height+5,100, height);
    
    _discountLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _discountLabel.numberOfLines = 0;
    height =[DynamicHeightWidth getDynamicLabelHeight:_discountLabel.text font:[UIFont montserratRegularWithSize:14] widthValue:100 heightValue:500];
    _discountLabel.frame=CGRectMake(rectSize.width - 110, 5,100, height);
    
    _taxLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _taxLabel.numberOfLines = 0;
    height =[DynamicHeightWidth getDynamicLabelHeight:_taxLabel.text font:[UIFont montserratRegularWithSize:14] widthValue:100 heightValue:500];
    _taxLabel.frame=CGRectMake(rectSize.width - 110, 2,100, height);
    
    _grandTotalLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _grandTotalLabel.numberOfLines = 0;
    height =[DynamicHeightWidth getDynamicLabelHeight:_grandTotalLabel.text font:[UIFont montserratRegularWithSize:14] widthValue:100 heightValue:500];
    _grandTotalLabel.frame=CGRectMake(rectSize.width - 110, 5,100, height);
    
    _grandTotalChargedLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _grandTotalChargedLabel.numberOfLines = 0;
    height =[DynamicHeightWidth getDynamicLabelHeight:_grandTotalChargedLabel.text font:[UIFont montserratRegularWithSize:14] widthValue:100 heightValue:500];
    _grandTotalChargedLabel.frame=CGRectMake(rectSize.width - 110, 28,100, height);
}

- (void)displayAddressData:(CGSize)rectSize orderData:(OrderModel *)orderData {
    [self removeAutolayouts];
    [self displayShippingAddressData:rectSize orderData:orderData];
    [self displayBillingAddressData:rectSize orderData:orderData];
    [self displayMethodTypeData:rectSize orderData:orderData];
}

- (void)displayShippingAddressData:(CGSize)rectSize orderData:(OrderModel *)orderData {
    //Set shipping address
    _shippingAddressTypeLabel.text = NSLocalizedText(@"shippingAddress");
    _shippingAddressNameLabel.text = [NSString stringWithFormat:@"%@ %@",orderData.fullShippingAddress[@"firstname"],orderData.fullShippingAddress[@"lastname"]];
    _shippingAddressNameLabel.numberOfLines = 0;
    float height =[DynamicHeightWidth getDynamicLabelHeight:_shippingAddressNameLabel.text font:[UIFont montserratRegularWithSize:14] widthValue:rectSize.width-20 heightValue:500];
    _shippingAddressNameLabel.frame=CGRectMake(10, 30,rectSize.width-20, height);
    _shippingAddressFirstStreetLabel.text = [orderData.fullShippingAddress[@"street"] componentsJoinedByString:@" "];
    _shippingAddressFirstStreetLabel.numberOfLines = 0;
    height =[DynamicHeightWidth getDynamicLabelHeight:_shippingAddressFirstStreetLabel.text font:[UIFont montserratRegularWithSize:13] widthValue:rectSize.width-20 heightValue:500];
    _shippingAddressFirstStreetLabel.frame=CGRectMake(10, _shippingAddressNameLabel.frame.origin.y + _shippingAddressNameLabel.frame.size.height + 5,rectSize.width-20, height);
    _shippingAddressSecondStreetLabel.text = [NSString stringWithFormat:@"%@ - %@, %@",orderData.fullShippingAddress[@"city"],orderData.fullShippingAddress[@"postcode"],orderData.fullShippingAddress[@"region"]];
    _shippingAddressSecondStreetLabel.numberOfLines = 0;
    height =[DynamicHeightWidth getDynamicLabelHeight:_shippingAddressSecondStreetLabel.text font:[UIFont montserratRegularWithSize:13] widthValue:rectSize.width-20 heightValue:500];
    _shippingAddressSecondStreetLabel.frame=CGRectMake(10, _shippingAddressFirstStreetLabel.frame.origin.y + _shippingAddressFirstStreetLabel.frame.size.height + 1,rectSize.width-20, height);
    _shippingAddressPhoneNumberLabel.text = [NSString stringWithFormat:@"Phone Number: %@",orderData.fullShippingAddress[@"telephone"]];
    _shippingAddressPhoneNumberLabel.numberOfLines = 0;
    height =[DynamicHeightWidth getDynamicLabelHeight:_shippingAddressPhoneNumberLabel.text font:[UIFont montserratRegularWithSize:13] widthValue:rectSize.width-20 heightValue:500];
    _shippingAddressPhoneNumberLabel.frame=CGRectMake(10, _shippingAddressSecondStreetLabel.frame.origin.y + _shippingAddressSecondStreetLabel.frame.size.height + 1,rectSize.width-20, height);
}

- (void)displayBillingAddressData:(CGSize)rectSize orderData:(OrderModel *)orderData {
    //Set billing address
    _billingAddressTypeLabel.text = NSLocalizedText(@"billingAddress");
    _billingAddressNameLabel.text = [NSString stringWithFormat:@"%@ %@",orderData.fullBillingAddress[@"firstname"],orderData.fullBillingAddress[@"lastname"]];
    _billingAddressNameLabel.numberOfLines = 0;
    float height =[DynamicHeightWidth getDynamicLabelHeight:_billingAddressNameLabel.text font:[UIFont montserratRegularWithSize:14] widthValue:rectSize.width-20 heightValue:500];
    _billingAddressNameLabel.frame=CGRectMake(10, 30,rectSize.width-20, height);
    _billingAddressFirstStreetLabel.text = [orderData.fullBillingAddress[@"street"] componentsJoinedByString:@" "];
    _billingAddressFirstStreetLabel.numberOfLines = 0;
    height =[DynamicHeightWidth getDynamicLabelHeight:_billingAddressFirstStreetLabel.text font:[UIFont montserratRegularWithSize:13] widthValue:rectSize.width-20 heightValue:500];
    _billingAddressFirstStreetLabel.frame=CGRectMake(10, _billingAddressNameLabel.frame.origin.y + _billingAddressNameLabel.frame.size.height + 5,rectSize.width-20, height);
    _billingAddressSecondStreetLabel.text = [NSString stringWithFormat:@"%@ - %@, %@",orderData.fullBillingAddress[@"city"],orderData.fullBillingAddress[@"postcode"],orderData.fullBillingAddress[@"region"]];
    _billingAddressSecondStreetLabel.numberOfLines = 0;
    height =[DynamicHeightWidth getDynamicLabelHeight:_billingAddressSecondStreetLabel.text font:[UIFont montserratRegularWithSize:13] widthValue:rectSize.width-20 heightValue:500];
    _billingAddressSecondStreetLabel.frame=CGRectMake(10, _billingAddressFirstStreetLabel.frame.origin.y + _billingAddressFirstStreetLabel.frame.size.height + 1,rectSize.width-20, height);
    _billingAddressPhoneNumberLabel.text = [NSString stringWithFormat:@"Phone Number: %@",orderData.fullBillingAddress[@"telephone"]];
    _billingAddressPhoneNumberLabel.numberOfLines = 0;
    height =[DynamicHeightWidth getDynamicLabelHeight:_billingAddressPhoneNumberLabel.text font:[UIFont montserratRegularWithSize:13] widthValue:rectSize.width-20 heightValue:500];
    _billingAddressPhoneNumberLabel.frame=CGRectMake(10, _billingAddressSecondStreetLabel.frame.origin.y + _billingAddressSecondStreetLabel.frame.size.height + 1,rectSize.width-20, height);
}

- (void)displayMethodTypeData:(CGSize)rectSize orderData:(OrderModel *)orderData {
    float height;
    //Set shipping method
    _shippingMethodLabel.numberOfLines = 0;
    if ((nil==orderData.shippingMethod)||[orderData.shippingMethod isEqualToString:@""]) {
        _shippingMethodLabel.text = NSLocalizedText(@"dataNotAdded");
        _shippingMethodLabel.frame=CGRectMake(10, 33,(rectSize.width/2)-15, 20);
    } else {
        _shippingMethodLabel.text = orderData.shippingMethod;
        height =[DynamicHeightWidth getDynamicLabelHeight:_shippingMethodLabel.text font:[UIFont montserratLightWithSize:13] widthValue:(rectSize.width/2)-15 heightValue:500];
        _shippingMethodLabel.frame=CGRectMake(10, 33,(rectSize.width/2)-15, height);
    }
    //Set payment method
    _paymentMethodLabel.numberOfLines = 0;
    if ((nil==orderData.paymentMethod)||[orderData.paymentMethod isEqualToString:@""]) {
        _paymentMethodLabel.text = NSLocalizedText(@"dataNotAdded");
        _paymentMethodLabel.frame=CGRectMake(_shippingMethodLabel.frame.origin.x + _shippingMethodLabel.frame.size.width +10, 33,(rectSize.width/2)-15, 20);
    } else {
        _paymentMethodLabel.text = orderData.paymentMethod;
        height =[DynamicHeightWidth getDynamicLabelHeight:_paymentMethodLabel.text font:[UIFont montserratLightWithSize:13] widthValue:(rectSize.width/2)-15 heightValue:500];
        _paymentMethodLabel.frame=CGRectMake(_shippingMethodLabel.frame.origin.x + _shippingMethodLabel.frame.size.width +10, 33,(rectSize.width/2)-15, height);
    }
}
#pragma mark - end

#pragma mark - Remove autolayouts
- (void)removeAutolayouts {
    [self setLocalisedText];
    _eventView.translatesAutoresizingMaskIntoConstraints=YES;
    _productView.translatesAutoresizingMaskIntoConstraints=YES;
    _productNameLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _skuLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _eventSkuLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _ticketOptionLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _billingAddressTypeLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _billingAddressNameLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _billingAddressFirstStreetLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _billingAddressSecondStreetLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _billingAddressPhoneNumberLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _shippingAddressTypeLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _shippingAddressNameLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _shippingAddressFirstStreetLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _shippingAddressSecondStreetLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _shippingAddressPhoneNumberLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _shippingMethodLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _paymentMethodLabel.translatesAutoresizingMaskIntoConstraints=YES;
}
#pragma mark - end

#pragma mark - Set localised text
- (void)setLocalisedText {
    //Product list labels
    _productNameHeadingLabel.text = NSLocalizedText(@"productNameTitle");
    _skuHeadingLabel.text = NSLocalizedText(@"skuTitle");
    _eventSkuHeadingLabel.text = NSLocalizedText(@"skuTitle");
    _ticketOptionHeadingLanbel.text = NSLocalizedText(@"optionSelectTitle");
    _priceHeadingLabel.text = NSLocalizedText(@"price");
    _quantityHeadingLabel.text = NSLocalizedText(@"QtyTitle");
    _subtotalHeadingLabel.text = NSLocalizedText(@"totalAmountTitle");
    // Order total label
    _orderSubTotalHeadingLabel.text = NSLocalizedText(@"subtotalTitle");
    _shippingTotalHeadingLabel.text = NSLocalizedText(@"ShippingChargeTitle");
    _taxHeadingLabel.text = NSLocalizedText(@"taxTitle");
    _grangTotalHeadingLabel.text = NSLocalizedText(@"grandtotalTitle");
    //Payment method label
    _paymentMethodHeadingLabel.text = NSLocalizedText(@"paymentMethodTitle");
    //Shipping method label
    _shippingMethodHeadingLabel.text = NSLocalizedText(@"shippingMethodTitle");
}
#pragma mark - end

@end
