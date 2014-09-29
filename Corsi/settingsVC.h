//
//  settingsVC.h
//  Corsi
//
//  Created by Jon Howell on 04/09/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//


#import <UIKit/UIKit.h>
/*
#define kEmail      @"emailAddress"
#define kTester     @"testerName"
#define kSubject    @"subjectName"

#define kStart      @"startBlocks"
#define kFinish     @"finishBlocks"
#define kSize       @"blockSize"

#define kForward    @"forwardTestEnabled"
#define kInfo       @"infoEnabled"
#define kRot        @"rotationEnabled"

#define kBlockCol   @"blockColour"
#define kShowCol    @"highlightColour"
#define kBackCol    @"backgroundColour"

#define kDelay      @"blockDelay"
#define kTime       @"blockTime"
#define kShow       @"blockShow"

#define kVersion    @"version"
*/
@interface settingsVC : UIViewController{
    UIView *settingsViewerVIEW;
}

@property (strong, nonatomic) IBOutlet UIColor *currentBlockColour;
@property (strong, nonatomic) IBOutlet UIColor *currentBackgroundColour;
@property (strong, nonatomic) IBOutlet UIColor *currentShowColour;


@property (strong, nonatomic) IBOutlet UILabel *canvasLBL;
@property (strong, nonatomic) IBOutlet UILabel *blockLBL;
@property (strong, nonatomic) IBOutlet UILabel *showLBL;

- (IBAction)newRotationAngle:(id)sender;

- (IBAction)setDefaults:(id)sender;

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

@end