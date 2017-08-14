//
//  ForgotPasswordViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 04/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "UITextField+Validations.h"
#import "UITextField+Padding.h"

@interface ForgotPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIView *forgotPasswordView;

@end

@implementation ForgotPasswordViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    //add text field padding
    [_emailTextField addTextFieldLeftRightPadding:self.emailTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - IBAction
- (IBAction)goBackToLoginViewButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendPasswordButtonAction:(id)sender {
    //Perform forgot password validations
    if([self performValidationsForForgotPassword]) {
        //        [myDelegate showIndicator];
        //        [self performSelector:@selector(forgotPassword) withObject:nil afterDelay:.1];
    }
    
}
#pragma mark - end

#pragma mark - Forgot password validation
- (BOOL)performValidationsForForgotPassword {
    if ([_emailTextField isEmpty]) {
//        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
//        [alert showWarning:nil title:alertTitle subTitle:emptyFieldMessage closeButtonTitle:alertOk duration:0.0f];
        return NO;
    }
    else if (![_emailTextField isValidEmail]) {
//        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
//        [alert showWarning:nil title:alertTitle subTitle:validEmailMessage closeButtonTitle:alertOk duration:0.0f];
        return NO;
    }
    else {
        return YES;
    }
}
#pragma mark - end

#pragma mark - Textfield delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - end
@end
