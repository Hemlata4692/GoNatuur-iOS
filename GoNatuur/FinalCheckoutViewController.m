//
//  FinalCheckoutViewController.m
//  GoNatuur
//
//  Created by Ranosys on 12/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "FinalCheckoutViewController.h"
#import "FinalCheckoutTableViewCell.h"
#import "UIView+RoundedCorner.h"
#import "UITextField+Padding.h"
#import "CardListViewController.h"
#import "GoNatuurPickerView.h"
#import "BSKeyboardControls.h"
#import "ThankYouViewController.h"
#import "NewsLetterSubscriptionViewController.h"
#import "PaymentWebViewController.h"
#import "UITextField+Validations.h"

#define selectedStepColor   [UIColor colorWithRed:182.0/255.0 green:36.0/255.0 blue:70.0/255.0 alpha:1.0]
#define unSelectedStepColor [UIColor lightGrayColor]
#define borderRadioColor [UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]
#define paymentBorderColor [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.3]
#define selectedPaymentMethodColor  [UIColor colorWithRed:250.0/255.0 green:241.0/255.0 blue:244.0/255.0 alpha:1.0]
#define textFieldBorderColor  [UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]



@interface FinalCheckoutViewController ()<GoNatuurPickerViewDelegate,BSKeyboardControlsDelegate,ApplyCouponDelegate> {
@private
    NSMutableArray *paymentMethodArray, *cardTypeDataArray, *cardTypeCodeArray;
    NSDictionary *cartItemPrice;
    int selectedPaymentMethodIndex;
    NSArray *totalArray;
    NSMutableDictionary *totalDict, *paymentMethodDict;
    bool isCyberSourceExist, isApplyCouponExist;
    bool isCreditUser;
    bool isCyberSourcePayment;
    bool isCardAdd, isSelectCard, isFreeProduct;
    int selectedPickerIndex;
    GoNatuurPickerView *gNPickerViewObj;
    NSString *selectedCardTypeId, *encryptedSubscriptionId;
}
//View objects declaration
@property (strong, nonatomic) IBOutlet UILabel *freeShippingLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstStepLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondStepLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdStepLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstStepSeperetorLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondStepSeperetorLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UITableView *cartItemsTableView;
@property (strong, nonatomic) IBOutlet UIView *cartListView;
@property (strong, nonatomic) IBOutlet UILabel *summaryLabel;
@property (strong, nonatomic) IBOutlet UIView *paymentView;
@property (strong, nonatomic) IBOutlet UIView *cyberSourceView;
@property (strong, nonatomic) IBOutlet UICollectionView *paymentCollectionView;
@property (weak, nonatomic) IBOutlet UIView *addCardView;
@property (weak, nonatomic) IBOutlet UITextField *cardHolderName;
@property (weak, nonatomic) IBOutlet UITextField *cardNumber;
@property (weak, nonatomic) IBOutlet UITextField *cardType;
@property (weak, nonatomic) IBOutlet UITextField *monthField;
@property (weak, nonatomic) IBOutlet UITextField *yearField;
@property (weak, nonatomic) IBOutlet UITextField *cvvField;
@property (weak, nonatomic) IBOutlet UILabel *selectCarRadioLabel;
@property (weak, nonatomic) IBOutlet UIButton *cardTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *placeOrderButton;
@property (weak, nonatomic) IBOutlet UILabel *selectCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *addCardRadioLabel;
@property (weak, nonatomic) IBOutlet UILabel *addCardLabel;
@property (weak, nonatomic) IBOutlet UIButton *addCardButton;
@property (weak, nonatomic) IBOutlet UIButton *selectCardButton;
//Declare BSKeyboard variable
@property (strong, nonatomic) BSKeyboardControls *keyboardControls;
@end

@implementation FinalCheckoutViewController
@synthesize cartModelData;
@synthesize cartListDataArray;
@synthesize finalCheckoutPriceDict;
@synthesize selectedCardDataDict;
@synthesize isCreditCustomer;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInitialization];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"GoNatuur");
    [self addLeftBarButtonWithImage:true];
    [self setSelectedCardData];
    if ([cartModelData.extensionAttributeDict[@"has_subscription_product"] isEqualToString:@"1"]) {
        _selectCardButton.enabled=false;
        _addCardButton.enabled=false;
        _selectCardLabel.alpha=0.3;
        _selectCardButton.alpha=0.3;
        _addCardLabel.alpha=0.3;
        _addCardButton.alpha=0.3;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    //Bring front view picker view
    [self.view bringSubviewToFront:gNPickerViewObj.goNatuurPickerViewObj];
    
}

- (void)applyCoupon:(NSString *)couponApplied {
    if ([couponApplied isEqualToString:@"1"]) {
        //removeCouponCode
        [myDelegate showIndicator];
        [self performSelector:@selector(getCartList) withObject:nil afterDelay:.1];
    }
}

