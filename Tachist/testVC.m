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

    //action buttons for methods
    IBOutlet UIButton    * noBut;
    IBOutlet UIButton    * yesBut;
    IBOutlet UIButton    * startBut;
    IBOutlet UIButton    * newTestBut;

    //array of card images needed
    UIImageView * card[50];
    IBOutlet UIImageView * cardHolder;
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
    

}
@end

@implementation testVC{

}

@synthesize
    backgroundMusicPlayer, //for sounds

    startBTN,
    statusMessageTXT,
    statusMessageLab,
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

//************************************************
//************************************************

int v1=3; //version: v1.v2.v3
int v2=3;
int v3=4;

//************************************************
//************************************************

// add average reaction for all tests, shortest and longest
float   longestWrongReaction  = -10000;
float   shortestWrongReaction = 10000;
float    averageWrongReaction = 0;

float longestCorrectReaction  = -10000;
float shortestCorrectReaction = 10000;
float  averageCorrectReaction = 0;

float        longestReaction  = -10000;
float        shortestReaction = 10000;
float        averageReaction  = 0;
float         totalWrongDelay = 0;
float       totalCorrectDelay = 0;

float roundUpFactor = 0;// or 0.5  adds 5 * 10,000 of a second to the reaction time to offset the int rounding

// add score correct x and correct o, also wrong x and wrong o
int correctO = 0;
int wrongO   = 0;
int correctX = 0;
int wrongX   = 0;
int noButton = 0;
int someResultsExist = 0;


//store the result reaction times if good - set in the singleton for results page
float cardReactionTime[150]; // added extra elements for all results plus stats
int r1[150]; //store the card
int r2[150]; //and its result

// allow quit abort with special button
// try short routine and test timings

// two more version when finished:-
//      Vienna, use photos with things in or out
//      TachistM use between 1 and 7 X's, count them on 7 buttons

//initialise
int detectorOn     = 0;
Float32 delay      = 0.5;
Float32 delay1     = 0;
Float32 delay3     = 0;
Float32 totalDelay = 0;

bool   lastCard    = NO;
int   noOfCards    = 1;
int  cardPicked    = 0;
int cardCounter    = 0;
bool wasButtonPressed = NO;

//autorotate stuff so we can have landscape and portrait and both work with the buttons and display output
//iOS 6+

- (BOOL)shouldAutorotate
{
    return YES;
}
//iOS 6+
- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // NSLog(@"Touches began with this event");
    [self.view endEditing:YES];
    //statusMessageLab.text=@"You\nTouched\nThe \nScreen";
    [super touchesBegan:touches withEvent:event];
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

    //tachist start...
    NSString *versionNo = [NSString stringWithFormat:@"V.%i.%i.%i",v1,v2,v3];

    //versionNumberLab.text=versionNo;


    //make a status message
    //statusMessageLab.text=@"Ready\nTo\nStart Test";

    // clear the old data, the app has started again.

    //set the delegates or text did start/end will not work
    //noCards.delegate = self;
    //stimOnTime.delegate = self;
    //postResponseDelay.delegate = self;
    //subjectCodeTxt.delegate = self;

    //********************************
    //hide unhide labels, screens and buttons
    //***
    //Action buttons
    noBut.hidden              = YES;
    yesBut.hidden             = YES;
    startBut.hidden           = NO;
    newTestBut.hidden         = YES;
    //hideResultsBut.hidden     = YES;
    //saveDataToEmailBut.hidden = YES;
    //infoBut.hidden            = NO;

    //text views
    //cardHolder.hidden         = YES;
    //resultsView.hidden        = YES;
    //resultsViewBorder.hidden  = YES;
    //settingsBG.hidden         = YES;
    //infoView.hidden           = YES;
    //settingsBG.hidden         = NO;

    //settings messages and text inputs
    //cardsLab.hidden           = NO;
    //stimLab.hidden            = NO;
    //respLab.hidden            = NO;
    //ms1Lab.hidden             = NO;
    //ms2Lab.hidden             = NO;
    //noCards.hidden            = NO;
    //stimOnTime.hidden         = NO;
    //postResponseDelay.hidden  = NO;

    //headings and labels
    //logoImage.hidden          = NO;
    //title1Lab.hidden          = NO;
    //title2Lab.hidden          = NO;
    //XbutLab.hidden            = YES;
    //ObutLab.hidden            = YES;

    //subjectCodeLab.hidden     = NO;
    //subjectCodeTxt.hidden     = NO;
    //statusMessageLab.hidden   = NO;
    //results.hidden            = YES;
    //settingsLab.hidden        = NO;
    //JumpingManLogo.hidden     = NO;
    //clickMessageLab.hidden    = NO;

    if (someResultsExist==1){
        //results.hidden=NO;
        //saveDataToEmailBut.hidden = NO;
    } else {
        //results.hidden=YES;
        //saveDataToEmailBut.hidden = YES;
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ddMMyyyyhhmmss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];

    NSString *newText = [NSString stringWithFormat:@"T%@", strDate];
    //subjectCodeTxt.text = newText;
    //..tachist end
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


    //from tachist...
    [self initVars];
    someResultsExist=0;
    //statusMessageLab.text=@"The Test\nHas\nStarted...";

    //Action buttons
    noBut.hidden              = NO;
    yesBut.hidden             = NO;
    startBut.hidden           = YES;
    newTestBut.hidden         = YES;
    //hideResultsBut.hidden     = YES;
    //saveDataToEmailBut.hidden = YES;
    //infoBut.hidden            = YES;

    //text views
    //cardHolder.hidden         = NO;
    //resultsView.hidden        = YES;
    //resultsViewBorder.hidden  = YES;
    //infoView.hidden           = YES;
    //settingsBG.hidden         = YES;

    //settings messages and text inputs
    //cardsLab.hidden           = YES;
    //stimLab.hidden            = YES;
    //respLab.hidden            = YES;
    //ms1Lab.hidden             = YES;
    //ms2Lab.hidden             = YES;
    //noCards.hidden            = YES;
    //stimOnTime.hidden         = YES;
    //postResponseDelay.hidden  = YES;

    //headings and labels
    //logoImage.hidden          = NO;
    //title1Lab.hidden          = NO;
    //title2Lab.hidden          = NO;
    //XbutLab.hidden            = NO;
    //ObutLab.hidden            = NO;

    //subjectCodeLab.hidden     = YES;
    //subjectCodeTxt.hidden     = YES;
    //statusMessageLab.hidden   = NO;
    //results.hidden            = YES;
    //settingsLab.hidden        = YES;
    //JumpingManLogo.hidden     = YES;
    //clickMessageLab.hidden    = YES;

    if (someResultsExist==1){
        //results.hidden=NO;
        //saveDataToEmailBut.hidden = NO;
    } else {
        //results.hidden=YES;
        //saveDataToEmailBut.hidden = YES;
    }

    //show cards
    //show start message first for 3 seconds
    [NSTimer scheduledTimerWithTimeInterval:(3.0) target:self selector:@selector(startCardDisplay) userInfo:nil repeats:NO];
    //get number of cards in test and check ranges in delegate methods for textfield inputs
    //noOfCards = [noCards.text intValue];
    noOfCards = 5;
    // NSLog(@"No of Cards = %i", noOfCards);
    wasButtonPressed=YES;
    //...end from tachist

}

