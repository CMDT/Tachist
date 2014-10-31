//
//  testVC.m
//  Corsi
//
//  Created by Jon Howell on 04/09/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import "testVC.h"
#import "mySingleton.h"

@interface testVC ()
{
    NSNumber *box[10];
    UIImageView *card[11];
    int startcounter;
    int finishcounter;
    int stageCounter;
    int xcounter;
    int ncounter;
    
    BOOL isFinished;
    BOOL stageEnded;
    BOOL resultsSaved;
    BOOL infoShow;
    BOOL reverseTest;
    float blockSize1;
    BOOL rotateBlocks;
    BOOL animals;
    
    int xAdj[10];
    int yAdj[10];
    int angle[10];
    int total;
    float percent;
    NSString *order[10];
    NSString *guess[10];
    NSString *reverse[10];
    NSString *beepName;
    NSString *subjectName;
    NSString *email;
    NSString *testerName;
    int score;
    int pressNo;
    NSString *orderStr[10];
    NSString *reverseStr[10];
    NSString *guessStr[10];
    NSString *correct[10];
    Float32 testTime[7][10];
    Float32 testTimer[7][10];
    int testNo;
    int timingCalc;
    int reply1;
    long tm;
    BOOL analysisFlag;
    Float32 timeGuess[7][10];
    int start;
    int finish;
    float waitTime;
    float startTime;
    float showTime;
    float messageTime;

    UIColor *currentBlockColour;
    UIColor *currentShowColour;
    UIColor *currentBackgroundColour;
    UIColor *currentStatusColour;
    NSArray *totalCorrect;
}
@end

@implementation testVC
@synthesize
    box1iv,
    backgroundMusicPlayer, //for sounds
    blkLBL,
    blkNoLBL,
    blkTotalLBL,
    blkOfLBL,
    box1BTN,
    box1image,
    box2BTN,
    box2image,
    box3BTN,
    box3image,
    box4BTN,
    box4image,
    box5BTN,
    box5image,
    box6BTN,
    box6image,
    box7BTN,
    box7image,
    box8BTN,
    box8image,
    box9BTN,
    box9image,
    setLBL,
    setNoLBL,
    setOfLBL,
    setTotalLBL,
    startBTN,
    statusMessageLBL,
    headingLBL,
    MessageTextView,
    MessageView,
    scaleFactor,
    testViewerView
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
    
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    //sound stuff
    backIsStarted=false;
    beepName=singleton.beepEffect;
    NSString *backgroundMusicPath=[[NSBundle mainBundle]pathForResource:beepName ofType:@"caf"];
    NSURL *backgroundMusicURL=[NSURL fileURLWithPath:backgroundMusicPath];
    NSError *error;
    backgroundMusicPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    [backgroundMusicPlayer setNumberOfLoops:3]; //-1 = forever
    //prepare to play
    NSString *mySoundEffectPath=[[NSBundle mainBundle]pathForResource:beepName ofType:@"caf"];
    NSURL *mySoundEffectURL=[NSURL fileURLWithPath:mySoundEffectPath];
    AudioServicesCreateSystemSoundID(CFBridgingRetain(mySoundEffectURL),&mySoundEffect);
    
    infoShow=singleton.onScreenInfo;
    
    //make 9 sets of number strings
    for (int x=1; x<10; x++) {
        order[x]=[self make9order];
        reverse[x]=[self rev9Order:order[x]];
        NSLog(@"Order returned for Set: %d is:%@, reverse:%@",x, order[x], reverse[x]);
    }
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
    statusMessageLBL.text = @"CORSI Block Test";
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    //check for direction of test and title the test appropiately
    if (singleton.forwardTestDirection) {
        headingLBL.text=@"CORSI FORWARD BLOCK TEST";
    }else{
        headingLBL.text=@"CORSI REVERSE BLOCK TEST";
    }

    animals=singleton.animals;
    
    [self putAnimals];//place the correct random animal in the view
    
    [self setColours];
    
    [self allButtonsBackgroundReset];
    
    [self putBlocksInPlace];
    
    int sizeb=0;
    if (!singleton.blockRotation) {
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
    
    //[self putBlocksInPlace];
    
    infoShow=singleton.onScreenInfo;
    
    //make 9 sets of number strings
    for (int x=1; x<10; x++) {
        order[x]=[self make9order];
        reverse[x]=[self rev9Order:order[x]];
        NSLog(@"Order returned for Set: %d is:%@, reverse:%@",x, order[x], reverse[x]);
    }

    // don't bother, too difficult to do yet //[self rotAllBlocks];
    //  [self sizeAllBlocks];
}

