//
//  NewsLetterSubscriptionViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 08/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "NewsLetterSubscriptionViewController.h"
#import "UITextField+Padding.h"
#import "LoginModel.h"
#import "UITextField+Validations.h"

@interface NewsLetterSubscriptionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *subscribeButton;
@property (weak, nonatomic) IBOutlet UIView *newsLetterView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@end

@implementation NewsLetterSubscriptionViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self viewCustomisation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Localized text and view customisation
- (void)viewCustomisation {
    _headingLabel.text=NSLocalizedText(@"newlettersubscription");
    _emailTextField.placeholder=NSLocalizedText(@"Email");
    [_subscribeButton setTitle:NSLocalizedText(@"subscribe") forState:UIControlStateNormal];
    [_emailTextField addTextFieldLeftRightPadding:_emailTextField];
    [_emailTextField setTextBorder:_emailTextField color:[UIColor colorWithRed:199.0/255.0 green:201.0/255.0 blue:201.0/255.0 alpha:1.0]];
    [_newsLetterView setCornerRadius:2.0];
    //customisation of save button
    [_subscribeButton setCornerRadius:20.0];
    [_subscribeButton addShadow:_subscribeButton color:[UIColor blackColor]];
    self.view.backgroundColor=[UIColor clearColor];
    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(dismissNewsView:)];
    [_mainView addGestureRecognizer:singleFingerTap];
}
#pragma mark - end

#pragma mark - Textfield delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - end

#pragma mark - Dismiss view
//The event handling method
- (void)dismissNewsView:(UITapGestureRecognizer *)recognizer {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)subscribeForNewsLetter:(id)sender {
    [_emailTextField resignFirstResponder];
    if([self performValidations]) {
        [myDelegate showIndicator];
        [self performSelector:@selector(subscribeForNews) withObject:nil afterDelay:.1];
    }
}
#pragma mark - end

#pragma mark - Webservice
- (void)subscribeForNews {
    LoginModel *userLogin = [LoginModel sharedUser];
    userLogin.email = _emailTextField.text;
    [userLogin newsLetterSubscribe:^(LoginModel *userData) {
        [myDelegate stopIndicator];
        [self dismissViewControllerAnimated:YES completion:nil];
    } onfailure:^(NSError *error) {
        
    }];
}
#pragma mark - end

#pragma mark - Perform Validatios
- (BOOL)performValidations {
    if ([_emailTextField isEmpty]){
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"emptyFieldMessage") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
        return NO;
    }
    else {
        return YES;
    }
}
#pragma mark - end
@end
