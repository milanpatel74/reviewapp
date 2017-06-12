//
//  myReviewModel.h
//  iosreviewApp
//
//  Created by dan jin on 5/30/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myReviewModel : NSObject

@property (nonatomic, retain) NSMutableArray *product_title;
@property (nonatomic, retain) NSMutableArray *product_rate;
@property (nonatomic, retain) NSMutableArray *product_photo;
@property (nonatomic, retain) NSMutableArray *review_count;
@property (nonatomic, retain) NSMutableArray *sale_price;
@property (nonatomic, retain) NSMutableArray *product_id;
@property (nonatomic, retain) NSMutableArray *category_id;


-(id)init:(NSDictionary*)jsonObject;
-(void) initWithJsonObject:(NSDictionary*)jsonObject;

@end