- (void)setSelectedCardData {
    if (selectedCardDataDict!=nil) {
        isCyberSourcePayment=true;
        _cardNumber.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedText(@"cardNumberList"),selectedCardDataDict.cardLastFourDigit];
        _cardHolderName.text = [NSString stringWithFormat:@"%@ %@",selectedCardDataDict.firstname,selectedCardDataDict.lastname];
        _monthField.text = selectedCardDataDict.cardExpMonth;
        _yearField.text = selectedCardDataDict.cardExpYear;
        _cardType.text=selectedCardDataDict.cardType;
        encryptedSubscriptionId=selectedCardDataDict.encryptedSubscriptionId;
        _yearField.userInteractionEnabled=false;
        _monthField.userInteractionEnabled=false;
        _cardHolderName.userInteractionEnabled=false;
        _cardNumber.userInteractionEnabled=false;
        _cardTypeButton.userInteractionEnabled=false;
        _cardType.userInteractionEnabled=false;
    }
    else {
        _cardNumber.text = @"";
        _cardHolderName.text = @"";
        _monthField.text = @"";
        _yearField.text = @"";
        _cardType.text=@"";
        _yearField.userInteractionEnabled=true;
        _monthField.userInteractionEnabled=true;
        _cardHolderName.userInteractionEnabled=true;
        _cardNumber.userInteractionEnabled=true;
        _cardTypeButton.userInteractionEnabled=true;
        _cardType.userInteractionEnabled=true;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addCustomPickerView {
    //Set initial index of picker view and initialized picker view
    selectedPickerIndex=0;
    cardTypeDataArray=[NSMutableArray new];
    gNPickerViewObj=[[GoNatuurPickerView alloc] initWithFrame:self.view.frame delegate:self pickerHeight:230];
    [self.view addSubview:gNPickerViewObj.goNatuurPickerViewObj];
}
#pragma mark - end

#pragma mark - View customisation
- (void)viewInitialization {
    [self showSelectedTab:2];
    [self addCustomPickerView];
    //Adding textfield to keyboard controls array
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:@[_cardHolderName, _cardNumber, _monthField,_yearField, _cvvField]]];
    [_keyboardControls setDelegate:self];
    //Customized steps
    [self customizedSteps];
    [self setLocalizedText];
    totalDict=[NSMutableDictionary new];
    totalArray=@[];
    isCreditUser=isCreditCustomer;
    [finalCheckoutPriceDict setObject:[NSNumber numberWithDouble:0.0] forKey:@"Apply coupon code"];
    if (nil==[UserDefaultManager getValue:@"userId"]) {
        _selectCardButton.enabled=false;
        _selectCardLabel.alpha=0.3;
        _selectCardButton.alpha=0.3;
    }
    [self setPrices];
    [self cyberSourcePayment:false];
    [self getDataFromCartModel];
    [self customizedFraming];
}

- (void)removeAutolayout {
    _firstStepLabel.translatesAutoresizingMaskIntoConstraints=true;
    _secondStepLabel.translatesAutoresizingMaskIntoConstraints=true;
    _thirdStepLabel.translatesAutoresizingMaskIntoConstraints=true;
    _firstStepSeperetorLabel.translatesAutoresizingMaskIntoConstraints=true;
    _secondStepSeperetorLabel.translatesAutoresizingMaskIntoConstraints=true;
    _mainView.translatesAutoresizingMaskIntoConstraints=true;
    _cartListView.translatesAutoresizingMaskIntoConstraints=true;
    _cartItemsTableView.translatesAutoresizingMaskIntoConstraints=true;
    _paymentView.translatesAutoresizingMaskIntoConstraints=true;
    _cyberSourceView.translatesAutoresizingMaskIntoConstraints=true;
    _paymentCollectionView.translatesAutoresizingMaskIntoConstraints=true;
    _addCardView.translatesAutoresizingMaskIntoConstraints=true;
}

- (void)setRoundedStepView {
    _firstStepLabel.layer.masksToBounds=true;
    _firstStepLabel.layer.cornerRadius=11;
    _secondStepLabel.layer.masksToBounds=true;
    _secondStepLabel.layer.cornerRadius=11;
    _thirdStepLabel.layer.masksToBounds=true;
    _thirdStepLabel.layer.cornerRadius=11;
    _selectCarRadioLabel.layer.cornerRadius=6;
    _selectCarRadioLabel.layer.masksToBounds=true;
    _addCardRadioLabel.layer.cornerRadius=6;
    _addCardRadioLabel.layer.masksToBounds=true;
    
    [_cardType setTextBorder:_cardType color:textFieldBorderColor];
    [_cardNumber setTextBorder:_cardNumber color:textFieldBorderColor];
    [_cardHolderName setTextBorder:_cardHolderName color:textFieldBorderColor];
    [_monthField setTextBorder:_monthField color:textFieldBorderColor];
    [_yearField setTextBorder:_yearField color:textFieldBorderColor];
    [_cvvField setTextBorder:_cvvField color:textFieldBorderColor];
    [_cardType addTextFieldPaddingWithoutImages:_cardType];
    [_cardNumber addTextFieldPaddingWithoutImages:_cardNumber];
    [_cardHolderName addTextFieldPaddingWithoutImages:_cardHolderName];
    [_monthField addTextFieldPaddingWithoutImages:_monthField];
    [_yearField addTextFieldPaddingWithoutImages:_yearField];
    [_cvvField addTextFieldPaddingWithoutImages:_cvvField];
}

- (void)setDefaultStepColor {
    _firstStepLabel.backgroundColor=unSelectedStepColor;
    _firstStepSeperetorLabel.backgroundColor=unSelectedStepColor;
    _secondStepLabel.backgroundColor=unSelectedStepColor;
    _secondStepSeperetorLabel.backgroundColor=unSelectedStepColor;
    _thirdStepLabel.backgroundColor=unSelectedStepColor;
}

- (void)customizedSteps {
    //Remove autolayout
    [self removeAutolayout];
    //Set round step labels
    [self setRoundedStepView];
    //Get single step separator width according to screen size
    float singleSeparatorWidth=([[UIScreen mainScreen] bounds].size.width-106.0)/2.0;
    _firstStepLabel.frame=CGRectMake(20, 20, 22, 22);
    _firstStepSeperetorLabel.frame=CGRectMake(_firstStepLabel.frame.origin.x+_firstStepLabel.frame.size.width-2, 27, singleSeparatorWidth+4, 8);
    _secondStepLabel.frame=CGRectMake(_firstStepSeperetorLabel.frame.origin.x+_firstStepSeperetorLabel.frame.size.width-2, 20, 22, 22);
    _secondStepSeperetorLabel.frame=CGRectMake(_secondStepLabel.frame.origin.x+_secondStepLabel.frame.size.width-2, 27, singleSeparatorWidth+4, 8);
    _thirdStepLabel.frame=CGRectMake(_secondStepSeperetorLabel.frame.origin.x+_secondStepSeperetorLabel.frame.size.width-2, 20, 22, 22);
    //Set default color at steps
    [self setDefaultStepColor];
    _firstStepLabel.backgroundColor=selectedStepColor;
    _firstStepSeperetorLabel.backgroundColor=selectedStepColor;
    _secondStepLabel.backgroundColor=selectedStepColor;
    _secondStepSeperetorLabel.backgroundColor=selectedStepColor;
    _thirdStepLabel.backgroundColor=selectedStepColor;
}

