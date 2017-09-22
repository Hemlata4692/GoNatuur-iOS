//
//  FilterViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 21/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterTableViewCell.h"

@interface FilterViewController ()
@property (weak, nonatomic) IBOutlet UITableView *filterTableView;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView DataSource and Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 5;
    }
    else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 50.0;
    }
    else
        return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 130;
    }
    else  {
        return 50;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier;
    if (indexPath.section == 0) {
        simpleTableIdentifier=@"rangeSlider";
    }
    else if (indexPath.section == 1) {
        simpleTableIdentifier=@"countryFilter";
    }
    else if (indexPath.section == 2) {
        simpleTableIdentifier=@"benefitsFilter";
    }
    else if (indexPath.section == 3) {
        simpleTableIdentifier=@"certificatesFilter";
    }
    else if (indexPath.section == 4) {
        simpleTableIdentifier=@"productTypeFilter";
    }

    FilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[FilterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (indexPath.section == 0) {
        [cell displaySlider:_filterTableView.frame.size];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
       UIView* sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 260,0)];
        return sectionView;
    }
    else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
    } else {
    }
}
#pragma mark - end
@end
