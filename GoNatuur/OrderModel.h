//
//  OrderModel.h
//  GoNatuur
//
//  Created by Monika on 9/8/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject
//Order listing
@property (strong, nonatomic) NSString *purchaseOrderId;
@property (strong, nonatomic) NSString *orderId;
@property (strong, nonatomic) NSString *orderDate;
@property (strong, nonatomic) NSString *shippingAddress;
@property (strong, nonatomic) NSString *BillingAddress;
@property (strong, nonatomic) NSString *orderStatus;
@property (strong, nonatomic) NSString *orderState;
@property (strong, nonatomic) NSString *orderPrice;
@property (strong, nonatomic) NSString *currencyCode;
@property (strong, nonatomic) NSString *billingAddressId;
@property (strong, nonatomic) NSString *shippingMethod;
@property (strong, nonatomic) NSString *paymentMethod;
@property (strong, nonatomic) NSNumber *totalProductCount;
@property (strong, nonatomic) NSNumber *currentPage;
@property (strong, nonatomic) NSNumber *pageSize;
@property (strong, nonatomic) NSString *event;

@property (strong, nonatomic) NSMutableArray *orderListingArray;
@property (strong, nonatomic) NSMutableArray *productListingArray;
@property (strong, nonatomic) NSDictionary *fullShippingAddress;
@property (strong, nonatomic) NSDictionary *fullBillingAddress;

//Order detail
@property (strong, nonatomic) NSString *isOrderDetailService;
@property (strong, nonatomic) NSString *productName;
@property (strong, nonatomic) NSString *productSku;
@property (strong, nonatomic) NSString *productPrice;
@property (strong, nonatomic) NSString *productQuantity;
@property (strong, nonatomic) NSString *productSubTotal;
@property (strong, nonatomic) NSString *productType;
@property (strong, nonatomic) NSString *productId;
@property (strong, nonatomic) NSString *orderReturnSuccess;

//Order total
@property (strong, nonatomic) NSString *baseCurrencyCode;
@property (strong, nonatomic) NSString *orderSubTotal;
@property (strong, nonatomic) NSString *baseGrandTotal;
@property (strong, nonatomic) NSString *shippingAmount;
@property (strong, nonatomic) NSString *taxAmount;
@property (strong, nonatomic) NSString *tax;
@property (strong, nonatomic) NSString *discountAmount;
@property (strong, nonatomic) NSString *discountDescription;

//Ticket option
@property (strong, nonatomic) NSString *ticketProductId;
@property (strong, nonatomic) NSString *ticketName;
@property (strong, nonatomic) NSMutableArray *ticketListingArray;

//Order invoice
@property (assign, nonatomic) BOOL isOrderInvoice;
@property (assign, nonatomic) BOOL isTrackShippment;
@property (strong, nonatomic) NSMutableArray *orderInvoiceArray;
@property (strong, nonatomic) NSMutableArray *trackArray;
@property (strong, nonatomic) NSMutableArray *orderShipmentDataArray;
@property (strong, nonatomic) NSString *trackNumber;

//Singleton instanse
+ (instancetype)sharedUser;

//Order listing data
- (void)getOrderListing:(void (^)(OrderModel *))success onfailure:(void (^)(NSError *))failure;
//Cancel order
- (void)cancelOrderService:(void (^)(OrderModel *))success onfailure:(void (^)(NSError *))failure;
//Get ticket option
- (void)getTicketOption:(void (^)(OrderModel *))success onfailure:(void (^)(NSError *))failure;
//Get order invoice
- (void)getOrderInvoiceOnSuccess:(void (^)(OrderModel *))success onfailure:(void (^)(NSError *))failure;
//return status
- (void)getOrderReturnStatusData:(void (^)(OrderModel *))success onfailure:(void (^)(NSError *))failure;
@end
