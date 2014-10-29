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


-(void)initialiseBlocks{
    statusMessageLBL.text = @"CORSI Block Test";
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    //check for direction of test and title the test appropiately
    if (singleton.forwardTestDirection) {
        headingLBL.text=@"CORSI FORWARD BLOCK TEST";
    }else{
        headingLBL.text=@"CORSI REVERSE BLOCK TEST";
    }
    float sizer;
    
    float viewHeight=testViewerView.frame.size.height;
    float viewWidth=testViewerView.frame.size.width;
    
    animals=singleton.animals;
    
    sizer=singleton.blockSize*viewWidth/100;
    /*
     float row2=viewHeight*35/100;
     float col2=(viewWidth/2)-38;
     float col1=38;
     float col3=viewWidth-38-(sizer);
     float row1=viewHeight*15/100;
     float row3=viewHeight*50/100;
     
     box1image =[[UIImageView alloc] initWithFrame:CGRectMake(col1,row1,sizer,sizer)];
     box4image =[[UIImageView alloc] initWithFrame:CGRectMake(col1,row2,sizer,sizer)];
     box7image =[[UIImageView alloc] initWithFrame:CGRectMake(col1,row3,sizer,sizer)];
     box2image =[[UIImageView alloc] initWithFrame:CGRectMake(col2,row1,sizer,sizer)];
     box5image =[[UIImageView alloc] initWithFrame:CGRectMake(col2,row2,sizer,sizer)];
     box8image =[[UIImageView alloc] initWithFrame:CGRectMake(col2,row3,sizer,sizer)];
     box3image =[[UIImageView alloc] initWithFrame:CGRectMake(col3,row1,sizer,sizer)];
     box6image =[[UIImageView alloc] initWithFrame:CGRectMake(col3,row2,sizer,sizer)];
     box9image =[[UIImageView alloc] initWithFrame:CGRectMake(col3,row3,sizer,sizer)];
     
     [self.view addSubview:box1image];
     [self.view addSubview:box2image];
     [self.view addSubview:box3image];
     [self.view addSubview:box4image];
     [self.view addSubview:box5image];
     [self.view addSubview:box6image];
     [self.view addSubview:box7image];
     [self.view addSubview:box8image];
     [self.view addSubview:box9image];
     */
    
    [self putAnimals];//place the correct random animal in the view
        /*
     
         
     float sizer;
     
     sizer=64; //singleton.blockSize;
     
     box1image.frame= CGRectMake(100, 100, sizer, sizer);
     
     box1image.frame = CGRectMake(box1image.frame.size.height,box1image.frame.size.width, sizer, sizer);
     box2image.frame = CGRectMake(box2image.frame.size.height,box2image.frame.size.width, sizer, sizer);
     box3image.frame = CGRectMake(box3image.frame.size.height,box3image.frame.size.width, sizer, sizer);
     box4image.frame = CGRectMake(box4image.frame.size.height,box4image.frame.size.width, sizer, sizer);
     box5image.frame = CGRectMake(box5image.frame.size.height,box5image.frame.size.width, sizer, sizer);
     box6image.frame = CGRectMake(box6image.frame.size.height,box6image.frame.size.width, sizer, sizer);
     box7image.frame = CGRectMake(box7image.frame.size.height,box7image.frame.size.width, sizer, sizer);
     box8image.frame = CGRectMake(box8image.frame.size.height,box8image.frame.size.width, sizer, sizer);
     box9image.frame = CGRectMake(box9image.frame.size.height,box9image.frame.size.width, sizer, sizer);
     */
    
    [self setColours];
    
    [self allButtonsBackgroundReset];
    
    box1image.transform = CGAffineTransformMakeScale(0,0);
    box2image.transform = CGAffineTransformMakeScale(0,0);
    box3image.transform = CGAffineTransformMakeScale(0,0);
    box4image.transform = CGAffineTransformMakeScale(0,0);
    box5image.transform = CGAffineTransformMakeScale(0,0);
    box6image.transform = CGAffineTransformMakeScale(0,0);
    box7image.transform = CGAffineTransformMakeScale(0,0);
    box8image.transform = CGAffineTransformMakeScale(0,0);
    box9image.transform = CGAffineTransformMakeScale(0,0);
    
    [self putBlocksInPlace];
    
        float sizeb = singleton.blockSize;
    switch ((int)sizeb) {
        case 10:
            sizeb=100;
            break;
        case 15:
            sizeb=80;
            break;
        case 20:
            sizeb=60;
            break;
        case 25:
            sizeb=50;
            break;
        case 30:
            sizeb=45;
            break;
        case 35:
            sizeb=40;
            break;
        case 40:
            sizeb=35;
            break;
        case 45:
            sizeb=30;
            break;
        case 50:
            sizeb=25;
            break;
        case 55:
            sizeb=20;
            break;
            
        default:
            sizeb=0;
            break;
    }
    
    box1image.transform = CGAffineTransformTranslate(box1image.transform,[self randomPt]-sizeb, [self randomPt]);
    box2image.transform = CGAffineTransformTranslate(box2image.transform,[self randomPt]-sizeb, [self randomPt]);
    box3image.transform = CGAffineTransformTranslate(box3image.transform,[self randomPt]-sizeb, [self randomPt]);
    box4image.transform = CGAffineTransformTranslate(box4image.transform,[self randomPt]-sizeb, [self randomPt]);
    box5image.transform = CGAffineTransformTranslate(box5image.transform,[self randomPt]-sizeb, [self randomPt]);
    box6image.transform = CGAffineTransformTranslate(box6image.transform,[self randomPt]-sizeb, [self randomPt]);
    box7image.transform = CGAffineTransformTranslate(box7image.transform,[self randomPt]-sizeb, [self randomPt]);
    box8image.transform = CGAffineTransformTranslate(box8image.transform,[self randomPt]-sizeb, [self randomPt]);
    box9image.transform = CGAffineTransformTranslate(box9image.transform,[self randomPt]-sizeb, [self randomPt]);
    
    infoShow=singleton.onScreenInfo;
    
    //make 9 sets of number strings
    for (int x=1; x<10; x++) {
        order[x]=[self make9order];
        reverse[x]=[self rev9Order:order[x]];
        NSLog(@"Order returned for Set: %d is:%@, reverse:%@",x, order[x], reverse[x]);
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

-(void)putAnimals{
    if (animals) {
        //draw an animal picture in the view
        long ani[22];
        NSLog(@"start");
        for (int b=0; b<22; b++) {
            ani[b]=b;
            NSLog(@"animal:%ld", ani[b]);
        }
        int temp=0;
        int tt=0;
        for (int b=0; b<1001; b++) {
            tt=[self random22];
            temp=ani[tt-1];
            ani[tt-1]=ani[tt];
            ani[tt]=temp;
        }
        NSLog(@"mix");
        for (int b=0; b<22; b++) {
            NSLog(@"animal:%ld", ani[b]);
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

    box1image.transform = CGAffineTransformMakeScale(0,0);
    box2image.transform = CGAffineTransformMakeScale(0,0);
    box3image.transform = CGAffineTransformMakeScale(0,0);
    box4image.transform = CGAffineTransformMakeScale(0,0);
    box5image.transform = CGAffineTransformMakeScale(0,0);
    box6image.transform = CGAffineTransformMakeScale(0,0);
    box7image.transform = CGAffineTransformMakeScale(0,0);
    box8image.transform = CGAffineTransformMakeScale(0,0);
    box9image.transform = CGAffineTransformMakeScale(0,0);

    [self putBlocksInPlace];

    box1image.transform = CGAffineTransformTranslate(box1image.transform,[self randomPt], [self randomPt]);
    box2image.transform = CGAffineTransformTranslate(box2image.transform,[self randomPt], [self randomPt]);
    box3image.transform = CGAffineTransformTranslate(box3image.transform,[self randomPt], [self randomPt]);
    box4image.transform = CGAffineTransformTranslate(box4image.transform,[self randomPt], [self randomPt]);
    box5image.transform = CGAffineTransformTranslate(box5image.transform,[self randomPt], [self randomPt]);
    box6image.transform = CGAffineTransformTranslate(box6image.transform,[self randomPt], [self randomPt]);
    box7image.transform = CGAffineTransformTranslate(box7image.transform,[self randomPt], [self randomPt]);
    box8image.transform = CGAffineTransformTranslate(box8image.transform,[self randomPt], [self randomPt]);
    box9image.transform = CGAffineTransformTranslate(box9image.transform,[self randomPt], [self randomPt]);

    infoShow=singleton.onScreenInfo;

    //make 9 sets of number strings
    for (int x=1; x<10; x++) {
        order[x]=[self make9order];
        reverse[x]=[self rev9Order:order[x]];
        NSLog(@"Order returned for Set: %d is:%@, reverse:%@",x, order[x], reverse[x]);
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
    //self.startDate = [NSDate date];
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
        

        
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        if(singleton.blockRotation){
        /*
        box1image.layer.anchorPoint = CGPointMake(.5,.5);
        box2image.layer.anchorPoint = CGPointMake(.5,.5);
        box3image.layer.anchorPoint = CGPointMake(.5,.5);
        box4image.layer.anchorPoint = CGPointMake(.5,.5);
        box5image.layer.anchorPoint = CGPointMake(.5,.5);
        box6image.layer.anchorPoint = CGPointMake(.5,.5);
        box7image.layer.anchorPoint = CGPointMake(.5,.5);
        box8image.layer.anchorPoint = CGPointMake(.5,.5);
        box9image.layer.anchorPoint = CGPointMake(.5,.5);*/
        }

                         
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
    //hide the buttons
    [self display_blocks];
    //[self hide_blocks];

    [self hideInfo];
    [self allButtonsBackgroundReset];// background colour reset to std

    MessageTextView.hidden=YES;
    MessageView.hidden=YES;
    startBTN.hidden=YES;
    
    [self showInfo];
    
    //zero counters
    xcounter = start; //default is 3 but could be 3-9 range depending on settings
    ncounter = 1;
    pressNo  = 1; //set initial no of presses
    
    blkTotalLBL.text = [NSString stringWithFormat:@"%d", xcounter];
    blkNoLBL.text    = [NSString stringWithFormat:@"%d", 0];
    setNoLBL.text    = [NSString stringWithFormat:@"%d", xcounter-2];
    setTotalLBL.text = [NSString stringWithFormat:@"%d", finish-3];

    [self buttonsDisable];
    
    [MessageView setImage: card[0].image];
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(startTestMSG) userInfo:nil repeats:NO];
}

-(void)stageChecks {
    if (isFinished) { //definitely ended, to catch second round of checks
        [NSTimer scheduledTimerWithTimeInterval:messageTime target:self selector:@selector(endTestMSG) userInfo:nil repeats:NO];
    }
    //check for stage and test end
    if ((xcounter == finish) && (ncounter >= xcounter)) {
        //test is ended
        isFinished=YES;
        [NSTimer scheduledTimerWithTimeInterval:messageTime target:self selector:@selector(finalStageEndMSG) userInfo:nil repeats:NO];
    }else{
        if(ncounter>=xcounter){
            //stage end 3
            //[self hide_blocks];
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
    guess[pressNo]=@"1";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo];
    [self statusUpdate:pressNo];
    pressNo=pressNo+1;
    if(pressNo >= xcounter+1){
        [self blankMSG3];
    }
}

-(IBAction)blk2BUT:(id)sender{
    //button 2 pressed
    guess[pressNo]=@"2";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo];
    [self statusUpdate:pressNo];
    pressNo=pressNo+1;
    if(pressNo >= xcounter+1){
        [self blankMSG3];
    }
}

-(IBAction)blk3BUT:(id)sender{
    //button 3 pressed
    guess[pressNo]=@"3";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo];
    pressNo=pressNo+1;
    [self statusUpdate:pressNo];
    if(pressNo >= xcounter+1){
        [self blankMSG3];
    }
}

-(IBAction)blk4BUT:(id)sender{
    //button 4 pressed
    guess[pressNo]=@"4";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo];
    [self statusUpdate:pressNo];
    pressNo=pressNo+1;
    if(pressNo >= xcounter+1){
        [self blankMSG3];
    }
}

-(IBAction)blk5BUT:(id)sender{
    //button 5 pressed
    guess[pressNo]=@"5";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo];
    [self statusUpdate:pressNo];
    pressNo=pressNo+1;
    if(pressNo >= xcounter+1){
        [self blankMSG3];
    }
}

-(IBAction)blk6BUT:(id)sender{
    //button 6 pressed
    guess[pressNo]=@"6";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo];
    [self statusUpdate:pressNo];
    pressNo=pressNo+1;
    if(pressNo >= xcounter+1){
        [self blankMSG3];
    }
}

