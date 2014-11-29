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

@implementation testVC

@synthesize
    backgroundMusicPlayer, //for sounds
    blkLBL,
    blkNoLBL,
    blkTotalLBL,
    blkOfLBL,
    setNoLBL,
    setOfLBL,
    setTotalLBL,
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
    [self hide_blocks];
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
    
    //make 9 sets of number strings
    for (int x=1; x<10; x++) {
        order[x]=[self make9order];
        reverse[x]=[self rev9Order:order[x]];
        //NSLog(@"Order returned for Set: %d is:%@, reverse:%@",x, order[x], reverse[x]);
    }
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

    [self initialiseBlocks];
    isAborted=NO;

    mySingleton *singleton = [mySingleton sharedSingleton];

    [self allButtonsBackgroundReset];

    testViewerView.backgroundColor  = singleton.currentBackgroundColour;
    currentBackgroundColour         = singleton.currentBackgroundColour;
    currentBlockColour              = singleton.currentBlockColour;
    currentShowColour               = singleton.currentShowColour;
    currentStatusColour             = singleton.currentStatusColour;

    [self setColours];

    tempStartMessage=@"You will be shown a sequence of coloured blocks. \n\nObserve the order shown, then recall \nthe sequence when prompted. \n\nThe test will proceed until all the sections are completed.\n\nYou will exit the test if you touch the 'Cancel Test' button during the test.\n\nOnly completed tests are valid and available for analysis and email.";

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

-(void)initialiseBlocks{
    statusMessageTXT.text = @"CORSI Block Test";
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    //check for direction of test and title the test appropiately
    if (singleton.forwardTestDirection == YES) {
        headingLBL.text=@"CORSI FORWARD BLOCK TEST";
        forwardTest=YES;
    }else{
        headingLBL.text=@"CORSI REVERSE BLOCK TEST";
        forwardTest = NO;
    }

    animals = singleton.animals;
    
    [self putAnimals]; //place the correct random animal in the view
    
    [self setColours];
    
    [self allButtonsBackgroundReset];
    
    [self putBlocksInPlace];
    
    int sizeb = 0;

    if (singleton.blockRotation == NO) {

        box1image.transform = CGAffineTransformTranslate(box1image.transform,[self randomPt]-sizeb, [self randomPt]);
        box2image.transform = CGAffineTransformTranslate(box2image.transform,[self randomPt]-sizeb, [self randomPt]);
        box3image.transform = CGAffineTransformTranslate(box3image.transform,[self randomPt]-sizeb, [self randomPt]);
        box4image.transform = CGAffineTransformTranslate(box4image.transform,[self randomPt]-sizeb, [self randomPt]);
        box5image.transform = CGAffineTransformTranslate(box5image.transform,[self randomPt]-sizeb, [self randomPt]);
        box6image.transform = CGAffineTransformTranslate(box6image.transform,[self randomPt]-sizeb, [self randomPt]);
        box7image.transform = CGAffineTransformTranslate(box7image.transform,[self randomPt]-sizeb, [self randomPt]);
        box8image.transform = CGAffineTransformTranslate(box8image.transform,[self randomPt]-sizeb, [self randomPt]);
        box9image.transform = CGAffineTransformTranslate(box9image.transform,[self randomPt]-sizeb, [self randomPt]);
    }
    
    infoShow    = singleton.onScreenInfo;

    forwardTest = singleton.forwardTestDirection;
    
    //make 9 sets of number strings
    for (int x = 1; x < 10; x++) {
        order[x]   = [self make9order];
        reverse[x] = [self rev9Order:order[x]];
        //NSLog(@"Order returned for Set: %d is:%@, reverse:%@",x, order[x], reverse[x]);
    }
    // don't bother, too difficult to do yet //[self rotAllBlocks];
}

-(void)putAnimals{
    if (animals) {
        //draw an animal picture in the view
        int ani[22];
        //NSLog(@"start");
        for (int b = 0; b < 22; b++) {
            ani[b] = b;
            //NSLog(@"animal:%d", ani[b]);
        }
        int temp = 0;
        int tt = 0;
        for (int b = 0; b < 2541; b++) {
            tt        = [self random22];
            temp      = ani[tt];
            ani[tt]   = temp;
        }
        //NSLog(@"mix");
        for (int b = 0; b < 22; b++) {
            //NSLog(@"animal:%d", ani[b]);
        }
        //NSLog(@"end");
        box1image.image = [self getAnimal:ani[1]];
        box2image.image = [self getAnimal:ani[3]];
        box3image.image = [self getAnimal:ani[5]];
        box4image.image = [self getAnimal:ani[7]];
        box5image.image = [self getAnimal:ani[8]];
        box6image.image = [self getAnimal:ani[0]];
        box7image.image = [self getAnimal:ani[2]];
        box8image.image = [self getAnimal:ani[4]];
        box9image.image = [self getAnimal:ani[6]];
    }
}

-(UIImage*)getAnimal:(int)animalNo{
    //pick an animal and return its image
    UIImage *animal;
    switch (animalNo) {
        case 1:
            animal = [UIImage imageNamed:@"Elephant"];
            break;
        case 2:
            animal = [UIImage imageNamed:@"Donkey"];
            break;
        case 3:
            animal = [UIImage imageNamed:@"Frog"];
            break;
        case 4:
            animal = [UIImage imageNamed:@"Fox"];
            break;
        case 5:
            animal = [UIImage imageNamed:@"Goat"];
            break;
        case 6:
            animal = [UIImage imageNamed:@"Crab"];
            break;
        case 7:
            animal = [UIImage imageNamed:@"Bear"];
            break;
        case 8:
            animal = [UIImage imageNamed:@"Bird"];
            break;
        case 9:
            animal = [UIImage imageNamed:@"Duck"];
            break;
        case 10:
            animal = [UIImage imageNamed:@"Croc"];
            break;
        case 11:
            animal = [UIImage imageNamed:@"Cow"];
            break;
        case 12:
            animal = [UIImage imageNamed:@"Butterfly"];
            break;
        case 13:
            animal = [UIImage imageNamed:@"Lion"];
            break;
        case 14:
            animal = [UIImage imageNamed:@"Lama"];
            break;
        case 15:
            animal = [UIImage imageNamed:@"Penguin"];
            break;
        case 16:
            animal = [UIImage imageNamed:@"Fish"];
            break;
        case 17:
            animal = [UIImage imageNamed:@"Seal"];
            break;
        case 18:
            animal = [UIImage imageNamed:@"Tortoise"];
            break;
        case 19:
            animal = [UIImage imageNamed:@"Rabbit"];
            break;
        case 20:
            animal = [UIImage imageNamed:@"Pig"];
            break;
        case 21:
            animal = [UIImage imageNamed:@"Squirel"];
            break;
        default:
            animal = [UIImage imageNamed:@"Cat"];
            break;
    }
    return animal;
}

