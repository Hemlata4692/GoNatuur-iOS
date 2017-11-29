//
//  ThankYouTableCell.m
//  GoNatuur
//
//  Created by Monika on 9/5/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ThankYouTableCell.h"
#import "DynamicHeightWidth.h"

@implementation ThankYouTableCell
@synthesize thankYouDescriptionLabel, rewardInfoLabel,orderIdLabel,thankYouLabel,totalLabel,productName,productPriceLabel,productQuantityLabel,productImage;
#pragma mark - Cell life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
#pragma mark - end

#pragma mark - Display data
- (void)displayData:(CGSize)rectSize orderId:(NSString *)orderId {
    thankYouLabel.text = NSLocalizedText(@"thanksText");
    thankYouLabel.translatesAutoresizingMaskIntoConstraints=YES;
    thankYouLabel.frame=CGRectMake(10, 0,rectSize.width-20, thankYouLabel.frame.size.height);
    orderIdLabel.text = [NSString stringWithFormat:@"%@ #%@",NSLocalizedText(@"purchaseOrderText"),orderId];
    orderIdLabel.translatesAutoresizingMaskIntoConstraints=YES;
    orderIdLabel.frame=CGRectMake(10, thankYouLabel.frame.origin.y+thankYouLabel.frame.size.height+8,rectSize.width-20, orderIdLabel.frame.size.height);
    thankYouDescriptionLabel.text = NSLocalizedText(@"thankDescText");
    thankYouDescriptionLabel.translatesAutoresizingMaskIntoConstraints=YES;
    thankYouDescriptionLabel.numberOfLines=0;
    float newHeight =[DynamicHeightWidth getDynamicLabelHeight:thankYouDescriptionLabel.text font:[UIFont montserratRegularWithSize:12] widthValue:rectSize.width-20 heightValue:500];
    thankYouDescriptionLabel.frame=CGRectMake(10, orderIdLabel.frame.origin.y+orderIdLabel.frame.size.height+4,rectSize.width-20, newHeight+10);
    rewardInfoLabel.text= NSLocalizedText(@"guestMessage");
    rewardInfoLabel.translatesAutoresizingMaskIntoConstraints=YES;
    rewardInfoLabel.numberOfLines=0;
    float rewardHeight =[DynamicHeightWidth getDynamicLabelHeight:rewardInfoLabel.text font:[UIFont montserratRegularWithSize:12] widthValue:rectSize.width-20 heightValue:500];
    rewardInfoLabel.frame=CGRectMake(10, 0,rectSize.width-20, rewardHeight);
}

- (void)displayPurchaseData:(CGSize)rectSize {
    _purchaseLabel.text = NSLocalizedText(@"purchaseText");
}

