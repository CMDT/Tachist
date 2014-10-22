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
    int xAdj[10];
    int yAdj[10];
    int angle[10];
    int total;
    float percent;
    NSString *order[10];
    NSString *guess[10];
    int score;
    int pressNo;
    NSString *orderStr[10];
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

    NSArray *totalCorrect;
}
@end

@implementation testVC
@synthesize
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
    blockBackgroundView,
    scaleFactor
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
    // Do any additional setup after loading the view.

    //make 9 sets of number strings
    for (int x=1; x<10; x++) {
        order[x]=[self make9order];
        NSLog(@"Order returned for Set: %d is:%@",x, order[x]);
    }
    //testing yto see what was made, can be turned off
    NSLog(@"Order returned=First Set");
    int no1=[self whichBlock:1 :1];
    NSLog(@"No.1=%i",no1);
    int no2=[self whichBlock:2 :1];
    NSLog(@"No.2=%i",no2);
    int no3=[self whichBlock:3 :1];
    NSLog(@"No.3=%i",no3);
    int no4=[self whichBlock:4 :1];
    NSLog(@"No.4=%i",no4);
    int no5=[self whichBlock:5 :1];
    NSLog(@"No.5=%i",no5);
    int no6=[self whichBlock:6 :1];
    NSLog(@"No.6=%i",no6);
    int no7=[self whichBlock:7 :1];
    NSLog(@"No.7=%i",no7);
    int no8=[self whichBlock:8 :1];
    NSLog(@"No.8=%i",no8);
    int no9=[self whichBlock:9 :1];
    NSLog(@"No.9=%i",no9);

    NSLog(@"Order returned=Second Set");
    no1=[self whichBlock:1 :2];
    NSLog(@"No.1=%i",no1);
    no2=[self whichBlock:2 :2];
    NSLog(@"No.2=%i",no2);
    no3=[self whichBlock:3 :2];
    NSLog(@"No.3=%i",no3);
    no4=[self whichBlock:4 :2];
    NSLog(@"No.4=%i",no4);
    no5=[self whichBlock:5 :2];
    NSLog(@"No.5=%i",no5);
    no6=[self whichBlock:6 :2];
    NSLog(@"No.6=%i",no6);
    no7=[self whichBlock:7 :2];
    NSLog(@"No.7=%i",no7);
    no8=[self whichBlock:8 :2];
    NSLog(@"No.8=%i",no8);
    no9=[self whichBlock:9 :2];
    NSLog(@"No.9=%i",no9);
    
    // don't bother, too difficult to do yet //[self rotAllBlocks];
    //  [self sizeAllBlocks];
}

-(IBAction)startTest:sender{
        mySingleton *singleton = [mySingleton sharedSingleton];

    NSLog(@"Test has started");
    
    //temp to test code
    finishcounter=10;
    
    startBTN.hidden   = YES;
    headingLBL.hidden = YES;
    
    currentBlockColour = singleton.currentBlockColour;
    currentShowColour  = singleton.currentShowColour;
    
    start       = singleton.start;
    finish      = singleton.finish;
    
    startTime   =[self delayDelay];
    showTime    =[self delayShow];
    waitTime    =[self delayWait];
    messageTime =[self delayMessage];

    [self putBlocksInPlace];
    
    [self hide_blocks];
    
    [self hideInfo];
    
    MessageTextView.hidden=YES;
    
    //start the timer
    //self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(boxInit) userInfo:nil repeats:NO];

    MessageView.hidden=NO;
}

-(float)randomDegrees359
{
    float degrees = 0;
    degrees = arc4random_uniform(360); //returns a value from 0 to 359, not 360;
    //NSLog(@"Degs=%f",degrees);
    return degrees;
}

