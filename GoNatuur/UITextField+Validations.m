//
//  UITextField+Validations.m
//  WheelerButler
//
//  Created by Hema on 16/01/15.
//
//

#import "UITextField+Validations.h"

@implementation UITextField (Validations)

- (BOOL)isEmpty {
    return ([self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) ? YES : NO;
}

- (BOOL)isValidEmail {
    
    NSString *emailRegEx = @"(?:[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[A-Za-z0-9](?:[A-Za-"
    @"z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[A-Za-z0-9-]*[A-Za-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [emailTest evaluateWithObject:self.text];
}

- (BOOL)isValidPassword {
    //At least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character:
    if (![self.text rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:NSLocalizedText(@"specialCharacter")]].length) {
        return false;
    }
    if (![self.text rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:NSLocalizedText(@"upperCaseCharacter")]].length) {
        return false;
    }
    if (![self.text rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:NSLocalizedText(@"lowerCaseCharacter")]].length) {
        return false;
    }
    if (![self.text rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:NSLocalizedText(@"numberCharacter")]].length) {
        return false;
    }
    return true;
}

- (BOOL)isValidURL {
    
    NSString *urlRegEx =
    @"((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:self.text];
}

- (void)setPlaceholderFontSize : (UITextField *)textfield string:(NSString *)string{
    textfield.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:string
                                    attributes:@{
                                                 NSFontAttributeName : [UIFont fontWithName:@"OpenSans" size:20.0]
                                                 }
     ];
}

- (BOOL)isValidAmericanExpress {
    NSString *validCard = @"(?:3[47][0-9]{13})";
    NSPredicate *cardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", validCard];
    return [cardTest evaluateWithObject:self.text];
}

- (BOOL)isValidVisaCard {
    NSString *validCard = @"(?:4[0-9]{12}(?:[0-9]{3})?)";
    NSPredicate *cardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", validCard];
    return [cardTest evaluateWithObject:self.text];
}

- (BOOL)isValidMasterCard {
    NSString *validCard = @"(?:5[1-5][0-9]{14})";
    NSPredicate *cardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", validCard];
    return [cardTest evaluateWithObject:self.text];
}

- (BOOL)isValidDiscoverCard {
    NSString *emailRegEx = @"(?:6(?:011|5[0-9][0-9])[0-9]{12})";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [emailTest evaluateWithObject:self.text];
}

- (BOOL)isDinnerClubCard {
    NSString *emailRegEx = @"(?:3(?:0[0-5]|[68][0-9])[0-9]{11})";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [emailTest evaluateWithObject:self.text];
}
@end
