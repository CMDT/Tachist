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
    NSNumber *box[9];
    UIImageView *card[5];
    int startcounter;
    int finishcounter;
    int stageCounter;
    
    BOOL isFinished;
    BOOL stageEnded;
    BOOL resultsSaved;
    BOOL infoShow;
    BOOL reverseTest;
    int blockSize;
    BOOL rotateBlocks;
    int xAdj[9];
    int yAdj[9];
    int angle[9];
    int totla;
    int percent;
    NSString *order[9];
    NSString *guess[9];
    int score;
    int pressNo;
    NSString *orderStr[9];
    NSString *guessStr[9];
    NSString *correct[9];
    Float32 testTime[7][9];
    Float32 testTimer[7][9];
    int testNo;
    int timingCalc;
    int reply1;
    long tm;
    BOOL analysisFlag;
    Float32 timeGuess[7][9];
    int start;
    int finish;
    float waitTime;
    float startTime;
    float showTime;
    int rot1;
    int rot2;
    int rot3;
    int rot4;
    int rot5;
    int rot6;
    int rot7;
    int rot8;
    int rot9;

    CGPoint blk1pos;
    CGPoint blk2pos;
    CGPoint blk3pos;
    CGPoint blk4pos;
    CGPoint blk5pos;
    CGPoint blk6pos;
    CGPoint blk7pos;
    CGPoint blk8pos;
    CGPoint blk9pos;

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
    MessageView
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
    [self sizeAllBlocks];
}

-(void)sizeAllBlocks{
    mySingleton *singleton = [mySingleton sharedSingleton];
    int bsize=singleton.blockSize;
    box1image.frame =  CGRectMake(box1image.frame.origin.x,
                                  box1image.frame.origin.y,
                                  bsize,
                                  bsize);
    box2image.frame =  CGRectMake(box2image.frame.origin.x,
                                  box2image.frame.origin.y,
                                  bsize,
                                  bsize);
    box3image.frame =  CGRectMake(box3image.frame.origin.x,
                                  box3image.frame.origin.y,
                                  bsize,
                                  bsize);
    box4image.frame =  CGRectMake(box4image.frame.origin.x,
                                  box4image.frame.origin.y,
                                  bsize,
                                  bsize);
    box5image.frame =  CGRectMake(box5image.frame.origin.x,
                                  box5image.frame.origin.y,
                                  bsize,
                                  bsize);
    box6image.frame =  CGRectMake(box6image.frame.origin.x,
                                  box6image.frame.origin.y,
                                  bsize,
                                  bsize);
    box7image.frame =  CGRectMake(box7image.frame.origin.x,
                                  box7image.frame.origin.y,
                                  bsize,
                                  bsize);
    box8image.frame =  CGRectMake(box8image.frame.origin.x,
                                  box8image.frame.origin.y,
                                  bsize,
                                  bsize);
    box9image.frame =  CGRectMake(box9image.frame.origin.x,
                                  box9image.frame.origin.y,
                                  bsize,
                                  bsize);
}

-(void)rotAllBlocks{
    //get a rand number of degrees for all blocks and assign rotate

    mySingleton *singleton = [mySingleton sharedSingleton];
    //rotate angles
    
    CGAffineTransform rotateTrans1 = CGAffineTransformMakeRotation([self randomDegrees359] * M_PI / 180);
    CGAffineTransform rotateTrans2 = CGAffineTransformMakeRotation([self randomDegrees359] * M_PI / 180);
    CGAffineTransform rotateTrans3 = CGAffineTransformMakeRotation([self randomDegrees359] * M_PI / 180);
    CGAffineTransform rotateTrans4 = CGAffineTransformMakeRotation([self randomDegrees359] * M_PI / 180);
    CGAffineTransform rotateTrans5 = CGAffineTransformMakeRotation([self randomDegrees359] * M_PI / 180);
    CGAffineTransform rotateTrans6 = CGAffineTransformMakeRotation([self randomDegrees359] * M_PI / 180);
    CGAffineTransform rotateTrans7 = CGAffineTransformMakeRotation([self randomDegrees359] * M_PI / 180);
    CGAffineTransform rotateTrans8 = CGAffineTransformMakeRotation([self randomDegrees359] * M_PI / 180);
    CGAffineTransform rotateTrans9 = CGAffineTransformMakeRotation([self randomDegrees359] * M_PI / 180);
    
    //scale
    //CGAffineTransform scaleTrans =  CGAffineTransformMakeScale(singleton.blockSize/30, singleton.blockSize/30);
    CGAffineTransform scaleTrans =  CGAffineTransformMakeScale(0.1, 0.1);
    //draw
    box1image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans1);
    //box2image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans2);
    //box3image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans3);
    //box4image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans4);
    //box5image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans5);
    //box6image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans6);
    //box7image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans7);
    //box8image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans8);
    //box9image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans9);
}
-(void)posAllBlocks{
    
}
-(IBAction)startTest:sender{
    /*box1image.frame =  CGRectMake(box1image.frame.origin.x,
                                  box1image.frame.origin.y,
                                  box1image.frame.size.width+20,
                                  box1image.frame.size.height+20);
*/
    NSLog(@"Test has started");
    
    //temp to test code
    finishcounter=10;
    
    startBTN.hidden  = YES;
    headingLBL.hidden= YES;
    
    [self hide_blocks];
    
    [self hideInfo];
    
    MessageTextView.hidden=YES;
    
    //start the timer
    //self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:[self delayDelay] target:self selector:@selector(boxInit) userInfo:nil repeats:NO];
    
    [MessageView setImage: card[0].image];
    MessageView.hidden=NO;
}