-(void)putBlocksInPlace{
    {
    mySingleton *singleton = [mySingleton sharedSingleton];
    // Do any additional setup after loading the view.
    blockSize1 = singleton.blockSize;
    blockSize1 = blockSize1/55.00;
    if( blockSize1 <= 0){
        blockSize1 = 0.1;
    }
    if( blockSize1 >= 1){
        blockSize1 = 1;
    }

    scaleFactor = blockSize1;//arbitary change, replace with singleton size
    if(singleton.blockRotation){
        angle[1] = self.randomDegrees359;//(_angle == 180 ? 360 : 180);
        angle[2] = self.randomDegrees359;
        angle[3] = self.randomDegrees359;
        angle[4] = self.randomDegrees359;
        angle[5] = self.randomDegrees359;
        angle[6] = self.randomDegrees359;
        angle[7] = self.randomDegrees359;
        angle[8] = self.randomDegrees359;
        angle[9] = self.randomDegrees359;
    }else{
        for (int t; t<10; t++) {
            angle[t] = 0;
        }
    }
    //UITouch *touch = [touches anyObject];
    //some new point slightly different from the original one
    CGPoint location1 = CGPointMake(box1image.center.x+[self randomPt], box1image.center.y+[self randomPt]);
    CGPoint location2 = CGPointMake(box2image.center.x+[self randomPt], box2image.center.y+[self randomPt]);
    CGPoint location3 = CGPointMake(box3image.center.x+[self randomPt], box3image.center.y+[self randomPt]);
    CGPoint location4 = CGPointMake(box4image.center.x+[self randomPt], box4image.center.y+[self randomPt]);
    CGPoint location5 = CGPointMake(box5image.center.x+[self randomPt], box5image.center.y+[self randomPt]);
    CGPoint location6 = CGPointMake(box6image.center.x+[self randomPt], box6image.center.y+[self randomPt]);
    CGPoint location7 = CGPointMake(box7image.center.x+[self randomPt], box7image.center.y+[self randomPt]);
    CGPoint location8 = CGPointMake(box8image.center.x+[self randomPt], box8image.center.y+[self randomPt]);
    CGPoint location9 = CGPointMake(box9image.center.x+[self randomPt], box9image.center.y+[self randomPt]);

    [UIView animateWithDuration:1.0
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGAffineTransform scaleTrans = CGAffineTransformMakeScale(scaleFactor, scaleFactor);

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

                         angle[1] = self.randomDegrees359;//(_angle == 180 ? 360 : 180);
                         angle[2] = self.randomDegrees359;
                         angle[3] = self.randomDegrees359;
                         angle[4] = self.randomDegrees359;
                         angle[5] = self.randomDegrees359;
                         angle[6] = self.randomDegrees359;
                         angle[7] = self.randomDegrees359;
                         angle[8] = self.randomDegrees359;
                         angle[9] = self.randomDegrees359;

                         scaleFactor = 1;
                         
                         box1image.center = location1;
                         box2image.center = location2;
                         box3image.center = location3;
                         box4image.center = location4;
                         box5image.center = location5;
                         box6image.center = location6;
                         box7image.center = location7;
                         box8image.center = location8;
                         box9image.center = location9;
                         
                     } completion:nil];
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
    mySingleton *singleton = [mySingleton sharedSingleton];
    //hide unhide labels, screens and buttons

    startBTN.hidden  = NO;
    headingLBL.hidden= NO;
    
    //[self hide_blocks];
    [self hide_blocks];

    [self hideInfo];
    
    MessageTextView.hidden=NO;
    blockBackgroundView.backgroundColor = singleton.currentBackgroundColour;
    MessageView.hidden=YES;
    startBTN.hidden=NO;

    //initialise images for messages on messageview
    card[0] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi_start.png"]];
    card[1] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi-finished.png"]];
    card[2] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi-stage-start.png"]];
    card[3] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi-stage-end.png"]];
    card[4] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi-calculating.png"]];
    card[5] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi-touch-blocks.png"]];
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

-(void)randomise_boxes{
    //move all the boxes a bit up/down/left/right from origin to give appearance of random throw
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
    statusMessageLBL.text = @"Observe Blocks, Start of Test";
    //hide the buttons
    [self hide_blocks];

    [self hideInfo];
    [self allButtonsBackgroundReset];// background colour reset to std
    [self putBlocksInPlace];
    MessageTextView.hidden=YES;
    MessageView.hidden=YES;
    startBTN.hidden=YES;
    
    [self showInfo];
    
    //zero counters
    xcounter = start; //default is 3 but could be 3-9 range depending on settings
    ncounter = 1;
    pressNo  = 1; //set initial no of presses
    
    blkTotalLBL.text = [NSString stringWithFormat:@"%d", xcounter];
    blkNoLBL.text    = [NSString stringWithFormat:@"%d", ncounter];
    setNoLBL.text    = [NSString stringWithFormat:@"%d", xcounter-2];
    setTotalLBL.text = [NSString stringWithFormat:@"%d", finish-3];
    
    [MessageView setImage: card[0].image];
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(startTestMSG) userInfo:nil repeats:NO];
}