-(IBAction)blk7BUT:(id)sender{
    //button 7 pressed
    guess[pressNo]=@"7";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo];
    [self statusUpdate:pressNo];
    pressNo=pressNo+1;
    if(pressNo >= xcounter+1){
        [self blankMSG3];
    }
}

-(IBAction)blk8BUT:(id)sender{
    //button 8 pressed
    guess[pressNo]=@"8";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo];
    [self statusUpdate:pressNo];
    pressNo=pressNo+1;
    if(pressNo >= xcounter+1){
        [self blankMSG3];
    }
}

-(IBAction)blk9BUT:(id)sender{
    //button 9 pressed
    guess[pressNo]=@"9";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo];
    [self statusUpdate:pressNo];
    pressNo=pressNo+1;
    if(pressNo >= xcounter+1){
        [self blankMSG3];
    }
}

-(void)getGuesses {
        blkNoLBL.text = [NSString stringWithFormat:@"%i",0];
    //turns on the buttons, collects the xcounter guesses, forms a string, saves it and carries on with next stage

    if (infoShow) {
        statusMessageLBL.text = @"Recall The Sequence, touch the blocks.";
    }else{
        statusMessageLBL.text = @"Recall";
    }

    NSLog(@"Press The Blocks in Order");
    [self buttonsEnable];
    if(pressNo >= xcounter+1){
        pressNo=1;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }else{
        [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(self) userInfo:nil repeats:NO];
    }
}