-(float)randomDegrees359
{
    float degrees = 0;
    degrees = arc4random_uniform(360); //returns a value from 0 to 359, not 360;
    //NSLog(@"Degs=%f",degrees);
    return degrees;
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
            if(boxz==0||boxz>9){boxz=1;}
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
    //hide unhide labels, screens and buttons
    //***
    //Action buttons

    startBTN.hidden  = NO;
    headingLBL.hidden= NO;
    
    [self hide_blocks];

    [self hideInfo];
    
    MessageTextView.hidden=NO;

    //text views


    //settings messages and text inputs


    //headings and labels


    //end of hide section

    NSMutableArray *boxNo = [[NSMutableArray alloc] init];

    //initialise

    card[0] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi_start.png"]];
    card[1] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi-finished.png"]];
    card[2] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi-stage-start.png"]];
    card[3] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi-stage-end.png"]];
    card[4] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi-calculating.png"]];

    //number the cards
    for(int s=0;s<10;++s){
        //[box addObject:[NSNumber numberWithInt:s]]; ??????????check original code
    }
    //shuffle the cards except the first one and the last two
    //for(int s=1;s<29;++s){
    //int r = arc4random() % 28;
    //[cardNo exchangeObjectAtIndex:s withObjectAtIndex:r+1];
    //}
    [self rotAllBlocks];
    
    //show the blocks
    //[self display_blocks];
    
    for(int s=0;s<31;++s){
        //NSLog(@"No: = %d Card No. %@", s, cardNo[s]);
    }
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
    NSLog(@"start delay = %f",delayDelay1);
    return delayDelay1;
}

-(float) delayWait
{//wait delay, after each box display
    mySingleton *singleton = [mySingleton sharedSingleton];
    float delayWait1;
    delayWait1 = singleton.waitTime/1000;
    NSLog(@"wait delay = %f",delayWait1);
    return delayWait1;
}

-(float) delayShow
{//show delay, after each box display
    mySingleton *singleton = [mySingleton sharedSingleton];
    float delayShow1;
    delayShow1 = singleton.showTime/1000;
    NSLog(@"show delay = %f",delayShow1);
    return delayShow1;
}

