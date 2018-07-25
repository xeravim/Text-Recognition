//
//  HomeControllerViewController.m
//  Text Recognition
//
//  Created by Alvin Resmana on 4/7/17.
//  Copyright © 2017 xeravim. All rights reserved.
//

#import "HomeControllerViewController.h"
#import <FlatUIKit/FlatUIKit.h>
@interface HomeControllerViewController ()

@end

@implementation HomeControllerViewController
@synthesize personal;
- (void)viewDidLoad {
    [super viewDidLoad];
 personal.buttonColor = [UIColor turquoiseColor];
 personal.shadowColor = [UIColor greenSeaColor];
 personal.shadowHeight = 3.0f;
 personal.cornerRadius = 6.0f;
 personal.titleLabel.font = [UIFont boldFlatFontOfSize:16];
 [personal setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
 [personal setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
 
 _logistic.buttonColor = [UIColor turquoiseColor];
 _logistic.shadowColor = [UIColor greenSeaColor];
 _logistic.shadowHeight = 3.0f;
 _logistic.cornerRadius = 6.0f;
 _logistic.titleLabel.font = [UIFont boldFlatFontOfSize:16];
 [_logistic setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
 [_logistic setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
 
 
 _Corporate.buttonColor = [UIColor turquoiseColor];
 _Corporate.shadowColor = [UIColor greenSeaColor];
 _Corporate.shadowHeight = 3.0f;
 _Corporate.cornerRadius = 6.0f;
 _Corporate.titleLabel.font = [UIFont boldFlatFontOfSize:16];
 [_Corporate setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
 [_Corporate setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
 
 
 _premium.buttonColor = [UIColor turquoiseColor];
 _premium.shadowColor = [UIColor greenSeaColor];
 _premium.shadowHeight = 3.0f;
 _premium.cornerRadius = 6.0f;
 _premium.titleLabel.font = [UIFont boldFlatFontOfSize:16];
 [_premium setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
 [_premium setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
 

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
