//
//  GoNatuurFilterView.m
//  GoNatuur
//
//  Created by Ranosys on 18/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "GoNatuurFilterView.h"

@interface GoNatuurFilterView () {
    int tagValue;
}
@end
@implementation GoNatuurFilterView
@synthesize goNatuurFilterViewObj;
@synthesize firstFilterButtonOutlet;
@synthesize subCategoryButtonOutlet;
@synthesize secondFilterButtonOutlet;

#pragma mark - Initialized view
- (id)initWithFrame:(CGRect)frame delegate:(id)delegate {
    self=[super initWithFrame:frame];
    if (self) {
        _delegate=delegate;
        //Access filter view xib
        [[NSBundle mainBundle] loadNibNamed:@"GoNatuurFilterView" owner:self options:nil];
    }
    return self;
}

- (void)setButtonTitles:(NSString *)firstFilterText subCategoryText:(NSString *)subCategoryText secondFilterText:(NSString *)secondFilterText {
    [firstFilterButtonOutlet setTitle:firstFilterText forState:UIControlStateNormal];
    [subCategoryButtonOutlet setTitle:subCategoryText forState:UIControlStateNormal];
    [secondFilterButtonOutlet setTitle:secondFilterText forState:UIControlStateNormal];
}
#pragma mark - end

- (IBAction)subCategoryAction:(UIButton *)sender {
    DLog(@"subcategory");
    [_delegate goNatuurFilterViewDelegateActionIndex:1];
}

- (IBAction)firstFilterAction:(UIButton *)sender {
    DLog(@"filter1");
    [_delegate goNatuurFilterViewDelegateActionIndex:2];
}

- (IBAction)secondFilterAction:(UIButton *)sender {
    DLog(@"filter2");
    [_delegate goNatuurFilterViewDelegateActionIndex:3];
}
@end