-(int)pickABox{
    int boxPicked;
    boxPicked = (arc4random() % 9)+1;
    return boxPicked;
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

//========**  blanks
//========*******************************************************=========
//========*******************************************************=========
-(void)boxInit {
    NSLog(@"box init");
    statusMessageLBL.text = @"Observe";
    //hide the buttons
    [self hide_blocks];
    MessageView.hidden=NO;
    startBTN.hidden = YES;
    //zero counters
    
    [MessageView setImage: card[1].image];
    
    [NSTimer scheduledTimerWithTimeInterval:[self delayDelay] target:self selector:@selector(box1) userInfo:nil repeats:NO];
}

-(void)box1 {
    NSLog(@"box 1");
    MessageView.hidden=YES;
    [self display_blocks];
    statusMessageLBL.text = @"Observe";

    int t=[self pickABox];
    //show the t block
    box1image.backgroundColor=currentShowColour;
    [NSTimer scheduledTimerWithTimeInterval:[self delayShow] target:self selector:@selector(but1) userInfo:nil repeats:NO];
}
-(void)box2 {
        NSLog(@"box 2");
    statusMessageLBL.text = @"Observe";

    int t=[self pickABox];

    [NSTimer scheduledTimerWithTimeInterval:[self delayShow] target:self selector:@selector(but2) userInfo:nil repeats:NO];
}
-(void)box3 {
        NSLog(@"box 3");
    statusMessageLBL.text = @"Observe";

    int t=[self pickABox];

    [NSTimer scheduledTimerWithTimeInterval:[self delayShow] target:self selector:@selector(but3) userInfo:nil repeats:NO];
}
-(void)box4 {
        NSLog(@"box 4");
    statusMessageLBL.text = @"Observe";

    int t=[self pickABox];

    [NSTimer scheduledTimerWithTimeInterval:[self delayShow] target:self selector:@selector(but4) userInfo:nil repeats:NO];
}
-(void)box5 {
        NSLog(@"box 5");
    statusMessageLBL.text = @"Observe";

    int t=[self pickABox];

    [NSTimer scheduledTimerWithTimeInterval:[self delayShow] target:self selector:@selector(but5) userInfo:nil repeats:NO];
}
-(void)box6 {
        NSLog(@"box 6");
    statusMessageLBL.text = @"Observe";

    int t=[self pickABox];

    [NSTimer scheduledTimerWithTimeInterval:[self delayShow] target:self selector:@selector(but6) userInfo:nil repeats:NO];
}
-(void)box7 {
        NSLog(@"box 7");
    statusMessageLBL.text = @"Observe";

    int t=[self pickABox];

    [NSTimer scheduledTimerWithTimeInterval:[self delayShow] target:self selector:@selector(but7) userInfo:nil repeats:NO];
}
-(void)box8 {
        NSLog(@"box 8");
    statusMessageLBL.text = @"Observe";

    int t=[self pickABox];

    [NSTimer scheduledTimerWithTimeInterval:[self delayShow] target:self selector:@selector(but8) userInfo:nil repeats:NO];
}
-(void)box9 {
        NSLog(@"box 9");
    statusMessageLBL.text = @"Observe";

    int t=[self pickABox];

    [NSTimer scheduledTimerWithTimeInterval:[self delayShow] target:self selector:@selector(but9) userInfo:nil repeats:NO];
}

//========**  blanks
//========*******************************************************=========

-(void)stageEnd {
    NSLog(@"stage end");
    [MessageView setImage: card[0].image];
    //[NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay1) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval: [self delayWait] target:self selector:@selector(self) userInfo:nil repeats:NO];
}

-(void)nextStage {
        NSLog(@"next stage");
    if (finishcounter<2) {
        isFinished=YES;
        // NSLog(@"card display ending now...");
        [MessageView setImage: card[3].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayWait] target:self selector:@selector(endTests) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [MessageView setImage: card[2].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayWait] target:self selector:@selector(box2) userInfo:nil repeats:NO];
    }
}