-(void)putAnimals{
    if (animals) {
        //draw an animal picture in the view
        int ani[22];
        NSLog(@"start");
        for (int b=0; b<22; b++) {
            ani[b]=b;
            NSLog(@"animal:%d", ani[b]);
        }
        int temp=0;
        int tt=0;
        for (int b=0; b<2541; b++) {
            tt=[self random22];
            temp=ani[tt-1];
            ani[tt-1]=ani[tt];
            ani[tt]=temp;
        }
        NSLog(@"mix");
        for (int b=0; b<22; b++) {
            NSLog(@"animal:%d", ani[b]);
        }
        NSLog(@"end");
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
    revOrder=@"";//blank
    for (int t=8; t>-1; t--) {
        revOrder= [revOrder stringByAppendingString:[forOrder substringWithRange:NSMakeRange(t, 1)]];
    }
    return revOrder;
}

-(IBAction)startTest:sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    [self playMyEffect];
    
    NSLog(@"Test has started");
    statusMessageLBL.text = @"The Test Has Started";

    startBTN.hidden   = YES;
    headingLBL.hidden = YES;

    [self setColours];

    start       = singleton.start;
    finish      = singleton.finish;
    
    startTime   =[self delayDelay];
    showTime    =[self delayShow];
    waitTime    =[self delayWait];
    messageTime =[self delayMessage];

    //[self hide_blocks];
    
    [self hideInfo];
    
    MessageTextView.hidden=YES;
    
    //start the timer
    //[self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(boxInit) userInfo:nil repeats:NO];

    MessageView.hidden=NO;
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
//

-(void)viewDidAppear:(BOOL)animated{
    
    UIImage *testImage      = [UIImage imageNamed:@"Test"];
    UIImage *testImageSel   = [UIImage imageNamed:@"TestSel"];
    testImage               = [testImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    testImageSel            = [testImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem         = [[UITabBarItem alloc] initWithTitle:@"Test" image:testImage selectedImage: testImageSel];
    
    [self initialiseBlocks];
    mySingleton *singleton = [mySingleton sharedSingleton];

    [self allButtonsBackgroundReset];
    //hide unhide labels, screens and buttons

    startBTN.hidden  = NO;
    headingLBL.hidden= NO;
    
    //[self hide_blocks];
    //[self hide_blocks];

    [self hideInfo];
    
    MessageTextView.hidden=NO;

    testViewerView.backgroundColor=singleton.currentBackgroundColour;
    currentBackgroundColour = singleton.currentBackgroundColour;
    currentBlockColour      = singleton.currentBlockColour;
    currentShowColour       = singleton.currentShowColour;
    currentStatusColour     = singleton.currentStatusColour;
    
    [self setColours];

    MessageView.hidden=YES;
    startBTN.hidden=NO;

    //initialise images for messages on messageview
    card[0] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi_start.png"]];
    card[1] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi-finished.png"]];
    card[2] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi-stage-start.png"]];
    card[3] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi-stage-end.png"]];
    card[4] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi-calculating.png"]];
    card[5] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi-touch-blocks.png"]];
    card[6] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi-results.png"]];
}

//
-(void)awakeFromNib {
    statusMessageLBL.text=@"The App is Awake...";
 }

//
-(float) delayDelay
{//start delay, once only
    mySingleton *singleton = [mySingleton sharedSingleton];
    float delayDelay1;
    delayDelay1  = singleton.startTime/1000;
    //NSLog(@"start delay = %f",delayDelay1);
    return delayDelay1;
}

-(float) delayWait
{//wait delay, after each box display
    mySingleton *singleton = [mySingleton sharedSingleton];
    float delayWait1;
    delayWait1 = singleton.waitTime/1000;
    //NSLog(@"wait delay = %f",delayWait1);
    return delayWait1;
}

-(float) delayShow
{//show delay, after each box display
    mySingleton *singleton = [mySingleton sharedSingleton];
    float delayShow1;
    delayShow1 = singleton.showTime/1000;
    //NSLog(@"show delay = %f",delayShow1);
    return delayShow1;
}

-(float) delayMessage
{//show delay, after each box display
    mySingleton *singleton = [mySingleton sharedSingleton];
    float delayMessage1;
    delayMessage1 = singleton.messageTime/1000;
    //NSLog(@"show delay = %f",delayShow1);
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
    statusMessageLBL.hidden
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
    statusMessageLBL.hidden
                       = true;
}

-(void)boxInit {
    NSLog(@"box init");

    if (infoShow) {
        statusMessageLBL.text = @"Observe Blocks, Start of Test";
    }else{
        statusMessageLBL.text = @"";
    }
    
    [self display_blocks];
    
    [self hideInfo];
    [self allButtonsBackgroundReset];// background colour reset to std

    MessageTextView.hidden=YES;
    MessageView.hidden=YES;
    startBTN.hidden=YES;
    isFinished=NO;
    [self showInfo];
    
    //zero counters
    xcounter = start; //default is 3 but could be 3-9 range depending on settings
    ncounter = 1;
    pressNo  = 0; //set initial no of presses
    
    blkTotalLBL.text = [NSString stringWithFormat:@"%d", xcounter];
    blkNoLBL.text    = [NSString stringWithFormat:@"%d", 0];
    setNoLBL.text    = [NSString stringWithFormat:@"%d", xcounter-2];
    setTotalLBL.text = [NSString stringWithFormat:@"%d", finish-2];

    [self buttonsDisable];
    
    [MessageView setImage: card[0].image];
    [NSTimer scheduledTimerWithTimeInterval:(messageTime*1.5) target:self selector:@selector(startTestMSG) userInfo:nil repeats:NO];
}

-(void)stageChecks {
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

    if (infoShow) {
        statusMessageLBL.text = @"Observe Block Sequence";
    }else{
        statusMessageLBL.text = @"Observe";
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
            [self allButtonsBackgroundReset];// background colour reset to std
            break;
    }
    [NSTimer scheduledTimerWithTimeInterval:showTime target:self selector:@selector(but1) userInfo:nil repeats:NO];
}

-(void)but1 {
    [self buttonsDisable];
    //clears the block, waits and then sends to check to see if any end, stage or flag is passed
    [self allButtonsBackgroundReset];// background colour reset to std
    [NSTimer scheduledTimerWithTimeInterval:waitTime target:self selector:@selector(stageChecks) userInfo:nil repeats:NO];
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
    if (infoShow) {

    switch (press) {
        case 1:
            statusMessageLBL.text = [NSString stringWithFormat:@"%@",guess[1]];
            break;
        case 2:
            statusMessageLBL.text = [NSString stringWithFormat:@"%@%@",guess[1],guess[2]];
            break;
        case 3:
            statusMessageLBL.text = [NSString stringWithFormat:@"%@%@%@",guess[1],guess[2],guess[3]];
            break;
        case 4:
            statusMessageLBL.text = [NSString stringWithFormat:@"%@%@%@%@",guess[1],guess[2],guess[3],guess[4]];
            break;
        case 5:
            statusMessageLBL.text = [NSString stringWithFormat:@"%@%@%@%@%@",guess[1],guess[2],guess[3],guess[4],guess[5]];
            break;
        case 6:
            statusMessageLBL.text = [NSString stringWithFormat:@"%@%@%@%@%@%@",guess[1],guess[2],guess[3],guess[4],guess[5],guess[6]];
            break;
        case 7:
            statusMessageLBL.text = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",guess[1],guess[2],guess[3],guess[4],guess[5],guess[6],guess[7]];
            break;
        case 8:
            statusMessageLBL.text = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",guess[1],guess[2],guess[3],guess[4],guess[5],guess[6],guess[7],guess[8]];
            break;
        case 9:
            statusMessageLBL.text = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",guess[1],guess[2],guess[3],guess[4],guess[5],guess[6],guess[7],guess[8],guess[9]];
            break;

        default:
            statusMessageLBL.text = @"Touch the blocks in sequence";
            break;
    }
    }else{
        statusMessageLBL.text = @"Recall";
    }
        //guessStr[xcounter]= [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",guess[1],guess[2],guess[3],guess[4],guess[5],guess[6],guess[7],guess[8],guess[9]];
}

-(IBAction)blk1BUT:(id)sender{
    //button 1 pressed
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self playMyEffect];
    guess[pressNo+1]=@"1";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo+1];
    [self statusUpdate:pressNo+1];
    pressNo=pressNo+1;
    if(pressNo >= xcounter-1){
        pressNo=0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }
}

-(IBAction)blk2BUT:(id)sender{
    //button 2 pressed
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self playMyEffect];
    guess[pressNo+1]=@"2";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo+1];
    [self statusUpdate:pressNo+1];
    pressNo=pressNo+1;
    if(pressNo >= xcounter-1){
        pressNo=0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }
}