-(NSString*) rev9Order:(NSString*)forOrder{
    NSString *revOrder;
    revOrder = @"";//blank
    for (int t = 8; t>-1; t--) {
        revOrder = [revOrder stringByAppendingString:[forOrder substringWithRange:NSMakeRange(t, 1)]];
    }
    return revOrder;
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
    
    [self hide_blocks];

    [self participantEntry];
    
    [self startTestPart2];
}

-(void)startTestPart2{
    //this will be looped until the text alert popup is finished
    mySingleton *singleton = [mySingleton sharedSingleton];
        MessageTextView.hidden=YES;
    if (isAlertFinished) {
        MessageTextView.hidden=YES;
        [self hideInfo];
        [self playMyEffect];//beep effect if on

        //blank out the tab bar during the test, no end until done now
        self.tabBarController.tabBar.hidden = YES;
        stopTestNowBTN.hidden=NO;
        //NSLog(@"Test has started");
        //statusMessageTXT.text = @"The Test Has Started";
        statusMessageTXT.text = @"";

        startBTN.hidden   = YES;
        headingLBL.hidden = YES;

        start       = singleton.start;
        finish      = singleton.finish;
    
        startTime   =[self delayDelay];
        showTime    =[self delayShow];
        waitTime    =[self delayWait];
        messageTime =[self delayMessage];
    
        //start test, the alert was dismissed
        [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(boxInit) userInfo:nil repeats:NO];
    } else {
        //participant alert not yet finished, loop back
        [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(startTestPart2) userInfo:nil repeats:NO];
    }
}

-(float)randomDegrees359
{
    float degrees = 0;
    degrees = arc4random_uniform(359); //was 359 //returns a value from 0 to 359, not 360;

    //NSLog(@"Degs=%f",degrees);
    return degrees;
}

-(void)putBlocksInPlace{
    {
    mySingleton *singleton = [mySingleton sharedSingleton];
    // Do any additional setup after loading the view.

    //colour the blocks
    [self updateBlockColours];

    blockSize1 = singleton.blockSize;
        blockSize1 = blockSize1 / 55; // 55.00; //size picked against max size allowed here
    if( blockSize1 <= 0.2){
        blockSize1 = 0.2;
    }
    if( blockSize1 >= 1){
        blockSize1 = 1;
    }

    scaleFactor = blockSize1;

    if(singleton.blockRotation){
        for (int t = 0; t < 10; t++) {
            angle[t] = self.randomDegrees359;
        }
    } else {
        for (int t = 0; t < 10; t++) {
                angle[t] = 0;
        }
    }
        
    //UITouch *touch = [touches anyObject];//some old example code if you used a touch rather than an image reference
    //make sure rotation is about the centre axis. 0,0 is bot left, .5,.5 is ctr, 1,1 is top rt, 1,.5 is mid right.
        
        box1image.layer.anchorPoint = CGPointMake(.5,.5);
        box2image.layer.anchorPoint = CGPointMake(.5,.5);
        box3image.layer.anchorPoint = CGPointMake(.5,.5);
        box4image.layer.anchorPoint = CGPointMake(.5,.5);
        box5image.layer.anchorPoint = CGPointMake(.5,.5);
        box6image.layer.anchorPoint = CGPointMake(.5,.5);
        box7image.layer.anchorPoint = CGPointMake(.5,.5);
        box8image.layer.anchorPoint = CGPointMake(.5,.5);
        box9image.layer.anchorPoint = CGPointMake(.5,.5);
      
    [UIView animateWithDuration:1.0
                        delay:0.0
                         options:UIViewAnimationOptionCurveEaseInOut
 
                     animations:^{
                         
                         CGAffineTransform scaleTrans = CGAffineTransformMakeScale(scaleFactor, scaleFactor);

                         CGAffineTransform rotateTrans1 = CGAffineTransformMakeRotation(angle[1] * M_PI / 180);
                         CGAffineTransform rotateTrans2 = CGAffineTransformMakeRotation(angle[2] * M_PI / 180);
                         CGAffineTransform rotateTrans3 = CGAffineTransformMakeRotation(angle[3] * M_PI / 180);
                         CGAffineTransform rotateTrans4 = CGAffineTransformMakeRotation(angle[4] * M_PI / 180);
                         CGAffineTransform rotateTrans5 = CGAffineTransformMakeRotation(angle[5] * M_PI / 180);
                         CGAffineTransform rotateTrans6 = CGAffineTransformMakeRotation(angle[6] * M_PI / 180);
                         CGAffineTransform rotateTrans7 = CGAffineTransformMakeRotation(angle[7] * M_PI / 180);
                         CGAffineTransform rotateTrans8 = CGAffineTransformMakeRotation(angle[8] * M_PI / 180);
                         CGAffineTransform rotateTrans9 = CGAffineTransformMakeRotation(angle[9] * M_PI / 180);
                         
                      
                         box1image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans1);
                         box2image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans2);
                         box3image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans3);
                         box4image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans4);
                         box5image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans5);
                         box6image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans6);
                         box7image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans7);
                         box8image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans8);
                         box9image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans9);
                         
                     }completion:nil];
    }
}

