//
//  ResultController.h
//  Text Recognition
//
//  Created by Alvin Resmana on 12/31/16.
//  Copyright © 2016 xeravim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property NSString* result;
@end