- (void)cyberSourcePayment:(BOOL)isCyberSourcePaymentSelcted {
    isCyberSourcePayment=isCyberSourcePaymentSelcted;
    if (isCyberSourcePaymentSelcted) {
        if (isSelectCard) {
            _selectCarRadioLabel.backgroundColor=selectedStepColor;
            _selectCarRadioLabel.layer.borderWidth=1.0;
            _selectCarRadioLabel.layer.borderColor=selectedStepColor.CGColor;
            
            _addCardRadioLabel.backgroundColor=[UIColor whiteColor];
            _addCardRadioLabel.layer.borderWidth=1.0;
            _addCardRadioLabel.layer.borderColor=selectedStepColor.CGColor;
        }
        else {
            _selectCarRadioLabel.backgroundColor=[UIColor whiteColor];
            _selectCarRadioLabel.layer.borderWidth=1.0;
            _selectCarRadioLabel.layer.borderColor=selectedStepColor.CGColor;
            
            _addCardRadioLabel.backgroundColor=selectedStepColor;
            _addCardRadioLabel.layer.borderWidth=1.0;
            _addCardRadioLabel.layer.borderColor=selectedStepColor.CGColor;
        }
    }
    else {
         isCyberSourceExist = true;
        isCardAdd=false;
        _selectCarRadioLabel.backgroundColor=[UIColor whiteColor];
        _selectCarRadioLabel.layer.borderWidth=1.0;
        _selectCarRadioLabel.layer.borderColor=selectedStepColor.CGColor;
        
        _addCardRadioLabel.backgroundColor=[UIColor whiteColor];
        _addCardRadioLabel.layer.borderWidth=1.0;
        _addCardRadioLabel.layer.borderColor=selectedStepColor.CGColor;
        [self customizedFraming];
    }
}

- (void)setLocalizedText {
    //Set localized string
    _freeShippingLabel.text=NSLocalizedText(@"cartListFreeShipping");
    _summaryLabel.text=NSLocalizedText(@"summary");
    _addCardLabel.text=NSLocalizedText(@"addCardCheckout");
    _selectCardLabel.text=NSLocalizedText(@"selectCard");
    _cardHolderName.placeholder=NSLocalizedText(@"cardholder");
    _cardNumber.placeholder=NSLocalizedText(@"cardnumber");
    _monthField.placeholder=NSLocalizedText(@"month");
    _yearField.placeholder=NSLocalizedText(@"year");
    _cvvField.placeholder=NSLocalizedText(@"cvv");
    _cardType.placeholder=NSLocalizedText(@"cardType");
    NSMutableArray *tempArray=[[UserDefaultManager getValue:@"cardTypes"] mutableCopy];
    for (int i=0; i<tempArray.count; i++) {
        NSDictionary *dataDict=[[NSDictionary alloc]init];
        dataDict=[tempArray objectAtIndex:i];
        [cardTypeDataArray addObject:[dataDict objectForKey:@"name"]];
        [cardTypeCodeArray addObject:[dataDict objectForKey:@"value"]];
    }
}

- (void)customizedFraming {
    if ((nil==[UserDefaultManager getValue:@"userId"])) {
        _cartItemsTableView.frame=CGRectMake(0, 35, [[UIScreen mainScreen] bounds].size.width, (93*cartListDataArray.count)+(totalArray.count*35)+55);
    }
    else {
        _cartItemsTableView.frame=CGRectMake(0, 35, [[UIScreen mainScreen] bounds].size.width, (93*cartListDataArray.count)+(totalArray.count*35));
    }
    _cartListView.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, _cartItemsTableView.frame.size.height+_cartItemsTableView.frame.origin.y);
    
    if (isCyberSourceExist&&paymentMethodArray.count>1&&isCardAdd) {
        _cyberSourceView.frame=CGRectMake(0, 34, [[UIScreen mainScreen] bounds].size.width-30, 44);
        _addCardView.hidden=false;
        _addCardView.frame=CGRectMake(0, _cyberSourceView.frame.origin.y+_cyberSourceView.frame.size.height+8, [[UIScreen mainScreen] bounds].size.width-30, 204);
        _paymentCollectionView.frame=CGRectMake(0, _addCardView.frame.origin.y+_addCardView.frame.size.height+12, [[UIScreen mainScreen] bounds].size.width-30, 78);
    }
    else if (isCyberSourceExist&&!isCardAdd&&paymentMethodArray.count>1) {
        _cyberSourceView.frame=CGRectMake(0, 34, [[UIScreen mainScreen] bounds].size.width-30, 44);
        _addCardView.frame=CGRectMake(0, _cyberSourceView.frame.origin.y+_cyberSourceView.frame.size.height+8, [[UIScreen mainScreen] bounds].size.width-30, 0);
        _addCardView.hidden=true;
        _paymentCollectionView.frame=CGRectMake(0, _addCardView.frame.origin.y+_addCardView.frame.size.height+12, [[UIScreen mainScreen] bounds].size.width-30, 78);
    }
    else if (isCyberSourceExist&&!isCardAdd) {
        _cyberSourceView.frame=CGRectMake(0, 34, [[UIScreen mainScreen] bounds].size.width-30, 44);
        _addCardView.frame=CGRectMake(0, _cyberSourceView.frame.origin.y+_cyberSourceView.frame.size.height+8, [[UIScreen mainScreen] bounds].size.width-30, 0);
        _addCardView.hidden=true;
        _paymentCollectionView.frame=CGRectMake(0, _addCardView.frame.origin.y+_addCardView.frame.size.height+12, [[UIScreen mainScreen] bounds].size.width-30, 0);
    }
    else if (!isCyberSourceExist&&paymentMethodArray.count>0) {
        _cyberSourceView.frame=CGRectMake(0, 34, [[UIScreen mainScreen] bounds].size.width-30, 44);
        _addCardView.frame=CGRectMake(0, 34, [[UIScreen mainScreen] bounds].size.width-30, 0);
        _addCardView.hidden=true;
        _paymentCollectionView.frame=CGRectMake(0, 34, [[UIScreen mainScreen] bounds].size.width-30, 78);
    }
    else {
        _cyberSourceView.frame=CGRectMake(0, 34, [[UIScreen mainScreen] bounds].size.width-30, 44);
        _addCardView.frame=CGRectMake(0, 34, [[UIScreen mainScreen] bounds].size.width-30, 0);
        _addCardView.hidden=true;
        _paymentCollectionView.frame=CGRectMake(0, 34, [[UIScreen mainScreen] bounds].size.width-30, 0);
    }
    
    if ((_cyberSourceView.frame.size.height==0)&&(_paymentCollectionView.frame.size.height==0)) {
        _paymentView.frame=CGRectMake(15, _cartListView.frame.size.height+_cartListView.frame.origin.y+8, [[UIScreen mainScreen] bounds].size.width-30, 0);
    }
    else {
        if (isCardAdd) {
            _paymentView.frame=CGRectMake(15, _cartListView.frame.size.height+_cartListView.frame.origin.y+8, [[UIScreen mainScreen] bounds].size.width-30, (_cyberSourceView.frame.size.height==0?(_paymentCollectionView.frame.origin.y+_paymentCollectionView.frame.size.height):(_cyberSourceView.frame.origin.y+_cyberSourceView.frame.size.height+17+_paymentCollectionView.frame.size.height+_paymentCollectionView.frame.size.height+204)));
        }
        else {
            _paymentView.frame=CGRectMake(15, _cartListView.frame.size.height+_cartListView.frame.origin.y+8, [[UIScreen mainScreen] bounds].size.width-30, (_cyberSourceView.frame.size.height==0?(_paymentCollectionView.frame.origin.y+_paymentCollectionView.frame.size.height):(_cyberSourceView.frame.origin.y+_cyberSourceView.frame.size.height+17+_paymentCollectionView.frame.size.height+_paymentCollectionView.frame.size.height)));
        }
    }
    _mainView.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, _paymentView.frame.size.height+_paymentView.frame.origin.y+80);
    [_paymentCollectionView reloadData];
}

