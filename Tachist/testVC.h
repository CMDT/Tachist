//
//  testVC.h
//  Tachist
//
//  Created by Jon Howell on 04/09/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface testVC : UIViewController{
    SystemSoundID mySoundEffect;
    AVAudioPlayer * backgroundMusicPlayer;
    BOOL backIsStarted;
}

@property (nonatomic, copy) NSDate * startDate;

@property (nonatomic, retain) AVAudioPlayer        * backgroundMusicPlayer;
@property (retain, nonatomic) IBOutlet UILabel     * headingLBL;
@property (retain, nonatomic) IBOutlet UITextView  * statusMessageTXT;
@property (retain, nonatomic) IBOutlet UILabel     * statusMessageLab;
@property (retain, nonatomic) IBOutlet UIImageView * MessageView;
@property (retain, nonatomic) IBOutlet UITextView  * MessageTextView;

//buttons for control
@property (strong, nonatomic) IBOutlet UIButton * startBTN;
@property (retain, nonatomic) IBOutlet UIButton * stopTestNowBTN;

//images for the boxes


@property (strong, nonatomic) IBOutlet UIView  * testViewerView;

@property (nonatomic) float scaleFactor;

-(IBAction)startTest:(id)sender;
-(IBAction)stopTestNow:(id)sender;

- (IBAction)yesPressed;
- (IBAction)noPressed;

-(float) delayDelay;
-(float) delayWait;
-(float) delayShow;

-(NSString*)getCurrentDate;
-(NSString*)getCurrentTime;

@end