-(Float32) delayx //stim on value to wait
{
    delay  = 500;//[stimOnTime.text floatValue]/1000;
    //// NSLog(@"time delay = %f",delay);
    return delay;
}

-(Float32) delayx1 //stim on value to wait
{
    delay1 = 500;//[postResponseDelay.text floatValue]/1000;
    //// NSLog(@"time delay = %f",delay1);
    return delay1;
}

-(Float32) delayx3 //stim on value to wait
{
    delay3 = delay1 + delay3;
    return delay3;
}

-(int)pickACard{
    cardPicked = (arc4random() % 27)+1;
    return cardPicked;
}

-(void)initVars{
    mySingleton *singleton = [mySingleton sharedSingleton];
    //statusMessageLab.text=@"Setting\nVariables\nand Flags";
    // add average reaction for all tests, shortest and longest
    longestWrongReaction  = -10000;
    shortestWrongReaction = 10000;
    averageWrongReaction = 0;

    longestCorrectReaction  = -10000;
    shortestCorrectReaction = 10000;
    averageCorrectReaction = 0;

    longestReaction  = -10000;
    shortestReaction = 10000;
    averageReaction  = 0;

    totalCorrectDelay=0;
    totalWrongDelay=0;

    // add score correct x and correct o, also wrong x and wrong o
    correctO = 0;
    wrongO   = 0;
    correctX = 0;
    wrongX   = 0;
    noButton = -1;

    detectorOn= 0;
    delay     = 0.5;
    delay1    = 0;
    delay3    = 0;
    totalDelay= 0;

    lastCard         = NO;
    noOfCards        = 1;
    cardPicked       = 0;
    cardCounter      = 0;
    wasButtonPressed = NO;

    // clear the old data, the app has started again.
    [singleton.cardReactionTimeResult removeAllObjects];
    for (int s=0; s<130; s++) {
        cardReactionTime[s] = 0.0f;
    }
    //subjectCodeTxt.text=@"";
}

-(void)awakeFromNib {
    //statusMessageLab.text=@"The App is Awake...";
    //hide unhide labels, screens and buttons
    //***
    //Action buttons
    noBut.hidden              = YES;
    yesBut.hidden             = YES;
    startBut.hidden           = NO;
    newTestBut.hidden         = YES;
    //hideResultsBut.hidden     = YES;
    //saveDataToEmailBut.hidden = YES;
    //infoBut.hidden            = NO;

    //text views
    //cardHolder.hidden         = YES;
    //resultsView.hidden        = YES;
    //resultsViewBorder.hidden  = YES;
    //settingsBG.hidden         = YES;
    //infoView.hidden           = YES;
    //settingsBG.hidden         = NO;

    //settings messages and text inputs
    //cardsLab.hidden           = NO;
    //stimLab.hidden            = NO;
    //respLab.hidden            = NO;
    //ms1Lab.hidden             = NO;
    //ms2Lab.hidden             = NO;
    //noCards.hidden            = NO;
    //stimOnTime.hidden         = NO;
    //postResponseDelay.hidden  = NO;

    //headings and labels
    //logoImage.hidden          = NO;
    //title1Lab.hidden          = NO;
    //title2Lab.hidden          = NO;
    //XbutLab.hidden            = YES;
    //ObutLab.hidden            = YES;

    //subjectCodeLab.hidden     = NO;
    //subjectCodeTxt.hidden     = NO;
    //statusMessageLab.hidden   = NO;
    //results.hidden            = YES;
    //settingsLab.hidden        = NO;
    //JumpingManLogo.hidden     = NO;
    //clickMessageLab.hidden    = NO;

    if (someResultsExist==1){
        //results.hidden=NO;
        //saveDataToEmailBut.hidden = NO;
    } else {
        //results.hidden=YES;
        //saveDataToEmailBut.hidden = YES;
    }
    //end of hide section
    NSString *temp2 = [NSString stringWithFormat:@"Tachistoscope Test V.%i.%i.%i",v1,v2,v3];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:temp2 message:@"Type the SUBJECT Code, STIMULUS On Time, POST Stimulus Delay and the NUMBER of cards before starting the test."
                                                   delegate:self cancelButtonTitle:@"Continue to the App Settings" otherButtonTitles: nil];
    [alert show];
    NSMutableArray *cardNo = [[NSMutableArray alloc] init];

    //initialise
    card[0] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-white.png"]];//@"tach-pyellow.png"]];
    card[1] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-1.png"]];
    card[2] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-2.png"]];
    card[3] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-3.png"]];
    card[4] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-4.png"]];
    card[5] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-5.png"]];
    card[6] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-6.png"]];
    card[7] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-7.png"]];
    card[8] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-blank.png"]];
    card[9] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-blank.png"]];
    card[10] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-blank.png"]];
    card[11] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-blank.png"]];
    card[12] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-blank.png"]];
    card[13] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-blank.png"]];
    card[14] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-blank.png"]];
    card[15] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-blank.png"]];
    card[16] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-blank.png"]];
    card[17] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-blank.png"]];
    card[18] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-blank.png"]];
    card[19] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-blank.png"]];
    card[20] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-blank.png"]];
    card[21] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-blank.png"]];
    card[22] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-blank.png"]];
    card[23] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-blank.png"]];
    card[24] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-blank.png"]];
    card[25] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-blank.png"]];
    card[26] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-blank.png"]];
    card[27] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-blank.png"]];
    card[28] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-white.png"]];
    card[29] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-start.png"]];
    card[30] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-finish.png"]];
    card[31] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-white.png"]];
    //number the cards
    for(int s=0;s<31;++s){
        [cardNo addObject:[NSNumber numberWithInt:s]];
    }
    //shuffle the cards except the first one and the last two
    //for(int s=1;s<29;++s){
    //int r = arc4random() % 28;
    //[cardNo exchangeObjectAtIndex:s withObjectAtIndex:r+1];
    //}

    for(int s=0;s<31;++s){
        // NSLog(@"No: = %d Card No. %@", s, cardNo[s]);
    }
}

