//
//  OrderInvoiceTableViewCell.m
//  GoNatuur
//
//  Created by Ranosys on 15/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "OrderInvoiceTableViewCell.h"
#import "DynamicHeightWidth.h"
#import "CurrencyDataModel.h"

@implementation OrderInvoiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//Display product detail data
- (void)displayProductData:(float)rectSizeWidth orderData:(OrderModel *)orderData currencyCode:(NSString *)currencyCode {
    [self removeAutolayouts];
    _productNameLabel.text = orderData.productName;
    _priceLabel.text = orderData.productPrice;
    _subtotalLabel.text = orderData.productSubTotal;
    _quantityLabel.text = [NSString stringWithFormat:@"%@",orderData.productQuantity];
    _skuLabel.text = orderData.productSku;
    _productNameLabel.numberOfLines=0;
    float height =[DynamicHeightWidth getDynamicLabelHeight:_productNameLabel.text font:[UIFont montserratLightWithSize:13] widthValue:rectSizeWidth-20 heightValue:500];
    _productNameLabel.frame=CGRectMake(10, 28,rectSizeWidth-20, height);
    _skuLabel.numberOfLines=0;
    height =[DynamicHeightWidth getDynamicLabelHeight:_skuLabel.text font:[UIFont montserratLightWithSize:13] widthValue:rectSizeWidth-20 heightValue:500];
    _skuLabel.frame=CGRectMake(0, 20,rectSizeWidth-20, height);
}

- (void)displayTotalAmountData:(float)rectSizeWidth orderData:(OrderModel *)orderData {
    [self setLocalisedText];
    _orderSubtotalLabel.text = orderData.orderSubTotal;
    _shippingTotalLabel.text = orderData.shippingAmount;
    _discountLabel.text = orderData.discountAmount;
    _taxLabel.text = orderData.taxAmount;
    _grandTotalLabel.text = orderData.orderPrice;
    _grandTotalChargedLabel.text = orderData.baseGrandTotal;
    
    _discountHeadingLabel.text = orderData.discountDescription;
    _discountHeadingLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _discountHeadingLabel.numberOfLines = 0;
    float height =[DynamicHeightWidth getDynamicLabelHeight:_discountHeadingLabel.text font:[UIFont montserratRegularWithSize:14] widthValue:rectSizeWidth-120 heightValue:500];
    _discountHeadingLabel.frame=CGRectMake(10, 5,rectSizeWidth-120, height);
    
    _grandTotalChargedHeadingLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _grandTotalChargedHeadingLabel.numberOfLines = 0;
    height =[DynamicHeightWidth getDynamicLabelHeight:NSLocalizedText(@"baseGrandTotal") font:[UIFont montserratRegularWithSize:14] widthValue:rectSizeWidth-120 heightValue:500];
    _grandTotalChargedHeadingLabel.frame=CGRectMake(10, 28,rectSizeWidth-120, height);
    
    _orderSubtotalLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _orderSubtotalLabel.numberOfLines = 0;
    height =[DynamicHeightWidth getDynamicLabelHeight:_orderSubtotalLabel.text font:[UIFont montserratRegularWithSize:14] widthValue:100 heightValue:500];
    _orderSubtotalLabel.frame=CGRectMake(rectSizeWidth - 110, 5,100, height);
    
    _shippingTotalLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _shippingTotalLabel.numberOfLines = 0;
    height =[DynamicHeightWidth getDynamicLabelHeight:_shippingTotalLabel.text font:[UIFont montserratRegularWithSize:14] widthValue:100 heightValue:500];
    _shippingTotalLabel.frame=CGRectMake(rectSizeWidth - 110, _orderSubtotalLabel.frame.origin.y + _orderSubtotalLabel.frame.size.height+5,100, height);
    
    
    _discountLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _discountLabel.numberOfLines = 0;
    height =[DynamicHeightWidth getDynamicLabelHeight:_discountLabel.text font:[UIFont montserratRegularWithSize:14] widthValue:100 heightValue:500];
    _discountLabel.frame=CGRectMake(rectSizeWidth - 110, 5,100, height);
    
    _taxLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _taxLabel.numberOfLines = 0;
    height =[DynamicHeightWidth getDynamicLabelHeight:_taxLabel.text font:[UIFont montserratRegularWithSize:14] widthValue:100 heightValue:500];
    _taxLabel.frame=CGRectMake(rectSizeWidth - 110, 2,100, height);
    
    _grandTotalLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _grandTotalLabel.numberOfLines = 0;
    height =[DynamicHeightWidth getDynamicLabelHeight:_grandTotalLabel.text font:[UIFont montserratRegularWithSize:14] widthValue:100 heightValue:500];
    _grandTotalLabel.frame=CGRectMake(rectSizeWidth - 110, 5,100, height);
    
    _grandTotalChargedLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _grandTotalChargedLabel.numberOfLines = 0;
    height =[DynamicHeightWidth getDynamicLabelHeight:_grandTotalChargedLabel.text font:[UIFont montserratRegularWithSize:14] widthValue:100 heightValue:500];
    _grandTotalChargedLabel.frame=CGRectMake(rectSizeWidth - 110, 28,100, height);
}

- (void)displayTrackShippment:(float)rectSizeWidth orderData:(OrderModel *)orderData {
    float height=[DynamicHeightWidth getDynamicLabelHeight:orderData.productName font:[UIFont montserratLightWithSize:13] widthValue:[[UIScreen mainScreen] bounds].size.width-40-124 heightValue:1000];
    _trackTItle.translatesAutoresizingMaskIntoConstraints=true;
    _trackNumberButton.translatesAutoresizingMaskIntoConstraints=true;
    _trackTItle.frame=CGRectMake(10, 10, rectSizeWidth, height);
    _trackTItle.text=orderData.productName;

     [_trackNumberButton setTitle:[NSString stringWithFormat:@"#%@",orderData.trackNumber] forState:UIControlStateNormal];
    [_trackNumberButton sizeToFit];
    _trackNumberButton.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width-30-(_trackNumberButton.frame.size.width>114?114:_trackNumberButton.frame.size.width), _trackTItle.frame.origin.y+(_trackTItle.frame.size.height/2)-10,(_trackNumberButton.frame.size.width>114?114:_trackNumberButton.frame.size.width), 18);
    [_trackNumberButton setBottomBorder:_trackNumberButton color:[UIColor colorWithRed:182.0/255.0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0]];
   
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
}
#pragma mark - end

#pragma mark - Remove autolayouts
- (void)removeAutolayouts {
    _productNameLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _skuLabel.translatesAutoresizingMaskIntoConstraints=YES;
}
#pragma mark - end
@end