-(void)but1 {
        NSLog(@"but 1");
    box1image.backgroundColor=currentBlockColour;
    if (finishcounter<3) {
        isFinished=YES;
        // NSLog(@"card display ending now...");
        [MessageView setImage: card[4].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayWait] target:self selector:@selector(endTests) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [MessageView setImage: card[2].image];
        
        [NSTimer scheduledTimerWithTimeInterval:[self delayWait] target:self selector:@selector(box2) userInfo:nil repeats:NO];
    }
}
-(void)but2 {
            NSLog(@"but 2");
    if (finishcounter<4) {
        isFinished=YES;
        // NSLog(@"card display ending now...");
        [MessageView setImage: card[4].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayWait] target:self selector:@selector(endTests) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [MessageView setImage: card[2].image];
        
        [NSTimer scheduledTimerWithTimeInterval:[self delayWait] target:self selector:@selector(box3) userInfo:nil repeats:NO];
    }
}
-(void)but3 {
            NSLog(@"but 3");
    if (finishcounter<5) {
        isFinished=YES;
        // NSLog(@"card display ending now...");
        [MessageView setImage: card[4].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayWait] target:self selector:@selector(endTests) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [MessageView setImage: card[2].image];
        
        [NSTimer scheduledTimerWithTimeInterval:[self delayWait] target:self selector:@selector(box4) userInfo:nil repeats:NO];
    }
    
}
-(void)but4 {
            NSLog(@"but 4");
    if (finishcounter<6) {
        isFinished=YES;
        // NSLog(@"card display ending now...");
        [MessageView setImage: card[4].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayWait] target:self selector:@selector(endTests) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [MessageView setImage: card[2].image];
        
        [NSTimer scheduledTimerWithTimeInterval:[self delayWait] target:self selector:@selector(box5) userInfo:nil repeats:NO];
    }
}
-(void)but5 {
            NSLog(@"but 5");
    if (finishcounter<7) {
        isFinished=YES;
        // NSLog(@"card display ending now...");
        [MessageView setImage: card[4].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayWait] target:self selector:@selector(endTests) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [MessageView setImage: card[2].image];
        
        [NSTimer scheduledTimerWithTimeInterval:[self delayWait] target:self selector:@selector(box6) userInfo:nil repeats:NO];
    }
}
-(void)but6 {
            NSLog(@"but 6");
    if (finishcounter<8) {
        isFinished=YES;
        // NSLog(@"card display ending now...");
        [MessageView setImage: card[4].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayWait] target:self selector:@selector(endTests) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [MessageView setImage: card[2].image];
        
        [NSTimer scheduledTimerWithTimeInterval:[self delayWait] target:self selector:@selector(box7) userInfo:nil repeats:NO];
    }
}
-(void)but7 {
            NSLog(@"but 7");
    if (finishcounter<9) {
        isFinished=YES;
        // NSLog(@"card display ending now...");
        [MessageView setImage: card[4].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayWait] target:self selector:@selector(endTests) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [MessageView setImage: card[2].image];
        
        [NSTimer scheduledTimerWithTimeInterval:[self delayWait] target:self selector:@selector(box8) userInfo:nil repeats:NO];
    }
}
-(void)but8 {
            NSLog(@"but 8");
    if (finishcounter<10) {
        isFinished=YES;
        // NSLog(@"card display ending now...");
        [MessageView setImage: card[4].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayWait] target:self selector:@selector(endTests) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [MessageView setImage: card[2].image];
        
        [NSTimer scheduledTimerWithTimeInterval:[self delayWait] target:self selector:@selector(box9) userInfo:nil repeats:NO];
    }
}
-(void)but9 {
            NSLog(@"but 9");
    if (finishcounter<11) {
        isFinished=YES;
        // NSLog(@"card display ending now...");
        [MessageView setImage: card[4].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayWait] target:self selector:@selector(endTests) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [MessageView setImage: card[2].image];
        
        [NSTimer scheduledTimerWithTimeInterval:[self delayWait] target:self selector:@selector(endTests) userInfo:nil repeats:NO];
    }
}

-(void)endTests {
            NSLog(@"end tests");
        [NSTimer scheduledTimerWithTimeInterval:[self delayWait] target:self selector:@selector(self) userInfo:nil repeats:NO];
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
    posrand=(int)arc4random_uniform(60)*split1;
    return posrand;
}