- (IBAction)yesPressed
{
    double noSeconds = (double) [self.startDate timeIntervalSinceNow] * -1000;
    //statusMessageLab.text=@"You\nPressed\nYES";
    if (wasButtonPressed==NO) {
        //NSString *reactionTime= [[NSString alloc] initWithFormat:@"Reaction time is %1.0f milliseconds. ", noSeconds];

        if(detectorOn == 0){
            // NSLog(@"Yes Reaction: = %f mS", noSeconds);
        }
        //reactionTime = @"Slow down! You have to wait for the card";

        NSString *cardWasCorrect = @"Empty";

        if ((cardPicked<8) && (cardPicked>0)){
            cardWasCorrect=@"Correct X";//don't pick the first card it is blank
            correctX++;
            r1[cardCounter]=1;//the card
            r2[cardCounter]=1;//the result
        } else {
            cardWasCorrect=@"Wrong O";
            wrongO++;
            r1[cardCounter]=0;//
            r2[cardCounter]=0;//
        }
        // NSLog(@"Yes %i Reaction: = %f mS, %@",cardCounter, noSeconds, cardWasCorrect);
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reaction Time" message:reactionTime
        //delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //[alert show];
    }
    wasButtonPressed = YES;
    cardReactionTime[cardCounter] = noSeconds;

}

- (IBAction)noPressed
{
    double noSeconds = (double) [self.startDate timeIntervalSinceNow] * -1000;
    //statusMessageLab.text=@"You\nPressed\nNO";
    if (wasButtonPressed==NO) {

        //NSString *reactionTime= [[NSString alloc] initWithFormat:@"Reaction time is %1.0f milliseconds.", noSeconds];

        if(detectorOn == 0)
            {
            // NSLog(@"No  Reaction: = %f mS", noSeconds);
            }
        //reactionTime = @"Slow down! You have to wait for the card";

        NSString *cardWasCorrect = @"Empty";
        if ((cardPicked>=7) && (cardPicked<29)) //don't pick the end two cards as they are messages
            {
            cardWasCorrect=@"Correct O";
            correctO++;
            r1[cardCounter]=0;//
            r2[cardCounter]=1;//
            }
        else
            {
            cardWasCorrect=@"Wrong X";
            wrongX++;
            r1[cardCounter]=1;//
            r2[cardCounter]=0;//
            }
        // NSLog(@"No %i Reaction: = %f mS, %@",cardCounter, noSeconds, cardWasCorrect);
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reaction Time" message:reactionTime
        //delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //[alert show];
    }
    wasButtonPressed = YES;
    //NSNumber *num = [NSNumber numberWithFloat:noSeconds] ;
    cardReactionTime[cardCounter] = noSeconds;
}

