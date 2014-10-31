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
#define kAnimals    @"animalsEnabled"
#define kSounds     @"soundsEnabled"

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

@property (strong, nonatomic) IBOutlet UILabel *canvasLBL;
@property (strong, nonatomic) IBOutlet UILabel *blockLBL;
@property (strong, nonatomic) IBOutlet UILabel *showLBL;

@property (strong, nonatomic) IBOutlet UILabel *blockSizeLBL;
@property (strong, nonatomic) IBOutlet UILabel *blockStartNumLBL;
@property (strong, nonatomic) IBOutlet UILabel *blockFinishNumLBL;

@property (strong, nonatomic) IBOutlet UILabel *blockStartLBL;
@property (strong, nonatomic) IBOutlet UILabel *blockShowLBL;
@property (strong, nonatomic) IBOutlet UILabel *blockWaitLBL;

@property (strong, nonatomic) IBOutlet UILabel *forwardLBL;
@property (strong, nonatomic) IBOutlet UILabel *infoLBL;
@property (strong, nonatomic) IBOutlet UILabel *rotateLBL;
@property (strong, nonatomic) IBOutlet UILabel *animalsLBL;
@property (strong, nonatomic) IBOutlet UILabel *soundsLBL;

@property (retain, nonatomic) IBOutlet UIView *block1View;
@property (retain, nonatomic) IBOutlet UIView *block2View;
@property (retain, nonatomic) IBOutlet UIView *block3View;
@property (retain, nonatomic) IBOutlet UIView *block4View;
@property (retain, nonatomic) IBOutlet UIView *block5View;
@property (retain, nonatomic) IBOutlet UIView *block6View;
@property (retain, nonatomic) IBOutlet UIView *block7View;
@property (retain, nonatomic) IBOutlet UIView *block8View;
@property (retain, nonatomic) IBOutlet UIView *block9View;

@property (retain, nonatomic) IBOutlet UIView *settingsViewerVIEW;

-(void)setDefaults;
-(UIColor*)colourPicker:(NSString*)colourName;
-(NSString*)colourUIToString:(UIColor*)myUIColour;
-(IBAction)saveSettings:(id)sender;
-(IBAction)loadSettings:(id)sender;

@end