- (void)getDataFromCartModel {
    selectedPaymentMethodIndex=-1;
    DLog(@"%@",[cartModelData.checkoutFinalData objectForKey:@"payment_methods"]);
    paymentMethodArray=[NSMutableArray arrayWithObjects:@"free",@"magedelight_cybersource", @"paypal_express", @"tenpaypayment", @"alipay", nil];
    paymentMethodDict=[NSMutableDictionary new];
     isCyberSourceExist=true;
    for (NSDictionary *tempDict in [cartModelData.checkoutFinalData objectForKey:@"payment_methods"]) {
        if ([tempDict[@"code"] isEqualToString:@"magedelight_cybersource"]) {
            [paymentMethodDict setObject:[tempDict copy] forKey:@"magedelight_cybersource"];
            continue;
        }
        else if ([tempDict[@"code"] isEqualToString:@"tenpaypayment"]) {
            [paymentMethodDict setObject:[tempDict copy] forKey:@"tenpaypayment"];
            continue;
        }
        else if ([tempDict[@"code"] isEqualToString:@"paypal_express"]) {
            [paymentMethodDict setObject:[tempDict copy] forKey:@"paypal_express"];
            continue;
        }
        else if ([tempDict[@"code"] isEqualToString:@"alipay"]) {
            [paymentMethodDict setObject:[tempDict copy] forKey:@"alipay"];
            continue;
        }
        else if ([tempDict[@"code"] isEqualToString:@"free"]) {
            [paymentMethodDict setObject:[tempDict copy] forKey:@"free"];
            continue;
        }
    }
    NSMutableArray *tempArray=[paymentMethodArray mutableCopy];
    for (NSString *temp in tempArray) {
        if (![[paymentMethodDict allKeys] containsObject:temp]) {
            [paymentMethodArray removeObject:temp];
        }
    }
    cartItemPrice=[[cartModelData.checkoutFinalData objectForKey:@"totals"] copy];
    if ([paymentMethodArray containsObject:@"free"]) {
        isFreeProduct=true;
        _paymentView.hidden=true;
    }
    else{
        isFreeProduct=false;
    }
}
#pragma mark - end

