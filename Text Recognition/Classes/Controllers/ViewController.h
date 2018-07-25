//
//  ViewController.h
//  Text Recognition
//
//  Created by Alvin Resmana on 12/18/16.
//  Copyright © 2016 xeravim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TesseractOCR/TesseractOCR.h>
#import <FlatUIKit/FlatUIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface ViewController : UIViewController <G8TesseractDelegate,UIImagePickerControllerDelegate,FUIAlertViewDelegate, UINavigationControllerDelegate>{
 MBProgressHUD* hud;
 G8RecognitionOperation *operation;
 UIImage *initImage;
 float currentBlockSize;
 float currentCSize;
}
@property NSString* result;
@property (weak, nonatomic) IBOutlet UISlider *blockSizeSlider;
@property (weak, nonatomic) IBOutlet UISlider *cSlider;
@property (weak, nonatomic) IBOutlet UIImageView *imageText;
@property (weak, nonatomic) IBOutlet FUIButton *gaussianThreshold;
@property (weak, nonatomic) IBOutlet FUIButton *recognizeText;
@property (weak, nonatomic) IBOutlet FUIButton *otsuThreshold;
@property (weak, nonatomic) IBOutlet FUIButton *gaussianAndOtsuThreshold;
@property (weak, nonatomic) IBOutlet UILabel *blockSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cSizeLabel;

@end
