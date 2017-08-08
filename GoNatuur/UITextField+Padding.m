//
//  UITextField+Padding.m
//  Sure
//
//  Created by Hema on 25/03/15.
//  Copyright (c) 2015 Shivendra. All rights reserved.
//

#import "UITextField+Padding.h"

@implementation UITextField (Padding)

- (void)addTextFieldPadding: (UITextField *)textfield; {
    UIView *leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 20)];
    textfield.leftView = leftPadding;
    textfield.leftViewMode = UITextFieldViewModeAlways;

}
- (void)addTextFieldPaddingWithoutImages: (UITextField *)textfield {
    UIView *leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    textfield.leftView = leftPadding;
    textfield.leftViewMode = UITextFieldViewModeAlways;    
}

- (void)addTextFieldLeftRightPadding: (UITextField *)textfield {
    UIView *leftPadding;
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0,10, 20)];
    textfield.leftView = leftPadding;
    textfield.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *rightPadding;
    rightPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    textfield.rightView = rightPadding;
    textfield.rightViewMode = UITextFieldViewModeAlways;
}

@end
