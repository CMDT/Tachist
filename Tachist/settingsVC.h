//
//  settingsVC.h
//  Tachist
//
//  Created by Jon Howell on 04/09/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface settingsVC : UIViewController{
    UIView *settingsViewerVIEW;
}

@property (nonatomic,retain) UIViewController  * settingsVC;

@property (strong, nonatomic) IBOutlet UILabel * testerLBL;
@property (strong, nonatomic) IBOutlet UILabel * emailLBL;

@property (strong, nonatomic) IBOutlet UILabel * blockStartLBL;
@property (strong, nonatomic) IBOutlet UILabel * blockShowLBL;
@property (strong, nonatomic) IBOutlet UILabel * blockWaitLBL;

@property (strong, nonatomic) IBOutlet UILabel * infoLBL;
@property (strong, nonatomic) IBOutlet UILabel * soundsLBL;

-(void)setDefaults;

-(IBAction)saveSettings:(id)sender;
-(IBAction)loadSettings:(id)sender;

@end