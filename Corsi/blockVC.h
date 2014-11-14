//
//  blockVC.h
//  Corsi
//
//  Created by Jonathan Howell on 28/09/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface blockVC : UIViewController

- (IBAction)blockStartPlusBTN:(id)sender;
- (IBAction)blockFinishPlusBTN:(id)sender;
- (IBAction)blockSizePlusBTN:(id)sender;
- (IBAction)blockStartMinusBTN:(id)sender;
- (IBAction)blockFinishMinusBTN:(id)sender;
- (IBAction)blockSizeMinusBTN:(id)sender;

- (IBAction)forwardTestSWT:(id)sender;
- (IBAction)onScreenInfoSWT:(id)sender;
- (IBAction)blockRotateSWT:(id)sender;
- (IBAction)animalsSWT:(id)sender;
- (IBAction)soundsSWT:(id)sender;
- (IBAction)soundsSEG:(id)sender;

- (void)buttonIncCheck;

@property (retain, nonatomic) IBOutlet UILabel *blockStartNumLBL;
@property (retain, nonatomic) IBOutlet UILabel *blockFinishNumLBL;
@property (retain, nonatomic) IBOutlet UILabel *blockSizeLBL;
@property (weak,   nonatomic) IBOutlet UISegmentedControl *soundsSEG;

@property (strong, nonatomic) IBOutlet UIButton *startMinusBTN;
@property (strong, nonatomic) IBOutlet UIButton *finishMinusBTN;
@property (strong, nonatomic) IBOutlet UIButton *sizeMinusBTN;
@property (strong, nonatomic) IBOutlet UIButton *startPlusBTN;
@property (strong, nonatomic) IBOutlet UIButton *finishPlusBTN;
@property (strong, nonatomic) IBOutlet UIButton *sizePlusBTN;

@property (weak, nonatomic) IBOutlet UISwitch *forwardTestSWT;
@property (weak, nonatomic) IBOutlet UISwitch *onScreenInfoSWT;
@property (weak, nonatomic) IBOutlet UISwitch *blockRotateSWT;
@property (weak, nonatomic) IBOutlet UISwitch *animalsSWT;
@property (weak, nonatomic) IBOutlet UISwitch *soundsSWT;

@end
