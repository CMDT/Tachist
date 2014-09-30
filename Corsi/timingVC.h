//
//  timingVC.h
//  Corsi
//
//  Created by Jonathan Howell on 28/09/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface timingVC : UIViewController

- (IBAction)blockStartDelaySLD:(UISlider *)sender;
- (IBAction)blockWaitTimeSLD  :(UISlider *)sender;
- (IBAction)blockShowTimeSLD  :(UISlider *)sender;

@property (retain, nonatomic) IBOutlet UISlider *blockShowTimeSLD;
@property (retain, nonatomic) IBOutlet UISlider *blockWaitTimeSLD;
@property (retain, nonatomic) IBOutlet UISlider *blockStartDelaySLD;

@property (weak, nonatomic) IBOutlet UILabel *blockStartDelayLBL;
@property (weak, nonatomic) IBOutlet UILabel *blockWaitTimeLBL;
@property (weak, nonatomic) IBOutlet UILabel *blockShowTimeLBL;

@property (weak, nonatomic) IBOutlet UITextField *blockStartDelayTXT;
@property (weak, nonatomic) IBOutlet UITextField *blockWaitTimeTXT;
@property (weak, nonatomic) IBOutlet UITextField *blockShowTimeTXT;

@end