-(void)calculateStats{
    //statusMessageLab.text=@"Calculating\nStats\nPlease\nWait...";
    mySingleton *singleton = [mySingleton sharedSingleton];
    // NSLog(@"Starting Stats");

    NSString *myNumbStr = [[NSString alloc] init];

    //set counter to cards for singleton global var
    singleton.counter = noOfCards;

    [singleton.cardReactionTimeResult removeAllObjects];

    [cardHolder setImage: card[31].image];
    // NSLog(@"The Test Ended normally.");
    // NSLog(@"Stats follow... ");
    // NSLog(@"Number of Cards : %i",noOfCards);
    // NSLog(@".");
    // NSLog(@"Correct O : = %i", correctO);
    // NSLog(@"Correct X : = %i", correctX);
    // NSLog(@"Wrong   O : = %i", wrongO);
    // NSLog(@"Wrong   X : = %i", wrongX);
    // NSLog(@"No button : = %i", noOfCards-correctO-correctX-wrongO-wrongX);// zero if always an answer, =no of cards if no button pressed
    // NSLog(@".");

    totalDelay=0;
    averageReaction=0;
    totalCorrectDelay=0;
    totalWrongDelay=0;
    averageCorrectReaction=0;
    averageWrongReaction=0;

    //do the adding up of times
    //for the general results
    for (int x = 1; (x < noOfCards+1); x++) {
        // NSLog(@"Card %i : was timed  : %f", x, cardReactionTime[x]);
        if (cardReactionTime[x] > longestReaction) {
            longestReaction = cardReactionTime[x];
        }
        if (((cardReactionTime[x] < shortestReaction))&& (cardReactionTime[x]>0.00)){
            shortestReaction = cardReactionTime[x];
        }
        totalDelay +=  cardReactionTime[x];

        //for the wrongs and right answers (wrongs)
        if ( r2[x]==0 ){  //wrong cards)

            if (cardReactionTime[x] > longestWrongReaction) {
                longestWrongReaction = cardReactionTime[x];

            }
            if (((cardReactionTime[x] < shortestWrongReaction))&& (cardReactionTime[x]>0.00)){
                shortestWrongReaction = cardReactionTime[x];

            }
            totalWrongDelay +=  cardReactionTime[x];
        }
        //for the wrongs and right answers (corrects)
        if ( r2[x]==1 ){  //correct cards)
            if (cardReactionTime[x] > longestCorrectReaction) {
                longestCorrectReaction = cardReactionTime[x];
            }
            if (((cardReactionTime[x] < shortestCorrectReaction))&& (cardReactionTime[x]>0.00)){
                shortestCorrectReaction = cardReactionTime[x];
            }
            totalCorrectDelay +=  cardReactionTime[x];
        }
    }
    //make sure that missed crads are not averaged, and the result is positive
    //don't do if negative, check
    float CardsTaken =(noOfCards-correctO-correctX-wrongO-wrongX);


    //must have picked at least one reaction time
    //put code her to select if all blanks

    averageReaction = ABS( totalDelay / noOfCards);

    if(wrongX+wrongO>0)
        {
        averageWrongReaction = ABS( totalWrongDelay / (wrongX+wrongO));
        }
    if(correctX+correctO>0)
        {
        averageCorrectReaction = ABS( totalCorrectDelay / (correctX+correctO));

        }
    //don't let any silly default results through
    if (CardsTaken==999) { //check if no button was pressed at all and zero out results if tha happened
        shortestReaction=0;
        averageReaction=0;
        totalDelay=0;
        longestReaction=0;

        shortestWrongReaction=0;
        averageWrongReaction=0;
        totalWrongDelay=0;
        longestWrongReaction=0;

        shortestCorrectReaction=0;
        averageCorrectReaction=0;
        totalCorrectDelay=0;
        longestCorrectReaction=0;
    }

    // NSLog(@"        Shortest Reaction : = %f", shortestReaction);
    // NSLog(@"        Longest Reaction  : = %f", longestReaction);
    // NSLog(@"        Average Reaction  : = %f", averageReaction);
    // NSLog(@"        Total Time Taken  : = %f", totalDelay);
    // NSLog(@" ");
    // NSLog(@"  Shortest Wrong Reaction : = %f", shortestReaction);
    // NSLog(@"  Longest Wrong Reaction  : = %f", longestReaction);
    // NSLog(@"  Average Wrong Reaction  : = %f", averageReaction);
    // NSLog(@"  Total Wrong Time Taken  : = %f", totalWrongDelay);
    // NSLog(@" ");
    // NSLog(@"Shortest Correct Reaction : = %f", shortestReaction);
    // NSLog(@"Longest Correct Reaction  : = %f", longestReaction);
    // NSLog(@"Average Correct Reaction  : = %f", averageReaction);
    // NSLog(@"Total Correct Time Taken  : = %f", totalCorrectDelay);
    // NSLog(@" ");

    //put titles and basic params up first
    [singleton.cardReactionTimeResult addObject:@"MMU Cheshire, Exercise and Sport Science, Tachistoscope iPad Application Results"];

    //mmu copyright message 2013 JAH
    [singleton.cardReactionTimeResult addObject:@"(c) 2013 MMU written by Jonathan A. Howell for ESS Tachistoscope V3.1"];

    //blank line
    [singleton.cardReactionTimeResult addObject:@" "];

    //subject code
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Subject Code: %@", @"set from singleton"]];//,subjectCodeTxt.text]];
    singleton.subjectName =  @"set from singleton";//subjectCodeTxt.text;

    //date of test and time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"E dd-MM-yyyy, hh:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    // NSLog(@"Date of test: %@", strDate);
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Date of Test: %@ ", strDate]];

    //blank line
    [singleton.cardReactionTimeResult addObject:@" "];

    //no cards
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Number of Cards in Test  : %@ ", [NSString stringWithFormat:@"%d", noOfCards]]];

    //stim delay
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Stimulation Delay (mS)    : %@ ", @"set from singleton"]];//stimOnTime.text]];

    //post delay
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Post Stimulus Delay (mS)  : %@ ", @"set from singleton"]]; //postResponseDelay.text]];

    //blank line
    [singleton.cardReactionTimeResult addObject:@" "];

    //got correct o
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Correct O Count  : %@ ", [NSString stringWithFormat:@"%d", correctO]]];

    //got correct x
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Correct X Count  : %@ ", [NSString stringWithFormat:@"%d", correctX]]];

    //got wrong o
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Wrong O Count    : %@ ", [NSString stringWithFormat:@"%d", wrongO]]];

    //got wrong x
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Wrong X Count     : %@ ", [NSString stringWithFormat:@"%d", wrongX]]];

    //no button count
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Missed Results     : %@ ", [NSString stringWithFormat:@"%d", noOfCards-correctO-correctX-wrongO-wrongX]]];
    //blank line
    [singleton.cardReactionTimeResult addObject:@""];

    //shortest reaction
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Shortest Reaction Time (mS) : %@ ", [NSString stringWithFormat:@"%d", ((int)(shortestReaction+roundUpFactor))]]];

    //longest reaction
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Longest Reaction Time (mS)  : %@ ", [NSString stringWithFormat:@"%d", ((int)(longestReaction+roundUpFactor))]]];

    //average reaction
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Average Reaction Time (mS)  : %@ ", [NSString stringWithFormat:@"%d", ((int)(averageReaction+roundUpFactor))]]];

    //total time in test reaction
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Total Reaction Time (mS)       : %@ ", [NSString stringWithFormat:@"%d", ((int)(totalDelay+roundUpFactor))]]];
    //blank line
    [singleton.cardReactionTimeResult addObject:@""];
    //********wrongs
    //shortest Wrong reaction
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Shortest Wrong Reaction Time (mS) : %@ ", [NSString stringWithFormat:@"%d", ((int)(shortestWrongReaction+roundUpFactor))]]];

    //longest Wrong reaction
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Longest Wrong Reaction Time (mS)  : %@ ", [NSString stringWithFormat:@"%d", ((int)(longestWrongReaction+roundUpFactor))]]];

    //average Wrong reaction
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Average Wrong Reaction Time (mS)  : %@ ", [NSString stringWithFormat:@"%d", ((int)(averageWrongReaction+roundUpFactor))]]];

    //total Wrong time in test reaction
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Total Wrong Reaction Time (mS)       : %@ ", [NSString stringWithFormat:@"%d", ((int)(totalWrongDelay+roundUpFactor))]]];
    //blank line
    [singleton.cardReactionTimeResult addObject:@""];
    //********end wrongs
    //********Corrects
    //shortest Correct reaction
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Shortest Correct Reaction Time (mS) : %@ ", [NSString stringWithFormat:@"%d", ((int)(shortestCorrectReaction+roundUpFactor))]]];

    //longest Correct reaction
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Longest Correct Reaction Time (mS)  : %@ ", [NSString stringWithFormat:@"%d", ((int)(longestCorrectReaction+roundUpFactor))]]];

    //average Correct reaction
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Average Correct Reaction Time (mS)  : %@ ", [NSString stringWithFormat:@"%d", ((int)(averageCorrectReaction+roundUpFactor))]]];

    //total Correct time in test reaction
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Total Correct Reaction Time (mS)       : %@ ", [NSString stringWithFormat:@"%d", ((int)(totalCorrectDelay+roundUpFactor))]]];
    //blank line
    //********end corrects
    [singleton.cardReactionTimeResult addObject:@" " ];
    //title line - results for cards follow
    [singleton.cardReactionTimeResult addObject:@"Card No., Card, Result, Reaction (mS)"];
    //card no., o or x was displayed, answer, time to react
    //results, one per line upto number of cards
    for (int y=1; y<noOfCards+1; y++) {
        myNumbStr = [NSString stringWithFormat:@"      %d,          %d,        %d,          %d", y, r1[y],r2[y], ((int)(cardReactionTime[y]+roundUpFactor))];
        [singleton.cardReactionTimeResult addObject: myNumbStr];
    }
    //blank line
    [singleton.cardReactionTimeResult addObject:@" " ];
    //end of data message
    [singleton.cardReactionTimeResult addObject:@"End of test data. " ];
    //blank line
    [singleton.cardReactionTimeResult addObject:@" " ];
    //mmu copyright message 2013 JAH
    [singleton.cardReactionTimeResult addObject:@"MMU (c) 2103 Jonathan A. Howell SAS Technical Services. " ];
    // 27 + no of cards array index total
    //blank line
    [singleton.cardReactionTimeResult addObject:@" "];

    //example for future

    // NSString* str1 = @"no 1";
    // NSString* str2 = @"no 2";
    // NSString* str3 = @"no 3";
    // NSString* strRR = [NSString stringWithFormat:@"%@ %@ %@", str1, str2, str3];
    // NSLog(@"Concat: %@.", strRR);

    for (int r=0; r < (singleton.counter+37); r++) {
        //nb if you change the number of line output, alter the 37 to less or more as needed else CRASH -bounds error

        // NSLog(@"%@", [singleton.cardReactionTimeResult objectAtIndex: r]);
    }

    //make a text file from the array of results
    NSMutableString *element = [[NSMutableString alloc] init];
    NSMutableString *printString = [NSMutableString stringWithString:@""];
    for(int i=0; i< (singleton.counter+37); i++)
        {
        element = [singleton.cardReactionTimeResult objectAtIndex: i];
        [printString appendString:[NSString stringWithFormat:@"\n%@", element]];
        }
    [printString appendString:@""];

    // NSLog(@"string to write pt1:%@",printString);
    //CREATE FILE to save in Documents Directory
    //nb Have to set info.plist environment variable to allow iTunes sharing if want to tx to iTunes etc this dir.

    //UIViewController *files = [[UIViewController alloc] init];

    singleton.resultStrings = printString;
    
    //============resultsView.text = singleton.resultStrings;
    //[self saveText];
    //============[self WriteToStringFile:[printString mutableCopy]];
    
    statusMessageLab.text=@"Waiting\nfor\nNext\nInstruction.";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newSubjectCodeGen:(id)sender {
    statusMessageLab.text=@"New Subject Code Added";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ddMMyyyyhhmmss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *newText = [NSString stringWithFormat:@"T%@", strDate];
    //subjectCodeTxt.text = newText;
}
#pragma mark Start

//START
-(void)startCardDisplay {
    //statusMessageLab.text=@"START";
    //[self initVars]; // this messes up all the timings? why?
    // NSLog(@"card display start");
    [cardHolder setImage: card[29].image];
    wasButtonPressed=YES;
    [NSTimer scheduledTimerWithTimeInterval:(3) target:self selector:@selector(blankCardDisplay0) userInfo:nil repeats:NO];//used to be 0.5
}

//FINISH part 1/2
-(void)finishCardDisplay {
    //statusMessageLab.text=@"FINISH";
    // NSLog(@"card display finish 1/2");
    [cardHolder setImage: card[0].image];
    wasButtonPressed=YES;
    [NSTimer scheduledTimerWithTimeInterval:(0.1) target:self selector:@selector(blankCardDisplay101) userInfo:nil repeats:NO];//used to be 0.5
}
//FINISH part 2/2
-(void)finishCardDisplay1 {
    //statusMessageLab.text=@"FINISH";
    // NSLog(@"card display finish 2/2");
    [cardHolder setImage: card[0].image];
    wasButtonPressed=YES;
    [NSTimer scheduledTimerWithTimeInterval:(0.1) target:self selector:@selector(blankCardDisplay102) userInfo:nil repeats:NO];
    someResultsExist = 1;
    //hide unhide labels, screens and buttons
    //***
    //Action buttons
    noBut.hidden              = YES;
    yesBut.hidden             = YES;
    startBut.hidden           = YES;
    newTestBut.hidden         = YES;
    //hideResultsBut.hidden     = NO;
    //saveDataToEmailBut.hidden = NO;
    //infoBut.hidden            = NO;

    //text views
    //cardHolder.hidden         = YES;
    //resultsView.hidden        = NO;
    //resultsViewBorder.hidden  = NO;
    //settingsBG.hidden         = YES;
    //infoView.hidden           = YES;
    //settingsBG.hidden         = YES;

    //settings messages and text inputs
    //cardsLab.hidden           = YES;
    //stimLab.hidden            = YES;
    //respLab.hidden            = YES;
    //ms1Lab.hidden             = YES;
    //ms2Lab.hidden             = YES;
    //noCards.hidden            = YES;
    //stimOnTime.hidden         = YES;
    //postResponseDelay.hidden  = YES;

    //headings and labels
    //logoImage.hidden          = NO;
    //title1Lab.hidden          = NO;
    //title2Lab.hidden          = NO;
    //XbutLab.hidden            = YES;
    //ObutLab.hidden            = YES;

    //subjectCodeLab.hidden     = YES;
    //subjectCodeTxt.hidden     = YES;
    //statusMessageLab.hidden   = NO;
    //results.hidden            = YES;
    //settingsLab.hidden        = YES;
    //JumpingManLogo.hidden     = YES;
    //clickMessageLab.hidden    = YES;

    if (someResultsExist==1){
        //results.hidden=NO;
        //saveDataToEmailBut.hidden = NO;
    } else {
        //results.hidden=YES;
        //saveDataToEmailBut.hidden = YES;
    }

    //end of hide section

    //resultsView.text=@"";// blank the results entry
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

    statusMessageTXT.hidden
                       = false;
}
-(void)hideInfo{
    //hide the messages and status

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
    tempString=@"(c) MMU 2014 ESS";
    [singleton.displayStringTitles addObject:tempString ]; //title
    [singleton.resultStringRows addObject:tempString]; //csv
    [singleton.displayStringRows addObject:@""]; //data

    //last line of data
    tempString=@"www.ess.mmu.ac.uk/apps/tachist";
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

-(void)onCardDisplay1 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    //hide the buttons
    noBut.hidden = NO;
    yesBut.hidden = NO;
    startBut.hidden = YES;
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay1) userInfo:nil repeats:NO];
}

