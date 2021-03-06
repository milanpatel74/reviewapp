//
//  CouponViewController.m
//  iosreviewApp
//
//  Created by dan jin on 5/29/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "CouponViewController.h"
#import "PromotionTableViewCell.h"

#import "Preference.h"
#import "Constants.h"

#import <AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import "ServerAPIPath.h"

#import "utility.h"
#import "AppDelegate.h"

@interface CouponViewController ()
{
    Preference *pref;
    int selected_row;
}
@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pref = [Preference getInstance];
    
    [_myTable registerNib:[UINib nibWithNibName:@"PromotionTableViewCell" bundle:nil] forCellReuseIdentifier:@"PromotionTableViewCell"];
    
    [self getCoupon];
}
-(void)getCoupon
{
    [utility showProgressDialog:self];
    
    
    NSURL *URL = [NSURL URLWithString:API_POST_GET_COUPONS];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""], @"user_id",nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * task, id  responseObject) {
        
        [utility hideProgressDialog];
        if (responseObject == nil) {
            return;
        }
        else {
            NSError *error = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                @try {
                    NSDictionary *countJson = [json objectForKey:@"count"];
                    NSString *couponCnt = [countJson objectForKey:@"coupon"];
                    NSString *freestuffCnt = [countJson objectForKey:@"free"];
                    NSString *limitedtimeCnt = [countJson objectForKey:@"limit"];
                    
                    NSDictionary *items = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:couponCnt,freestuffCnt,limitedtimeCnt,nil] forKeys:[NSArray arrayWithObjects:@"coupon",@"freestuff",@"limitedtime", nil]];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"PromotionCount" object:self userInfo:items];
                    
                    _arrPromotion = [[promotionModel alloc] initCoupon:[json objectForKey:@"Data"]];
                    [_myTable reloadData];
                }
                @catch (NSException *e) {
                    NSLog(@"responseInvoiceList - JSONException : %@", e.reason);
                }
        }
        
        
    } failure:^(NSURLSessionDataTask  *task, NSError  *error) {
        
        [utility hideProgressDialog];
        [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        
    }];
}
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PromotionTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"PromotionTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[PromotionTableViewCell alloc] init];
    }
    NSString *photoUrl = [self.arrPromotion.photo objectAtIndex:indexPath.row];
    NSString *name = [self.arrPromotion.title objectAtIndex:indexPath.row];
    NSString *startdate = [self.arrPromotion.startdate objectAtIndex:indexPath.row]; //rate
    NSString *enddate = [self.arrPromotion.enddate objectAtIndex:indexPath.row];
    NSString *percent = [self.arrPromotion.others objectAtIndex:indexPath.row];
    
    [cell setPhotoCell:photoUrl];
    [cell setTitleCell:name];
    [cell setStartDateCell:startdate];
    [cell setEndDateCell:enddate];
    [cell setCouponCell:percent];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrPromotion.promotion_id count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
//    selected_row = (int)indexPath.row;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
