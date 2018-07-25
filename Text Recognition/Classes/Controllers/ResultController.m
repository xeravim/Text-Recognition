//
//  ResultController.m
//  Text Recognition
//
//  Created by Alvin Resmana on 12/31/16.
//  Copyright © 2016 xeravim. All rights reserved.
//

#import "ResultController.h"

@interface ResultController ()

@end

@implementation ResultController

- (void)viewDidLoad {
    [super viewDidLoad];
 [self.resultTextView setText:self.result];
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
