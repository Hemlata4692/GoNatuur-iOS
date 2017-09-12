//
//  CardListViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 07/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "CardListViewController.h"
#import "CardListTableViewCell.h"

@interface CardListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *cardsListTableView;
@property (weak, nonatomic) IBOutlet UIButton *addCardButton;

@end

@implementation CardListViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"CardList");
    [self addLeftBarButtonWithImage:false];
    
    [_addCardButton setTitle:NSLocalizedText(@"addCard") forState:UIControlStateNormal];
    [_addCardButton setCornerRadius:17.0];
    [_addCardButton addShadow:_addCardButton color:[UIColor blackColor]];
    
    //remove extra lines from table view
    _cardsListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
#pragma mark - end

#pragma mark - Table view data source and delgate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"cardCell";
    CardListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
   // [cell displayData:[reviewListingDataAray objectAtIndex:indexPath.row] reviewId:@"0" rectSize:_reviewListingTableView.frame.size];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
#pragma mark - end
@end