-(void)getFinalGuesses {
        blkNoLBL.text = [NSString stringWithFormat:@"%i",0];
    //turns on the buttons, collects the xcounter guesses, forms a string, saves it and carries on with next stage
    if (infoShow) {
        statusMessageLBL.text = @"Recall The Sequence, touch the blocks.";
    }else{
        statusMessageLBL.text = @"Recall";
    }
    NSLog(@"Press The Blocks in Order");
    [self buttonsEnable];
    if(pressNo >= xcounter+1){
        pressNo=1;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(endTestMSG) userInfo:nil repeats:NO];
    }else{
        [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(self) userInfo:nil repeats:NO];
    }
}

-(void)guessMSG {
        blkNoLBL.text = [NSString stringWithFormat:@"%i",0];
    NSLog(@"Guess Now");
    if (infoShow) {
        statusMessageLBL.text = @"Recall The Sequence, touch the blocks.";
    }else{
        statusMessageLBL.text = @"Recall";
    }
    [NSTimer scheduledTimerWithTimeInterval: messageTime target:self selector:@selector(getGuesses) userInfo:nil repeats:NO];
}

-(void)finalGuessMSG {
        blkNoLBL.text = [NSString stringWithFormat:@"%i",0];
    if (infoShow) {
        statusMessageLBL.text = @"Recall The Sequence, touch the blocks.";
    }else{
        statusMessageLBL.text = @"Recall";
    }
    [NSTimer scheduledTimerWithTimeInterval: messageTime target:self selector:@selector(getFinalGuesses) userInfo:nil repeats:NO];
}

