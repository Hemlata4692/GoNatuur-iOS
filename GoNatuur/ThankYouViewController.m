//
//  ThankYouViewController.m
//  GoNatuur
//
//  Created by Monika on 9/5/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ThankYouViewController.h"
#import "ThankYouTableCell.h"
#import "DynamicHeightWidth.h"

@interface ThankYouViewController ()

@end

@implementation ThankYouViewController
@synthesize cartListDataArray;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Table view datasource delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[UserDefaultManager getValue:@"userId"] isEqualToString:@""]) {
        return 5+cartListDataArray.count;
    } else {
        return 4+cartListDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier;
    if (indexPath.row == 0) {
        simpleTableIdentifier=@"ThankYouCell";
    } else if (indexPath.row == 1) {
        simpleTableIdentifier=@"PurchaseCell";
    } else if (indexPath.row < cartListDataArray.count+2) {
        simpleTableIdentifier=@"ProductDetailCell";
    } else if (indexPath.row == cartListDataArray.count+2) {
        simpleTableIdentifier=@"OrderTotalCell";
    } else if (indexPath.row == cartListDataArray.count+3){
        simpleTableIdentifier=@"GuestInfoCell";
    }
    ThankYouTableCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[ThankYouTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (indexPath.row == 0) {
        [cell displayData:_thankYouTable.frame.size];
    } else if (indexPath.row == 1) {
        [cell displayPurchaseData:_thankYouTable.frame.size];
    } else if (indexPath.row < cartListDataArray.count+2) {
        [cell displayCartListData:[cartListDataArray objectAtIndex:indexPath.row - 2] rectSize:_thankYouTable.frame.size];
    }
    else if (indexPath.row == cartListDataArray.count+2) {
        [cell displayOrderTotalData:_thankYouTable.frame.size];
    }
    else if (indexPath.row == cartListDataArray.count+3) {
        [cell displayData:_thankYouTable.frame.size];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [DynamicHeightWidth getDynamicLabelHeight:NSLocalizedText(@"thankDescText") font:[UIFont montserratRegularWithSize:12] widthValue:_thankYouTable.frame.size.width-20 heightValue:500]+70;
    } else if (indexPath.row == 1) {
        return 30;
    } else if (indexPath.row < cartListDataArray.count+2) {
        float height=10;
        height+=[DynamicHeightWidth getDynamicLabelHeight:[[cartListDataArray objectAtIndex:indexPath.row -2] itemName] font:[UIFont montserratRegularWithSize:11] widthValue:[[UIScreen mainScreen] bounds].size.width-228];
        height+=2;
        if (height<80) {
            return 80;
        }
        return height;
    } else if (indexPath.row == cartListDataArray.count+2) {
        return 30;
    } else if (indexPath.row == cartListDataArray.count+3) {
        return [DynamicHeightWidth getDynamicLabelHeight:NSLocalizedText(@"guestMessage") font:[UIFont montserratRegularWithSize:12] widthValue:_thankYouTable.frame.size.width-20 heightValue:500]+10;
    }
    return 1;
}
#pragma mark - end

@end