-(NSString*) make9order{
    //makes a string of numbers, each one only once
    NSString *nums[11];
    NSString *orderz;
    //make numbers 1=9
    for (int n=1;n<10;n++){
        nums[n]=[NSString stringWithFormat:@"%i",n ];
    }
    //shuffle the array of numbers
    NSString *temp;
    for (int x=0;x<12531;x++){
        for(int n=1;n<9;n++){
            int boxz = (arc4random() % 8)+1;
            
            if(boxz==0||boxz>9){
                boxz=1;
            }
            
            if(boxz>=5){
                temp = nums[n];
                nums[n]=nums[n+1];
                nums[n+1]=temp;
            }
        }
    }
    //format the string from the parts and return it
    orderz=[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",nums[1],nums[3],nums[2],nums[5],nums[4],nums[7],nums[6],nums[9],nums[8]];
    return orderz;
}

-(int) whichBlock: (int) number :(int) stage{
    //read the order from the array and pick the n'th char
    //int stringNo = [order[stage] characterAtIndex:number]; //returns character number
    NSString *stringNo = [order[stage] substringWithRange:NSMakeRange(number-1, 1)];
    int block = [stringNo intValue];
    return block;
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
    [self hide_blocks];

    
    //Cancel, return to settings after message
    [self buttonsDisable];
    
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

-(void)display_blocks{
    //show the blocks
    box1image.hidden = false;
    box2image.hidden = false;
    box3image.hidden = false;
    box4image.hidden = false;
    box5image.hidden = false;
    box6image.hidden = false;
    box7image.hidden = false;
    box8image.hidden = false;
    box9image.hidden = false;
    //show the buttons on the top
    box1BTN.hidden   = false;
    box2BTN.hidden   = false;
    box3BTN.hidden   = false;
    box4BTN.hidden   = false;
    box5BTN.hidden   = false;
    box6BTN.hidden   = false;
    box7BTN.hidden   = false;
    box8BTN.hidden   = false;
    box9BTN.hidden   = false;
}

-(void)hide_blocks{
    //hide the blocks
    box1image.hidden = true;
    box2image.hidden = true;
    box3image.hidden = true;
    box4image.hidden = true;
    box5image.hidden = true;
    box6image.hidden = true;
    box7image.hidden = true;
    box8image.hidden = true;
    box9image.hidden = true;
    //hide the buttons on the top
    box1BTN.hidden   = true;
    box2BTN.hidden   = true;
    box3BTN.hidden   = true;
    box4BTN.hidden   = true;
    box5BTN.hidden   = true;
    box6BTN.hidden   = true;
    box7BTN.hidden   = true;
    box8BTN.hidden   = true;
    box9BTN.hidden   = true;
}

-(void)showInfo{
    //show the messages and status
    blkLBL.hidden      = false;
    blkNoLBL.hidden    = false;
    blkOfLBL.hidden    = false;
    blkTotalLBL.hidden = false;
    setLBL.hidden      = false;
    setTotalLBL.hidden = false;
    setOfLBL.hidden    = false;
    setNoLBL.hidden    = false;
    statusMessageTXT.hidden
                       = false;
}
-(void)hideInfo{
    //hide the messages and status
    blkLBL.hidden      = true;
    blkNoLBL.hidden    = true;
    blkOfLBL.hidden    = true;
    blkTotalLBL.hidden = true;
    setLBL.hidden      = true;
    setTotalLBL.hidden = true;
    setOfLBL.hidden    = true;
    setNoLBL.hidden    = true;
    statusMessageTXT.hidden
                       = true;
}

-(void)boxInit {
    [self buttonsDisable];
    MessageTextView.hidden=YES;
    startBTN.hidden=YES;
    stopTestNowBTN.hidden=NO;
    
    //NSLog(@"box init");
    if (isAborted == NO) {
        mySingleton *singleton = [mySingleton sharedSingleton];
        if (singleton.onScreenInfo == YES) {
            statusMessageTXT.text = @"The Test is Starting now...";
        }else{
            statusMessageTXT.text = @"";
        }
    //[MessageView setImage: card[0].image];
    //[self display_blocks];
    
    [self hideInfo];
    [self allButtonsBackgroundReset];// background colour reset to std

    isFinished=NO;
    isCalculating=NO;

    //zero counters
    xcounter = start; //default is 3 but could be 3-9 range depending on settings
    ncounter = 1;
    pressNo  = 0; //set initial no of presses
        
    blkTotalLBL.text = [NSString stringWithFormat:@"%d", xcounter];
    blkNoLBL.text    = [NSString stringWithFormat:@"%d", 0];
    setNoLBL.text    = [NSString stringWithFormat:@"%d", xcounter-2];
    setTotalLBL.text = [NSString stringWithFormat:@"%d", finish-2];
        
        //reset the timer vars
        totalReactionTime=0.00f;
        for (int cnt=0; cnt<10; cnt++) {
            shortestReactionTime[cnt]   = 10000.00f;
            longestReactionTime[cnt]    = -10000.00f;
            averageReactionTime[cnt]    = 0.00f;
            for (int dnt=0; dnt<13; dnt++) {
                reactionTime[cnt][dnt]  = 0.00f;
            }
        }
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTestMSG) userInfo:nil repeats:NO];
    }
}

-(void)stageChecks {
    if (isAborted == NO) {
        if (isFinished) { //definitely ended, to catch second round of checks
            [NSTimer scheduledTimerWithTimeInterval:messageTime target:self selector:@selector(endTestMSG) userInfo:nil repeats:NO];
        }
    //check for stage and test end
        if ((xcounter == finish) && (ncounter >= xcounter)) {
        //test is ended
        //update all counters
            ncounter = ncounter+1;   //block number 3-9 range
    
            if(ncounter>=xcounter+1){ //starts at 3 for 3 blocks, end stage, then new set, 3 for 4 blocks etc.
                xcounter=xcounter+1; //stage counter 3-9 range
                ncounter=0;
            }
            isFinished=YES;
            [NSTimer scheduledTimerWithTimeInterval:messageTime target:self selector:@selector(finalStageEndMSG) userInfo:nil repeats:NO];
        }else{
            if(ncounter>=xcounter){
                //not finished, but ended a stage
                //update all counters
                ncounter = ncounter+1;   //block number 3-9 range

                if(ncounter>=xcounter+1){ //starts at 3 for 3 blocks, end stage, then new set, 3 for 4 blocks etc.
                    xcounter=xcounter+1; //stage counter 3-9 range
                    ncounter=0;
                }
                [NSTimer scheduledTimerWithTimeInterval:messageTime target:self selector:@selector(stageEndMSG) userInfo:nil repeats:NO];
            }else{
                //not ended, carry on
                //update all counters
                ncounter = ncounter+1;   //block number 3-9 range

                if(ncounter>=xcounter+1){ //starts at 3 for 3 blocks, end stage, then new set, 3 for 4 blocks etc.
                    xcounter=xcounter+1; //stage counter 3-9 range
                    ncounter=0;
                }
                [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(box1) userInfo:nil repeats:NO];
            }
        }
    }else{
        //aborted end
        [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(box1) userInfo:nil repeats:NO];
    }
}

-(void)buttonsEnable{
    box1BTN.enabled=YES;
    box2BTN.enabled=YES;
    box3BTN.enabled=YES;
    box4BTN.enabled=YES;
    box5BTN.enabled=YES;
    box6BTN.enabled=YES;
    box7BTN.enabled=YES;
    box8BTN.enabled=YES;
    box9BTN.enabled=YES;
}

