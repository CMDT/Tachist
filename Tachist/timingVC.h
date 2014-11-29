//
//  timingVC.h
//  Tachist
//
//  Created by Jonathan Howell on 28/09/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface timingVC : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UISlider *blockShowTimeSLD;
@property (strong, nonatomic) IBOutlet UISlider *blockWaitTimeSLD;
@property (strong, nonatomic) IBOutlet UISlider *blockStartDelaySLD;

@property (strong, nonatomic) IBOutlet UITextField *blockStartDelayTXT;
@property (strong, nonatomic) IBOutlet UITextField *blockWaitTimeTXT;
@property (strong, nonatomic) IBOutlet UITextField *blockShowTimeTXT;

@property (strong, nonatomic) IBOutlet UITextView *timeMessageTXT;

- (IBAction)blockStartDelaySLD:(UISlider *)sender;
- (IBAction)blockWaitTimeSLD  :(UISlider *)sender;
- (IBAction)blockShowTimeSLD  :(UISlider *)sender;

@end

