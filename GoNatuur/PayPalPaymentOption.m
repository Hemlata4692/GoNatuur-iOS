//
//  PayPalPaymentOption.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 06/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "PayPalPaymentOption.h"

@implementation PayPalPaymentOption

#pragma mark - Configure paypal account
- (void) configPaypalPayment:(NSString *)environment {
    //sandbox
   //PayPalEnvironmentSandbox;
    //live
    //PayPalEnvironmentNoNetwork
    [PayPalMobile preconnectWithEnvironment:environment];
    // Set up payPalConfig
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.merchantName = @"Awesome Shirts, Inc.";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionNone;
}
#pragma mark - end

#pragma mark - Setup payment details
- (void)setPaymentDetails:(NSMutableArray *)dataArray delegate:(id)delegate {
    // Note: For purposes of illustration, this example shows a payment that includes
    //       both payment details (subtotal, shipping, tax) and multiple items.
    //       You would only specify these if appropriate to your situation.
    //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
    //       and simply set payment.amount to your total charge.
    
    // Optional: include multiple items
    NSMutableArray *tempArray=[[NSMutableArray alloc]init];
    for (int i=0; i<dataArray.count; i++) {
        PayPalItem *item = [PayPalItem itemWithName:@"Old jeans with holes"
                                        withQuantity:2
                                           withPrice:[NSDecimalNumber decimalNumberWithString:@"84.99"]
                                        withCurrency:@"USD"
                                             withSku:@"Hip-00037"];
        [tempArray addObject:item];
    }
    NSArray *itemArray = [tempArray copy];

    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:itemArray];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"5.99"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"2.50"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"USD";
    payment.shortDescription = @"Hipster clothing";
    payment.items = itemArray;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:delegate];
    [delegate presentViewController:paymentViewController animated:YES completion:nil];
}
#pragma mark - end
@end
