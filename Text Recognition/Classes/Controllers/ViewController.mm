//
//  ViewController.m
//  Text Recognition
//
//  Created by Alvin Resmana on 12/18/16.
//  Copyright © 2016 xeravim. All rights reserved.
//

#import "ViewController.h"
#import "ResultController.h"
@interface ViewController ()
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@end

@implementation ViewController
@synthesize gaussianThreshold,gaussianAndOtsuThreshold, otsuThreshold, recognizeText;
- (void)configureButton{
 [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];
 [self.blockSizeSlider configureFlatSliderWithTrackColor:[UIColor silverColor]
                                  progressColor:[UIColor alizarinColor]
                                     thumbColor:[UIColor pomegranateColor]];
 [self.cSlider configureFlatSliderWithTrackColor:[UIColor silverColor]
                                           progressColor:[UIColor alizarinColor]
                                              thumbColor:[UIColor pomegranateColor]];
 gaussianThreshold.buttonColor = [UIColor turquoiseColor];
 gaussianThreshold.shadowColor = [UIColor greenSeaColor];
 gaussianThreshold.shadowHeight = 3.0f;
 gaussianThreshold.cornerRadius = 6.0f;
 gaussianThreshold.titleLabel.font = [UIFont boldFlatFontOfSize:16];
 [gaussianThreshold setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
 [gaussianThreshold setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
 
 gaussianAndOtsuThreshold.buttonColor = [UIColor turquoiseColor];
 gaussianAndOtsuThreshold.shadowColor = [UIColor greenSeaColor];
 gaussianAndOtsuThreshold.shadowHeight = 3.0f;
 gaussianAndOtsuThreshold.cornerRadius = 6.0f;
 gaussianAndOtsuThreshold.titleLabel.font = [UIFont boldFlatFontOfSize:16];
 [gaussianAndOtsuThreshold setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
 [gaussianAndOtsuThreshold setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
 
 otsuThreshold.buttonColor = [UIColor turquoiseColor];
 otsuThreshold.shadowColor = [UIColor greenSeaColor];
 otsuThreshold.shadowHeight = 3.0f;
 otsuThreshold.cornerRadius = 6.0f;
 otsuThreshold.titleLabel.font = [UIFont boldFlatFontOfSize:16];
 [otsuThreshold setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
 [otsuThreshold setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
 
 recognizeText.buttonColor = [UIColor midnightBlueColor];
 recognizeText.shadowColor = [UIColor cloudsColor];
 recognizeText.shadowHeight = 3.0f;
 recognizeText.cornerRadius = 6.0f;
 recognizeText.titleLabel.font = [UIFont boldFlatFontOfSize:16];
 [recognizeText setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
 [recognizeText setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
}
- (UIImage*)usingAdaptiveThreshGaussianC :(UIImage*)image :(float)blockSize :(float)cSize{
 cv::Mat greyMat;
 cv::Mat imageResult;
 cv::cvtColor([self cvMatFromUIImage:image], greyMat, CV_BGR2GRAY);
 cv::adaptiveThreshold(greyMat, imageResult, 255, CV_ADAPTIVE_THRESH_GAUSSIAN_C, CV_THRESH_BINARY_INV, blockSize, cSize);
 currentCSize = cSize;
 currentBlockSize = blockSize;
return [self UIImageFromCVMat:imageResult];
}

- (UIImage*)usingOtsuThresh :(UIImage*)image{
 cv::Mat greyMat;
 cv::Mat imageResult;
 cv::cvtColor([self cvMatFromUIImage:image], greyMat, CV_BGR2GRAY);
 cv::threshold(greyMat, imageResult, 0, 255, CV_THRESH_BINARY_INV | CV_THRESH_OTSU);
 return [self UIImageFromCVMat:imageResult];

}

- (UIImage*)usingGaussianAndOtsuThresh :(UIImage*)image{
 cv::Mat greyMat;
 cv::Mat imageAdaptive;
 cv::Mat imageResult;
 cv::cvtColor([self cvMatFromUIImage:image], greyMat, CV_BGR2GRAY);
 cv::adaptiveThreshold(greyMat, imageAdaptive, 255, CV_ADAPTIVE_THRESH_GAUSSIAN_C, CV_THRESH_BINARY_INV, 51, 31);
 cv::threshold(imageAdaptive, imageResult, 0, 255, CV_THRESH_BINARY | CV_THRESH_OTSU);
 return [self UIImageFromCVMat:imageResult];
 
}


-(void)recognizeImageWithTesseract:(UIImage *)image
{
 hud = [MBProgressHUD new];
 hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
 hud.label.text = @"Recognizing...";
 operation = [[G8RecognitionOperation alloc] initWithLanguage:@"eng"];
 operation.delegate = self;
 
 operation.tesseract.engineMode = G8OCREngineModeTesseractOnly;
 
 operation.tesseract.pageSegmentationMode = G8PageSegmentationModeAutoOnly;
 operation.tesseract.image = image;
 
 operation.recognitionCompleteBlock = ^(G8Tesseract *tesseract) {
  // Fetch the recognized text
  NSString *recognizedText = tesseract.recognizedText;
  
  self.result = recognizedText;
  [hud hideAnimated:YES];
  [self performSegueWithIdentifier:@"toResult" sender:self];
};
 
 //self.imageText.image = operation.tesseract.thresholdedImage;
 
 [self.operationQueue addOperation:operation];
 [G8Tesseract clearCache];
 
}

 //Tesseract delegate method inside of your class
- (UIImage *)preprocessedImageForTesseract:(G8Tesseract *)tesseract sourceImage:(UIImage *)sourceImage {
 return sourceImage;
}

- (void)progressImageRecognitionForTesseract:(G8Tesseract *)tesseract {

 NSLog(@"progress: %lu", tesseract.progress);

}


- (void)viewDidLoad {
    [super viewDidLoad];
 [self configureButton];
 
 initImage = self.imageText.image;
 self.operationQueue = [[NSOperationQueue alloc] init];

}


- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract {

 return NO;  // return YES, if you need to interrupt tesseract before it finishes
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
 CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
 CGFloat cols = image.size.width;
 CGFloat rows = image.size.height;
 
 cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
 
 CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                 cols,                       // Width of bitmap
                                                 rows,                       // Height of bitmap
                                                 8,                          // Bits per component
                                                 cvMat.step[0],              // Bytes per row
                                                 colorSpace,                 // Colorspace
                                                 kCGImageAlphaNoneSkipLast |
                                                 kCGBitmapByteOrderDefault); // Bitmap info flags
 
 CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
 CGContextRelease(contextRef);
 
 return cvMat;
}

- (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image
{
 CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
 CGFloat cols = image.size.width;
 CGFloat rows = image.size.height;
 
 cv::Mat cvMat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
 
 CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to data
                                                 cols,                       // Width of bitmap
                                                 rows,                       // Height of bitmap
                                                 8,                          // Bits per component
                                                 cvMat.step[0],              // Bytes per row
                                                 colorSpace,                 // Colorspace
                                                 kCGImageAlphaNoneSkipLast |
                                                 kCGBitmapByteOrderDefault); // Bitmap info flags
 
 CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
 CGContextRelease(contextRef);
 
 return cvMat;
}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
 NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
 CGColorSpaceRef colorSpace;
 
 if (cvMat.elemSize() == 1) {
  colorSpace = CGColorSpaceCreateDeviceGray();
 } else {
  colorSpace = CGColorSpaceCreateDeviceRGB();
 }
 
 CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
 
 // Creating CGImage from cv::Mat
 CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                     cvMat.rows,                                 //height
                                     8,                                          //bits per component
                                     8 * cvMat.elemSize(),                       //bits per pixel
                                     cvMat.step[0],                            //bytesPerRow
                                     colorSpace,                                 //colorspace
                                     kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                     provider,                                   //CGDataProviderRef
                                     NULL,                                       //decode
                                     false,                                      //should interpolate
                                     kCGRenderingIntentDefault                   //intent
                                     );
 
 
 // Getting UIImage from CGImage
 UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
 CGImageRelease(imageRef);
 CGDataProviderRelease(provider);
 CGColorSpaceRelease(colorSpace);
 
 return finalImage;
}

- (IBAction)otsu:(id)sender {
 UIImage *imageToRecognize = initImage;
 
 self.imageText.image = [self usingOtsuThresh:imageToRecognize];
}
- (IBAction)gaussian:(id)sender {
 UIImage *imageToRecognize = initImage;
 //self.imageText.image = [self usingGaussianAndOtsuThresh:imageToRecognize];
 self.imageText.image = [self usingAdaptiveThreshGaussianC:imageToRecognize :51 :31];
}
- (IBAction)recognizedText:(id)sender {
 [self recognizeImageWithTesseract:self.imageText.image];
}
- (IBAction)actions:(id)sender {
 FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"Actions"
                                                       message:nil
                                                      delegate:self cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"Take Photo",@"Select Photo", nil];
 alertView.titleLabel.textColor = [UIColor cloudsColor];
 alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
 alertView.messageLabel.textColor = [UIColor cloudsColor];
 alertView.messageLabel.font = [UIFont flatFontOfSize:14];
 alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
 alertView.alertContainer.backgroundColor = [UIColor midnightBlueColor];
 alertView.defaultButtonColor = [UIColor cloudsColor];
 alertView.defaultButtonShadowColor = [UIColor asbestosColor];
 alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
 alertView.defaultButtonTitleColor = [UIColor asbestosColor];
 [alertView show];
}
- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
 switch (buttonIndex) {
  case 0:
  
   break;
  case 1:
   [self takePicture];
   break;
  case 2:
   [self selectPicture];
   break;
  default:
   break;
 }
}
- (void)takePicture {
 UIImagePickerController *picker = [[UIImagePickerController alloc] init];
 picker.delegate = self;
 picker.allowsEditing = YES;
 picker.sourceType = UIImagePickerControllerSourceTypeCamera;
 
 [self presentViewController:picker animated:YES completion:NULL];
}

- (void)selectPicture{
 UIImagePickerController *picker = [[UIImagePickerController alloc] init];
 picker.delegate = self;
 picker.allowsEditing = YES;
 picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
 
 [self presentViewController:picker animated:YES completion:NULL];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
 
 UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
 initImage = chosenImage;
 self.imageText.image = chosenImage;
 
 [picker dismissViewControllerAnimated:YES completion:NULL];
 
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
 
 [picker dismissViewControllerAnimated:YES completion:NULL];
 
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 ResultController *controller = [segue destinationViewController];
 controller.result = self.result;
}
- (IBAction)cSlider:(UISlider*)sender {
 UIImage *imageToRecognize = initImage;
 [self.cSizeLabel setText:[NSString stringWithFormat:@"%d",(int)sender.value]];
 self.imageText.image = [self usingAdaptiveThreshGaussianC:imageToRecognize :currentBlockSize :sender.value];
}
- (IBAction)blockSize:(UISlider*)sender {
 UIImage *imageToRecognize = initImage;
 int block = (int)sender.value % 2;
 if (block == 0){
  block = (int)sender.value+1;
  [self.blockSizeLabel setText:[NSString stringWithFormat:@"%d",(int)block]];
  self.imageText.image = [self usingAdaptiveThreshGaussianC:imageToRecognize :block :currentCSize];
 }
 else{
  [self.blockSizeLabel setText:[NSString stringWithFormat:@"%d",(int)sender.value]];
  self.imageText.image = [self usingAdaptiveThreshGaussianC:imageToRecognize :(int)sender.value :currentCSize];
 }
 
}
@end
