//
//  GoNatuurPickerView.h
//  GoNatuur
//
//  Created by Ranosys on 18/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoNatuurPickerViewDelegate <NSObject>
@optional
- (void)goNatuurPickerViewDelegateActionIndex:(int)selectedIndex option:(int)option;
- (void)cancelDelegateMethod;
@end

@interface GoNatuurPickerView : UIView {
    id <GoNatuurPickerViewDelegate> _delegate;
}

@property (strong, nonatomic) IBOutlet UIView *goNatuurPickerViewObj;
@property (assign, nonatomic) int pickerHeight;
@property (strong, nonatomic) NSMutableArray *pickerArray;
@property (nonatomic,strong) id delegate;
- (id)initWithFrame:(CGRect)frame delegate:(id)delegate pickerHeight:(int)tempPickerHeight;
- (void)showPickerView:(NSArray *)tempPickerArray selectedIndex:(int)selectedIndex option:(int)option;
- (void)hidePickerView;
@end