-(void)buttonsDisable{
    box1BTN.enabled=NO;
    box2BTN.enabled=NO;
    box3BTN.enabled=NO;
    box4BTN.enabled=NO;
    box5BTN.enabled=NO;
    box6BTN.enabled=NO;
    box7BTN.enabled=NO;
    box8BTN.enabled=NO;
    box9BTN.enabled=NO;
}

-(void)box1 {
    if (isAborted == NO) {

        mySingleton *singleton = [mySingleton sharedSingleton];

        //block button inputs for now, re-enable after stage end.
        [self buttonsDisable];
    
        //display status
        blkTotalLBL.text = [NSString stringWithFormat:@"%d", xcounter];
        blkNoLBL.text    = [NSString stringWithFormat:@"%d", ncounter];
        setNoLBL.text    = [NSString stringWithFormat:@"%d", xcounter-2];
        setTotalLBL.text = [NSString stringWithFormat:@"%d", finish-2];
        [self showInfo];
        //hide all messages except blocks
        MessageTextView.hidden=YES;
        MessageView.hidden=YES;
        startBTN.hidden=YES;
    
        //display blocks
        [self display_blocks];

        if (singleton.onScreenInfo == YES) {
            statusMessageTXT.text = @"Observe";
        }else{
            statusMessageTXT.text = @"Observe";
        }

        int t=[self whichBlock:ncounter :xcounter];
        NSLog(@"block showing : %i seq : %i set : %i", t, ncounter, xcounter);
        //show the t block
    switch (t) {
        case 1:
            box1image.backgroundColor=currentShowColour;
            break;
        case 2:
            box2image.backgroundColor=currentShowColour;
            break;
        case 3:
            box3image.backgroundColor=currentShowColour;
            break;
        case 4:
            box4image.backgroundColor=currentShowColour;
            break;
        case 5:
            box5image.backgroundColor=currentShowColour;
            break;
        case 6:
            box6image.backgroundColor=currentShowColour;
            break;
        case 7:
            box7image.backgroundColor=currentShowColour;
            break;
        case 8:
            box8image.backgroundColor=currentShowColour;
            break;
        case 9:
            box9image.backgroundColor=currentShowColour;
            break;
        default:
            [self allButtonsBackgroundReset];// background colour reset to std.
            break;
        }
        [NSTimer scheduledTimerWithTimeInterval:showTime target:self selector:@selector(but1) userInfo:nil repeats:NO];
    }
}

-(void)but1 {
    if (isAborted == NO) {
        [self buttonsDisable];
        //clears the block, waits and then sends to check to see if any end, stage or flag is passed
        [self allButtonsBackgroundReset];// background colour reset to std
        [NSTimer scheduledTimerWithTimeInterval:waitTime target:self selector:@selector(stageChecks) userInfo:nil repeats:NO];
    }
}

-(void)allButtonsBackgroundReset {
    box1image.backgroundColor=currentBlockColour;
    box2image.backgroundColor=currentBlockColour;
    box3image.backgroundColor=currentBlockColour;
    box4image.backgroundColor=currentBlockColour;
    box5image.backgroundColor=currentBlockColour;
    box6image.backgroundColor=currentBlockColour;
    box7image.backgroundColor=currentBlockColour;
    box8image.backgroundColor=currentBlockColour;
    box9image.backgroundColor=currentBlockColour;
}

-(void)statusUpdate:(int)press{
    //type in the guesses if the info flag is on
    if (isAborted == NO) {

        mySingleton *singleton = [mySingleton sharedSingleton];

            if (singleton.onScreenInfo == YES) {
        switch (press) {
            case 1:
                statusMessageTXT.text = [NSString stringWithFormat:@"%@",guess[1]];
            break;
            case 2:
                statusMessageTXT.text = [NSString stringWithFormat:@"%@%@",guess[1],guess[2]];
            break;
            case 3:
                statusMessageTXT.text = [NSString stringWithFormat:@"%@%@%@",guess[1],guess[2],guess[3]];
            break;
            case 4:
                statusMessageTXT.text = [NSString stringWithFormat:@"%@%@%@%@",guess[1],guess[2],guess[3],guess[4]];
            break;
            case 5:
                statusMessageTXT.text = [NSString stringWithFormat:@"%@%@%@%@%@",guess[1],guess[2],guess[3],guess[4],guess[5]];
            break;
            case 6:
                statusMessageTXT.text = [NSString stringWithFormat:@"%@%@%@%@%@%@",guess[1],guess[2],guess[3],guess[4],guess[5],guess[6]];
            break;
            case 7:
                statusMessageTXT.text = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",guess[1],guess[2],guess[3],guess[4],guess[5],guess[6],guess[7]];
            break;
            case 8:
                statusMessageTXT.text = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",guess[1],guess[2],guess[3],guess[4],guess[5],guess[6],guess[7],guess[8]];
            break;
            case 9:
                statusMessageTXT.text = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",guess[1],guess[2],guess[3],guess[4],guess[5],guess[6],guess[7],guess[8],guess[9]];
            break;

            default:
                statusMessageTXT.text = @"Recall";
            break;
        }
        }else{
            statusMessageTXT.text = @"Recall";
        }
    }
}

-(void)waiting{
    //do nothing, wait for a new key press after flashing the button
}

-(void)blankMSGbut1 {
    box1image.backgroundColor=currentBlockColour;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(waiting) userInfo:nil repeats:NO];
}
-(void)blankMSGbut2 {
    box2image.backgroundColor=currentBlockColour;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(waiting) userInfo:nil repeats:NO];
}
-(void)blankMSGbut3 {
    box3image.backgroundColor=currentBlockColour;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(waiting) userInfo:nil repeats:NO];
}
-(void)blankMSGbut4 {
    box4image.backgroundColor=currentBlockColour;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(waiting) userInfo:nil repeats:NO];
}
-(void)blankMSGbut5 {
    box5image.backgroundColor=currentBlockColour;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(waiting) userInfo:nil repeats:NO];
}
-(void)blankMSGbut6 {
    box6image.backgroundColor=currentBlockColour;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(waiting) userInfo:nil repeats:NO];
}
-(void)blankMSGbut7 {
    box7image.backgroundColor=currentBlockColour;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(waiting) userInfo:nil repeats:NO];
}
-(void)blankMSGbut8 {
    box8image.backgroundColor=currentBlockColour;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(waiting) userInfo:nil repeats:NO];
}
-(void)blankMSGbut9 {
    box9image.backgroundColor=currentBlockColour;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(waiting) userInfo:nil repeats:NO];
}

