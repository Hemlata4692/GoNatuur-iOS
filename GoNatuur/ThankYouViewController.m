//
//  ThankYouViewController.m
//  GoNatuur
//
//  Created by Monika on 9/5/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ThankYouViewController.h"
#import "ThankYouTableCell.h"

@interface ThankYouViewController ()

@end

@implementation ThankYouViewController

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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier;
    if (indexPath.row == 0) {
        simpleTableIdentifier=@"ThankYouCell";
    } else if (indexPath.row == 1) {
        simpleTableIdentifier=@"PurchaseCell";
    } else if (indexPath.row == 2) {
        simpleTableIdentifier=@"ProductDetailCell";
    } else if (indexPath.row == 3) {
        simpleTableIdentifier=@"OrderTotalCell";
    } else {
        simpleTableIdentifier=@"GuestInfoCell";
    }
    ThankYouTableCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[ThankYouTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    float height=10;
//    height+=[DynamicHeightWidth getDynamicLabelHeight:[[cartListDataArray objectAtIndex:indexPath.row] itemName] font:[UIFont montserratRegularWithSize:11] widthValue:[[UIScreen mainScreen] bounds].size.width-228];
//    height+=15;
//    height+=[DynamicHeightWidth getDynamicLabelHeight:[[cartListDataArray objectAtIndex:indexPath.row] itemDescription] font:[UIFont montserratRegularWithSize:11] widthValue:[[UIScreen mainScreen] bounds].size.width-228];
//    height+=10;
//    if (height<90) {
//        return 90;
//    }
//    return height;
//}
#pragma mark - end

@end