-(void)stageEndMSG {
    [self buttonsDisable];
    NSLog(@"Stage Ending");
    if (infoShow) {
        statusMessageLBL.text = @"The Stage has Ended, prepare to recall the  sequence of blocks.";
    }else{
        statusMessageLBL.text = @"";
    }
    [NSTimer scheduledTimerWithTimeInterval: messageTime target:self selector:@selector(guessMSG) userInfo:nil repeats:NO];
}

-(void)finalStageEndMSG {
    [self buttonsDisable];
    NSLog(@"Final Stage Ending");
    if (infoShow) {
        statusMessageLBL.text = @"The Final Stage has Ended, prepare to recall the  sequence of blocks.";
    }else{
        statusMessageLBL.text = @"";
    }
    [NSTimer scheduledTimerWithTimeInterval: messageTime target:self selector:@selector(finalGuessMSG) userInfo:nil repeats:NO];
}

-(void)nextStageMSG {
    [self buttonsDisable];
    NSLog(@"Stage Starting");
    if (infoShow) {
        statusMessageLBL.text = @"Observe the Blocks";
    }else{
        statusMessageLBL.text = @"Observe";
    }
    [NSTimer scheduledTimerWithTimeInterval: messageTime target:self selector:@selector(blankMSG) userInfo:nil repeats:NO];
}

