//
//  testVC.m
//  Tachist
//
//  Created by Jon Howell on 04/09/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import "testVC.h"
#import "mySingleton.h"

#define kEmail      @"emailAddress"
#define kTester     @"testerName"
#define kSubject    @"subjectName"

@interface testVC ()
{
    int startcounter;
    int finishcounter;
    int stageCounter;
    int xcounter;
    int ncounter;

    int total;
    int score;
    int pressNo;
    int testNo;
    int timingCalc;
    int reply1;
    int start;
    int finish;
    
    long tm;
    
    float waitTime;
    float startTime;
    float showTime;
    float messageTime;
    float blockSize1;
    float percent;
    float flash2;
    
    //for timing
    Float32 testReactionTime[10];     //each group
    Float32 reactionTime[7][12];      //each test
    Float32 totalReactionTime;        //total for all tests
    Float32 shortestReactionTime[10]; //for each group
    Float32 longestReactionTime[10];
    Float32 averageReactionTime[10];
    
    double noOfSeconds;
    
    BOOL analysisFlag;
    BOOL isFinished;
    BOOL isCalculating;
    BOOL isAlertFinished;
    BOOL isAborted;
    BOOL stageEnded;
    BOOL resultsSaved;
    BOOL infoShow;


    NSString *order[12];
    NSString *guess[12];
    NSString *reverse[12];
    NSString *beepName;
    NSString *subjectName;
    NSString *email;
    NSString *testerName;
    NSString *tempStartMessage;
    NSString *orderStr[12];
    NSString *reverseStr[12];
    NSString *guessStr[12];
    NSString *correct[12];

    UIColor *currentBlockColour;
    UIColor *currentShowColour;
    UIColor *currentBackgroundColour;
    UIColor *currentStatusColour;
    
    NSNumber *box[10];
    
    UIImageView *card[11];
}
@end

@implementation testVC{

}

@synthesize
    backgroundMusicPlayer, //for sounds
    blkLBL,
    blkNoLBL,
    blkTotalLBL,
    blkOfLBL,
    startBTN,
    statusMessageTXT,
    headingLBL,
    MessageTextView,
    MessageView,
    scaleFactor,
    testViewerView,
    stopTestNowBTN
    ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    stopTestNowBTN.hidden=YES;
    MessageView.hidden=YES;
    [self hideInfo];

    mySingleton *singleton = [mySingleton sharedSingleton];
    
    isAborted=NO;
    
    //sound stuff
    backIsStarted=false;
    
    beepName = singleton.beepEffect;

    NSString *backgroundMusicPath=[[NSBundle mainBundle]pathForResource:beepName ofType:@"caf"];
    NSURL *backgroundMusicURL=[NSURL fileURLWithPath:backgroundMusicPath];
    NSError *error;
    
    backgroundMusicPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    [backgroundMusicPlayer setNumberOfLoops:3]; //-1 = forever
    //prepare to play
    NSString *mySoundEffectPath=[[NSBundle mainBundle]pathForResource:beepName ofType:@"caf"];
    NSURL *mySoundEffectURL=[NSURL fileURLWithPath:mySoundEffectPath];
    AudioServicesCreateSystemSoundID(CFBridgingRetain(mySoundEffectURL),&mySoundEffect);
    
    infoShow = singleton.onScreenInfo;

    flash2 = 0.25;// flash button when pressed
}

-(void)viewDidAppear:(BOOL)animated{
    [self hideInfo];
    MessageTextView.hidden=YES;
    startBTN.hidden   = NO;
    headingLBL.hidden = NO;
    isAborted         = NO;
    UIImage *testImage      = [UIImage imageNamed:@"test.png"];
    UIImage *testImageSel   = [UIImage imageNamed:@"test.png"];
    testImage               = [testImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    testImageSel            = [testImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.tabBarItem         = [[UITabBarItem alloc] initWithTitle:@"Test" image:testImage selectedImage: testImageSel];

    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Test" image:testImage selectedImage: testImageSel];

    isAborted=NO;

    tempStartMessage=@"You will be shown a sequence of cards. \n\nObserve the O's, then recall \nif a X is present. \n\nThe test will proceed until all the sections are completed.\n\nYou will exit the test if you touch the 'Cancel Test' button during the test.\n\nOnly completed tests are valid and available for analysis and email.";

    MessageTextView.text = tempStartMessage;
    MessageTextView.textAlignment = NSTextAlignmentCenter;
    //MessageTextView.font=[UIFont fontWithName:@"Serifa-Roman" size:(14.0f)];

    MessageTextView.hidden = NO;
    MessageView.hidden     = YES;
    startBTN.hidden        = NO;

    //initialise images for messages on messageview
    card[0] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"started.png"]];    //start
    card[1] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"finished.png"]];   //finish
    card[2] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loading.png"]];    //loading
    card[3] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"recall.png"]];     //recall
    card[4] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"calculating.png"]];     //calculations
    //card[5] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi-touch-blocks2.png"]];
    card[6] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"redblocks800.png"]];  //results
    card[7] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cancelled.png"]]; //cancel message
    //card[8] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi_blank.png"]];     //just a blank card
    //card[9] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"redblocks800.png"]];     //picture of some coloured blocks
}