-(void)onCardDisplay2 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }

    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay2) userInfo:nil repeats:NO];
}

-(void)onCardDisplay3 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }

    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay3) userInfo:nil repeats:NO];
}

-(void)onCardDisplay4 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }

    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay4) userInfo:nil repeats:NO];
}

-(void)onCardDisplay5 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }

    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay5) userInfo:nil repeats:NO];
}

-(void)onCardDisplay6 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }

    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay6) userInfo:nil repeats:NO];
}

-(void)onCardDisplay7 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay7) userInfo:nil repeats:NO];
}
-(void)onCardDisplay8 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay8) userInfo:nil repeats:NO];
}
-(void)onCardDisplay9 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay9) userInfo:nil repeats:NO];
}
-(void)onCardDisplay10 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay10) userInfo:nil repeats:NO];
}
-(void)onCardDisplay11 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay11) userInfo:nil repeats:NO];
}
-(void)onCardDisplay12 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay12) userInfo:nil repeats:NO];
}
-(void)onCardDisplay13 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay13) userInfo:nil repeats:NO];
}
-(void)onCardDisplay14 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay14) userInfo:nil repeats:NO];
}
-(void)onCardDisplay15 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay15) userInfo:nil repeats:NO];
}
-(void)onCardDisplay16 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay16) userInfo:nil repeats:NO];
}
-(void)onCardDisplay17 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay17) userInfo:nil repeats:NO];
}
-(void)onCardDisplay18 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay18) userInfo:nil repeats:NO];
}
-(void)onCardDisplay19 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay19) userInfo:nil repeats:NO];
}
-(void)onCardDisplay20 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay20) userInfo:nil repeats:NO];
}
-(void)onCardDisplay21 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay21) userInfo:nil repeats:NO];
}
-(void)onCardDisplay22 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay22) userInfo:nil repeats:NO];
}
-(void)onCardDisplay23 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay23) userInfo:nil repeats:NO];
}
-(void)onCardDisplay24 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay24) userInfo:nil repeats:NO];
}
-(void)onCardDisplay25 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay25) userInfo:nil repeats:NO];
}
-(void)onCardDisplay26 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay26) userInfo:nil repeats:NO];
}
-(void)onCardDisplay27 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay27) userInfo:nil repeats:NO];
}
-(void)onCardDisplay28 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay28) userInfo:nil repeats:NO];
}
-(void)onCardDisplay29 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay29) userInfo:nil repeats:NO];
}
-(void)onCardDisplay30 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay30) userInfo:nil repeats:NO];
}
-(void)onCardDisplay31 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay31) userInfo:nil repeats:NO];
}
-(void)onCardDisplay32 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay32) userInfo:nil repeats:NO];
}
-(void)onCardDisplay33 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay33) userInfo:nil repeats:NO];
}
-(void)onCardDisplay34 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay34) userInfo:nil repeats:NO];
}
-(void)onCardDisplay35 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay35) userInfo:nil repeats:NO];
}
-(void)onCardDisplay36 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay36) userInfo:nil repeats:NO];
}
-(void)onCardDisplay37 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay37) userInfo:nil repeats:NO];
}
-(void)onCardDisplay38 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay38) userInfo:nil repeats:NO];
}
-(void)onCardDisplay39 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay39) userInfo:nil repeats:NO];
}
-(void)onCardDisplay40 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay40) userInfo:nil repeats:NO];
}
-(void)onCardDisplay41 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay41) userInfo:nil repeats:NO];
}
-(void)onCardDisplay42 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay42) userInfo:nil repeats:NO];
}
-(void)onCardDisplay43 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay43) userInfo:nil repeats:NO];
}
-(void)onCardDisplay44 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay44) userInfo:nil repeats:NO];
}
-(void)onCardDisplay45 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay45) userInfo:nil repeats:NO];
}
-(void)onCardDisplay46 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay46) userInfo:nil repeats:NO];
}
-(void)onCardDisplay47 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay47) userInfo:nil repeats:NO];
}
-(void)onCardDisplay48 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay48) userInfo:nil repeats:NO];
}
-(void)onCardDisplay49 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay49) userInfo:nil repeats:NO];
}
-(void)onCardDisplay50 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay50) userInfo:nil repeats:NO];
}
-(void)onCardDisplay51 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay51) userInfo:nil repeats:NO];
}
-(void)onCardDisplay52 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay52) userInfo:nil repeats:NO];
}
-(void)onCardDisplay53 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay53) userInfo:nil repeats:NO];
}
-(void)onCardDisplay54 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay54) userInfo:nil repeats:NO];
}
-(void)onCardDisplay55 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay55) userInfo:nil repeats:NO];
}
-(void)onCardDisplay56 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay56) userInfo:nil repeats:NO];
}
-(void)onCardDisplay57 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay57) userInfo:nil repeats:NO];
}
-(void)onCardDisplay58 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay58) userInfo:nil repeats:NO];
}
-(void)onCardDisplay59 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay59) userInfo:nil repeats:NO];
}
-(void)onCardDisplay60 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay60) userInfo:nil repeats:NO];
}
-(void)onCardDisplay61 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay61) userInfo:nil repeats:NO];
}
-(void)onCardDisplay62 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay62) userInfo:nil repeats:NO];
}
-(void)onCardDisplay63 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay63) userInfo:nil repeats:NO];
}
-(void)onCardDisplay64 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay64) userInfo:nil repeats:NO];
}
-(void)onCardDisplay65 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay65) userInfo:nil repeats:NO];
}
-(void)onCardDisplay66 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay66) userInfo:nil repeats:NO];
}
-(void)onCardDisplay67 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay67) userInfo:nil repeats:NO];
}
-(void)onCardDisplay68 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay68) userInfo:nil repeats:NO];
}
-(void)onCardDisplay69 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay69) userInfo:nil repeats:NO];
}
-(void)onCardDisplay70 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay70) userInfo:nil repeats:NO];
}
-(void)onCardDisplay71 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay71) userInfo:nil repeats:NO];
}
-(void)onCardDisplay72 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay72) userInfo:nil repeats:NO];
}
-(void)onCardDisplay73 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay73) userInfo:nil repeats:NO];
}
-(void)onCardDisplay74 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay74) userInfo:nil repeats:NO];
}
-(void)onCardDisplay75 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay75) userInfo:nil repeats:NO];
}
-(void)onCardDisplay76 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay76) userInfo:nil repeats:NO];
}
-(void)onCardDisplay77 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay77) userInfo:nil repeats:NO];
}
-(void)onCardDisplay78 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay78) userInfo:nil repeats:NO];
}
-(void)onCardDisplay79 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay79) userInfo:nil repeats:NO];
}
-(void)onCardDisplay80 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay80) userInfo:nil repeats:NO];
}
-(void)onCardDisplay81 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay81) userInfo:nil repeats:NO];
}
-(void)onCardDisplay82 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay82) userInfo:nil repeats:NO];
}
-(void)onCardDisplay83 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay83) userInfo:nil repeats:NO];
}
-(void)onCardDisplay84 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay84) userInfo:nil repeats:NO];
}
-(void)onCardDisplay85 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay85) userInfo:nil repeats:NO];
}
-(void)onCardDisplay86 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay86) userInfo:nil repeats:NO];
}
-(void)onCardDisplay87 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay87) userInfo:nil repeats:NO];
}
-(void)onCardDisplay88 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay88) userInfo:nil repeats:NO];
}
-(void)onCardDisplay89 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay89) userInfo:nil repeats:NO];
}
-(void)onCardDisplay90 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay90) userInfo:nil repeats:NO];
}
-(void)onCardDisplay91 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay91) userInfo:nil repeats:NO];
}
-(void)onCardDisplay92 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay92) userInfo:nil repeats:NO];
}
-(void)onCardDisplay93 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay93) userInfo:nil repeats:NO];
}
-(void)onCardDisplay94 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay94) userInfo:nil repeats:NO];
}
-(void)onCardDisplay95 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay95) userInfo:nil repeats:NO];
}
-(void)onCardDisplay96 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay96) userInfo:nil repeats:NO];
}
-(void)onCardDisplay97 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay97) userInfo:nil repeats:NO];
}
-(void)onCardDisplay98 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay98) userInfo:nil repeats:NO];
}
-(void)onCardDisplay99 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay99) userInfo:nil repeats:NO];
}
-(void)onCardDisplay100 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    cardCounter++;
    int t=[self pickACard];
    if (wasButtonPressed==NO) {
        // NSLog(@"(Button Not Pressed)");
    }
    wasButtonPressed=NO;
    [cardHolder setImage: card[t].image];

    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay100) userInfo:nil repeats:NO];
}
#pragma mark Blanks
//========*******************************************************=========
//========*******************************************************=========
//========**  blanks
//========*******************************************************=========
//========*******************************************************=========