#pragma mark - Manage price title and value in dictionary
- (void)setPrices {
    isApplyCouponExist=true;
    //For guest user
    if ((nil==[UserDefaultManager getValue:@"userId"])) {
        totalArray=@[@"Cart subtotal", @"Shipping charges", @"Tax" ,@"Apply coupon code", @"Grand Total"];
        [totalDict setObject:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([finalCheckoutPriceDict[@"Cart subtotal"] floatValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Cart subtotal"];
        [totalDict setObject:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([finalCheckoutPriceDict[@"Apply coupon code"] floatValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Apply coupon code"];
        [totalDict setObject:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],(([finalCheckoutPriceDict[@"Cart subtotal"] floatValue]+[finalCheckoutPriceDict[@"Shipping charges"] floatValue])*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Grand Total"];
    }
    else if (isCreditUser) {
        [self setPriceForCreditUser];
    }
    else {
        [self setPriceForCashUser];
    }
    [totalDict setObject:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([finalCheckoutPriceDict[@"Shipping charges"] floatValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Shipping charges"];
    [totalDict setObject:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([finalCheckoutPriceDict[@"Tax"] floatValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Tax"];
}

- (void)setRedeemProductsWithApplyCouponCode {
    [totalDict setObject:[NSString stringWithFormat:@"%@ip",finalCheckoutPriceDict[@"Points subtotal"]] forKey:@"Points subtotal"];
    [totalDict setObject:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([finalCheckoutPriceDict[@"Apply coupon code"] floatValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Apply coupon code"];
    [totalDict setObject:[NSString stringWithFormat:@"-%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([finalCheckoutPriceDict[@"Discount"] floatValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Discount"];
    [totalDict setObject:[NSString stringWithFormat:@"%@%.2f + %@ip",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([finalCheckoutPriceDict[@"Shipping charges"] floatValue]-[finalCheckoutPriceDict[@"Discount"] floatValue]),finalCheckoutPriceDict[@"Points subtotal"]] forKey:@"Grand Total"];
}

- (void)setRedeemProductsWithOutApplyCouponCode {
    [totalDict setObject:[NSString stringWithFormat:@"%@ip",finalCheckoutPriceDict[@"Points subtotal"]] forKey:@"Points subtotal"];
    [totalDict setObject:[NSString stringWithFormat:@"-%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([finalCheckoutPriceDict[@"Discount"] floatValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Discount"];
    [totalDict setObject:[NSString stringWithFormat:@"%@%.2f + %@ip",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([finalCheckoutPriceDict[@"Shipping charges"] floatValue]-[finalCheckoutPriceDict[@"Discount"] floatValue]),finalCheckoutPriceDict[@"Points subtotal"]] forKey:@"Grand Total"];
}

- (void)setOnlyForSimpleProducts {
    [totalDict setObject:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([finalCheckoutPriceDict[@"Apply coupon code"] floatValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Apply coupon code"];
    [totalDict setObject:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([finalCheckoutPriceDict[@"Cart subtotal"] floatValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Cart subtotal"];
    [totalDict setObject:[NSString stringWithFormat:@"-%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([finalCheckoutPriceDict[@"Discount"] floatValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Discount"];
    [totalDict setObject:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],(([finalCheckoutPriceDict[@"Cart subtotal"] floatValue]+[finalCheckoutPriceDict[@"Shipping charges"] floatValue]-[finalCheckoutPriceDict[@"Discount"] floatValue])*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Grand Total"];
}

- (void)setForBothSimpleAndRedeemProducts {
    [totalDict setObject:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([finalCheckoutPriceDict[@"Apply coupon code"] floatValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Apply coupon code"];
    [totalDict setObject:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([finalCheckoutPriceDict[@"Cart subtotal"] floatValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Cart subtotal"];
    [totalDict setObject:[NSString stringWithFormat:@"%@ip",finalCheckoutPriceDict[@"Points subtotal"]]forKey:@"Points subtotal"];
    [totalDict setObject:[NSString stringWithFormat:@"-%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([finalCheckoutPriceDict[@"Discount"] floatValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Discount"];
    [totalDict setObject:[NSString stringWithFormat:@"%@%.2f + %@ip",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],(([finalCheckoutPriceDict[@"Cart subtotal"] floatValue]+[finalCheckoutPriceDict[@"Shipping charges"] floatValue]-[finalCheckoutPriceDict[@"Discount"] floatValue])*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue]),finalCheckoutPriceDict[@"Points subtotal"]] forKey:@"Grand Total"];//Show subtotal and ip
}

- (void)setPriceForCashUser {
    //Only for redeem products with apply coupon code
    if (![cartModelData.isSimpleProductExist boolValue]&&[cartModelData.isRedeemProductExist boolValue]&&([finalCheckoutPriceDict[@"Shipping charges"] floatValue]-[finalCheckoutPriceDict[@"Discount"] floatValue])>0) {
        totalArray=@[@"Points subtotal", @"Shipping charges", @"Discount",@"Tax", @"Apply coupon code", @"Grand Total"];
        [self setRedeemProductsWithApplyCouponCode];
    }
    //Only for redeem products without apply coupon code
    else if (![cartModelData.isSimpleProductExist boolValue]&&[cartModelData.isRedeemProductExist boolValue]) {
        isApplyCouponExist=false;
        totalArray=@[@"Points subtotal", @"Shipping charges", @"Discount",@"Tax", @"Grand Total"];
        [self setRedeemProductsWithOutApplyCouponCode];
    }
    //Only for simple products
    else if ([cartModelData.isSimpleProductExist boolValue]&&![cartModelData.isRedeemProductExist boolValue]) {
        totalArray=@[@"Cart subtotal", @"Shipping charges", @"Discount",@"Tax", @"Apply coupon code", @"Grand Total"];
        [self setOnlyForSimpleProducts];
    }
    //For both simple and redeem products
    else {
        totalArray=@[@"Cart subtotal", @"Points subtotal", @"Shipping charges", @"Discount",@"Tax", @"Apply coupon code", @"Grand Total"];
        [self setForBothSimpleAndRedeemProducts];
    }
}

- (void)setPriceForCreditUser {
    //Only for redeem products with apply coupon code
    if (![cartModelData.isSimpleProductExist boolValue]&&[cartModelData.isRedeemProductExist boolValue]&&([finalCheckoutPriceDict[@"Shipping charges"] floatValue]-[finalCheckoutPriceDict[@"Discount"] floatValue])>0) {
        totalArray=@[@"Points subtotal", @"Shipping charges", @"Discount", @"Credit usage",@"Tax", @"Apply coupon code", @"Grand Total"];
        [self setRedeemProductsWithApplyCouponCode];
        
    }
    //Only for redeem products without apply coupon code
    else if (![cartModelData.isSimpleProductExist boolValue]&&[cartModelData.isRedeemProductExist boolValue]) {
        isApplyCouponExist=false;
        totalArray=@[@"Points subtotal", @"Shipping charges", @"Discount", @"Credit usage",@"Tax", @"Grand Total"];
        [self setRedeemProductsWithOutApplyCouponCode];
    }
    //Only for simple products
    else if ([cartModelData.isSimpleProductExist boolValue]&&![cartModelData.isRedeemProductExist boolValue]) {
        totalArray=@[@"Cart subtotal", @"Shipping charges", @"Discount", @"Credit usage",@"Tax", @"Apply coupon code", @"Grand Total"];
        [self setOnlyForSimpleProducts];
    }
    //For both simple and redeem products
    else {
        totalArray=@[@"Cart subtotal", @"Points subtotal", @"Shipping charges", @"Discount", @"Credit usage",@"Tax", @"Apply coupon code", @"Grand Total"];
        [self setForBothSimpleAndRedeemProducts];
    }
    [totalDict setObject:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([finalCheckoutPriceDict[@"Credit usage"] floatValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Credit usage"];
    
    if ([[totalDict objectForKey:@"Credit usage"] floatValue] >= [[totalDict objectForKey:@"Grand Total"] floatValue]) {
        [totalDict setObject:[totalDict objectForKey:@"Grand Total"] forKey:@"Credit usage"];
        [totalDict setObject:[NSString stringWithFormat:@"%@%@",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],@"0.00"] forKey:@"Grand Total"];
//        [totalDict setObject:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([finalCheckoutPriceDict[@"Shipping charges"] floatValue]-[finalCheckoutPriceDict[@"Discount"] floatValue])] forKey:@"Credit usage"];
    }
    else {
         [totalDict setObject:[NSString stringWithFormat:@"%@%.2f + %@ip",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([finalCheckoutPriceDict[@"Shipping charges"] floatValue]-[finalCheckoutPriceDict[@"Discount"] floatValue]-[[totalDict objectForKey:@"Credit usage"] floatValue]),finalCheckoutPriceDict[@"Points subtotal"]] forKey:@"Grand Total"];
    }
}
#pragma mark - end

#pragma mark - Table view datasource delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ((nil==[UserDefaultManager getValue:@"userId"])) {
        return cartListDataArray.count+totalArray.count+1;
    }
    else {
        return cartListDataArray.count+totalArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FinalCheckoutTableViewCell *cell;
    NSString *simpleTableIdentifier;
    if (indexPath.row<cartListDataArray.count) {
        simpleTableIdentifier=@"cartListCell";
    }
    else {
        if ((nil==[UserDefaultManager getValue:@"userId"])&&(indexPath.row==(cartListDataArray.count+totalArray.count))) {
            simpleTableIdentifier=@"infoCell";
        }
        else if ([[totalArray objectAtIndex:(indexPath.row-cartListDataArray.count)] isEqualToString:@"Apply coupon code"]) {
            simpleTableIdentifier=@"applyCouponCell";
        }
        else {
            simpleTableIdentifier=@"priceCell";
        }
    }
    cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[FinalCheckoutTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (indexPath.row<cartListDataArray.count) {
        [cell displayCartListData:[cartListDataArray objectAtIndex:indexPath.row] isSeparatorHide:(indexPath.row==cartListDataArray.count-1?true:false)];
    }
    else if (indexPath.row<(cartListDataArray.count+totalArray.count)) {
        [cell displayPriceCellData:[totalDict mutableCopy] priceTitleArray:[totalArray objectAtIndex:(indexPath.row-cartListDataArray.count)] islastIndex:(((cartListDataArray.count+totalArray.count)-1)==indexPath.row)?true:false isApplyCoupon:([[totalArray objectAtIndex:(indexPath.row-cartListDataArray.count)] isEqualToString:@"Apply coupon code"]?true:false) couponCode:[totalDict mutableCopy]];
        [cell.applyCouponButton addTarget:self action:@selector(applyCouponAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row<cartListDataArray.count) {
        return 93.0;
    }
    else {
        if ((nil==[UserDefaultManager getValue:@"userId"])&&(indexPath.row==(cartListDataArray.count+totalArray.count))) {
            return 55.0;
        }
        else {
            if ([[totalArray objectAtIndex:(indexPath.row-cartListDataArray.count)] isEqualToString:@"Apply coupon code"]) {
                if ([myDelegate.isCouponApplied isEqualToString:@"1"]) {
                    return 45.0;
                }
                else {
                    return 35.0;
                }
            }
            else {
                return 35.0;
            }
        }
    }
}
#pragma mark - end

#pragma mark - Collection view datasource methods
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (nil!=paymentMethodDict) {
        if (isCyberSourceExist) {
            return paymentMethodArray.count-1;
        }
        else {
            return paymentMethodArray.count;
        }
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.layer.cornerRadius=5;
    cell.contentView.layer.masksToBounds=true;
    cell.contentView.layer.borderColor=paymentBorderColor.CGColor;
    cell.contentView.layer.borderWidth=1;
    UIImageView *paymentmethodImageView=(UIImageView *)[cell viewWithTag:1];
    int index;
    if (isCyberSourceExist) {
        index=(int)indexPath.row+1;
    }
    else {
        index=(int)indexPath.row;
    }
    DLog(@"%@",[paymentMethodArray objectAtIndex:index]);
    if ([[paymentMethodArray objectAtIndex:index] isEqualToString:@"tenpaypayment"]) {
        if ([cartModelData.extensionAttributeDict[@"has_subscription_product"] isEqualToString:@"1"]) {
            [cell setUserInteractionEnabled:NO];
            [cell setAlpha:0.5];
        }
        paymentmethodImageView.image=[UIImage imageNamed:@"weChatPayIcon.png"];
    }
    else if ([[paymentMethodArray objectAtIndex:index] isEqualToString:@"paypal_express"]) {
        paymentmethodImageView.image=[UIImage imageNamed:@"paypalIcon.png"];
    }
    else if ([[paymentMethodArray objectAtIndex:index] isEqualToString:@"alipay"]) {
        if ([cartModelData.extensionAttributeDict[@"has_subscription_product"] isEqualToString:@"1"]) {
            [cell setUserInteractionEnabled:NO];
            [cell setAlpha:0.5];
        }
        paymentmethodImageView.image=[UIImage imageNamed:@"alipayIcon.png"];
    }
    
    if (selectedPaymentMethodIndex==index) {
        cell.contentView.backgroundColor=selectedPaymentMethodColor;
    }
    else {
        cell.contentView.backgroundColor=[UIColor whiteColor];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //You may want to create a divider to scale the size by the way.
    float picDimension;
    if (isCyberSourceExist) {
        picDimension = (self.view.frame.size.width-30) / (float)(paymentMethodArray.count-1);
    }
    else {
        picDimension = (self.view.frame.size.width-30) / (float)paymentMethodArray.count;
    }
    return CGSizeMake(picDimension-5, 79);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (isCyberSourceExist) {
        selectedPaymentMethodIndex=(int)indexPath.row+1;
    }
    else {
        selectedPaymentMethodIndex=(int)indexPath.row;
    }
     [self cyberSourcePayment:false];
    [_paymentCollectionView reloadData];
}
#pragma mark - end

#pragma mark - Webservice
- (void)getCartList {
    CartDataModel *cartData = [CartDataModel sharedUser];
    [cartData getCartListingData:^(CartDataModel *userData)  {
        [myDelegate stopIndicator];
        if (userData.itemList.count>0) {
            [totalDict setObject:userData.couponCode forKey:@"couponCode"];
            [totalDict setObject:[NSString stringWithFormat:@"%@%.2f",[UserDefaultManager getValue:@"DefaultCurrencySymbol"],([[userData.extensionAttributeDict objectForKey:@"coupon_discount_price"] floatValue]*[[UserDefaultManager getValue:@"ExchangeRates"] doubleValue])] forKey:@"Apply coupon code"];
            [_cartItemsTableView reloadData];
            [_paymentCollectionView reloadData];
        }
        else {
            [myDelegate stopIndicator];
        }
    } onfailure:^(NSError *error) {
        
    }];
}

- (void)setPaymentMethod {
    CartDataModel *cartData = [CartDataModel sharedUser];
    cartData.email=[cartModelData.billingAddressDict objectForKey:@"email"];
    cartData.paymentMethod=[paymentMethodArray objectAtIndex:selectedPaymentMethodIndex];
    [cartData setPaymentMethodOnSuccess:^(CartDataModel *cartData)  {
        //[self setCheckoutOrder];
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PaymentWebViewController * nextView=[sb instantiateViewControllerWithIdentifier:@"PaymentWebViewController"];
        nextView.isSubscriptionProduct=cartModelData.extensionAttributeDict[@"has_subscription_product"];
        nextView.paymentMethod = [paymentMethodArray objectAtIndex:selectedPaymentMethodIndex];
        nextView.finalCheckoutPriceDict = totalDict;
        nextView.cartListDataArray = cartListDataArray;
        [self.navigationController pushViewController:nextView animated:YES];
        
        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
        
    }];
}

- (void)setCheckoutOrder {
    CartDataModel *cartData = [CartDataModel sharedUser];
    cartData.paymentMethod=@"cashondelivery";
    [cartData setCheckoutOrderOnSuccess:^(CartDataModel *shippmentDetailData)  {
        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
        
    }];
}

- (void)callCyberSourcePaymentService {
    CartDataModel *cartData = [CartDataModel sharedUser];
    cartData.city=[cartModelData.billingAddressDict objectForKey:@"city"];
    cartData.countryId=[cartModelData.billingAddressDict objectForKey:@"country_id"];
    cartData.firstName=[cartModelData.billingAddressDict objectForKey:@"firstname"];
    cartData.lastName=[cartModelData.billingAddressDict objectForKey:@"lastname"];
    cartData.postcode=[cartModelData.billingAddressDict objectForKey:@"postcode"];
    cartData.region=[cartModelData.billingAddressDict objectForKey:@"region"];
    cartData.regionCode=[cartModelData.billingAddressDict objectForKey:@"region_code"];
    cartData.saveCard=@"0";
    cartData.street=[cartModelData.billingAddressDict objectForKey:@"street"];
    cartData.telephone=[cartModelData.billingAddressDict objectForKey:@"telephone"];
    cartData.email=[cartModelData.billingAddressDict objectForKey:@"email"];
    
    if (!isFreeProduct) {
        if (nil==[UserDefaultManager getValue:@"userId"]) {
            cartData.ccId=_cvvField.text;
            cartData.ccNumber=_cardNumber.text;
            cartData.ccType=_cardType.text;
            cartData.expirationYear=_yearField.text;
            cartData.saveCard=@"1";
            cartData.expirationMonth=_monthField.text;
            cartData.subscriptionID=@"new";
        }
        else {
            if (isSelectCard) {
                cartData.ccId=_cvvField.text;
                cartData.ccNumber=@"";
                cartData.ccType=@"";
                cartData.expirationYear=_yearField.text;
                cartData.expirationMonth=_monthField.text;
                cartData.saveCard=@"1";
                 cartData.expirationMonth=_monthField.text;
                cartData.subscriptionID=encryptedSubscriptionId;
            }
            else {
                cartData.ccId=_cvvField.text;
                cartData.ccNumber=_cardNumber.text;
                cartData.ccType=_cardType.text;
                cartData.expirationYear=_yearField.text;
                cartData.saveCard=@"1";
                cartData.expirationMonth=_monthField.text;
                cartData.subscriptionID=@"new";
            }
        }
        cartData.method=@"magedelight_cybersource";
    } else {
        cartData.ccId=@"";
        cartData.ccNumber=@"";
        cartData.ccType=@"";
        cartData.expirationYear=@"";
        cartData.saveCard=@"0";
        cartData.expirationMonth=@"";
        cartData.subscriptionID=@"";
        cartData.method=@"free";
    }
    [cartData setCyberSourcePaymentData:^(CartDataModel *cartData)  {
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ThankYouViewController * nextView=[sb instantiateViewControllerWithIdentifier:@"ThankYouViewController"];
        nextView.cartListDataArray = cartListDataArray;
        nextView.finalCheckoutPriceDict=totalDict;
        [self.navigationController pushViewController:nextView animated:YES];
        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
        
    }];
}

- (void)removeCouponService {
    CartDataModel *cartData = [CartDataModel sharedUser];
    [cartData removeCouponCode:^(CartDataModel *cartData)  {
        myDelegate.isCouponApplied=@"0";
        [self getCartList];
    } onfailure:^(NSError *error) {
        
    }];
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)selectCardTypeAction:(id)sender {
    // picker of card type
     [_keyboardControls.activeField resignFirstResponder];
    [gNPickerViewObj showPickerView:cardTypeDataArray selectedIndex:selectedPickerIndex option:1 isCancelDelegate:false isFilterScreen:false];
}

- (IBAction)applyCouponAction:(id)sender {
    if ([myDelegate.isCouponApplied isEqualToString:@"1"] ) {
        [myDelegate showIndicator];
        [self performSelector:@selector(removeCouponService) withObject:nil afterDelay:.1];
    }
    else {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewsLetterSubscriptionViewController *popView =
    [storyboard instantiateViewControllerWithIdentifier:@"NewsLetterSubscriptionViewController"];
    popView.delegate=self;
    popView.screeType=@"2";
    popView.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4f];
    [popView setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:popView animated:YES completion:^{
        }];
        
    });
    }
}

- (IBAction)addCardButtonAction:(id)sender {
    isCardAdd=true;
    isSelectCard=false;
    isCyberSourcePayment=true;
    _addCardRadioLabel.backgroundColor=selectedStepColor;
    _addCardRadioLabel.layer.borderWidth=1.0;
    _addCardRadioLabel.layer.borderColor=selectedStepColor.CGColor;
    
    _selectCarRadioLabel.backgroundColor=[UIColor whiteColor];
    _selectCarRadioLabel.layer.borderWidth=1.0;
    _selectCarRadioLabel.layer.borderColor=selectedStepColor.CGColor;
    selectedPaymentMethodIndex=0;
    [_paymentCollectionView reloadData];
    selectedCardDataDict=nil;
    [self setSelectedCardData];
    [self cyberSourcePayment:true];
    [self customizedFraming];
}

- (IBAction)selectCardButtonAction:(id)sender {
    isCardAdd=true;
    isSelectCard=true;
    isCyberSourcePayment=true;
    _addCardRadioLabel.backgroundColor=[UIColor whiteColor];
    _addCardRadioLabel.layer.borderWidth=1.0;
    _addCardRadioLabel.layer.borderColor=selectedStepColor.CGColor;
    _selectCarRadioLabel.backgroundColor=selectedStepColor;
    _selectCarRadioLabel.layer.borderWidth=1.0;
    _selectCarRadioLabel.layer.borderColor=selectedStepColor.CGColor;
    selectedPaymentMethodIndex=0;
    [_paymentCollectionView reloadData];
    [self cyberSourcePayment:true];
    [self customizedFraming];
    
    CardListViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CardListViewController"];
    obj.finalCheckoutView=self;
    [self.navigationController pushViewController:obj animated:YES];
}

- (IBAction)placeOrderButtonAction:(id)sender {
    [_keyboardControls.activeField resignFirstResponder];
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    if ([self performValidations]) {
        if (isFreeProduct) {
            [myDelegate showIndicator];
            [self performSelector:@selector(callCyberSourcePaymentService) withObject:nil afterDelay:.1];
        }
        else {
        if (isCyberSourcePayment==true) {
            selectedPaymentMethodIndex=0;
            if ([self performValidationsForCard]) {
                [myDelegate showIndicator];
                [self performSelector:@selector(callCyberSourcePaymentService) withObject:nil afterDelay:.1];
            }
        } else {
            [myDelegate showIndicator];
            [self performSelector:@selector(setPaymentMethod) withObject:nil afterDelay:.1];
        }
        }
    }
}
#pragma mark - end

#pragma mark - Perform Validatios
- (BOOL)performValidations {
    NSLog(@"%d",selectedPaymentMethodIndex);
    if (selectedPaymentMethodIndex == -1 && !isFreeProduct){
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"selectPaymentMessage") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    }
    else {
        return YES;
    }
}
#pragma mark - end

#pragma mark - Custom picker delegate method
- (void)goNatuurPickerViewDelegateActionIndex:(int)tempSelectedIndex option:(int)option {
    if (option==1) {
        if (selectedPickerIndex!=tempSelectedIndex) {
            selectedPickerIndex=tempSelectedIndex;
            _cardType.text=[cardTypeDataArray objectAtIndex:selectedPickerIndex];
            selectedCardTypeId=[cardTypeCodeArray objectAtIndex:selectedPickerIndex];
        }
    }
}
#pragma mark - end

#pragma mark - Keyboard control delegate
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction {
    UIView *view;
    view = field.superview.superview.superview;
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControl {
    [keyboardControl.activeField resignFirstResponder];
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark - end

#pragma mark - Textfield delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [_keyboardControls setActiveField:textField];
    [gNPickerViewObj hidePickerView];
    if (textField.frame.origin.y + textField.frame.size.height + 15 < (_mainView.frame.size.height - 256)) {
        [_scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y+200) animated:NO];
    } else {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}
#pragma mark - end

#pragma mark - Card validation
- (BOOL)performValidationsForCard {
     if ([_cvvField isEmpty] || [_cardHolderName isEmpty] || [_monthField isEmpty] || [_yearField isEmpty]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"emptyFieldMessage") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
        
    }
    else if (_monthField.text.length < 1 && _monthField.text.length > 2) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"validMonth") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    }
    else if (_yearField.text.length < 2 && _yearField.text.length > 4) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"validYear") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    }
    else if (_cvvField.text.length < 3 && _cvvField.text.length > 4) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"validCVV") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    }
    else if ([_cardType.text isEqualToString:@"Visa"] || [_cardType.text isEqualToString:@"VI"]) {
        if (![_cardNumber isValidVisaCard]) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"invalidCard") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
            return NO;
        }
        else {
            return YES;
        }
    }
    else  if ([_cardType.text isEqualToString:@"MasterCard"] || [_cardType.text isEqualToString:@"Maestro International"] || [_cardType.text isEqualToString:@"Maestro UK"] || [_cardType.text isEqualToString:@"MC"] || [_cardType.text isEqualToString:@"MAESTRO"] || [_cardType.text isEqualToString:@"SWITCH"]) {
        if (![_cardNumber isValidMasterCard]) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"invalidCard") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
            return NO;
        }
        else {
            return YES;
        }
    }
    else  if ([_cardType.text isEqualToString:@"Discover"] || [_cardType.text isEqualToString:@"DI"]) {
        if (![_cardNumber isValidDiscoverCard] ) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"invalidCard") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
            return NO;
        }
        else {
            return YES;
        }
    }
    else  if ([_cardType.text isEqualToString:@"Diners Club"] || [_cardType.text isEqualToString:@"DC"]) {
        if (![_cardNumber isDinnerClubCard]) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"invalidCard") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
            return NO;
        }
        else {
            return YES;
        }
    }
    else  if ([_cardType.text isEqualToString:@"American Express"] || [_cardType.text isEqualToString:@"AE"]) {
        if (![_cardNumber isValidAmericanExpress]) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"invalidCard") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
            return NO;
        }
        else {
            return YES;
        }
    }
    else {
        return YES;
    }
}
@end