-(IBAction)blk3BUT:(id)sender{
    //button 3 pressed
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self playMyEffect];
    guess[pressNo+1]=@"3";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo+1];
    [self statusUpdate:pressNo+1];
    pressNo=pressNo+1;
    if(pressNo >= xcounter-1){
        pressNo=0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }
}

-(IBAction)blk4BUT:(id)sender{
    //button 4 pressed
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self playMyEffect];
    guess[pressNo+1]=@"4";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo+1];
    [self statusUpdate:pressNo+1];
    pressNo=pressNo+1;
    if(pressNo >= xcounter-1){
        pressNo=0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }
}

-(IBAction)blk5BUT:(id)sender{
    //button 5 pressed
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self playMyEffect];
    guess[pressNo+1]=@"5";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo+1];
    [self statusUpdate:pressNo+1];
    pressNo=pressNo+1;
    if(pressNo >= xcounter-1){
        pressNo=0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }
}

-(IBAction)blk6BUT:(id)sender{
    //button 6 pressed
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self playMyEffect];
    guess[pressNo+1]=@"6";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo+1];
    [self statusUpdate:pressNo+1];
    pressNo=pressNo+1;
    if(pressNo >= xcounter-1){
        pressNo=0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }
}

-(IBAction)blk7BUT:(id)sender{
    //button 7 pressed
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self playMyEffect];
    guess[pressNo+1]=@"7";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo+1];
    [self statusUpdate:pressNo+1];
    pressNo=pressNo+1;
    if(pressNo >= xcounter-1){
        pressNo=0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }
}

