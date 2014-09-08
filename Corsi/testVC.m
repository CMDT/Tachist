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
}
@end

@implementation testVC
@synthesize
    blkLBL,
    blkNoLBL,
    blkTotalLBL,
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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
//
-(void)awakeFromNib {
    statusMessageLBL.text=@"The App is Awake...";
    //hide unhide labels, screens and buttons
    //***
    //Action buttons

    startBTN.hidden           = NO;


    //text views


    //settings messages and text inputs


    //headings and labels


    //end of hide section

    NSMutableArray *boxNo = [[NSMutableArray alloc] init];

    //initialise


    card[0] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi-start.png"]];
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

    for(int s=0;s<31;++s){
        // NSLog(@"No: = %d Card No. %@", s, cardNo[s]);
    }
}

//
-(Float32) delayDelay
{//start delay, once only
    mySingleton *singleton = [mySingleton sharedSingleton];
    Float32 delayDelay;
    delayDelay  = singleton.startTime/1000;
    //// NSLog(@"start delay = %f",delay);
    return delayDelay;
}

-(Float32) delayWait
{//wait delay, after each box display
    mySingleton *singleton = [mySingleton sharedSingleton];
    Float32 delayWait;
    delayWait = singleton.waitTime/1000;
    //// NSLog(@"wait delay = %f",delay1);
    return delayWait;
}

-(Float32) delayShow
{//show delay, after each box display
    mySingleton *singleton = [mySingleton sharedSingleton];
    Float32 delayShow;
    delayShow = singleton.showTime/1000;
    //// NSLog(@"wait delay = %f",delay1);
    return delayShow;
}

-(int)pickABox{
    int boxPicked;
    boxPicked = (arc4random() % 9)+1;
    return boxPicked;
}

//========**  blanks
//========*******************************************************=========
//========*******************************************************=========
-(void)boxInit {
    statusMessageLBL.text = @"Observe";
    //hide the buttons

    //startBut.hidden = YES;
    //zero counters

    [MessageView setImage: card[0].image];
    
    [NSTimer scheduledTimerWithTimeInterval:(([self delayDelay])) target:self selector:@selector(box1) userInfo:nil repeats:NO];
}

-(void)box1 {
    statusMessageLBL.text = @"Observe";

    int t=[self pickABox];
    //show the t block

    [NSTimer scheduledTimerWithTimeInterval:(([self delayShow])) target:self selector:@selector(but1) userInfo:nil repeats:NO];
}
-(void)box2 {
    statusMessageLBL.text = @"Observe";

    int t=[self pickABox];

    [NSTimer scheduledTimerWithTimeInterval:(([self delayShow])) target:self selector:@selector(but2) userInfo:nil repeats:NO];
}
-(void)box3 {
    statusMessageLBL.text = @"Observe";

    int t=[self pickABox];

    [NSTimer scheduledTimerWithTimeInterval:(([self delayShow])) target:self selector:@selector(but3) userInfo:nil repeats:NO];
}
-(void)box4 {
    statusMessageLBL.text = @"Observe";

    int t=[self pickABox];

    [NSTimer scheduledTimerWithTimeInterval:(([self delayShow])) target:self selector:@selector(but4) userInfo:nil repeats:NO];
}
-(void)box5 {
    statusMessageLBL.text = @"Observe";

    int t=[self pickABox];

    [NSTimer scheduledTimerWithTimeInterval:(([self delayShow])) target:self selector:@selector(but5) userInfo:nil repeats:NO];
}
-(void)box6 {
    statusMessageLBL.text = @"Observe";

    int t=[self pickABox];

    [NSTimer scheduledTimerWithTimeInterval:(([self delayShow])) target:self selector:@selector(but6) userInfo:nil repeats:NO];
}
-(void)box7 {
    statusMessageLBL.text = @"Observe";

    int t=[self pickABox];

    [NSTimer scheduledTimerWithTimeInterval:(([self delayShow])) target:self selector:@selector(but7) userInfo:nil repeats:NO];
}
-(void)box8 {
    statusMessageLBL.text = @"Observe";

    int t=[self pickABox];

    [NSTimer scheduledTimerWithTimeInterval:(([self delayShow])) target:self selector:@selector(but8) userInfo:nil repeats:NO];
}
-(void)box9 {
    statusMessageLBL.text = @"Observe";

    int t=[self pickABox];

    [NSTimer scheduledTimerWithTimeInterval:(([self delayShow])) target:self selector:@selector(but9) userInfo:nil repeats:NO];
}

//========**  blanks
//========*******************************************************=========

-(void)stageEnd {

    [MessageView setImage: card[0].image];
    //[NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay1) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval: [self delayWait] target:self selector:@selector(onCardDisplay1) userInfo:nil repeats:NO];
}

-(void)nextStage {
    if (finishcounter<2) {
        isFinished=YES;
        // NSLog(@"card display ending now...");
        [MessageView setImage: card[3].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayWait] target:self selector:@selector(testEnd) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [MessageView setImage: card[2].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayWait] target:self selector:@selector(box2) userInfo:nil repeats:NO];
    }
}

-(void)but1 {
    if (finishcounter<3) {
        isFinished=YES;
        // NSLog(@"card display ending now...");
        [MessageView setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayWait] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }else{
        //// NSLog(@"card display blank");
        [MessageView setImage: card[0].image];
        
        [NSTimer scheduledTimerWithTimeInterval:(([self delayWait])) target:self selector:@selector(box3) userInfo:nil repeats:NO];
    }
}



@end