- (void)displayOrderTotalData:(CGSize)rectSize finalCheckoutPriceDict:(NSDictionary *)finalCheckoutPriceDict{
    _cartSubtotalHeadingLabel.text = NSLocalizedText(@"cartSubtotal");
    _creditPointsHeadingLabel.text = NSLocalizedText(@"creditPoints");
    _pointsSubtotalHeadinglabel.text = NSLocalizedText(@"pointsSubtotal");
    _shippingHeadingLabel.text = NSLocalizedText(@"shipping");
    _promotionDiscountHeadingLabel.text = NSLocalizedText(@"promotionDiscount");
    _taxHeadingLabel.text = NSLocalizedText(@"taxTitle");
    _couponHeadingLabel.text = finalCheckoutPriceDict[@"couponCode"];
    _totalHeadingLabel.text = NSLocalizedText(@"orderTotal");
    
    //Cart subtotal
    if (finalCheckoutPriceDict[@"Cart subtotal"] == nil) {
        _cartSubtotalLabel.text = [NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],0.00];
    } else {
        _cartSubtotalLabel.text = finalCheckoutPriceDict[@"Cart subtotal"];
    }
    //Credit points
    if (finalCheckoutPriceDict[@"creditPoints"] == nil) {
        _creditPointsLabel.text = [NSString stringWithFormat:@"%fip",0.00];
    } else {
        _creditPointsLabel.text = finalCheckoutPriceDict[@"creditPoints"];
    }
    //Points subtotal
    if (finalCheckoutPriceDict[@"Points subtotal"] == nil) {
        _pointsSubtotalLabel.text = [NSString stringWithFormat:@"%fip",0.00];
    } else {
        _pointsSubtotalLabel.text = finalCheckoutPriceDict[@"Points subtotal"];
    }
    //Shipping
    if (finalCheckoutPriceDict[@"Shipping charges"] == nil) {
        _shippingLabel.text = [NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],0.00];
    } else {
        _shippingLabel.text = finalCheckoutPriceDict[@"Shipping charges"];
    }
    //Promotion discount
    if (finalCheckoutPriceDict[@"Discount"] == nil) {
        _promotionDiscountLabel.text = [NSString stringWithFormat:@"-%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],0.00];
    } else {
        _promotionDiscountLabel.text = finalCheckoutPriceDict[@"Discount"];
    }
    //Tax
    if (finalCheckoutPriceDict[@"Tax"] == nil) {
        _taxLabel.text = [NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],0.00];
    } else {
        _taxLabel.text = [NSString stringWithFormat:@"%@",finalCheckoutPriceDict[@"Tax"]];
    }
    //Coupon
    if (finalCheckoutPriceDict[@"couponCodeDiscount"] == nil) {
        _couponLabel.text = [NSString stringWithFormat:@"-%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],0.00];
    } else {
        _couponLabel.text = [NSString stringWithFormat:@"%@",finalCheckoutPriceDict[@"couponCodeDiscount"]];
    }
    //Grand total
    if (finalCheckoutPriceDict[@"Grand Total"] == nil) {
        totalLabel.text = [NSString stringWithFormat:@"%fip",0.00];
    } else {
        totalLabel.text = [NSString stringWithFormat:@"%@",finalCheckoutPriceDict[@"Grand Total"]];
    }
}

- (void)displayCartListData:(CartDataModel *)cartData rectSize:(CGSize)rectSize {
    [self removeAutolayout];
    //Reframe product name label
    float height=[DynamicHeightWidth getDynamicLabelHeight:cartData.itemName font:[UIFont montserratRegularWithSize:11] widthValue:rectSize.width-228];
    productName.frame=CGRectMake(88, (productImage.frame.origin.y + productImage.frame.size.height/2) - (height/2), rectSize.width-228, height);
    productName.text=cartData.itemName;
    //Reframe product price label
    height=[DynamicHeightWidth getDynamicLabelHeight:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],(([[cartData itemPrice] floatValue]*[cartData.itemQty floatValue])*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] font:[UIFont montserratRegularWithSize:11] widthValue:54];
    productPriceLabel.frame=CGRectMake(rectSize.width-62, (productImage.frame.origin.y + productImage.frame.size.height/2) - (height/2), 54, height);
    productPriceLabel.text=[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],(([[cartData itemPrice] floatValue]*[cartData.itemQty floatValue])*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])];
    //Reframe product quantity label
    height=[DynamicHeightWidth getDynamicLabelHeight:[NSString stringWithFormat:@"%@",cartData.itemQty] font:[UIFont montserratRegularWithSize:11] widthValue:64];
    productQuantityLabel.frame=CGRectMake(productPriceLabel.frame.origin.x-71, (productImage.frame.origin.y + productImage.frame.size.height/2) - (height/2), 64, height);
    productQuantityLabel.text=[NSString stringWithFormat:@"%@",cartData.itemQty];
    [ImageCaching downloadImages:productImage imageUrl:cartData.itemImageUrl placeholderImage:@"product_placeholder" isDashboardCell:false];
}

- (void)removeAutolayout {
    productName.translatesAutoresizingMaskIntoConstraints=true;
    productQuantityLabel.translatesAutoresizingMaskIntoConstraints=true;
    productPriceLabel.translatesAutoresizingMaskIntoConstraints=true;
}
#pragma mark - end

@end