-(IBAction)blk8BUT:(id)sender{
    //button 8 pressed
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self playMyEffect];
    guess[pressNo+1]=@"8";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo+1];
    [self statusUpdate:pressNo+1];
    pressNo=pressNo+1;
    if(pressNo >= xcounter-1){
        pressNo=0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }
}

-(IBAction)blk9BUT:(id)sender{
    //button 9 pressed
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self playMyEffect];
    guess[pressNo+1]=@"9";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo+1];
    [self statusUpdate:pressNo+1];
    pressNo=pressNo+1;
    if(pressNo >= xcounter-1){
        pressNo=0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }
}

-(void)getGuesses {
    [self buttonsEnable];
    blkNoLBL.text = [NSString stringWithFormat:@"%i",0];
    //turns on the buttons, collects the xcounter guesses, forms a string, saves it and carries on with next stage
    
    if (infoShow) {
        statusMessageLBL.text = @"Recall The Sequence, touch the blocks.";
    }else{
        statusMessageLBL.text = @"Recall";
    }

    NSLog(@"Press The Blocks in Order");
    
    if(pressNo >= xcounter+1){
        pressNo=0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }else{
        [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(self) userInfo:nil repeats:NO];
    }
}

-(void)getFinalGuesses {
    [self buttonsEnable];
    blkNoLBL.text = [NSString stringWithFormat:@"%i",0];
    //turns on the buttons, collects the xcounter guesses, forms a string, saves it and carries on with next stage
    if (infoShow) {
        statusMessageLBL.text = @"Recall The Sequence, touch the blocks.";
    }else{
        statusMessageLBL.text = @"Recall";
    }
    NSLog(@"Press The Blocks in Order");
   
    if((pressNo >= xcounter+1)&&(isFinished==YES)){
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(endTestMSG) userInfo:nil repeats:NO];
    }else{
        [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(self) userInfo:nil repeats:NO];
    }
}

