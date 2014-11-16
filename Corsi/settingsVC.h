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

@property (nonatomic,retain) UIViewController  *settingsVC;
@property (strong, nonatomic) IBOutlet UILabel *canvasLBL;
@property (strong, nonatomic) IBOutlet UILabel *blockLBL;
@property (strong, nonatomic) IBOutlet UILabel *showLBL;
@property (strong, nonatomic) IBOutlet UILabel *testerLBL;
@property (strong, nonatomic) IBOutlet UILabel *emailLBL;
@property (strong, nonatomic) IBOutlet UILabel *subjectLBL;

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

@property (strong, nonatomic) IBOutlet UIImageView  *block1View;
@property (strong, nonatomic) IBOutlet UIImageView  *block2View;
@property (strong, nonatomic) IBOutlet UIImageView  *block3View;
@property (strong, nonatomic) IBOutlet UIImageView  *block4View;
@property (strong, nonatomic) IBOutlet UIImageView  *block5View;
@property (strong, nonatomic) IBOutlet UIImageView  *block6View;
@property (strong, nonatomic) IBOutlet UIImageView  *block7View;
@property (strong, nonatomic) IBOutlet UIImageView  *block8View;
@property (strong, nonatomic) IBOutlet UIImageView  *block9View;

@property (retain, nonatomic) IBOutlet UIView  *settingsViewerVIEW;

-(void)setDefaults;
-(UIColor*)colourPicker:(NSString*)colourName;
-(NSString*)colourUIToString:(UIColor*)myUIColour;
-(IBAction)saveSettings:(id)sender;
-(IBAction)loadSettings:(id)sender;

@end