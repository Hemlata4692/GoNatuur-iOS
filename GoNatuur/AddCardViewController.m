//
//  AddCardViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 07/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "AddCardViewController.h"
#import "UITextField+Padding.h"
#import "BSKeyboardControls.h"

@interface AddCardViewController ()<BSKeyboardControlsDelegate> {
    UITextField *currentSelectedTextField;
}
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UITextField *cardholderName;
@property (weak, nonatomic) IBOutlet UITextField *cardNumber;
@property (weak, nonatomic) IBOutlet UITextField *monthField;
@property (weak, nonatomic) IBOutlet UITextField *yearField;
@property (weak, nonatomic) IBOutlet UITextField *cvvField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) BSKeyboardControls *keyboardControls;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIWebView *addCardWebview;

@end

@implementation AddCardViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"AddCard");
    [self addLeftBarButtonWithImage:true];
    [self customizeViewFields];
    [myDelegate showIndicator];
    [self loadAddCardRequest];
    
}

- (void)loadAddCardRequest {
    NSString *webViewString=[NSString stringWithFormat:@"%@%@/%@token=%@",BaseUrl,[UserDefaultManager getValue:@"Language"],@"creditcard/index/add/?",[UserDefaultManager getValue:@"Authorization"]];
    NSString *encodedString = [webViewString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *webViewURL = [NSURL URLWithString:encodedString];
    NSURLRequest *shareRequest=[NSURLRequest requestWithURL:webViewURL];
    [_addCardWebview loadRequest: shareRequest];
}

- (void)localizedText {
    _cardholderName.placeholder=NSLocalizedText(@"cardholder");
    _cardNumber.placeholder=NSLocalizedText(@"cardnumber");
    _monthField.placeholder=NSLocalizedText(@"month");
    _yearField.placeholder=NSLocalizedText(@"year");
    _cvvField.placeholder=NSLocalizedText(@"cvv");
    _emailField.placeholder=NSLocalizedText(@"emailPlaceholder");
    [_saveButton setTitle:NSLocalizedText(@"save") forState:UIControlStateNormal];
}
#pragma mark - end

#pragma mark - Customise text fields
- (void)customizeViewFields {
    _addCardWebview.backgroundColor=[UIColor clearColor];
    _addCardWebview.opaque=YES;
    
    //Add textfield to keyboard controls array
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:@[_cardholderName, _cardNumber,_monthField,_yearField,_cvvField,_emailField]]];
    [_keyboardControls setDelegate:self];
    //Add text field border and padding
    [_cardNumber setTextBorder:_cardNumber color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_cardholderName setTextBorder:_cardholderName color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_monthField setTextBorder:_monthField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_yearField setTextBorder:_yearField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_cvvField setTextBorder:_cvvField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_emailField setTextBorder:_emailField color:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0]];
    [_cardNumber addTextFieldPaddingWithoutImages:_cardNumber];
    [_cardholderName addTextFieldPaddingWithoutImages:_cardholderName];
    [_monthField addTextFieldPaddingWithoutImages:_monthField];
    [_yearField addTextFieldPaddingWithoutImages:_yearField];
    [_cvvField addTextFieldPaddingWithoutImages:_cvvField];
    [_emailField addTextFieldPaddingWithoutImages:_emailField];
    //customisation of save button
    [_saveButton setCornerRadius:20.0];
    [_saveButton addShadow:_saveButton color:[UIColor blackColor]];
    _mainView.translatesAutoresizingMaskIntoConstraints=YES;
    _mainView.frame=CGRectMake([[UIScreen mainScreen] bounds].origin.x, [[UIScreen mainScreen] bounds].origin.y+115, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-65);
    [self localizedText];
}
#pragma mark - end

#pragma mark - Keyboard control delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.keyboardControls setActiveField:textField];
        if (textField==_emailField) {
            if([[UIScreen mainScreen] bounds].size.height<=568) {
                [UIView animateWithDuration:0.3 animations:^{
                    _mainView.frame=CGRectMake([[UIScreen mainScreen] bounds].origin.x, [[UIScreen mainScreen] bounds].origin.y+115-40, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-65);
                }];
            }
        }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField==_emailField) {
    [UIView animateWithDuration:0.3 animations:^{
           _mainView.frame=CGRectMake([[UIScreen mainScreen] bounds].origin.x, [[UIScreen mainScreen] bounds].origin.y+115, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-65);
    }];
    }
}

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction {
    UIView *view;
    view = field.superview.superview.superview;
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControl {
    [keyboardControl.activeField resignFirstResponder];
}
#pragma mark - end

#pragma mark - Textfield delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)saveButtonAction:(id)sender {
}
#pragma mark - end

#pragma mark - Webview delegates
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[request.URL absoluteString] isEqualToString:[NSString stringWithFormat:@"%@%@/%@",BaseUrl,[UserDefaultManager getValue:@"Language"],@"magedelight_cybersource/cards/listing/"]]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [myDelegate stopIndicator];
    NSString *padding = @"document.body.style.padding='1px 1px 1px 1px'";
    [webView stringByEvaluatingJavaScriptFromString:padding];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [myDelegate stopIndicator];
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert addButton:NSLocalizedText(@"alertOk") actionBlock:^(void) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"somethingWrongMessage")  closeButtonTitle:nil duration:0.0f];
}
#pragma mark - end
@end