-(void)blankCardDisplay0 {
    //blank screen
    //detectorOn = 0;

    //// NSLog(@"card display blank");
    [cardHolder setImage: card[0].image];
    //[NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay1) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval: [self delayx1] target:self selector:@selector(onCardDisplay1) userInfo:nil repeats:NO];
}

-(void)blankCardDisplay1 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<2) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(onCardDisplay2) userInfo:nil repeats:NO];
    }
}

-(void)blankCardDisplay2 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<3) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay3) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay3 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<4) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay4) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay4 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<5) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay5) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay5 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<6) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay6) userInfo:nil repeats:NO];
    }
}

-(void)blankCardDisplay6 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<7) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay7) userInfo:nil repeats:NO];
    }
}

-(void)blankCardDisplay7 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<8) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay8) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay8 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<9) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay9) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay9 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<10) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay10) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay10 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<11) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay11) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay11 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<12) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay12) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay12 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<13) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay13) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay13 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<14) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay14) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay14 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<15) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay15) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay15 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<16) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay16) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay16 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<17) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay17) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay17 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<18) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay18) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay18 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<19) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay19) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay19 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<20) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay20) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay20 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<21) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay21) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay21 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<22) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay22) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay22 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<23) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay23) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay23 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<24) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay24) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay24 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<25) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay25) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay25 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<26) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay26) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay26 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<27) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay27) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay27 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<28) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay28) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay28 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<29) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay29) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay29 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<30) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay30) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay30 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<31) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay31) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay31 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<32) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay32) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay32 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<33) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay33) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay33 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<34) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay34) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay34 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<35) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay35) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay35 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<36) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay36) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay36 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<37) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay37) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay37 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<38) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay38) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay38 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<39) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay39) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay39 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<40) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay40) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay40 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<41) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay41) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay41 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<42) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay42) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay42 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<43) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay43) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay43 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<44) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay44) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay44 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<45) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay45) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay45 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<46) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay46) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay46 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<47) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay47) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay47 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<48) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay48) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay48 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<49) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay49) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay49 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<50) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay50) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay50 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<51) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay51) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay51 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<52) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay52) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay52 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<53) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay53) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay53 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<54) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay54) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay54 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<55) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay55) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay55 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<56) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay56) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay56 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<57) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay57) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay57 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<58) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay58) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay58 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<59) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay59) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay59 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<60) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay60) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay60 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<61) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay61) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay61 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<62) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay62) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay62 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<63) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay63) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay63 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<64) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay64) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay64 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<65) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay65) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay65 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<66) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay66) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay66 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<67) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay67) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay67 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<68) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay68) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay68 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<69) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay69) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay69 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<70) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay70) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay70 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<71) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay71) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay71 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<72) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay72) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay72 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<73) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay73) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay73 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<74) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay74) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay74 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<75) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay75) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay75 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<76) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay76) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay76 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<77) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay77) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay77 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<78) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay78) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay78 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<79) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay79) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay79 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<80) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay80) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay80 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<81) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay81) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay81 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<82) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay82) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay82 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<83) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay83) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay83 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<84) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay84) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay84 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<85) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay85) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay85 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<86) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay86) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay86 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<87) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay87) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay87 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<88) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay88) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay88 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<89) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay89) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay89 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<90) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay90) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay90 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<91) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay91) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay91 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<92) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay92) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay92 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<93) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay93) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay93 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<94) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay94) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay94 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<95) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay95) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay95 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<96) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay96) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay96 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<97) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay97) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay97 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<98) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay98) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay98 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<99) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay99) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay99 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<100) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay100) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay100 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<101) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay101) userInfo:nil repeats:NO];
    }
}

-(void)blankCardDisplay101 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<101) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay1) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[0].image];

        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(finishCardDisplay1) userInfo:nil repeats:NO];
    }
}
-(void)blankCardDisplay102 {
    //blank screen
    //detectorOn = 0;
    if (noOfCards<101) {
        lastCard=YES;
        // NSLog(@"card display ending now...");
        [cardHolder setImage: card[30].image];
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(calculateStats) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [cardHolder setImage: card[30].image];

        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(calculateStats) userInfo:nil repeats:NO];
    }
}

@end
