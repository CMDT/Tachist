//
//  settingsVC.h
//  Corsi
//
//  Created by Jon Howell on 04/09/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface settingsVC : UIViewController{
    UIView *settingsViewerVIEW;
}

@property (retain, nonatomic) IBOutlet UISlider *blockShowTimeSLD;
@property (retain, nonatomic) IBOutlet UISlider *blockWaitTimeSLD;
@property (retain, nonatomic) IBOutlet UISlider *blockStartDelaySLD;

@property (retain, nonatomic) IBOutlet UILabel *blockStartNumLBL;
@property (retain, nonatomic) IBOutlet UILabel *blockFinishNumLBL;
@property (retain, nonatomic) IBOutlet UILabel *blockSizeLBL;

@property (strong, nonatomic) IBOutlet UIButton *startMinusBTN;
@property (strong, nonatomic) IBOutlet UIButton *finishMinusBTN;
@property (strong, nonatomic) IBOutlet UIButton *sizeMinusBTN;
@property (strong, nonatomic) IBOutlet UIButton *startPlusBTN;
@property (strong, nonatomic) IBOutlet UIButton *finishPlusBTN;
@property (strong, nonatomic) IBOutlet UIButton *sizePlusBTN;

@property (strong, nonatomic) IBOutlet UIColor *currentBlockColour;
@property (strong, nonatomic) IBOutlet UIColor *currentBackgroundColour;
@property (strong, nonatomic) IBOutlet UIColor *currentShowColour;

- (IBAction)newRotationAngle:(id)sender;

- (IBAction)setDefaults:(id)sender;

- (IBAction)blockStartPlusBTN:(id)sender;
- (IBAction)blockFinishPlusBTN:(id)sender;
- (IBAction)blockSizePlusBTN:(id)sender;
- (IBAction)blockStartMinusBTN:(id)sender;
- (IBAction)blockFinishMinusBTN:(id)sender;
- (IBAction)blockSizeMinusBTN:(id)sender;

- (IBAction)forwardTestSWT:(id)sender;
- (IBAction)onScreenInfoSWT:(id)sender;
- (IBAction)blockRotateSWT:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *forwardTestSWT;
@property (weak, nonatomic) IBOutlet UISwitch *onScreenInfoSWT;
@property (weak, nonatomic) IBOutlet UISwitch *blockRotateSWT;

@property (weak, nonatomic) IBOutlet UILabel *blockStartDelayLBL;
@property (weak, nonatomic) IBOutlet UILabel *blockWaitTimeLBL;
@property (weak, nonatomic) IBOutlet UILabel *blockShowTimeLBL;

- (IBAction)blockStartDelaySLD:(UISlider *)sender;
- (IBAction)blockWaitTimeSLD:(UISlider *)sender;
- (IBAction)blockShowTimeSLD:(UISlider *)sender;

- (IBAction)BlockColourBlaBTN:(id)sender;
- (IBAction)BlockColourBluBTN:(id)sender;
- (IBAction)BlockColourRedBTN:(id)sender;
- (IBAction)BlockColourOraBTN:(id)sender;
- (IBAction)BlockColourGreBTN:(id)sender;
- (IBAction)BlockColourCyaBTN:(id)sender;
- (IBAction)BlockColourYelBTN:(id)sender;
- (IBAction)BlockColourWhiBTN:(id)sender;
- (IBAction)BlockColourGraBTN:(id)sender;
- (IBAction)BlockColourMagBTN:(id)sender;

- (IBAction)BlockHighlightColourBlaBTN:(id)sender;
- (IBAction)BlockHighlightColourBluBTN:(id)sender;
- (IBAction)BlockHighlightColourRedBTN:(id)sender;
- (IBAction)BlockHighlightColourOraBTN:(id)sender;
- (IBAction)BlockHighlightColourGreBTN:(id)sender;
- (IBAction)BlockHighlightColourCyaBTN:(id)sender;
- (IBAction)BlockHighlightColourYelBTN:(id)sender;
- (IBAction)BlockHighlightColourWhiBTN:(id)sender;

- (IBAction)BlockBackgroundColourBlaBTN:(id)sender;
- (IBAction)BlockBackgroundColourBluBTN:(id)sender;
- (IBAction)BlockBackgroundColourRedBTN:(id)sender;
- (IBAction)BlockBackgroundColourOraBTN:(id)sender;
- (IBAction)BlockBackgroundColourGreBTN:(id)sender;
- (IBAction)BlockBackgroundColourCyaBTN:(id)sender;
- (IBAction)BlockBackgroundColourYelBTN:(id)sender;
- (IBAction)BlockBackgroundColourWhiBTN:(id)sender;

@property (retain, nonatomic) IBOutlet UIView *block1View;
@property (retain, nonatomic) IBOutlet UIView *block2View;
@property (retain, nonatomic) IBOutlet UIView *block3View;
@property (retain, nonatomic) IBOutlet UIView *block4View;
@property (retain, nonatomic) IBOutlet UIView *block5View;
@property (retain, nonatomic) IBOutlet UIView *block6View;
@property (retain, nonatomic) IBOutlet UIView *block7View;
@property (retain, nonatomic) IBOutlet UIView *block8View;
@property (retain, nonatomic) IBOutlet UIView *block9View;

//@property (strong, nonatomic) IBOutlet UIView *CBTView;

@property (retain, nonatomic) IBOutlet UIView *settingsViewerVIEW;

//@property (strong, nonatomic) IBOutlet UIView *bl1;
//@property (strong, nonatomic) IBOutlet UIView *bl2;
//@property (strong, nonatomic) IBOutlet UIView *bl3;
//@property (strong, nonatomic) IBOutlet UIView *bl4;
//@property (strong, nonatomic) IBOutlet UIView *bl5;
//@property (strong, nonatomic) IBOutlet UIView *bl6;
//@property (strong, nonatomic) IBOutlet UIView *bl7;
//@property (strong, nonatomic) IBOutlet UIView *bl8;
//@property (strong, nonatomic) IBOutlet UIView *bl9;
//@property (strong, nonatomic) IBOutlet UIButton *startTestBTNo;
//- (IBAction)startTestBTNa:(id)sender;
//@property (strong, nonatomic) IBOutlet UILabel *infoStartLBL;
//@property (strong, nonatomic) IBOutlet UILabel *infoFinishLBL;
//@property (strong, nonatomic) IBOutlet UILabel *infoRoundLBL;
//@property (strong, nonatomic) IBOutlet UILabel *infoSelectLBL;
//@property (strong, nonatomic) IBOutlet UILabel *myMessageLBL;

-(float)randomDegrees359;
//-(CGPoint)randomXY:(CGFloat)X Y:(CGFloat)Y;
-(void)updateBlockNumbers;
-(void)saveSettings;
-(void)loadSettings;

@end