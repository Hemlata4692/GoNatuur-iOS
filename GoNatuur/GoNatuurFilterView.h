//
//  GoNatuurFilterView.h
//  GoNatuur
//
//  Created by Ranosys on 18/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoNatuurFilterViewDelegate <NSObject>
@optional
- (void)goNatuurFilterViewDelegateActionIndex:(int)option;
- (void)cancelDelegateMethod;
@end

@interface GoNatuurFilterView : UIView {
    id <GoNatuurFilterViewDelegate> _delegate;
}
@property (strong, nonatomic) IBOutlet UIButton *firstFilterButtonOutlet;
@property (strong, nonatomic) IBOutlet UIButton *subCategoryButtonOutlet;
@property (strong, nonatomic) IBOutlet UIButton *secondFilterButtonOutlet;

@property (strong, nonatomic) IBOutlet UIView *goNatuurFilterViewObj;
@property (assign, nonatomic) int pickerHeight;
@property (strong, nonatomic) NSMutableArray *pickerArray;
@property (nonatomic,strong) id delegate;
- (id)initWithFrame:(CGRect)frame delegate:(id)delegate;
- (void)setButtonTitles:(NSString *)firstFilterText subCategoryText:(NSString *)subCategoryText secondFilterText:(NSString *)secondFilterText;
@end