-(IBAction)blk1BUT:(id)sender{
    //button 1 pressed
    //read the timer
    noOfSeconds = (double)[self.startDate timeIntervalSinceNow]* -1000;
    reactionTime[xcounter-1][pressNo] = noOfSeconds;
    box1image.backgroundColor=currentShowColour;
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self playMyEffect];
    guess[pressNo+1] = @"1";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo+1];
    [self statusUpdate:pressNo+1];
    pressNo=pressNo+1;
    if(pressNo >= xcounter-1){
        pressNo = 0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }
    [NSTimer scheduledTimerWithTimeInterval: flash2 target:self selector:@selector(blankMSGbut1) userInfo:nil repeats:NO];
}

-(IBAction)blk2BUT:(id)sender{
    //button 2 pressed
    //read the timer
    noOfSeconds = (double)[self.startDate timeIntervalSinceNow]* -1000;
    reactionTime[xcounter-1][pressNo] = noOfSeconds;
    box2image.backgroundColor=currentShowColour;
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self playMyEffect];
    guess[pressNo+1] = @"2";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo+1];
    [self statusUpdate:pressNo+1];
    pressNo=pressNo+1;
    if(pressNo >= xcounter-1){
        pressNo = 0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }
    [NSTimer scheduledTimerWithTimeInterval: flash2 target:self selector:@selector(blankMSGbut2) userInfo:nil repeats:NO];
}

-(IBAction)blk3BUT:(id)sender{
    //button 3 pressed
    //read the timer
    noOfSeconds = (double)[self.startDate timeIntervalSinceNow]* -1000;
    reactionTime[xcounter-1][pressNo] = noOfSeconds;
    box3image.backgroundColor=currentShowColour;
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self playMyEffect];
    guess[pressNo+1] = @"3";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo+1];
    [self statusUpdate:pressNo+1];
    pressNo=pressNo+1;
    if(pressNo >= xcounter-1){
        pressNo = 0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }
    [NSTimer scheduledTimerWithTimeInterval: flash2 target:self selector:@selector(blankMSGbut3) userInfo:nil repeats:NO];
}

-(IBAction)blk4BUT:(id)sender{
    //button 4 pressed
    //read the timer
    noOfSeconds = (double)[self.startDate timeIntervalSinceNow]* -1000;
    reactionTime[xcounter-1][pressNo] = noOfSeconds;
    box4image.backgroundColor=currentShowColour;
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self playMyEffect];
    guess[pressNo+1] = @"4";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo+1];
    [self statusUpdate:pressNo+1];
    pressNo=pressNo+1;
    if(pressNo >= xcounter-1){
        pressNo = 0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }
    [NSTimer scheduledTimerWithTimeInterval: flash2 target:self selector:@selector(blankMSGbut4) userInfo:nil repeats:NO];
}

-(IBAction)blk5BUT:(id)sender{
    //button 5 pressed
    //read the timer
    noOfSeconds = (double)[self.startDate timeIntervalSinceNow]* -1000;
    reactionTime[xcounter-1][pressNo] = noOfSeconds;
    box5image.backgroundColor=currentShowColour;
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self playMyEffect];
    guess[pressNo+1] = @"5";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo+1];
    [self statusUpdate:pressNo+1];
    pressNo=pressNo+1;
    if(pressNo >= xcounter-1){
        pressNo = 0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }
    [NSTimer scheduledTimerWithTimeInterval: flash2 target:self selector:@selector(blankMSGbut5) userInfo:nil repeats:NO];
}

-(IBAction)blk6BUT:(id)sender{
    //button 6 pressed
    //read the timer
    noOfSeconds = (double)[self.startDate timeIntervalSinceNow]* -1000;
    reactionTime[xcounter-1][pressNo] = noOfSeconds;
    box6image.backgroundColor=currentShowColour;
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self playMyEffect];
    guess[pressNo+1] = @"6";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo+1];
    [self statusUpdate:pressNo+1];
    pressNo=pressNo+1;
    if(pressNo >= xcounter-1){
        pressNo = 0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }
    [NSTimer scheduledTimerWithTimeInterval: flash2 target:self selector:@selector(blankMSGbut6) userInfo:nil repeats:NO];
}

-(IBAction)blk7BUT:(id)sender{
    //button 7 pressed
    //read the timer
    noOfSeconds = (double)[self.startDate timeIntervalSinceNow]* -1000;
    reactionTime[xcounter-1][pressNo] = noOfSeconds;
    box7image.backgroundColor=currentShowColour;
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self playMyEffect];
    guess[pressNo+1] = @"7";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo+1];
    [self statusUpdate:pressNo+1];
    pressNo=pressNo+1;
    if(pressNo >= xcounter-1){
        pressNo = 0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }
    [NSTimer scheduledTimerWithTimeInterval: flash2 target:self selector:@selector(blankMSGbut7) userInfo:nil repeats:NO];
}

-(IBAction)blk8BUT:(id)sender{
    //button 8 pressed
    //read the timer
    noOfSeconds = (double)[self.startDate timeIntervalSinceNow]* -1000;
    reactionTime[xcounter-1][pressNo] = noOfSeconds;
    box8image.backgroundColor=currentShowColour;
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self playMyEffect];
    guess[pressNo+1] = @"8";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo+1];
    [self statusUpdate:pressNo+1];
    pressNo=pressNo+1;
    if(pressNo >= xcounter-1){
        pressNo = 0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }
    [NSTimer scheduledTimerWithTimeInterval: flash2 target:self selector:@selector(blankMSGbut8) userInfo:nil repeats:NO];
}

-(IBAction)blk9BUT:(id)sender{
    //button 9 pressed
    //read the timer
    noOfSeconds = (double)[self.startDate timeIntervalSinceNow]* -1000;
    reactionTime[xcounter-1][pressNo] = noOfSeconds;
    
    box9image.backgroundColor=currentShowColour;
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self playMyEffect];
    guess[pressNo+1] = @"9";
    blkNoLBL.text = [NSString stringWithFormat:@"%i", pressNo+1];
    [self statusUpdate:pressNo+1];
    pressNo=pressNo+1;
    if(pressNo >= xcounter-1){
        pressNo = 0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }
    [NSTimer scheduledTimerWithTimeInterval: flash2 target:self selector:@selector(blankMSGbut9) userInfo:nil repeats:NO];
}

