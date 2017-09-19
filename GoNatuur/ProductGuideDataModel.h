//
//  ProductGuideDataModel.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 14/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductGuideDataModel : NSObject
@property (strong, nonatomic) NSMutableArray *guideCategoryDataArray;
@property (strong, nonatomic) NSString *categoryName;
@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) NSString *categoryDescription;
@property (strong, nonatomic) NSString *postId;
@property (strong, nonatomic) NSString *postName;
@property (strong, nonatomic) NSString *shortDescription;
@property (strong, nonatomic) NSString *tagline;
@property (strong, nonatomic) NSString *postContent;
@property (strong, nonatomic) NSString *postImage;
@property (strong, nonatomic) NSString *isSearch;
@property (strong, nonatomic) NSString *searchKeywod;
@property (strong, nonatomic) NSString *screenType;
@property (strong, nonatomic) NSMutableArray *postDataArray;
@property (strong, nonatomic) NSString *totalProductCount;
@property (strong, nonatomic) NSNumber *pageSize;
@property (strong, nonatomic) NSNumber *currentPage;
+ (instancetype)sharedUser;

- (void)getProductGuideCategoryData:(void (^)(ProductGuideDataModel *))success onfailure:(void (^)(NSError *))failure;

- (void)getProductGuideDetailsCategoryData:(void (^)(ProductGuideDataModel *))success onfailure:(void (^)(NSError *))failure;
@end
