//
//  NewsCentreDetailTableViewCell.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 13/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCentreDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateHeading;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoriesHeading;
@property (weak, nonatomic) IBOutlet UILabel *categoriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsHeading;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UILabel *byHeading;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;

- (void)displayNewsTitleImage:(NSString *)imageUrl title:(NSString *)title;
- (void)displayNewsDate:(NSString *)date;
- (void)displayNewsCategory:(NSString *)category;
- (void)displayNewsTags:(NSString *)tags;
- (void)displayNewsAuthor:(NSString *)authorName;
- (void)displayWebView:(NSString *)newsContent;
@end