-(void)startTestMSG {
    //Start of Test Message
    [self buttonsDisable];
    NSLog(@"Start Test");

    if (reverseTest) {
        if (infoShow) {
            statusMessageLBL.text = @"Observe the sequence, recall in the reverse order by touching the blocks when asked.";
        }else{
            statusMessageLBL.text = @"Reverse Test";
        }
    }else{
        if (infoShow) {
            statusMessageLBL.text = @"Observe the sequence, recall in the same order by touching the blocks when asked.";
        }else{
            statusMessageLBL.text = @"Forward Test";
        }
    }

    [MessageView setImage: card[0].image];
    MessageView.hidden=NO;
    [NSTimer scheduledTimerWithTimeInterval: messageTime target:self selector:@selector(blankMSG2) userInfo:nil repeats:NO];
}

-(void)endTestMSG {
    //End of Test Message
    [self buttonsDisable];
    NSLog(@"End Test");
    if (infoShow) {
        statusMessageLBL.text = @"The test has now finished, you have completed all the stages.  In a few moments the results will be ready.";
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
    NSLog(@"Calculating Test Results");
    if (infoShow) {
      statusMessageLBL.text = @"The test results are being calculated, please wait a moment";
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
    NSLog(@"(blank)");
    MessageView.hidden=YES;
    [NSTimer scheduledTimerWithTimeInterval:messageTime target:self selector:@selector(stageChecks) userInfo:nil repeats:NO];
}

-(void)blankMSG2 {
    [self buttonsDisable];
    NSLog(@"(blank2)");
    [self display_blocks];
    MessageView.hidden=YES;
    [NSTimer scheduledTimerWithTimeInterval:messageTime*2 target:self selector:@selector(box1) userInfo:nil repeats:NO];
}

-(void)blankMSG3 {
    [self buttonsDisable];
    guessStr[xcounter]= [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",guess[1],guess[2],guess[3],guess[4],guess[5],guess[6],guess[7],guess[8],guess[9]];
    [self statusUpdate:xcounter];
    NSLog(@"(blank3 after buttons input %@)",guessStr[xcounter]);
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
    return 0;//************************************ posrand;
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
    NSLog(@"Calculations have started.");
    NSLog(@"String 1 was:%@, your guess:%@",order[1],guessStr[1]);
    NSLog(@"String 2 was:%@, your guess:%@",order[2],guessStr[2]);
    NSLog(@"String 3 was:%@, your guess:%@",order[3],guessStr[3]);
    NSLog(@"String 4 was:%@, your guess:%@",order[4],guessStr[4]);
    NSLog(@"String 5 was:%@, your guess:%@",order[5],guessStr[5]);
    NSLog(@"String 6 was:%@, your guess:%@",order[6],guessStr[6]);
    NSLog(@"String 7 was:%@, your guess:%@",order[7],guessStr[7]);
    NSLog(@"String 8 was:%@, your guess:%@",order[8],guessStr[8]);
    NSLog(@"String 9 was:%@, your guess:%@",order[9],guessStr[9]);
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