-(void)stageChecks {
    //keep blocks displayed for now
    [self display_blocks];
    //check for stage and test end
    if (xcounter==finish) {
        //end test 1
        isFinished=YES;
        [self hide_blocks];
        [NSTimer scheduledTimerWithTimeInterval:messageTime target:self selector:@selector(endTestMSG) userInfo:nil repeats:NO];
    }else{
        if(ncounter==xcounter){
            //stage end 3
            [self hide_blocks];
            [NSTimer scheduledTimerWithTimeInterval:messageTime target:self selector:@selector(stageEndMSG) userInfo:nil repeats:NO];
        }else{
            //not ended, carry on
            [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(box1) userInfo:nil repeats:NO];
        }
    }
    //update all counters
    ncounter = ncounter+1;   //block number 3-9 range
    
    if(ncounter>xcounter+1){ //starts at 3 for 3 blocks, end stage, then new set, 3 for 4 blocks etc.
        ncounter=1;
        xcounter=xcounter+1; //stage counter 3-9 range
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
    setTotalLBL.text = [NSString stringWithFormat:@"%d", finish-3];
        [self showInfo];
    //hide all messages except blocks
    MessageTextView.hidden=YES;
    MessageView.hidden=YES;
    startBTN.hidden=YES;
    
    //display blocks
    [self display_blocks];
    
    statusMessageLBL.text = @"Observe Boxes";

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

-(IBAction)blk1BUT:(id)sender{
    //button 1 pressed
    guess[pressNo]=@"1";
    pressNo=pressNo+1;
    if(pressNo >= xcounter+1){
        [self blankMSG3];
    }
}

-(IBAction)blk2BUT:(id)sender{
    //button 2 pressed
    guess[pressNo]=@"2";
    pressNo=pressNo+1;
    if(pressNo >= xcounter+1){
        [self blankMSG3];
    }
}

-(IBAction)blk3BUT:(id)sender{
    //button 3 pressed
    guess[pressNo]=@"3";
    pressNo=pressNo+1;
    if(pressNo >= xcounter+1){
        [self blankMSG3];
    }
}

-(IBAction)blk4BUT:(id)sender{
    //button 4 pressed
    guess[pressNo]=@"4";
    pressNo=pressNo+1;
    if(pressNo >= xcounter+1){
        [self blankMSG3];
    }
}

-(IBAction)blk5BUT:(id)sender{
    //button 5 pressed
    guess[pressNo]=@"5";
    pressNo=pressNo+1;
    if(pressNo >= xcounter+1){
        [self blankMSG3];
    }
}

-(IBAction)blk6BUT:(id)sender{
    //button 6 pressed
    guess[pressNo]=@"6";
    pressNo=pressNo+1;
    if(pressNo >= xcounter+1){
        [self blankMSG3];
    }
}

-(IBAction)blk7BUT:(id)sender{
    //button 7 pressed
    guess[pressNo]=@"7";
    pressNo=pressNo+1;
    if(pressNo >= xcounter+1){
        [self blankMSG3];
    }
}

-(IBAction)blk8BUT:(id)sender{
    //button 8 pressed
    guess[pressNo]=@"8";
    pressNo=pressNo+1;
    if(pressNo >= xcounter+1){
        [self blankMSG3];
    }
}

-(IBAction)blk9BUT:(id)sender{
    //button 9 pressed
    guess[pressNo]=@"9";
    pressNo=pressNo+1;
    if(pressNo >= xcounter+1){
        [self blankMSG3];
    }
}

-(void)getGuesses {
    //turns on the buttons, collects the xcounter guesses, forms a string, saves it and carries on with next stage
    NSLog(@"Press The Blocks in Order");
    [self display_blocks];
    [self buttonsEnable];
    
    MessageView.hidden=YES;
    if(pressNo >= xcounter+1){
        pressNo=1;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }else{
        [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(self) userInfo:nil repeats:NO];
    }
    //now need to add get button presses for ncounter buttons inputs before move on
}
-(void)guessMSG {
    NSLog(@"Guess Now");
    //set a message to say touch blocks in the sequence    NSLog(@"touch the blocks in sequence");
    [self hide_blocks];
    [MessageView setImage: card[5].image];
    MessageView.hidden=NO;
    [NSTimer scheduledTimerWithTimeInterval: messageTime target:self selector:@selector(getGuesses) userInfo:nil repeats:NO];
    //now need to add get button presses for ncounter buttons inputs before move on
}
-(void)stageEndMSG {
    //ends a stage with a message, either move to next stage or end of test
    NSLog(@"Stage Ending");
    [self hide_blocks];
    [MessageView setImage: card[3].image];
    MessageView.hidden=NO;
    [NSTimer scheduledTimerWithTimeInterval: messageTime target:self selector:@selector(guessMSG) userInfo:nil repeats:NO];
    //now need to add get button presses for ncounter buttons inputs before move on
}

-(void)nextStageMSG {
    //before this, have to hold to collect button presses
    NSLog(@"Stage Starting");
    [self hide_blocks];
    [MessageView setImage: card[2].image];
    MessageView.hidden=NO;
    //starts a stage with a message
    [NSTimer scheduledTimerWithTimeInterval: messageTime target:self selector:@selector(blankMSG) userInfo:nil repeats:NO];
}

-(void)startTestMSG {
    //Start of Test Message
    NSLog(@"Start Test");
        [self hideInfo];
    [self hide_blocks];
    [MessageView setImage: card[0].image];
    MessageView.hidden=NO;
    [NSTimer scheduledTimerWithTimeInterval: messageTime target:self selector:@selector(blankMSG2) userInfo:nil repeats:NO];
}

-(void)endTestMSG {
    //End of Test Message
    NSLog(@"End Test");
        [self hideInfo];
    [self hide_blocks];
    [MessageView setImage: card[1].image];
    MessageView.hidden=NO;
    
    [NSTimer scheduledTimerWithTimeInterval:messageTime target:self selector:@selector(calculatingMSG) userInfo:nil repeats:NO];
}

-(void)calculatingMSG {
    //Calculate stats and outputs
    NSLog(@"Calculating Test Results");
    //holds here at present, need to make new func to do the work
    [self hide_blocks];
    [self hideInfo];
    [MessageView setImage: card[4].image];
    MessageView.hidden=NO;
    [NSTimer scheduledTimerWithTimeInterval:messageTime target:self selector:@selector(self) userInfo:nil repeats:NO];
}

-(void)blankMSG {
    //blank blocks, before new sequence is shown
    NSLog(@"(blank)");
    //holds here at present, need to make new func to do the work
    [self display_blocks];
    MessageView.hidden=YES;
    [NSTimer scheduledTimerWithTimeInterval:messageTime target:self selector:@selector(stageChecks) userInfo:nil repeats:NO];
}

-(void)blankMSG2 {
    //blank set of blocks, but only after init start
    NSLog(@"(blank2)");
    //holds here at present, need to make new func to do the work
    [self display_blocks];
    MessageView.hidden=YES;
    [NSTimer scheduledTimerWithTimeInterval:messageTime target:self selector:@selector(box1) userInfo:nil repeats:NO];
}

-(void)blankMSG3 {
    guessStr[xcounter]= [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",guess[1],guess[2],guess[3],guess[4],guess[5],guess[6],guess[7],guess[8],guess[9]];
    //blank set of blocks, but only after init start
    NSLog(@"(blank3 after buttons input %@)",guessStr[xcounter]);
    //holds here at present, need to make new func to do the work
    [self display_blocks];
    MessageView.hidden=YES;
    pressNo = 1; //reset counter for next time
    [NSTimer scheduledTimerWithTimeInterval:messageTime target:self selector:@selector(nextStageMSG) userInfo:nil repeats:NO];
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

-(int)randomPt
{
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
    posrand=(int)arc4random_uniform(30)*split1;
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
@end