-(void)startStop{
    //toggle the background sounds on/off
    if (backIsStarted) {
        [backgroundMusicPlayer stop];
    }else{
        [backgroundMusicPlayer prepareToPlay];
        [backgroundMusicPlayer play];
    }
    backIsStarted=!backIsStarted;
}

-(void)setVolumeValue{
    //set the volume of the sound
    [backgroundMusicPlayer setVolume:5];
}

-(void)playMyEffect{
    //make a noise, if the flag is on for sound
        mySingleton *singleton = [mySingleton sharedSingleton];
    if (singleton.sounds) {
        AudioServicesPlaySystemSound(mySoundEffect);
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //an alert was detected, get the text filelds and update the singleton
    mySingleton *singleton = [mySingleton sharedSingleton];
    //NSString * testerEmail =[[alertView textFieldAtIndex:0] text];

    NSString * participant=@"none";
    participant=[[alertView textFieldAtIndex:0] text];//used to be 1 for dual entry, 0 for single
        //NSLog(@"Tester Email    : %@", testerEmail);
        //NSLog(@"Participant     : %@", participant);

    //test for blank names and details
    //if ([testerEmail isEqualToString:@""]) {
    //    testerEmail=singleton.email;
    //}

    //update singleton
    //singleton.email       = testerEmail;
    //save to plist root

    //email name
        //[defaults setObject:testerEmail forKey:kEmail];
    //subject name
    if (participant==nil||[participant isEqualToString:@""]) {
        singleton.oldSubjectName = [singleton.subjectName stringByAppendingString: [NSString stringWithFormat:@"_%@",[self getCurrentDateTimeAsNSString]]];
        //no name was input, use the old one
    }else{
        NSString *pathStr = [[NSBundle mainBundle] bundlePath];
        NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
        NSString *defaultPrefsFile   = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
        NSDictionary *defaultPrefs   = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
        NSUserDefaults *defaults     = [NSUserDefaults standardUserDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //for plist
        [defaults setObject:participant forKey:kSubject];
        //for singleton
        singleton.subjectName = participant;
        singleton.oldSubjectName = [singleton.subjectName stringByAppendingString: [NSString stringWithFormat:@"_%@",[self getCurrentDateTimeAsNSString]]];
    }
    isAlertFinished=YES;
}

-(NSString*)getCurrentDateTimeAsNSString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"ddMMyyHHmmss"];
    NSDate *now = [NSDate date];
    NSString *retStr = [format stringFromDate:now];
    
    return retStr;
}

-(NSString*)getCurrentDate
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd/MM/yyyy"];
    NSDate *now = [NSDate date];
    NSString *retStr = [format stringFromDate:now];
    
    return retStr;
}

-(NSString*)getCurrentTime
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm:ss"];
    NSDate *now = [NSDate date];
    NSString *retStr = [format stringFromDate:now];
    
    return retStr;
}

-(void)participantEntry{
    mySingleton *singleton = [mySingleton sharedSingleton];
    //clear the underlying text message instructions
    MessageTextView.hidden=YES;
    
    //do a text input for the participant
    //two line alert
    /*UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                     message:@"Enter Tester Email and Participant Code"
                                                    delegate:self
                                           cancelButtonTitle:nil //@"Cancel"
                                           otherButtonTitles:@"Continue", nil]; 
     alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;*/
    //one line alert
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""//@"CORSI TEST START"
                                                     message:@"Enter a Participant Code For This Test, or to use the pervious one, \ntouch 'continue'"
                                                    delegate:self
                                           cancelButtonTitle:nil //@"Cancel"
                                           otherButtonTitles:@"Continue", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;

    //UITextField * alertTextField1 = [alert textFieldAtIndex:0];
    //alertTextField1.keyboardType = UIKeyboardTypeEmailAddress;
    //alertTextField1.placeholder = singleton.email;

    UITextField * alertTextField2 = [alert textFieldAtIndex:0];//used to be 1 for dual entry, 0 for single
    alertTextField2.secureTextEntry = NO;
    alertTextField2.textAlignment = NSTextAlignmentCenter;
    alertTextField2.keyboardType = UIKeyboardTypeDefault;
    alertTextField2.textAlignment =NSTextAlignmentNatural;
    [alertTextField2 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:(28.0)]];
    //if blank, add temp name, else add the current one
    if ([singleton.subjectName isEqualToString:@""]) {
        alertTextField2.placeholder = @"Participant Code";
    }else{
        alertTextField2.placeholder = singleton.subjectName;
    }
    [alert show];
}

