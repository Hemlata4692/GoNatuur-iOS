//
//  GoNatuurPickerView.m
//  GoNatuur
//
//  Created by Ranosys on 18/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "GoNatuurPickerView.h"

@interface GoNatuurPickerView() {
    int tagValue;
    BOOL isCancel;
}

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@end

@implementation GoNatuurPickerView
@synthesize goNatuurPickerViewObj;
@synthesize pickerHeight;

#pragma mark - Initialized view
- (id)initWithFrame:(CGRect)frame delegate:(id)delegate pickerHeight:(int)tempPickerHeight {
    self=[super initWithFrame:frame];
    if (self) {
        _delegate=delegate;
        pickerHeight=tempPickerHeight;
        //Access pickerView xib
        [[NSBundle mainBundle] loadNibNamed:@"GoNatuurPickerView" owner:self options:nil];
        goNatuurPickerViewObj.frame=CGRectMake(0, 1000, [[UIScreen mainScreen] bounds].size.width, pickerHeight);
        _pickerView.backgroundColor = [UIColor colorWithRed:253.0/255.0 green:244.0/255.0 blue:246.0/255.0 alpha:1.0];
    }
    return self;
}
#pragma mark - end

#pragma mark - Hide/Show pickerView
- (void)showPickerView:(NSArray *)tempPickerArray selectedIndex:(int)selectedIndex option:(int)option isCancelDelegate:(BOOL)isCancelDelegate isFilterScreen:(BOOL)isFilterScreen {
    _pickerArray=[tempPickerArray mutableCopy];
    _pickerView.showsSelectionIndicator = YES;
    tagValue=option;
    [_pickerView reloadAllComponents];
    [_pickerView selectRow:selectedIndex inComponent:0 animated:YES];
   
    [UIView animateWithDuration:0.2f animations:^{
        //To Frame
        if (isFilterScreen) {
           goNatuurPickerViewObj.frame=CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-pickerHeight-64, [[UIScreen mainScreen] bounds].size.width, pickerHeight);
        }
        else {
        goNatuurPickerViewObj.frame=CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-pickerHeight, [[UIScreen mainScreen] bounds].size.width, pickerHeight);
        }
        
    } completion:^(BOOL completed) {
        
    }];
    isCancel=isCancelDelegate;
}

- (void)hidePickerView {
    [UIView animateWithDuration:0.2f animations:^{
        //To Frame
        goNatuurPickerViewObj.frame=CGRectMake(0, 1000, [[UIScreen mainScreen] bounds].size.width, pickerHeight);
        
    } completion:^(BOOL completed) {
    }];
}
#pragma mark - end

#pragma mark - Toolbar button actions
- (IBAction)done:(UIBarButtonItem *)sender {
    [self hidePickerView];
    NSInteger index = [_pickerView selectedRowInComponent:0];
    [_delegate goNatuurPickerViewDelegateActionIndex:(int)index option:tagValue];
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self hidePickerView];
    if (isCancel) {
        [_delegate cancelDelegateMethod];
    }
}
#pragma mark - end

#pragma mark - Pickerview methods
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,[[UIScreen mainScreen] bounds].size.width,20)];
        pickerLabel.font = [UIFont montserratRegularWithSize:17];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
    }
    pickerLabel.text=[_pickerArray objectAtIndex:row];
    return pickerLabel;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _pickerArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_pickerArray objectAtIndex:row];
}
#pragma mark - end
@end
