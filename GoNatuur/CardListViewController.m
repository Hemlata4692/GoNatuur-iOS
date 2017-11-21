//
//  CardListViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 07/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "CardListViewController.h"
#import "CardListTableViewCell.h"
#import "PaymentModel.h"
#import "AddCardViewController.h"

@interface CardListViewController () {
    NSMutableArray *cardListArray;
}
@property (weak, nonatomic) IBOutlet UITableView *cardsListTableView;
@property (weak, nonatomic) IBOutlet UIButton *addCardButton;
@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;

@end

@implementation CardListViewController
@synthesize cardAdded;
@synthesize finalCheckoutView;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    cardListArray = [NSMutableArray new];
    cardAdded=@"0";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"CardList");
    _noRecordLabel.text=NSLocalizedText(@"norecord");
    [self addLeftBarButtonWithImage:false];
    [_addCardButton setTitle:NSLocalizedText(@"addCard") forState:UIControlStateNormal];
    [_addCardButton setCornerRadius:20.0];
    [_addCardButton addShadow:_addCardButton color:[UIColor blackColor]];
    
    [myDelegate showIndicator];
    [self performSelector:@selector(getCardListing) withObject:nil afterDelay:.1];
    
    //remove extra lines from table view
    _cardsListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
#pragma mark - end

#pragma mark - Table view data source and delgate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return cardListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"cardCell";
    CardListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    PaymentModel *paymentDataModel = [cardListArray objectAtIndex:indexPath.row];
    [cell displayOrderData:_cardsListTableView.frame.size orderData:paymentDataModel];
    cell.deleteCardButton.tag=indexPath.row;
    [cell.deleteCardButton addTarget:self action:@selector(deleteCardButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        if (nil!=finalCheckoutView) {
            finalCheckoutView.selectedCardDataDict=[cardListArray objectAtIndex:indexPath.row];
            [self.navigationController popViewControllerAnimated:true];
        }
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)deleteCardButtonAction:(UIButton *)sender {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert addButton:NSLocalizedText(@"alertOk") actionBlock:^(void) {
        [myDelegate showIndicator];
        [self performSelector:@selector(deleteCard:) withObject:[NSNumber numberWithInteger:sender.tag] afterDelay:0.1];
    }];
    [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"deleteCardMessage") closeButtonTitle:NSLocalizedText(@"alertCancel") duration:0.0f];
}

- (IBAction)addCardButtonAction:(id)sender {
    AddCardViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddCardViewController"];
    obj.cardListObj=self;
    _cardCount=(int)cardListArray.count;
    [self.navigationController pushViewController:obj animated:YES];
}
#pragma mark - end

#pragma mark - Webservices
- (void)getCardListing {
    PaymentModel *paymentDataModel = [PaymentModel sharedUser];
    [paymentDataModel getCardListing:^(PaymentModel *userData) {
        cardListArray = [userData.cardListArray mutableCopy];
        if ([cardAdded isEqualToString:@"1"]) {
            if (_cardCount==cardListArray.count) {
                SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"cardNotAdded") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
            }
        }
        if (cardListArray.count == 0) {
            _noRecordLabel.hidden = NO;
           
        } else {
            _noRecordLabel.hidden = YES;
        }
        [_cardsListTableView reloadData];
        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
        _noRecordLabel.hidden=NO;
    }];
}

//delete card service
- (void)deleteCard:(NSNumber *)buttonTag {
    PaymentModel *paymentDataModel = [PaymentModel sharedUser];
    paymentDataModel.cardId=[[cardListArray objectAtIndex:[buttonTag intValue]] cardId];
    [paymentDataModel deleteCard:^(PaymentModel *userData) {
        [cardListArray removeObjectAtIndex:[buttonTag intValue]];
       // [self getCardListing];
        [_cardsListTableView reloadData];
        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
        _noRecordLabel.hidden=NO;
    }];
}
#pragma mark - end

@end