-(void)getGuesses {
    if (isAborted == NO) {
        [self buttonsEnable];
        blkNoLBL.text = [NSString stringWithFormat:@"%i",0];
        //turns on the buttons, collects the xcounter guesses, forms a string, saves it and carries on with next stage
    
        [self recallMessage];
        //NSLog(@"Press The Blocks in Order");
        
        //read the timer
        self.startDate=[NSDate date];
        
        if(pressNo >= xcounter+1){
            pressNo = 0;
            [self buttonsDisable];
            [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
        }else{
            [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(self) userInfo:nil repeats:NO];
        }
    }
}

-(void)recallMessage{
    mySingleton *singleton = [mySingleton sharedSingleton];

    if (singleton.forwardTestDirection == NO) {
        if (singleton.onScreenInfo == YES) {
            statusMessageTXT.text = @"Recall the sequence in the \nreverse order.";
        }else{
            statusMessageTXT.text = @"Recall Reverse Test";
        }
    }else{
        if (singleton.onScreenInfo == YES) {
            statusMessageTXT.text = @"Recall the sequence in the \nsame order.";
        }else{
            statusMessageTXT.text = @"Recall Forward Test";
        }
    }
}

-(void)getFinalGuesses {
    if (isAborted == NO) {
        [self buttonsEnable];
        blkNoLBL.text = [NSString stringWithFormat:@"%i", 0];
        //turns on the buttons, collects the xcounter guesses, forms a string, saves it and carries on with next stage
        [self recallMessage];

        //NSLog(@"Press The Blocks in Order");
        
        //read the timer
        self.startDate=[NSDate date];
        
        if((pressNo >= xcounter+1)&&(isFinished==YES)){
        [self buttonsDisable];
            
            [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(endTestMSG) userInfo:nil repeats:NO];
        }else{
            [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(self) userInfo:nil repeats:NO];
        }
    }
}

-(void)guessMSG {
    if (isAborted == NO) {
        blkNoLBL.text = [NSString stringWithFormat:@"%i", 0];
        //NSLog(@"Guess Now");
        statusMessageTXT.text = @"";
        [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(getGuesses) userInfo:nil repeats:NO];
    }
}

-(void)finalGuessMSG {
    if (isAborted == NO) {
        blkNoLBL.text = [NSString stringWithFormat:@"%i", 0];
        statusMessageTXT.text = @"";
        [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(getFinalGuesses) userInfo:nil repeats:NO];
    }
}

-(void)stageEndMSG {
    if (isAborted == NO) {
        [self buttonsDisable];
        //NSLog(@"Stage Ending");

        mySingleton *singleton = [mySingleton sharedSingleton];
        
        if (singleton.onScreenInfo == YES) {
            statusMessageTXT.text = @"Prepare to Recall";
        }else{
            statusMessageTXT.text = @"";
        }
        //[NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(guessMSG) userInfo:nil repeats:NO];
        [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(halt) userInfo:nil repeats:NO];
    }
}

-(void)halt{
    MessageView.hidden=NO;
    MessageView.alpha=0.70;
    [MessageView setImage: card[3].image];
    [NSTimer scheduledTimerWithTimeInterval: 1.2 target:self selector:@selector(haltPart2) userInfo:nil repeats:NO];
}

-(void)haltPart2{
    MessageView.hidden=YES;
    isAlertFinished=YES;
    if (isAlertFinished == YES) {
        [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(guessMSG) userInfo:nil repeats:NO];
    }else{
        [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(haltPart2) userInfo:nil repeats:NO];
    }
}

-(void)finalStageEndMSG {
    if (isAborted == NO) {
        [self buttonsDisable];
        //NSLog(@"Final Stage Ending");
        isFinished=YES;

        mySingleton *singleton = [mySingleton sharedSingleton];

        if (singleton.onScreenInfo == YES) {
            statusMessageTXT.text = @"";
        }else{
            statusMessageTXT.text = @"";
        }
        //[NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(finalGuessMSG) userInfo:nil repeats:NO];
        [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(finalHalt) userInfo:nil repeats:NO];
    }
}

-(void)finalHalt{
    MessageView.hidden=NO;
    MessageView.alpha=0.70;
    [MessageView setImage: card[3].image];

    [NSTimer scheduledTimerWithTimeInterval: 1.2 target:self selector:@selector(finalHaltPart2) userInfo:nil repeats:NO];
}

-(void)finalHaltPart2{
    MessageView.hidden=YES;
    isAlertFinished=YES;
    if (isAlertFinished == YES) {
        [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(finalGuessMSG) userInfo:nil repeats:NO];
    }else{
        [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(finalHaltPart2) userInfo:nil repeats:NO];
    }
}

-(void)nextStageMSG {
    if (isAborted == NO) {
        [self buttonsDisable];
        //NSLog(@"Stage Starting");

        mySingleton *singleton = [mySingleton sharedSingleton];

        if (singleton.onScreenInfo == YES) {
            statusMessageTXT.text = @"Observe";
        }else{
            statusMessageTXT.text = @"Observe";
        }
        pressNo = 0;
        [NSTimer scheduledTimerWithTimeInterval: messageTime target:self selector:@selector(blankMSG) userInfo:nil repeats:NO];
    }
}

-(void)startTestMSG {
    if (isAborted == NO) {
        //Start of Test Message
        [self buttonsDisable];
        //NSLog(@"Start Test");
        MessageView.hidden=YES;
        [MessageView setImage: card[0].image];
        
        [self animateMessageView];
   
        [NSTimer scheduledTimerWithTimeInterval: 5.5 target:self selector:@selector(blankMSG2) userInfo:nil repeats:NO];
        
        [self setColours];
    }
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

-(void)endTestMSG {
    if (isAborted == NO) {
        //End of Test Message
        [self buttonsDisable];
        //NSLog(@"End Test");
        stopTestNowBTN.hidden=YES;
        isFinished=YES;

        mySingleton *singleton = [mySingleton sharedSingleton];

        if (singleton.onScreenInfo == YES) {
            statusMessageTXT.text = @"The Test has Finished.";
        }else{
            statusMessageTXT.text = @"";
        }
        [self hideInfo];
        [self hide_blocks];
        [MessageView setImage: card[1].image];
        MessageView.hidden=NO;
        [self animateMessageViewIN];
        [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(calculatingMSG) userInfo:nil repeats:NO];
    }
}

-(void)calculatingMSG {
    if (isAborted == NO) {
        //Calculate stats and outputs
        [self buttonsDisable];
        isFinished=YES;
        //NSLog(@"Calculating Test Results");

        mySingleton *singleton = [mySingleton sharedSingleton];

        if (singleton.onScreenInfo == YES) {
            statusMessageTXT.text = @"The test results are being calculated.";
        }else{
            statusMessageTXT.text = @"Calculating...";
        }
        [self hide_blocks];
        [self hideInfo];
        [MessageView setImage: card[4].image];
        MessageView.hidden=NO;
        [self animateMessageViewIN];

        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(calculations) userInfo:nil repeats:NO];
    }
}

-(void)blankMSG {
    if (isAborted == NO) {
        [self buttonsDisable];
        //NSLog(@"(blankmsg)");
        MessageView.hidden=YES;
        [NSTimer scheduledTimerWithTimeInterval:waitTime target:self selector:@selector(stageChecks) userInfo:nil repeats:NO];
    }
}

-(void)blankMSG2 {
    if (isAborted == NO) {
        [self buttonsDisable];
        //NSLog(@"(blankmsg2)");
        [self display_blocks];
        [self showInfo];

                statusMessageTXT.text = @"Observe";

        MessageView.hidden=YES;//maybe messagetime--v
        [NSTimer scheduledTimerWithTimeInterval:startTime target:self selector:@selector(box1) userInfo:nil repeats:NO];
    }
}

-(void)jumpToResultsView {
    if (isAborted == NO) {
        [self buttonsDisable];
        //NSLog(@"(jumpToResultsView)");
        [self hide_blocks];
        [MessageView setImage: card[6].image];
        MessageView.hidden=NO;
        isCalculating=YES;
    
        self.tabBarController.tabBar.hidden = NO;
    
        [self animateMessageViewIN];
        [MessageView setImage: card[6].image];
    //jump to selector ResultsVC

        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(selectTabBarResults) userInfo:nil repeats:NO];
    }else{
        //jump to selector SettingsVC

        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(selectTabBarSettings) userInfo:nil repeats:NO];
    }
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