-(IBAction)startTest:sender{
    MessageView.hidden=NO;
    [MessageView setImage: card[2].image]; //loading message
    [self animateMessageViewOUT2:0.5];

    isAlertFinished=NO;
    self.tabBarController.tabBar.hidden = YES;
    MessageTextView.hidden=YES;
    startBTN.hidden=YES;
    statusMessageTXT.hidden=YES;
    
    [self participantEntry];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)stopTestNow:(id)sender{
    stopTestNowBTN.hidden=YES;
    MessageView.hidden = NO;
    [self hideInfo];

    //Cancel, return to settings after message

    isFinished         = YES;
    isCalculating      = YES;
    isAborted          = YES;
    
    [MessageView setImage: card[7].image];//cancelled image
    [self animateMessageViewIN];

//halt here, user selects new menu option to proceed
    //[MessageView setImage: card[7].image]; //hold message if not faded out (set animate out to hold for this one if needed
    [NSTimer scheduledTimerWithTimeInterval:3.5 target:self selector:@selector(abortWasPressed) userInfo:nil repeats:NO];
}

-(void)abortWasPressed{
    //the end...
        [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(selectTabBarSettings) userInfo:nil repeats:NO];
}

//
-(float) delayDelay
{//start delay, once only
    mySingleton *singleton = [mySingleton sharedSingleton];
    float delayDelay1;
    delayDelay1  = singleton.startTime/1000;
    return delayDelay1;
}

-(float) delayWait
{//wait delay, after each box display
    mySingleton *singleton = [mySingleton sharedSingleton];
    float delayWait1;
    delayWait1 = singleton.waitTime/1000;
    return delayWait1;
}

-(float) delayShow
{//show delay, after each box display
    mySingleton *singleton = [mySingleton sharedSingleton];
    float delayShow1;
    delayShow1 = singleton.showTime/1000;
    return delayShow1;
}

-(float) delayMessage
{//show delay, after each box display
    mySingleton *singleton = [mySingleton sharedSingleton];
    float delayMessage1;
    delayMessage1 = singleton.messageTime/1000;
    return delayMessage1;
}



-(void)showInfo{
    //show the messages and status
    blkLBL.hidden      = false;
    blkNoLBL.hidden    = false;
    blkOfLBL.hidden    = false;
    blkTotalLBL.hidden = false;
    statusMessageTXT.hidden
                       = false;
}
-(void)hideInfo{
    //hide the messages and status
    blkLBL.hidden      = true;
    blkNoLBL.hidden    = true;
    blkOfLBL.hidden    = true;
    blkTotalLBL.hidden = true;
    statusMessageTXT.hidden
                       = true;
}



-(void)animateMessageView{
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(animateMessageViewIN) userInfo:nil repeats:NO];
}

-(void)animateMessageViewIN{
    //ease in
    MessageView.alpha = 0.0;
    MessageView.hidden=NO;
    [[MessageView superview] bringSubviewToFront:MessageView];
    
    //[UIView animateKeyframesWithDuration:1 delay:1 options:1 animations:^(){MessageView.alpha = 1.0;} completion:nil];
    [UIView animateWithDuration:1.2
              delay:0  /* do not add a delay because we will use performSelector. */
            options:UIViewAnimationOptionCurveEaseInOut
         animations:^ {
        MessageView.alpha = 1.0; //fade in
                      }
        completion:^(BOOL finished) {[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(animateMessageViewOUT) userInfo:nil repeats:NO];
                      }];
}

-(void)animateMessageViewIN2:(float)dur{
    //ease in
    MessageView.alpha = 0.0;
    MessageView.hidden=NO;
    [[MessageView superview] bringSubviewToFront:MessageView];

    //[UIView animateKeyframesWithDuration:1 delay:1 options:1 animations:^(){MessageView.alpha = 1.0;} completion:nil];
    [UIView animateWithDuration:dur
                          delay:0  /* do not add a delay because we will use performSelector. */
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         MessageView.alpha = 1.0; //fade in
                     }
                     completion:^(BOOL finished) {[NSTimer scheduledTimerWithTimeInterval:dur target:self selector:@selector(animateMessageViewOUT) userInfo:nil repeats:NO];
                     }];
}