-(void)guessMSG {
    blkNoLBL.text = [NSString stringWithFormat:@"%i",0];
    NSLog(@"Guess Now");

        statusMessageLBL.text = @"";

    [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(getGuesses) userInfo:nil repeats:NO];
}

-(void)finalGuessMSG {
        blkNoLBL.text = [NSString stringWithFormat:@"%i",0];

        statusMessageLBL.text = @"";

    [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(getFinalGuesses) userInfo:nil repeats:NO];
}

-(void)stageEndMSG {
    [self buttonsDisable];
    NSLog(@"Stage Ending");
    if (infoShow) {
        statusMessageLBL.text = @"";
    }else{
        statusMessageLBL.text = @"";
    }
    [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(guessMSG) userInfo:nil repeats:NO];
}

-(void)finalStageEndMSG {
    [self buttonsDisable];
    NSLog(@"Final Stage Ending");
    isFinished=YES;
    if (infoShow) {
        statusMessageLBL.text = @"";
    }else{
        statusMessageLBL.text = @"";
    }
    [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(finalGuessMSG) userInfo:nil repeats:NO];
}

-(void)nextStageMSG {
    [self buttonsDisable];
    NSLog(@"Stage Starting");
    if (infoShow) {
        statusMessageLBL.text = @"Observe the Blocks";
    }else{
        statusMessageLBL.text = @"Observe";
    }
    pressNo=0;
    [NSTimer scheduledTimerWithTimeInterval: messageTime target:self selector:@selector(blankMSG) userInfo:nil repeats:NO];
}

-(void)startTestMSG {
    //Start of Test Message
    [self buttonsDisable];
    NSLog(@"Start Test");

    if (reverseTest) {
        if (infoShow) {
            statusMessageLBL.text = @"Observe the sequence, recall in the reverse order.";
        }else{
            statusMessageLBL.text = @"Reverse Test";
        }
    }else{
        if (infoShow) {
            statusMessageLBL.text = @"Observe the sequence, recall in the same order.";
        }else{
            statusMessageLBL.text = @"Forward Test";
        }
    }
    [MessageView setImage: card[0].image];
    MessageView.hidden=NO;
    [NSTimer scheduledTimerWithTimeInterval: messageTime*1.5 target:self selector:@selector(blankMSG2) userInfo:nil repeats:NO];
}