-(void)blankMSG3 {
    if (isAborted == NO) {
    [self buttonsDisable];
    guessStr[xcounter-1]= [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",guess[1],guess[2],guess[3],guess[4],guess[5],guess[6],guess[7],guess[8],guess[9]];
    [self statusUpdate:xcounter-1];
        //NSLog(@"(blank3 after buttons input %@)",guessStr[xcounter-1]);
    [self display_blocks];
    MessageView.hidden=YES;
    if (isFinished) {
        //NSLog(@"(blank3 endtestmsg)");
        [NSTimer scheduledTimerWithTimeInterval:messageTime target:self selector:@selector(endTestMSG) userInfo:nil repeats:NO];
    }else{
        //NSLog(@"(blank3 stagechecks)");
        statusMessageTXT.text = @"";
        [NSTimer scheduledTimerWithTimeInterval:messageTime target:self selector:@selector(stageChecks) userInfo:nil repeats:NO];
    }
    }
}

-(float)random9
//for the blocks
{
    float num = 1;
    for (int r=1; r<+arc4random_uniform(321); r++)
        {
        while (num>0)
            {
            num = arc4random_uniform(10); //1-9
            }
        }
    return num;
}

-(int)random22
//for the animal graphics
{
    int num1 = 1;
            num1 = arc4random_uniform(22); //1-21
    if (num1<1) {
        num1=1;
    }
    if (num1>21) {
        num1=21;
    }
    return num1;
}

-(int)randomPt
//a random point to put a block away from origin depending on block size
{
    mySingleton *singleton = [mySingleton sharedSingleton];
    int range1;
    
    switch ((int)singleton.blockSize) {
        case 5:
            range1=90;
            break;
        case 10:
            range1=100;
            break;
        case 15:
            range1=85;
            break;
        case 20:
            range1=65;
            break;
        case 25:
            range1=55;
            break;
        case 30:
            range1=40;
            break;
        case 35:
            range1=30;
            break;
        case 40:
            range1=20;
            break;
        case 45:
            range1=17;
            break;
        case 50:
            range1=12;
            break;
        case 55:
            range1=10;
            break;
        default:
            range1=10;
            break;
    }
    float split1=0;
    if (arc4random_uniform(11)>5.1)
        {
        split1=-1;
        }
    else
        {
        split1=1;
        }
    
    int posrand = 0;
    
    posrand = (float)arc4random_uniform(range1) * split1;
    
    //NSLog(@"Random Pt:%i",posrand);
    return posrand;
}

-(void)updateBlockColours{
    if (isAborted == NO) {
    mySingleton *singleton = [mySingleton sharedSingleton];

    currentBlockColour     = singleton.currentBlockColour;
    currentBackgroundColour= singleton.currentBackgroundColour;
    currentShowColour      = singleton.currentShowColour;

    self.testViewerView.backgroundColor=singleton.currentBackgroundColour;

    self.box1image.backgroundColor=currentBlockColour;
    self.box2image.backgroundColor=currentBlockColour;
    self.box3image.backgroundColor=currentBlockColour;
    self.box4image.backgroundColor=currentBlockColour;
    self.box5image.backgroundColor=currentShowColour;
    self.box6image.backgroundColor=currentBlockColour;
    self.box7image.backgroundColor=currentBlockColour;
    self.box8image.backgroundColor=currentBlockColour;
    self.box9image.backgroundColor=currentBlockColour;
    }
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
        
        tempString4=@"Canvas";
        tempString=[NSString stringWithFormat:@"Canvas:, %@",[self colourUIToString:(singleton.currentBackgroundColour)]];
        [singleton.resultStringRows addObject:tempString];//csv
        [singleton.displayStringTitles addObject:tempString4 ];//title
        tempString=[NSString stringWithFormat:@"%@", [self colourUIToString:(singleton.currentBackgroundColour)]];
        [singleton.displayStringRows addObject: tempString ];//data
        
        tempString4=@"Show";
        tempString=[NSString stringWithFormat:@"Show:,    %@",[self colourUIToString:(singleton.currentShowColour)]];
        [singleton.resultStringRows addObject:tempString];//csv
        [singleton.displayStringTitles addObject:tempString4 ];//title
        tempString=[NSString stringWithFormat:@"%@", [self colourUIToString:(singleton.currentShowColour)]];
        [singleton.displayStringRows addObject: tempString ];//data

        tempString4=@"Block";
        tempString=[NSString stringWithFormat:@"Block:, %@",[self colourUIToString:(singleton.currentBlockColour)]];
        [singleton.resultStringRows addObject:tempString];//csv
        [singleton.displayStringTitles addObject:tempString4 ];//title
        tempString=[NSString stringWithFormat:@"%@", [self colourUIToString:(singleton.currentBlockColour)]];
        [singleton.displayStringRows addObject: tempString ];//data

    NSString *rot;
    NSString *ani;
    NSString *forw;
    NSString *beep;
    NSString *beep2;

    NSString *ans;
    NSString *ans2;
    
    if (singleton.animals) {
        ani=@"YES Random";
    }else{
        ani=@"NO Plain";
    }
    if (singleton.blockRotation) {
        rot=@"YES Random";
    }else{
        rot=@"NO 90 degrees";
    }
    if (singleton.forwardTestDirection) {
        forw=@"YES Normal Test";
    }else{
        forw=@"NO Reverse Test";
    }
    if (singleton.sounds) {
        beep=@"Beep ON";
        beep2=singleton.beepEffect;
    }else{
        beep=@"Beep Off";
        beep2=@"(none)";
    }
    beep2=singleton.beepEffect;
        
    //line
    tempString=[NSString stringWithFormat:@"Forward Test:,%@", forw];
    [singleton.resultStringRows addObject:tempString];//csv
    tempString=@"Forward Test";
    [singleton.displayStringTitles addObject:tempString ];//title
    tempString=[NSString stringWithFormat:@"%@", forw];
    [singleton.displayStringRows addObject: tempString ];//data
        
    //line
    tempString=[NSString stringWithFormat:@"Block Size:,%.0f", singleton.blockSize];
    [singleton.resultStringRows addObject:tempString];//csv
    tempString=@"Block Size";
    [singleton.displayStringTitles addObject:tempString ];//title
    tempString=[NSString stringWithFormat:@"%0.0f ", singleton.blockSize];
    [singleton.displayStringRows addObject: tempString ];//data
        
    //line
    tempString=[NSString stringWithFormat:@"Block Rotation:,%@",rot];
    [singleton.resultStringRows addObject:tempString];//csv
    tempString=@"Block Rotation";
    [singleton.displayStringTitles addObject:tempString ];//title
    tempString=[NSString stringWithFormat:@"%@", rot];
    [singleton.displayStringRows addObject: tempString ];//data
        
    //line
    tempString=[NSString stringWithFormat:@"Block Animals:,%@", ani];
    [singleton.resultStringRows addObject:tempString];//csv
    tempString=@"Block Animals";
    [singleton.displayStringTitles addObject:tempString ];//title
    tempString=[NSString stringWithFormat:@"%@", ani];
    [singleton.displayStringRows addObject: tempString ];//data

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
            //swap order for the reverse order if that was selected
            if (singleton.forwardTestDirection == NO) {
                order[q] = reverse[q];
            }
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

-(void)setColours{
    mySingleton *singleton = [mySingleton sharedSingleton];
    testViewerView.backgroundColor=singleton.currentBackgroundColour;
    currentBackgroundColour = singleton.currentBackgroundColour;
    currentBlockColour      = singleton.currentBlockColour;
    currentShowColour       = singleton.currentShowColour;

    currentStatusColour     = singleton.currentStatusColour;
    statusMessageTXT.textColor=currentStatusColour;
    statusMessageTXT.alpha=0.70;

    if (singleton.onScreenInfo) {
        blkNoLBL.textColor      = singleton.currentStatusColour;
        blkLBL.textColor        = singleton.currentStatusColour;
        blkOfLBL.textColor      = singleton.currentStatusColour;
        blkTotalLBL.textColor   = singleton.currentStatusColour;
        setLBL.textColor        = singleton.currentStatusColour;
        setNoLBL.textColor      = singleton.currentStatusColour;
        setOfLBL.textColor      = singleton.currentStatusColour;
        setTotalLBL.textColor   = singleton.currentStatusColour;
    } else {
        blkNoLBL.textColor      = singleton.currentBackgroundColour;
        blkLBL.textColor        = singleton.currentBackgroundColour;
        blkOfLBL.textColor      = singleton.currentBackgroundColour;
        blkTotalLBL.textColor   = singleton.currentBackgroundColour;
        setLBL.textColor        = singleton.currentBackgroundColour;
        setNoLBL.textColor      = singleton.currentBackgroundColour;
        setOfLBL.textColor      = singleton.currentBackgroundColour;
        setTotalLBL.textColor   = singleton.currentBackgroundColour;
    }
}

-(NSString*)colourUIToString:(UIColor*)myUIColour{
    NSString * myColour;

    //make an array of colour names
    NSArray *items =
    @[
        [UIColor blackColor],
        [UIColor blueColor],
        [UIColor greenColor],
        [UIColor redColor],
        [UIColor cyanColor],
        [UIColor whiteColor],
        [UIColor yellowColor],
        [UIColor magentaColor],
        [UIColor grayColor],
        [UIColor orangeColor],
        [UIColor brownColor],
        [UIColor purpleColor],
        [UIColor darkGrayColor],
        [UIColor lightGrayColor]
    ];
    //find the index value of each
    long item = [items indexOfObject: myUIColour];

    //select the item number
    switch (item) {
        case 0:
            // Item 1
            myColour = @"Black";
            break;
        case 1:
            // Item 2
            myColour = @"Blue";
            break;
        case 2:
            // Item 3
            myColour = @"Green";
            break;
        case 3:
            // Item 4
            myColour = @"Red";
            break;
        case 4:
            // Item 5
            myColour = @"Cyan";
            break;
        case 5:
            // Item 6
            myColour = @"White";
            break;
        case 6:
            // Item 7
            myColour = @"Yellow";
            break;
        case 7:
            // Item 8
            myColour = @"Magenta";
            break;
        case 8:
            // Item 9
            myColour = @"Gray";
            break;
        case 9:
            // Item 10
            myColour = @"Orange";
            break;
        case 10:
            // Item 11
            myColour = @"Brown";
            break;
        case 11:
            // Item 12
            myColour = @"Purple";
            break;
        case 12:
            // Item 13
            myColour = @"Dark Gray";
            break;
        case 13:
            // Item 14
            myColour = @"Light Gray";
            break;
        default:
            myColour = @"Yellow";
            break;
    }
    return myColour;
}

- (IBAction)returnToStepOne:(UIStoryboardSegue *)segue {
    //NSLog(@"And now we are back.");
}
@end