-(void)animateMessageViewOUT{
    //ease out
    MessageView.hidden=NO;
    [[MessageView superview] bringSubviewToFront:MessageView];

    [UIView animateWithDuration:1.0
                          delay:1.2
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         /*if (isCalculating) { //do not fade out, keep display on
                             MessageView.alpha = 1.0;
                         }else{
                             MessageView.alpha = 0.0;
                         }*/
                         MessageView.alpha = 0.0; //fade out
                     }
                     completion:^(BOOL finished) {
                     }];
    //nothing else to do, the image was shown
}

-(void)animateMessageViewOUT2:(float)dur{
    //ease out
    MessageView.hidden=NO;
    [[MessageView superview] bringSubviewToFront:MessageView];

    [UIView animateWithDuration:dur
                          delay:dur
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         /*if (isCalculating) { //do not fade out, keep display on
                          MessageView.alpha = 1.0;
                          }else{
                          MessageView.alpha = 0.0;
                          }*/
                         MessageView.alpha = 0.0; //fade out
                     }
                     completion:^(BOOL finished) {
                     }];
    //nothing else to do, the image was shown
}



-(void)selectTabBarResults{
    //jump to the results view
        int controllerIndex = 2;

        UITabBarController *tabBarController = self.tabBarController;
        UIView * fromView = tabBarController.selectedViewController.view;
        UIView * toView = [[tabBarController.viewControllers objectAtIndex:controllerIndex] view];

        // Transition using a page curl.
        [UIView transitionFromView:fromView
                            toView:toView
                          duration:2.0
                           options:(controllerIndex > tabBarController.selectedIndex ? UIViewAnimationOptionTransitionFlipFromLeft: UIViewAnimationOptionTransitionCurlDown)
                        completion:^(BOOL finished) {
                            if (finished) {
                                tabBarController.selectedIndex = controllerIndex;
                            }
                        }];
    //results VC jump
}

-(void)selectTabBarSettings{

    //jump to the setting view
    int controllerIndex = 0;

    UITabBarController *tabBarController = self.tabBarController;
    UIView * fromView = tabBarController.selectedViewController.view;
    UIView * toView = [[tabBarController.viewControllers objectAtIndex:controllerIndex] view];

    // Transition using a page curl.
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:2.0
                       options:(controllerIndex > tabBarController.selectedIndex ? UIViewAnimationOptionTransitionFlipFromRight : UIViewAnimationOptionTransitionCurlDown)
                    completion:^(BOOL finished) {
                        if (finished) {
                            tabBarController.selectedIndex = controllerIndex;
                        }
                    }];
    //settings VC jump
}