-(void)endTestMSG {
    //End of Test Message
    [self buttonsDisable];
    NSLog(@"End Test");
    isFinished=YES;
    if (infoShow) {
        statusMessageLBL.text = @"The test has now finished.";
    }else{
        statusMessageLBL.text = @"Finished";
    }
    [self hideInfo];
    [self hide_blocks];
    [MessageView setImage: card[1].image];
    MessageView.hidden=NO;
    
    [NSTimer scheduledTimerWithTimeInterval:messageTime target:self selector:@selector(calculatingMSG) userInfo:nil repeats:NO];
}

-(void)calculatingMSG {
    //Calculate stats and outputs
    [self buttonsDisable];
    isFinished=YES;
    NSLog(@"Calculating Test Results");
    if (infoShow) {
      statusMessageLBL.text = @"The test results are being calculated.";
    }else{
        statusMessageLBL.text = @"";
    }
    [self hide_blocks];
    [self hideInfo];
    [MessageView setImage: card[4].image];
    MessageView.hidden=NO;
    [NSTimer scheduledTimerWithTimeInterval:messageTime target:self selector:@selector(calculations) userInfo:nil repeats:NO];
}

-(void)blankMSG {
    [self buttonsDisable];
    NSLog(@"(blankmsg)");
    MessageView.hidden=YES;
    [NSTimer scheduledTimerWithTimeInterval:waitTime target:self selector:@selector(stageChecks) userInfo:nil repeats:NO];
}

-(void)blankMSG2 {
    [self buttonsDisable];
    NSLog(@"(blankmsg2)");
    [self display_blocks];
    MessageView.hidden=YES;//maybe messagetime--v
    [NSTimer scheduledTimerWithTimeInterval:startTime target:self selector:@selector(box1) userInfo:nil repeats:NO];
}

-(void)jumpToResultsView {
    [self buttonsDisable];
    NSLog(@"(jumpToResultsView)");
    [self hide_blocks];
    [MessageView setImage: card[6].image];
    MessageView.hidden=NO;
    //jump to selector ResultsVC
    //[self.tabBarController setSelectedIndex:4]; needs to be able to jump as well
    //manual selection at present on tab bar
}

