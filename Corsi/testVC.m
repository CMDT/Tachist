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
    int box[9];
    UIImage *card[5];
    int startcounter;
    int finishcounter;
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
    statusMessageLab.text=@"The App is Awake...";
    //hide unhide labels, screens and buttons
    //***
    //Action buttons
    noBut.hidden              = YES;
    yesBut.hidden             = YES;
    startBut.hidden           = NO;
    newTestBut.hidden         = YES;
    hideResultsBut.hidden     = YES;
    saveDataToEmailBut.hidden = YES;
    infoBut.hidden            = NO;

    //text views
    cardHolder.hidden         = YES;
    resultsView.hidden        = YES;
    resultsViewBorder.hidden  = YES;
    settingsBG.hidden         = YES;
    infoView.hidden           = YES;
    settingsBG.hidden         = NO;

    //settings messages and text inputs
    cardsLab.hidden           = NO;
    stimLab.hidden            = NO;
    respLab.hidden            = NO;
    ms1Lab.hidden             = NO;
    ms2Lab.hidden             = NO;
    noCards.hidden            = NO;
    stimOnTime.hidden         = NO;
    postResponseDelay.hidden  = NO;

    //headings and labels
    logoImage.hidden          = NO;
    title1Lab.hidden          = NO;
    title2Lab.hidden          = NO;
    XbutLab.hidden            = YES;
    ObutLab.hidden            = YES;

    subjectCodeLab.hidden     = NO;
    subjectCodeTxt.hidden     = NO;
    statusMessageLab.hidden   = NO;
    results.hidden            = YES;
    settingsLab.hidden        = NO;
    JumpingManLogo.hidden     = NO;
    clickMessageLab.hidden    = NO;

    if (someResultsExist==1){
        results.hidden=NO;
        saveDataToEmailBut.hidden = NO;
    } else {
        results.hidden=YES;
        saveDataToEmailBut.hidden = YES;
    }
    //end of hide section
    NSString *temp2 = [NSString stringWithFormat:@"Tachistoscope Test V.%i.%i.%i",v1,v2,v3];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:temp2 message:@"Type the SUBJECT Code, STIMULUS On Time, POST Stimulus Delay and the NUMBER of cards before starting the test."
                                                   delegate:self cancelButtonTitle:@"Continue to the App Settings" otherButtonTitles: nil];
    [alert show];
    NSMutableArray *cardNo = [[NSMutableArray alloc] init];

    //initialise


    card[0] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi-start.png"]];
    card[1] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi-finished.png"]];
    card[2] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi-stage-start.png"]];
    card[3] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi-stage-end.png"]];
    card[4] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi-calculating.png"]];
    
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
-(void)onCardDisplay1 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    //hide the buttons
    //noBut.hidden = NO;
    //yesBut.hidden = NO;
    //startBut.hidden = YES;
    //cardCounter++;
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


@end