-(void)calculations{
    //MessageView.hidden = YES;
    if (isAborted == NO) {

    mySingleton *singleton = [mySingleton sharedSingleton];
    //NSLog(@"Calculations have started.");

    //clear arrays for results strings
    [singleton.resultStringRows removeAllObjects];
    [singleton.displayStringRows removeAllObjects];
    [singleton.displayStringTitles removeAllObjects];

    //clear output strings
    singleton.resultStrings=@"";
    singleton.displayStrings=@"";

    singleton.testTime=[self getCurrentTime];
    singleton.testDate=[self getCurrentDate];

    //NSLog(@"Results array cleared, new results ready..");
    
   /* NSLog(@"String 1 was:%@, your guess:%@",order[1],guessStr[1]);
    NSLog(@"String 2 was:%@, your guess:%@",order[2],guessStr[2]);
    NSLog(@"String 3 was:%@, your guess:%@",order[3],guessStr[3]);
    NSLog(@"String 4 was:%@, your guess:%@",order[4],guessStr[4]);
    NSLog(@"String 5 was:%@, your guess:%@",order[5],guessStr[5]);
    NSLog(@"String 6 was:%@, your guess:%@",order[6],guessStr[6]);
    NSLog(@"String 7 was:%@, your guess:%@",order[7],guessStr[7]);
    NSLog(@"String 8 was:%@, your guess:%@",order[8],guessStr[8]);
    NSLog(@"String 9 was:%@, your guess:%@",order[9],guessStr[9]);*/

    NSString * tempString;
    NSString * tempString2;
    NSString * tempString3;
    NSString * tempString4;

    int cor;
    int wro;
    int totcor = 0;
    int totwro = 0;

    NSString * ee;
    NSString * ff;

    //headers
    //line
    tempString=@"Tachist Block Tapping Test Results";
    [singleton.resultStringRows addObject: tempString];//csv
    [singleton.displayStringTitles addObject:tempString ];//title
    [singleton.displayStringRows addObject: @""];//data
        
    //blank
    tempString=@"";
    [singleton.resultStringRows addObject:tempString];//csv

    tempString  = @"Date:";
    tempString2 =singleton.testDate;
    [singleton.displayStringTitles addObject:tempString ];//title
    [singleton.displayStringRows addObject: tempString2];//data

    tempString  = @"Time:";
    tempString2=singleton.testTime;
    [singleton.displayStringTitles addObject:tempString ];//title
    [singleton.displayStringRows addObject: tempString2];//data

    tempString=[NSString stringWithFormat:@"Date: %@", singleton.testDate];//csv
    [singleton.resultStringRows addObject:tempString];
    tempString=[NSString stringWithFormat:@"Time: %@", singleton.testTime];//csv
    [singleton.resultStringRows addObject:tempString];

    tempString=@"";
    [singleton.resultStringRows addObject:tempString];//csv

        tempString4 = @"Tester:";
        [singleton.displayStringTitles addObject:tempString4 ];//title

        tempString  = [NSString stringWithFormat:@"Tester:, %@", singleton.testerName];
        [singleton.resultStringRows addObject: tempString];//csv

        tempString2 = singleton.testerName;
        [singleton.displayStringRows addObject: tempString2];//data

        tempString4 = @"Participant No:";
        [singleton.displayStringTitles addObject:tempString4 ];//title

        tempString  = [NSString stringWithFormat:@"Participant No:, %@", singleton.subjectName];
        [singleton.resultStringRows addObject: tempString];//csv

        tempString2 = singleton.subjectName;
        [singleton.displayStringRows addObject: tempString2];//data
//blank
        tempString=@"";
        [singleton.resultStringRows addObject:tempString];//csv

        tempString4 = @"Start Time";
        [singleton.displayStringTitles addObject:tempString4 ];//title
        tempString=[NSString stringWithFormat:@"Start Time:, %.0f, ms",singleton.startTime];//csv
        [singleton.resultStringRows addObject:tempString];//csv
        tempString2 = [NSString stringWithFormat:@"%.0f ms", singleton.startTime];
        [singleton.displayStringRows addObject: tempString2];//data

        tempString4 = @"Wait Time";
        [singleton.displayStringTitles addObject:tempString4 ];//title
        tempString=[NSString stringWithFormat:@"Wait Time:, %.0f, ms",singleton.startTime];//csv
        [singleton.resultStringRows addObject:tempString];//csv
        tempString2 = [NSString stringWithFormat:@"%.0f ms", singleton.waitTime];
        [singleton.displayStringRows addObject: tempString2];//data
        
        tempString4=@"Show Time";
        tempString=[NSString stringWithFormat:@"   Show Time:, %.0f, ms",singleton.showTime];
        [singleton.resultStringRows addObject:tempString];
        [singleton.displayStringTitles addObject:tempString4 ];//title
        tempString=[NSString stringWithFormat:@"%.0f ms", singleton.showTime];
        [singleton.displayStringRows addObject: tempString ];//data
        

    NSString *rot;
    NSString *ani;
    NSString *forw;
    NSString *beep;
    NSString *beep2;

    NSString *ans;
    NSString *ans2;

    if (singleton.sounds) {
        beep=@"Beep ON";
        beep2=singleton.beepEffect;
    }else{
        beep=@"Beep Off";
        beep2=@"(none)";
    }
    beep2=singleton.beepEffect;

    //line
    tempString=[NSString stringWithFormat:@"Beep Que:,%@", beep];
    [singleton.resultStringRows addObject:tempString];//csv
    tempString=@"Beep Que";
    [singleton.displayStringTitles addObject:tempString ];//title
    tempString=[NSString stringWithFormat:@"%@", beep];
    [singleton.displayStringRows addObject: tempString ];//data

    //line
    tempString=[NSString stringWithFormat:@"Beep Name:,%@", beep2];
    [singleton.resultStringRows addObject:tempString];
    tempString=@"Beep Name";
    [singleton.displayStringTitles addObject:tempString ];//title
    tempString=[NSString stringWithFormat:@"%@", beep2];
    [singleton.displayStringRows addObject: tempString ];//data

    //line
    tempString=@"";
    [singleton.resultStringRows addObject:tempString];//csv

    //line
    tempString=@"(1 = correct number in correct sequence, 0 = wrong number in sequence)";
    [singleton.resultStringRows addObject:tempString];//csv
    tempString=@"1 = Correct, 0 = Wrong";
    [singleton.displayStringTitles addObject:tempString ];//title
    tempString=@"";
    [singleton.displayStringRows addObject:tempString];//data

    //line
    tempString=[NSString stringWithFormat:@""];//csv
    [singleton.resultStringRows addObject:tempString];

        //line
    tempString=@"Test No,Sequence,Response,1,2,3,4,5,6,7,8,9,Correct,Wrong";
    tempString2=@"Test:123456789_CW";
    [singleton.resultStringRows addObject:tempString];

    //body of results
    //reset tempstring before building a line of data
    tempString=@"";
    tempString2=@"  ";

    //loop for test no
    for (int xx=start; xx<finish+1; xx++) {
        //for stage no
    //add a few blanks to the strings to enable it to run over the 9 chars
            order[xx]=[order[xx] stringByAppendingString:@"xxx"];
            guessStr[xx]=[guessStr[xx] stringByAppendingString:@"xxx"];
        //for order and guess

        tempString3 = [NSString stringWithFormat:@"%d", xx-2];

        ee=[order[xx] substringWithRange:NSMakeRange(0, xx)];
        ff=[guessStr[xx] substringWithRange:NSMakeRange(0, xx)];

        tempString = [NSString stringWithFormat:@"%@,%@,%@", tempString3, ee, ff];
        tempString2 = [NSString stringWithFormat:@"%@:%@-%@",tempString3, ee, ff];

        tempString3=@"No:Ord:Test";
        [singleton.displayStringTitles addObject:tempString3];//title
        [singleton.displayStringRows addObject: tempString2];//data

        tempString2=@"";

        cor=0;
        wro=0;
        ans=@"";
        ans2=@"..:";

        //loop for test in line
        for (int q=0; q<xx; q++) {

            //get the character at a position in the strings
            ee = [order[xx] substringWithRange:NSMakeRange(q, 1)];
            ff = [guessStr[xx] substringWithRange:NSMakeRange(q, 1)];
            
            //check for same digits in order and guess and count
            if ([ee isEqualToString: ff]) {
                cor  = cor + 1;
                totcor=totcor + 1;
                ans  = @"1";
                ans2 = @"1";
            }else{
                wro  = wro+1;
                totwro=totwro + 1;
                ans  = @"0";
                ans2 = @"0";
            }
            //put the individual components csv in string
            tempString  = [NSString stringWithFormat:@"%@%@", tempString, [NSString stringWithFormat:@",%@", ans]];
            tempString2 = [NSString stringWithFormat:@"%@%@", tempString2, [NSString stringWithFormat:@"%@", ans2]];
        }

        //add some commas
        for (int y = 1; y < (11-xx); y++) {
            tempString  = [NSString stringWithFormat:@"%@%@", tempString, [NSString stringWithFormat:@","]];
            tempString2 = [NSString stringWithFormat:@"%@%@", tempString2, [NSString stringWithFormat:@"."]];
        }
        
        //finish off string from loop
        tempString  = [NSString stringWithFormat:@"%@%@", tempString, [NSString stringWithFormat:@"%d, %d", cor, wro]];
        tempString2 = [NSString stringWithFormat:@"  :%@%@", tempString2, [NSString stringWithFormat:@"c%dw%d", cor, wro]];
        //line

        //tempString4=[NSString stringWithFormat:@"Test:123456789_CW"];
        //[singleton.displayStringTitles addObject:tempString4];//title
        //[singleton.displayStringRows addObject: @""];//data
        tempString3 = @"DATA:";
        [singleton.displayStringTitles addObject:tempString3 ];//title
        [singleton.displayStringRows addObject: tempString2];//data
        [singleton.resultStringRows addObject:tempString];//csv


    }
        //blankline
        tempString = @"";
        [singleton.resultStringRows addObject:tempString];//csv
        
        //nb arrays and vars zeroed in boxinit before timings start.
        
        NSLog(@"Timings follow");
        NSLog(@"--------------");
        
        //check timing data is within limits and set max/mins if extended.  Crash possible if very long times get through.
        Float32 react=0.00;
        for (int aa = 0; aa < start; aa++) {
            for (int bb = 0; bb < aa; bb++) {
                //make positive
                react = abs(reactionTime[aa][bb]);
                if (react>60000.00) {//about 60 seconds in ms
                    react=60001.00;//one more so I can see if it was set or was a default
                }
                reactionTime[aa][bb] = react;
            }
        }
        
        //for timing strings
        Float32 tempCalcR                 = 0.00;
        Float32 actualReactionTime[12][15];
        Float32 firstPress                = 0.00;
        int cc                            = 0;
        
        totalReactionTime = 0.00;
        
        //do the timings output to csv
        tempString=[NSString stringWithFormat:@"Timings Output"];
        [singleton.resultStringRows addObject:tempString];//csv
        
        tempString=@"Test No,,,1,2,3,4,5,6,7,8,9,Total-1,Min-1,Max-1,Average-1,,TotalT,MinT,MaxT,Average-T";
        [singleton.resultStringRows addObject:tempString];//csv
        
        for (int aa = start; aa < finish+1; aa++) {
            
            firstPress = abs(reactionTime[aa][0]);
            testReactionTime[aa] = 0.00;
            
            tempString=[NSString stringWithFormat:@"%d,,", aa-2];
            
            for (int bb = 0; bb < aa; bb++) {
                //NSLog(@"reaction time:%d-%d-%f",aa,bb,reactionTime[aa][bb]);
                //total time
                if (bb == 0) {
                    cc = 0;
                }else{
                    cc = bb - 1;
                }
                tempCalcR = abs(reactionTime[aa][cc]);
                
                actualReactionTime[aa][bb]   = abs(reactionTime[aa][bb] - tempCalcR);
                
                totalReactionTime    = abs(totalReactionTime    + actualReactionTime[aa][bb]);
                testReactionTime[aa] = abs(testReactionTime[aa] + actualReactionTime[aa][bb]);
                
                //min
                if ((shortestReactionTime[aa] > abs(actualReactionTime[aa][bb])) && (bb>0)) {
                    shortestReactionTime[aa] = abs(actualReactionTime[aa][bb]);
                }
     
                //max
                if (longestReactionTime[aa] < abs(actualReactionTime[aa][bb])) {
                    longestReactionTime[aa] = abs(actualReactionTime[aa][bb]);
                }

                //times
                
                if (bb == 0) {
                    tempString = [NSString stringWithFormat:@"%@%@", tempString, [NSString stringWithFormat:@",%.0f", reactionTime[aa][0]]];
                    NSLog(@"reaction time:            r-%.0f mS", reactionTime[aa][bb]);
                }else{
                    tempString = [NSString stringWithFormat:@"%@%@", tempString, [NSString stringWithFormat:@",%.0f", actualReactionTime[aa][bb]]];
                    NSLog(@"reaction time:            r-%.0f mS aa=%d bb=%d", actualReactionTime[aa][bb],aa,bb);
                }
                //NSLog(@"cumulative reaction time: c-%.0f mS", reactionTime[aa][bb]);
            }
                
            //add some commas
            for (int y=1; y<10-aa; y++) {
                tempString = [NSString stringWithFormat:@"%@%@", tempString, [NSString stringWithFormat:@","]];//csv
                //tempString2 = [NSString stringWithFormat:@"%@%@", tempString2, [NSString stringWithFormat:@"."]];//data
            }
            
            //avg absolute
            averageReactionTime[aa] = abs(testReactionTime[aa] / (Float32)(aa-1));
            
            //stage end totals
            tempString = [NSString stringWithFormat:@"%@%@", tempString, [NSString stringWithFormat:@",%.0f", testReactionTime[aa]]];
            tempString = [NSString stringWithFormat:@"%@%@", tempString, [NSString stringWithFormat:@",%.0f", shortestReactionTime[aa]]];
            tempString = [NSString stringWithFormat:@"%@%@", tempString, [NSString stringWithFormat:@",%.0f", longestReactionTime[aa]]];
            tempString = [NSString stringWithFormat:@"%@%@", tempString, [NSString stringWithFormat:@",%.0f,", averageReactionTime[aa]]];
            
            if (longestReactionTime[aa] < abs(reactionTime[aa][0])) {
                longestReactionTime[aa] = abs(reactionTime[aa][0]);

            }
            if (shortestReactionTime[aa] > abs(reactionTime[aa][0])){
                shortestReactionTime[aa] = abs(reactionTime[aa][0]);
            }
            tempString = [NSString stringWithFormat:@"%@%@", tempString, [NSString stringWithFormat:@",%.0f", testReactionTime[aa]+reactionTime[aa][0]]];
            tempString = [NSString stringWithFormat:@"%@%@", tempString, [NSString stringWithFormat:@",%.0f", shortestReactionTime[aa]]];
            tempString = [NSString stringWithFormat:@"%@%@", tempString, [NSString stringWithFormat:@",%.0f", longestReactionTime[aa]]];
            
            //add 1st reaction
            testReactionTime[aa] = abs(testReactionTime[aa] + reactionTime[aa][0]);
            tempString=@"No. Test Reaction Time";
            [singleton.displayStringTitles addObject:tempString ];//title
            tempString=[NSString stringWithFormat:@"   %d: %.0f", aa-2, testReactionTime[aa]];
            [singleton.displayStringRows addObject: tempString];//data
            
            //avg
            averageReactionTime[aa] = abs(testReactionTime[aa] / (Float32)aa);
            tempString = [NSString stringWithFormat:@"%@%@", tempString, [NSString stringWithFormat:@",%.0f", averageReactionTime[aa]]];
            
            [singleton.resultStringRows addObject:tempString];//csv
            tempString=@"Average Reaction Time";
            [singleton.displayStringTitles addObject:tempString ];//title
            tempString=[NSString stringWithFormat:@"%.0f", averageReactionTime[aa]];
            [singleton.displayStringRows addObject: tempString];//data
            
            //add the first guess on to the totals
            totalReactionTime = abs(totalReactionTime + reactionTime[aa][0]);

            //1st one is zero, so don't count that.
            //Need to take into account that timing starts after 1st guess is received, although timer starts when user is asked
            //to reply.  This means that depending on rection time of 1st guess, this can be bigger for the first go.
            //After the 1st one, the user will be more rhythmical and probably more meaningful results.
            //May need to visit this area of calculation to determine best approach.
            //For now, 1=0, then followed by difference between each and the previous time.  Total time is just the 2nd to the last,
            //as the start delay is not used (but could be!).
        }
        
        //blank
        tempString=@"";
        [singleton.resultStringRows addObject:tempString];//csv
        
        //total time
        //NSLog(@"total reaction time: %f", totalReactionTime);
        //NSLog(@"* -------------- *");

        //some test code to see data================
        //for (int rr=0; rr< finish+1;rr++){
        //    for (int ss=0; ss<rr; ss++) {
        //        NSLog(@"React %i, %i : %f",rr,ss,reactionTime[rr][ss]);
        //    }
        //}
            //=======================================
        tempString=@"Total Reaction Time";
        [singleton.displayStringTitles addObject:tempString ];//title
        tempString=[NSString stringWithFormat:@"%.0f", totalReactionTime];
        [singleton.displayStringRows addObject: tempString];//data
        
        tempString=[NSString stringWithFormat:@"Total Reaction Time:, %.0f", totalReactionTime];
        [singleton.resultStringRows addObject:tempString];//csv
        
    //blank
    tempString=@"";
    [singleton.resultStringRows addObject:tempString];//csv

    //put final totals
    //line
    tempString=@"Total Possible";
    [singleton.displayStringTitles addObject:tempString ];//title
    tempString=[NSString stringWithFormat:@"%d", totcor+totwro];
    [singleton.displayStringRows addObject: tempString];//data
    tempString=[NSString stringWithFormat:@"Total Possible:, %d", totcor+totwro];
    [singleton.resultStringRows addObject:tempString];//csv

    //blankline
    tempString=@"";
    [singleton.resultStringRows addObject:tempString];//csv

    //line
    tempString=@"Total Correct";
    [singleton.displayStringTitles addObject:tempString ];//title
    tempString=[NSString stringWithFormat:@"%d", totcor];
    [singleton.displayStringRows addObject: tempString];//data
    tempString=@"Total Wrong";
    [singleton.displayStringTitles addObject:tempString ];//title
    tempString=[NSString stringWithFormat:@"%d", totwro];
    [singleton.displayStringRows addObject: tempString];//data
    tempString=[NSString stringWithFormat:@"Total Correct:, %d",totcor];
    [singleton.resultStringRows addObject:tempString];//csv
    tempString=[NSString stringWithFormat:@"Total Wrong:, %d",totwro];
    [singleton.resultStringRows addObject:tempString];//csv

    //blank
    [singleton.resultStringRows addObject: @""];//csv

    //line
    tempString=@"End of Tachist Test Results";
    [singleton.displayStringTitles addObject:tempString ];//title
    [singleton.resultStringRows addObject: tempString];//csv
    [singleton.displayStringRows addObject: @""];//data

    //line
    tempString=@"(c) MMU 2014 EES";
    [singleton.displayStringTitles addObject:tempString ]; //title
    [singleton.resultStringRows addObject:tempString]; //csv
    [singleton.displayStringRows addObject:@""]; //data

    //last line of data
    tempString=@"www.ess.mmu.ac.uk/apps/corsi";
    [singleton.displayStringTitles addObject:tempString ]; //title
    [singleton.resultStringRows addObject: tempString]; //csv
    [singleton.displayStringRows addObject: @""]; //data
        
    //last line blank for display
    tempString=@"";
    [singleton.displayStringTitles addObject:tempString ]; //title
    [singleton.resultStringRows addObject: tempString]; //csv
    [singleton.displayStringRows addObject: tempString]; //data
        
    //jump to the results page
    [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(jumpToResultsView) userInfo:nil repeats:NO];
    }
}

@end