-(void)blankMSG3 {
    [self buttonsDisable];
    guessStr[xcounter-1]= [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",guess[1],guess[2],guess[3],guess[4],guess[5],guess[6],guess[7],guess[8],guess[9]];
    [self statusUpdate:xcounter-1];
    NSLog(@"(blank3 after buttons input %@)",guessStr[xcounter-1]);
    [self display_blocks];
    MessageView.hidden=YES;
    if (isFinished) {
        NSLog(@"(blank3 endtestmsg)");
        [NSTimer scheduledTimerWithTimeInterval:messageTime target:self selector:@selector(endTestMSG) userInfo:nil repeats:NO];
    }else{
        NSLog(@"(blank3 stagechecks)");
        statusMessageLBL.text = @"";
        [NSTimer scheduledTimerWithTimeInterval:messageTime target:self selector:@selector(stageChecks) userInfo:nil repeats:NO];
    }
}

-(float)random9
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
{
    mySingleton *singleton = [mySingleton sharedSingleton];
    int range1;
    
    switch ((int)singleton.blockSize) {
        case 10:
            range1=45;
            break;
        case 15:
            range1=40;
            break;
        case 20:
            range1=35;
            break;
        case 25:
            range1=30;
            break;
        case 30:
            range1=25;
            break;
        case 35:
            range1=20;
            break;
        case 40:
            range1=15;
            break;
        case 45:
            range1=10;
            break;
        case 50:
            range1=7;
            break;
        case 55:
            range1=5;
            break;
        default:
            range1=5;
            break;
    }
    float split1=0;
    if (arc4random_uniform(11)>5.5)
        {
        split1=-1;
        }
    else
        {
        split1=1;
        }
    
    int posrand=0;
    
    posrand=(float)arc4random_uniform(range1)*split1;
    
    NSLog(@"Random Pt:%i",posrand);
    //*********************************************
    return posrand;
}

-(void)updateBlockColours{
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

-(void)calculations{
    mySingleton *singleton = [mySingleton sharedSingleton];
    NSLog(@"Calculations have started.");
    
    [singleton.resultStringRows removeAllObjects];
    singleton.resultStrings=@"";
    NSLog(@"Results array cleared, new results ready..");
    
    NSLog(@"String 1 was:%@, your guess:%@",order[1],guessStr[1]);
    NSLog(@"String 2 was:%@, your guess:%@",order[2],guessStr[2]);
    NSLog(@"String 3 was:%@, your guess:%@",order[3],guessStr[3]);
    NSLog(@"String 4 was:%@, your guess:%@",order[4],guessStr[4]);
    NSLog(@"String 5 was:%@, your guess:%@",order[5],guessStr[5]);
    NSLog(@"String 6 was:%@, your guess:%@",order[6],guessStr[6]);
    NSLog(@"String 7 was:%@, your guess:%@",order[7],guessStr[7]);
    NSLog(@"String 8 was:%@, your guess:%@",order[8],guessStr[8]);
    NSLog(@"String 9 was:%@, your guess:%@",order[9],guessStr[9]);

    NSString * tempString;

    int cor;
    int wro;
    int totcor=0;
    int totwro=0;


    NSString *ee;
    NSString *ff;
    int rsCounter = 0;
    
    //headers
    tempString=[NSString stringWithFormat:@"Corsi Block Tapping Test Results"];
    [singleton.resultStringRows addObject: tempString];
    NSLog(@"%@",tempString);
    rsCounter=rsCounter+1;
    tempString=[NSString stringWithFormat:@"Date:%@, Time:%@",singleton.testDate,singleton.testTime];
    [singleton.resultStringRows addObject:tempString];
    NSLog(@"%@",tempString);
    rsCounter=rsCounter+1;
    tempString=[NSString stringWithFormat:@"Tester:%@",singleton.testerName];
    [singleton.resultStringRows addObject:tempString];
    NSLog(@"%@",tempString);
    rsCounter=rsCounter+1;
    tempString=[NSString stringWithFormat:@"Message Time:,%f, Wait Time:,%f, Show Time:,%f",singleton.startTime,singleton.waitTime,singleton.showTime];
    [singleton.resultStringRows addObject:tempString];
    NSLog(@"%@",tempString);
    rsCounter=rsCounter+1;
    tempString=[NSString stringWithFormat:@"Canvas:%@, Block:%@, Show:%@",singleton.currentBackgroundColour,singleton.currentBlockColour,singleton.currentShowColour];
    [singleton.resultStringRows addObject:tempString];
    NSLog(@"%@",tempString);
    rsCounter=rsCounter+1;
    
    NSString *rot;
    NSString *ani;
    NSString *forw;
    NSString *ans;
    
    if (singleton.animals) {
        ani=@"YES, random";
    }else{
        ani=@"NO, Plain";
    }
    if (singleton.blockRotation) {
        rot=@"YES, random";
    }else{
        rot=@"NO, 90 degrees";
    }
    if (singleton.forwardTestDirection) {
        forw=@"YES, Normal Test";
    }else{
        forw=@"NO, Reverse Corsi Test";
    }
    tempString=[NSString stringWithFormat:@"Forward Test: %@, Block Size: %f, Block Rotation: %@, Block Animals: %@", forw, singleton.blockSize, rot, ani];
    [singleton.resultStringRows addObject:tempString];
    NSLog(@"%@",tempString);
    rsCounter=rsCounter+1;
    tempString=[NSString stringWithFormat:@""];
    [singleton.resultStringRows addObject:tempString];
    NSLog(@"%@",tempString);
    rsCounter=rsCounter+1;
    tempString=[NSString stringWithFormat:@"Test No,1,2,3,4,5,6,7,8,9,Correct,Wrong"];
    [singleton.resultStringRows addObject:tempString];
    NSLog(@"%@",tempString);
    rsCounter=rsCounter+1;
    
    //body of results
    
    //reset tempstring before building a line of data
    tempString=@"";
    
    //loop for test no
    for (int xx=start; xx<finish+1; xx++) {
        
        tempString = [NSString stringWithFormat:@"%d", xx-2];
        
        cor=0;
        wro=0;
        ans=@"";
        //loop for test in line
        for (int q=0; q<xx; q++) {
            //swap order for the reverse order if that was selected
            if (!singleton.forwardTestDirection) {
                order[q]=reverse[q];
            }
            //get the character at a position in the strings
            ee=[order[xx] substringWithRange:NSMakeRange(q, 1)];
            ff=[guessStr[xx] substringWithRange:NSMakeRange(q, 1)];
            
            //check for same digits in order and guess and count
            if ([ee isEqualToString: ff]) {
                cor=cor+1;
                totcor=totcor+1;
                ans=@"1";
            }else{
                wro=wro+1;
                totwro=totwro+1;
                ans=@"0";
            }
            //put the individual components csv in string
            tempString = [NSString stringWithFormat:@"%@%@", tempString, [NSString stringWithFormat:@",%@", ans]];
        }
        rsCounter=rsCounter+1;
        
        //add some commas
        for (int y=1; y<11-xx; y++) {
            tempString = [NSString stringWithFormat:@"%@%@", tempString, [NSString stringWithFormat:@","]];
        }
        
        //finish off string from loop
        tempString = [NSString stringWithFormat:@"%@%@", tempString, [NSString stringWithFormat:@"%d,%d", cor, wro]];
        [singleton.resultStringRows addObject:tempString];
        NSLog(@"%@",tempString);
        rsCounter=rsCounter+1;
        
        //blankline
        tempString=[NSString stringWithFormat:@""];
        [singleton.resultStringRows addObject:tempString];
        NSLog(@"%@",tempString);
        rsCounter=rsCounter+1;
        
        //put line of results
        //rsCounter=rsCounter+1;
        //tempString=[NSString stringWithFormat:@"order=%@, guess=%@, Correct=%i, Wrong=%i", [order[xx] substringWithRange:NSMakeRange(0, xx)], [guessStr[xx] substringWithRange:NSMakeRange(0, xx)],cor,wro];
        //[singleton.resultStringRow addObject:tempString];
        //NSLog(@"%@",tempString);

    }
    //blankline
    tempString=[NSString stringWithFormat:@""];
    [singleton.resultStringRows addObject:tempString];
    NSLog(@"%@",tempString);
    rsCounter=rsCounter+1;
    
    //put final totals
    rsCounter=rsCounter+1;
    tempString=[NSString stringWithFormat:@"Total Correct=%d, Total Wrong=%d",totcor, totwro];
    [singleton.resultStringRows addObject:tempString];
    NSLog(@"%@",tempString);
    
    //end of results save
    rsCounter=rsCounter+1;
    tempString=[NSString stringWithFormat:@""];
    [singleton.resultStringRows addObject:tempString];
    
    //end
    rsCounter=rsCounter+1;
    tempString=[NSString stringWithFormat:@"End of Test Results"];
    [singleton.resultStringRows addObject:tempString];
    
    //jump to the results page
    [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(jumpToResultsView) userInfo:nil repeats:NO];
}

-(void)setColours{
    mySingleton *singleton = [mySingleton sharedSingleton];
    testViewerView.backgroundColor=singleton.currentBackgroundColour;
    currentBackgroundColour = singleton.currentBackgroundColour;
    currentBlockColour      = singleton.currentBlockColour;
    currentShowColour       = singleton.currentShowColour;

    currentStatusColour     = singleton.currentStatusColour;
    statusMessageLBL.textColor=currentStatusColour;
    statusMessageLBL.alpha=0.70;

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
@end