-(void)updateSizesOfBlocks{
    //mySingleton *singleton = [mySingleton sharedSingleton];

    //blockSizeLBL.text=[[NSString alloc]initWithFormat:@"%i", blockSize];


    //get pos of centres
    CGPoint block1pt = box1image.frame.origin;
    CGPoint block2pt = box2image.frame.origin;
    CGPoint block3pt = box3image.frame.origin;
    CGPoint block4pt = box4image.frame.origin;
    CGPoint block5pt = box5image.frame.origin;
    CGPoint block6pt = box6image.frame.origin;
    CGPoint block7pt = box7image.frame.origin;
    CGPoint block8pt = box8image.frame.origin;
    CGPoint block9pt = box9image.frame.origin;

    //move the block

   box1image.frame=CGRectMake(block1pt.x, block1pt.y, blockSize, blockSize) ;
   box2image.frame=CGRectMake(block2pt.x, block2pt.y, blockSize, blockSize) ;
   box3image.frame=CGRectMake(block3pt.x, block3pt.y, blockSize, blockSize) ;
   box4image.frame=CGRectMake(block4pt.x, block4pt.y, blockSize, blockSize) ;
   box5image.frame=CGRectMake(block5pt.x, block5pt.y, blockSize, blockSize) ;
   box6image.frame=CGRectMake(block6pt.x, block6pt.y, blockSize, blockSize) ;
   box7image.frame=CGRectMake(block7pt.x, block7pt.y, blockSize, blockSize) ;
   box8image.frame=CGRectMake(block8pt.x, block8pt.y, blockSize, blockSize) ;
   box9image.frame=CGRectMake(block9pt.x, block9pt.y, blockSize, blockSize) ;

    float scale=1;
    CGAffineTransform scaleTrans = CGAffineTransformMakeScale(scale, scale);


    //singleton.blockSize=[blockSizeLBL.text intValue];


    CGAffineTransform rotateTrans =
    CGAffineTransformMakeRotation(0 * M_PI / 180);

    box1image.transform = CGAffineTransformConcat(scaleTrans,
                                                   rotateTrans
                                                   );
    box2image.transform = CGAffineTransformConcat(scaleTrans,
                                                   rotateTrans
                                                   );
    box3image.transform = CGAffineTransformConcat(scaleTrans,
                                                   rotateTrans
                                                   );
    box4image.transform = CGAffineTransformConcat(scaleTrans,
                                                   rotateTrans
                                                   );
    box5image.transform = CGAffineTransformConcat(scaleTrans,
                                                   rotateTrans
                                                   );
    box6image.transform = CGAffineTransformConcat(scaleTrans,
                                                   rotateTrans
                                                   );
    box7image.transform = CGAffineTransformConcat(scaleTrans,
                                                   rotateTrans
                                                   );
    box8image.transform = CGAffineTransformConcat(scaleTrans,
                                                   rotateTrans
                                                   );
    box9image.transform = CGAffineTransformConcat(scaleTrans,
                                                   rotateTrans
                                                   );
}

- (IBAction)newRotationAngle:(id)sender {
    rot1=[self randomDegrees359];
    rot2=[self randomDegrees359];
    rot3=[self randomDegrees359];
    rot4=[self randomDegrees359];
    rot5=[self randomDegrees359];
    rot6=[self randomDegrees359];
    rot7=[self randomDegrees359];
    rot8=[self randomDegrees359];
    rot9=[self randomDegrees359];
}

-(void)setRotAngle{
    mySingleton *singleton = [mySingleton sharedSingleton];
    CGAffineTransform rotateTrans1 = CGAffineTransformMakeRotation(rot1 * M_PI / 180);
    CGAffineTransform rotateTrans2 = CGAffineTransformMakeRotation(rot2 * M_PI / 180);
    CGAffineTransform rotateTrans3 = CGAffineTransformMakeRotation(rot3 * M_PI / 180);
    CGAffineTransform rotateTrans4 = CGAffineTransformMakeRotation(rot4 * M_PI / 180);
    CGAffineTransform rotateTrans5 = CGAffineTransformMakeRotation(rot5 * M_PI / 180);
    CGAffineTransform rotateTrans6 = CGAffineTransformMakeRotation(rot6 * M_PI / 180);
    CGAffineTransform rotateTrans7 = CGAffineTransformMakeRotation(rot7 * M_PI / 180);
    CGAffineTransform rotateTrans8 = CGAffineTransformMakeRotation(rot8 * M_PI / 180);
    CGAffineTransform rotateTrans9 = CGAffineTransformMakeRotation(rot9 * M_PI / 180);

    CGAffineTransform scaleTrans =  CGAffineTransformMakeScale(singleton.blockSize/30, singleton.blockSize/30);

    box1image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans1);
    box2image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans2);
    box3image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans3);
    box4image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans4);
    box5image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans5);
    box6image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans6);
    box7image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans7);
    box8image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans8);
    box9image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans9);
}

-(void)setRot90{
    //set the blocks to original rotation

    box1image.transform = CGAffineTransformIdentity;
    box2image.transform = CGAffineTransformIdentity;
    box3image.transform = CGAffineTransformIdentity;
    box4image.transform = CGAffineTransformIdentity;
    box5image.transform = CGAffineTransformIdentity;
    box6image.transform = CGAffineTransformIdentity;
    box7image.transform = CGAffineTransformIdentity;
    box8image.transform = CGAffineTransformIdentity;
    box9image.transform = CGAffineTransformIdentity;
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
