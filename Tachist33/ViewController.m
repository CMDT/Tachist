//
//  ViewController.m
//  Tachist4.3.2 - change v1,v2,v3 etc
//
//  Created by Jon Howell on 12/09/2013.
//  Copyright (c) 2013 Manchester Metropolitan University - ESS - psyc. All rights reserved.
//
//  Updated for ios9 17/11/15
//  this version 07/09/16

#import "ViewController.h"
#import "mySingleton.h" //for global variables
#import "AppDelegate.h"

#define kEmail      @"emailAddress"
#define kTester     @"testerName"
#define kVersion0   @"version0"
#define kVersion1   @"version1"
#define kVersion2   @"version2"
#define kVersion3   @"version3"

// use the following line in any method that needs the singleton
// mySingleton *singleton = [mySingleton sharedSingleton];
// then call like this example
// singleton.btnNotPressed = YES; //YES;

// delegate needs setting at line about 681 to work

//@end

@interface ViewController ()
{
    //array of card images needed
    UIImageView *card[50];
    //for keyboard and field moving animations
    float keyboardAnimSpeed;
    float keyboardAnimDelay;
    
    BOOL  cancelButtonPressed;
    
//text fields for inputs
    IBOutlet UITextField *noCards;
    IBOutlet UITextField *stimOnTime;
    IBOutlet UITextField *postResponseDelay;
    IBOutlet UITextField *subjectCodeTxt;
    
//text views for text displays ie results or help screens
    IBOutlet UITextView  *resultsView;
    IBOutlet UITextView  *resultsViewBorder;
    IBOutlet UITextView  *infoView;
    
//image views for pictures
    IBOutlet UIImageView *logoImage;
    IBOutlet UIImageView *cardHolder;
    IBOutlet UIImageView *subjectCodeLab;
    IBOutlet UIImageView *cardsLab;
    IBOutlet UIImageView *stimLab;
    IBOutlet UIImageView *respLab;
    IBOutlet UIImageView *settingsLab;
    IBOutlet UIImageView *settingsBG;
    IBOutlet UIImageView *JumpingManLogo;

//labels for various input boxes or messages
    IBOutlet UILabel     *statusMessageLab;
    IBOutlet UILabel     *ms1Lab;
    IBOutlet UILabel     *ms2Lab;
    IBOutlet UILabel     *XbutLab;
    IBOutlet UILabel     *ObutLab;
    IBOutlet UILabel     *versionNumberLab;
    IBOutlet UILabel     *clickMessageLab;
    IBOutlet UIImageView *title1Lab;
    IBOutlet UIImageView *title2Lab;

//action buttons for methods
    IBOutlet UIButton    *noBut;
    IBOutlet UIButton    *yesBut;
    IBOutlet UIButton    *startBut;
    IBOutlet UIButton    *newTestBut;
    IBOutlet UIButton    *results;
    IBOutlet UIButton    *hideResultsBut;
    IBOutlet UIButton    *saveDataToEmailBut;
    IBOutlet UIButton    *infoBut;
    IBOutlet UIButton    *newSubjectBut;
    IBOutlet UIButton    *cancelBut;
    NSString * emailAdd;
}
@end

@implementation ViewController{
    
}

#pragma mark Inits
//************
//****  inits
//************

@synthesize startDate;
@synthesize noCards;
@synthesize postResponseDelay;
@synthesize stimOnTime;
@synthesize subjectCodeTxt;
@synthesize fileMgr;
@synthesize homeDir;
@synthesize filename;
@synthesize filepath;
@synthesize vDate;

-(NSString *) setFilename{
    mySingleton *singleton  = [mySingleton sharedSingleton];
    NSString *extn          = @"csv";
    filename                = [NSString stringWithFormat:@"%@.%@", singleton.subjectName, extn];

    return filename;
}

//find the home directory for Document
-(NSString *)GetDocumentDirectory{
    fileMgr     = [NSFileManager defaultManager];
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths    = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir     = dirPaths[0];
    return docsDir;
}

/*Create a new file*/
-(void)WriteToStringFile:(NSMutableString *)textToWrite{
    filepath    = [[NSString alloc] init];
    NSError *err;
    filepath    = [self.GetDocumentDirectory stringByAppendingPathComponent:self.setFilename];
    BOOL ok     = [textToWrite writeToFile:filepath atomically:YES encoding:NSASCIIStringEncoding error:&err];
    if (!ok) {
        NSLog(@"Error writing file at %@\n%@",
              filepath, [err localizedFailureReason]);
    }
}

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

//***** masybe delete this
//
float roundUpFactor = 0;// or 0.5  adds 5 * 10,000 of a second to the reaction time to offset the int rounding
//
//*****

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
int detectorOn          = 0;
Float32 delay           = 0.5;
Float32 delay1          = 0;
Float32 delay3          = 0;
Float32 totalDelay      = 0;

bool   lastCard         = NO;
int   noOfCards         = 1;
int  cardPicked         = 0;
int cardCounter         = 0;
bool wasButtonPressed   = NO;

//autorotate stuff so we can have landscape and portrait and both work with the buttons and display output
//iOS 6+

- (BOOL)shouldAutorotate
{
    return YES;
}

//iOS 6+
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return (UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight);
//}
// Check for IOS version and then set orientation method accordingly, orherwise error warning as in code above remmed out
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskLandscape;
}

//one block for each input var to colour the boxes and test the validity
//******** Start of block *********

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    // effects position of frames etc on different devices
#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad
    
    int yy;
    
    if ( IDIOM == IPAD ) {
        /* do something specifically for iPad. */
        yy = 140;
    } else {
        /* do something specifically for iPhone or iPod touch. */
        yy = 70;
    }
    
    //hide the start button for a while
    startBut.hidden = YES;
    infoBut.hidden  = YES;
    
    //move the field to be above keyboard
    if((textField == self -> noCards) || (textField == self -> subjectCodeTxt || textField == self -> postResponseDelay) || (textField == self -> stimOnTime)){
        
        textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y), textField.frame.size.width, textField.frame.size.height);
        int oft=textField.frame.origin.y-yy;
        [self keyBoardAppeared:oft];
    }
    
    if(textField == self->noCards){
        noCards.backgroundColor = [UIColor greenColor];
        // NSLog(@"Var cards");
        statusMessageLab.text = @"Editing \nNo Of\nCards";
    }
    if(textField == self->subjectCodeTxt){
        subjectCodeTxt.backgroundColor = [UIColor greenColor];
        // NSLog(@"Var sub");
        statusMessageLab.text = @"Editing\nSubject\nName";
    }
    if(textField == self->postResponseDelay){
        postResponseDelay.backgroundColor = [UIColor greenColor];
        // NSLog(@"Var post");
        statusMessageLab.text = @"Editing\nPost\nDelay";
    }
    if(textField == self->stimOnTime){
        stimOnTime.backgroundColor = [UIColor greenColor];
        // NSLog(@"Var stim");
        statusMessageLab.text = @"Editing\nStimulus\nTime";
    }
}

-(void)textFieldDidEndEditing:(UITextField *) textField {
    
    mySingleton *singleton = [mySingleton sharedSingleton];
//set int values to the text field inputs
    noOfCards = [noCards.text intValue];
    int stimOnTimeN = [stimOnTime.text intValue];
    int postResponseDelayN = [postResponseDelay.text intValue];

//set all backgrounds to white
    noCards.backgroundColor = [UIColor whiteColor];
    stimOnTime.backgroundColor = [UIColor whiteColor];
    postResponseDelay.backgroundColor = [UIColor whiteColor];
    subjectCodeTxt.backgroundColor = [UIColor whiteColor];

//set backgrounds to yellow if had to correct
//******** start of block num of cards *********
    noCards.textColor=[UIColor blackColor];
    if (noOfCards<1) {
                noCards.textColor=[UIColor redColor];
        noOfCards=1;
                noCards.text = @"1";
        noCards.backgroundColor = [UIColor yellowColor];
        //        set limits here change colour in check method
    }
    if (noOfCards > 100) {
               noCards.textColor=[UIColor redColor];
        noOfCards    = 100;
        noCards.text = @"100";
        noCards.backgroundColor = [UIColor yellowColor];
        //        set limits here change colour in check method
        
     }
//******** end of block noCards*********
    //******** start of block stimDelay *********
    stimOnTime.textColor=[UIColor blackColor];
    if (stimOnTimeN < 50) {
        stimOnTime.textColor=[UIColor redColor];
        stimOnTime.text = @"50";
        stimOnTime.backgroundColor = [UIColor yellowColor];
        //        set limits here change colour in check method
    }
    if (stimOnTimeN > 3000) {
        stimOnTime.textColor=[UIColor redColor];
        stimOnTime.text = @"3000";
        stimOnTime.backgroundColor = [UIColor yellowColor];
        //        set limits here change colour in check method
    }
    //******** end of block *********
    //******** start of block *********
    postResponseDelay.textColor=[UIColor blackColor];
    if (postResponseDelayN < 1) {
        postResponseDelay.textColor=[UIColor redColor];
        postResponseDelay.text = @"1";
        postResponseDelay.backgroundColor = [UIColor yellowColor];
        //        set limits here change colour in check method
    }
    if (postResponseDelayN > 5000) {
        postResponseDelay.textColor=[UIColor redColor];
        postResponseDelay.text = @"5000";
        postResponseDelay.backgroundColor = [UIColor yellowColor];
        //        set limits here change colour in check method
    }
    //******** end of block *********
    //******** start of block *********
    subjectCodeTxt.textColor = [UIColor blackColor];
    if ([subjectCodeTxt.text isEqual:@""]) {
        subjectCodeTxt.textColor=[UIColor redColor];
        subjectCodeTxt.text = @"Temp Subject";
        subjectCodeTxt.backgroundColor = [UIColor yellowColor];
        //        set limits here change colour in check method
    }
    if ([subjectCodeTxt.text isEqual:@" "]) {
        subjectCodeTxt.textColor=[UIColor redColor];
        subjectCodeTxt.text = @"Temp Subject";
        subjectCodeTxt.backgroundColor = [UIColor yellowColor];
        //        set limits here change colour in check method
    }
    //put the subject in the singleton for the file manager to use
    singleton.subjectName=subjectCodeTxt.text;

    // NSLog(@"Subject Code=:%@",subjectCodeTxt.text);
    //******** end of block *********
        statusMessageLab.text=@"Finished\nEditing\nSettings";
    
    //reset the screen positions of the fields
    [self keyBoardDisappeared:0];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // NSLog(@"Touches began with this event");
    [self.view endEditing:YES];
            statusMessageLab.text=@"You\nTouched\nThe \nScreen";
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - Show Keyboard and move frame

- (void) keyBoardAppeared :(int)oft
{
    //move screen up or down as needed to avoid text field entry
    CGRect frame = self.view.frame;
    
    //move frame without anim if toggle in settings indicates yes
    
    //oft= the y of the text field?  make some code to find it
    [UIView animateWithDuration:keyboardAnimSpeed
                          delay:keyboardAnimDelay
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.view.frame = CGRectMake(frame.origin.x, -oft, frame.size.width, frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
}

#pragma mark - Hide Keyboard when done

- (void) keyBoardDisappeared :(int)oft
{
    //move the screen back to original position
    CGRect frame = self.view.frame;
    
    //oft= the y of the text field?  make some code to find it
    [UIView animateWithDuration:keyboardAnimSpeed
                          delay:keyboardAnimDelay
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.view.frame = CGRectMake(frame.origin.x, oft, frame.size.width, frame.size.height);
                     }
                     completion:^(BOOL finished){
                         //replace the hidden buttons now the frame is back home
                         [self showButtons];
                     }];
//any colour re-config now
}

//replace the info and start buttons
-(void)showButtons{
    //use delegate to check if keyboard is on screen (also works with bluetooth kb?)
    BOOL keyboardIsShowing = ((AppDelegate*)[UIApplication sharedApplication].delegate).keyboardIsShowing;
    if (keyboardIsShowing) {
        startBut.hidden = YES;
        infoBut.hidden  = YES;
    }else{
        startBut.hidden = NO;
        infoBut.hidden  = NO;
    }
}

- (IBAction)startTest:(id)sender {
    [self initVars];
    someResultsExist=0;
    statusMessageLab.text=@"The Test\nHas\nStarted...";

//Action buttons
    noBut.hidden              = NO;
    yesBut.hidden             = NO;
    cancelBut.hidden          = YES;
    startBut.hidden           = YES;
    newTestBut.hidden         = YES;
    hideResultsBut.hidden     = YES;
    saveDataToEmailBut.hidden = YES;
    infoBut.hidden            = YES;
    newSubjectBut.hidden      = YES;
    
//text views
    cardHolder.hidden         = NO;
    resultsView.hidden        = YES;
    resultsViewBorder.hidden  = YES;
    infoView.hidden           = YES;
    settingsBG.hidden         = YES;

//settings messages and text inputs
    cardsLab.hidden           = YES;
    stimLab.hidden            = YES;
    respLab.hidden            = YES;
    ms1Lab.hidden             = YES;
    ms2Lab.hidden             = YES;
    noCards.hidden            = YES;
    stimOnTime.hidden         = YES;
    postResponseDelay.hidden  = YES;
    
//headings and labels
    logoImage.hidden          = NO;
    title1Lab.hidden          = NO;
    title2Lab.hidden          = NO;
    XbutLab.hidden            = NO;
    ObutLab.hidden            = NO;

    subjectCodeLab.hidden     = YES;
    subjectCodeTxt.hidden     = YES;
    statusMessageLab.hidden   = NO;
    results.hidden            = YES;
    settingsLab.hidden        = YES;
    JumpingManLogo.hidden     = YES;
    clickMessageLab.hidden    = YES;
    
    if (someResultsExist == 1){
        results.hidden    = NO;
        saveDataToEmailBut.hidden = NO;
    } else {
        results.hidden    = YES;
        saveDataToEmailBut.hidden = YES;
    }
    //hide the top titles and logos
    title1Lab.hidden        = YES;
    title2Lab.hidden        = YES;
    JumpingManLogo.hidden   = YES;
    logoImage.hidden        = YES;
    versionNumberLab.hidden = YES;
    
    //show cards
    //show start message first for 3 seconds
    [NSTimer scheduledTimerWithTimeInterval:(3.0) target:self selector:@selector(startCardDisplay) userInfo:nil repeats:NO];
    
    //get number of cards in test and check ranges in delegate methods for textfield inputs
    noOfCards = [noCards.text intValue];
    
    // NSLog(@"No of Cards = %i", noOfCards);
    wasButtonPressed = YES;
}

- (IBAction)NewTestExit:(id)sender {
    statusMessageLab.text=@"New Test";
    //hide unhide labels, screens and buttons
    //***
    //end of hide section
}

-(Float32) delayx //stim on value to wait
{
    delay  = [stimOnTime.text floatValue]/1000;
    //// NSLog(@"time delay = %f",delay);
    return delay;
}

-(Float32) delayx1 //stim on value to wait
{
    delay1 = [postResponseDelay.text floatValue]/1000;
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
    mySingleton *singleton   = [mySingleton sharedSingleton];
    statusMessageLab.text    = @"Setting\nVariables\nand Flags";
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

    totalCorrectDelay        = 0;
    totalWrongDelay          = 0;
    
    cancelButtonPressed      = NO;
    
    // add score correct x and correct o, also wrong x and wrong o
    correctO   = 0;
    wrongO     = 0;
    correctX   = 0;
    wrongX     = 0;
    noButton   = -1;

    detectorOn = 0;
    delay      = 0.5;
    delay1     = 0;
    delay3     = 0;
    totalDelay = 0;

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
}

- (IBAction)newSubjectCodeGen:(id)sender {
    statusMessageLab.text          = @"New Subject Code Added";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ddMMyyyyhhmmss"];
    NSString *strDate   = [dateFormatter stringFromDate:[NSDate date]];
    NSString *newText   = [NSString stringWithFormat:@"T%@", strDate];
    subjectCodeTxt.text = newText;
}

- (IBAction)showResults:(id)sender {
    statusMessageLab.text = @"Results\nScreen\nDisplayed";
    //hide unhide labels, screens and buttons
    //***
    //hide the top titles and logos
    title1Lab.hidden        = NO;
    title2Lab.hidden        = NO;
    JumpingManLogo.hidden   = NO;
    logoImage.hidden        = NO;
    versionNumberLab.hidden = NO;
    cancelBut.hidden        = YES;
    
    //Action buttons
    noBut.hidden              = YES;
    yesBut.hidden             = YES;
    startBut.hidden           = YES;
    newTestBut.hidden         = YES;
    hideResultsBut.hidden     = NO;
    saveDataToEmailBut.hidden = YES;
    infoBut.hidden            = NO;
    newSubjectBut.hidden      = YES;

    //text views
    cardHolder.hidden         = YES;
    resultsView.hidden        = NO;
    resultsViewBorder.hidden  = NO;
    settingsBG.hidden         = YES;
    infoView.hidden           = YES;
    settingsBG.hidden         = YES;

    //settings messages and text inputs
    cardsLab.hidden           = YES;
    stimLab.hidden            = YES;
    respLab.hidden            = YES;
    ms1Lab.hidden             = YES;
    ms2Lab.hidden             = YES;
    noCards.hidden            = YES;
    stimOnTime.hidden         = YES;
    postResponseDelay.hidden  = YES;

    //headings and labels
    logoImage.hidden          = NO;
    title1Lab.hidden          = NO;
    title2Lab.hidden          = NO;
    XbutLab.hidden            = YES;
    ObutLab.hidden            = YES;

    subjectCodeLab.hidden     = YES;
    subjectCodeTxt.hidden     = YES;
    statusMessageLab.hidden   = NO;
    results.hidden            = YES;
    settingsLab.hidden        = YES;
    JumpingManLogo.hidden     = YES;
    clickMessageLab.hidden    = YES;
    
    if (someResultsExist==1){
        results.hidden=NO;
        saveDataToEmailBut.hidden = NO;
    } else {
        results.hidden=YES;
        saveDataToEmailBut.hidden = YES;
    }
    //end of hide section
}

- (IBAction)hideResults:(id)sender {
    statusMessageLab.text = @"Ready\nFor\nInstruction";
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
    newSubjectBut.hidden      = NO;
    cancelBut.hidden          = YES;

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
}

#pragma mark ViewDidLoad

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    mySingleton *singleton = [mySingleton sharedSingleton];
    //********************************
    //for text fields delegate methods to work in colour change when edited.
    //do the version number in the title bar
    //************************* added plist stuff start
    //********************************
    //for plist version group
    NSString * version0; //version number
    NSString * version1; //copyright info
    NSString * version2; //author info
    NSString * version3; //web site info
    NSString * tester; //web site info
    //NSString * emailAdd; //web site info
    
    // for web page link
    //NSURL *url = [NSURL URLWithString:@"http://www.ess.mmu.ac.uk/"];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //[webview loadRequest:request];
    //read the user defaults from the iPhone/iPad bundle
    // if any are set to nil (no value on first run), put a temporary one in
    
    NSString        * pathStr               = [[NSBundle mainBundle] bundlePath];
    NSString        * settingsBundlePath    = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
    NSString        * defaultPrefsFile      = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
    NSDictionary    * defaultPrefs          = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    NSUserDefaults  * defaults              = [NSUserDefaults standardUserDefaults];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //*************************************************************
    //version, set anyway *****************************************
    //*************************************************************
    vDate    = singleton.vDate;
    version0 = singleton.version;               // version   in awake from nib ************************ <<<<<<<<<<<<<<<
    version1 = @"MMU (C) 2017";                // copyright *** limited line space
    version2 = @"j.a.howell@mmu.ac.uk";        // author    *** to display on device
    version3 = @"http://www.ess.mmu.ac.uk";    // web site  *** settings screen
    //*************************************************************
    
    [defaults setObject:version0 forKey:kVersion0];   //***
    [defaults setObject:version1 forKey:kVersion1];   //***
    [defaults setObject:version2 forKey:kVersion2];   //***
    [defaults setObject:version3 forKey:kVersion3];   //***
    //*************************************************************
    //version set end *********************************************
    //*************************************************************
    
    [defaults synchronize];
    //if any settings not already set, as in new installation, put the defaults in.
    
    [self registerDefaultsFromSettingsBundle];
    
    //tester name
    tester     = [defaults objectForKey:kTester];
    if([tester isEqualToString: @ "" ]){
        tester =  @"Me";
        [defaults setObject:[NSString stringWithFormat:@"%@", tester] forKey:kTester];
    }
    //email name
    emailAdd     = [defaults objectForKey:kEmail];
    if([emailAdd isEqualToString: @ "" ]){
        emailAdd =  @"@mmu.ac.uk";
        [defaults setObject:[NSString stringWithFormat:@"%@", emailAdd] forKey:kEmail];
    }

    [defaults synchronize];//make sure all are updated
    
    versionNumberLab.text   = version0;
  
    //************************* added plist stuff end

    NSString *versionNo = versionNumberLab.text;

    versionNumberLab.text=versionNo;

    //make a status message
    statusMessageLab.text=@"Ready\nTo\nStart Test";
    
    keyboardAnimSpeed = 0.5;
    keyboardAnimDelay = 0.3;

    // clear the old data, the app has started again.

    //set the delegates or text did start/end will not work
    noCards.delegate            = self;
    stimOnTime.delegate         = self;
    postResponseDelay.delegate  = self;
    subjectCodeTxt.delegate     = self;
    
    //********************************
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
    newSubjectBut.hidden      = NO;
    cancelBut.hidden          = YES;

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
    
    if (someResultsExist          == 1){
        results.hidden            = NO;
        saveDataToEmailBut.hidden = NO;
    } else {
        results.hidden            = YES;
        saveDataToEmailBut.hidden = YES;
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ddMMyyyyhhmmss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];

    NSString *newText = [NSString stringWithFormat:@"T%@", strDate];
    subjectCodeTxt.text = newText;
}

- (IBAction)infoButtonPressed:(id)sender {
    statusMessageLab.text = @"Information\nScreen\nDisplayed";
    //hide unhide labels, screens and buttons
    //***
    //Action buttons
    noBut.hidden              = YES;
    yesBut.hidden             = YES;
    startBut.hidden           = YES;
    newTestBut.hidden         = YES;
    hideResultsBut.hidden     = NO;
    saveDataToEmailBut.hidden = YES;
    infoBut.hidden            = YES;
    newSubjectBut.hidden      = YES;
    cancelBut.hidden          = YES;

    //text views
    cardHolder.hidden         = YES;
    resultsView.hidden        = YES;
    resultsViewBorder.hidden  = YES;
    settingsBG.hidden         = YES;
    infoView.hidden           = NO;
    settingsBG.hidden         = YES;

    //settings messages and text inputs
    cardsLab.hidden           = YES;
    stimLab.hidden            = YES;
    respLab.hidden            = YES;
    ms1Lab.hidden             = YES;
    ms2Lab.hidden             = YES;
    noCards.hidden            = YES;
    stimOnTime.hidden         = YES;
    postResponseDelay.hidden  = YES;

    //headings and labels
    logoImage.hidden          = NO;
    title1Lab.hidden          = NO;
    title2Lab.hidden          = NO;
    XbutLab.hidden            = YES;
    ObutLab.hidden            = YES;

    subjectCodeLab.hidden     = YES;
    subjectCodeTxt.hidden     = YES;
    statusMessageLab.hidden   = NO;
    results.hidden            = YES;
    settingsLab.hidden        = YES;
    JumpingManLogo.hidden     = YES;
    clickMessageLab.hidden    = YES;
    
    if (someResultsExist == 1){
        results.hidden            = NO;
        saveDataToEmailBut.hidden = NO;
    } else {
        results.hidden            = YES;
        saveDataToEmailBut.hidden = YES;
    }
    //end of hide section
}

-(void)awakeFromNib {
    [super awakeFromNib];
    mySingleton *singleton = [mySingleton sharedSingleton];
    statusMessageLab.text=@"The App is Awake...";
    
    //set version no
    singleton.vDate   = @"17.1.17";
    singleton.version = @"4.3.3";
    
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
    newSubjectBut.hidden      = NO;
    cancelBut.hidden          = YES;

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
    
    if (someResultsExist == 1){
        results.hidden            = NO;
        saveDataToEmailBut.hidden = NO;
    } else {
        results.hidden            = YES;
        saveDataToEmailBut.hidden = YES;
    }
    //end of hide section
    
    NSString *temp2 = [NSString stringWithFormat:@"Tachistoscope Test for IOS\nV.%@ - %@",singleton.version, singleton.vDate];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:temp2 message:@"Type the SUBJECT Code,\nSTIMULUS On Time, \nPOST Stimulus Delay and the \nNUMBER of cards before \nstarting the test."
                                                   delegate:self cancelButtonTitle:@"Continue to the App Settings" otherButtonTitles: nil];
    [alert show];
    NSMutableArray *cardNo = [[NSMutableArray alloc] init];
    
    //initialise
    card[0]  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-white.png"]];//@"tach-yellow.png"]];
    card[1]  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-1.png"]];
    card[2]  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-2.png"]];
    card[3]  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-3.png"]];
    card[4]  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-4.png"]];
    card[5]  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-5.png"]];
    card[6]  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-6.png"]];
    card[7]  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-7.png"]];
    card[8]  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-blank.png"]];
    card[9]  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tach-blank.png"]];
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
    
    noBut.hidden        = YES;
    yesBut.hidden       = YES;
    XbutLab.hidden      = YES;
    ObutLab.hidden      = YES;
    
    //statusMessageLab.text=@"You\nPressed\nYES";
    if (wasButtonPressed == NO) {
        //NSString *reactionTime= [[NSString alloc] initWithFormat:@"Reaction time is %1.0f milliseconds. ", noSeconds];
        
        if(detectorOn == 0){
            // NSLog(@"Yes Reaction: = %f mS", noSeconds);
        }
        //reactionTime = @"Slow down! You have to wait for the card";
        
        NSString *cardWasCorrect = @"Empty";
        
        if ((cardPicked <= 7) && (cardPicked>=1)){ //cards 1-7 are 'x's, not 0 and not over 7
            cardWasCorrect  = @"Correct X";//don't pick the first card it is blank
            correctX++;
            r1[cardCounter] = 1;//the card
            r2[cardCounter] = 1;//the result
        } else {
            cardWasCorrect  = @"Wrong O";
            wrongO++;
            r1[cardCounter] = 0;//
            r2[cardCounter] = 0;//
        }
    }
    wasButtonPressed = YES;
    cardReactionTime[cardCounter] = noSeconds;
}

-(IBAction)cancelButtonPressesInTest{
    lastCard            = YES;
    cancelButtonPressed = YES;
    noBut.hidden        = YES;
    yesBut.hidden       = YES;
    XbutLab.hidden      = YES;
    ObutLab.hidden      = YES;
    cancelBut.hidden    = YES;
    
    //display finish message
    [cardHolder setImage: card[30].image];
    
    noOfCards           = cardCounter;
    //end the test now
    [NSTimer scheduledTimerWithTimeInterval:((0)) target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
}

- (IBAction)noPressed
{
    double noSeconds = (double) [self.startDate timeIntervalSinceNow] * -1000;
    
    noBut.hidden        = YES;
    yesBut.hidden       = YES;
    XbutLab.hidden      = YES;
    ObutLab.hidden      = YES;
    
    //statusMessageLab.text=@"You\nPressed\nNO";
    if (wasButtonPressed == NO) {
        
        //NSString *reactionTime= [[NSString alloc] initWithFormat:@"Reaction time is %1.0f milliseconds.", noSeconds];
        
        if(detectorOn == 0)
        {
            // NSLog(@"No  Reaction: = %f mS", noSeconds);
        }
        //reactionTime = @"Slow down! You have to wait for the card";
        
        NSString *cardWasCorrect = @"Empty";
        if ((cardPicked >= 8) && (cardPicked<=28)) //don't pick the end two cards as they are messages, start at the 8th card, an 'O'
        {
            cardWasCorrect = @"Correct O";
            correctO++;
        r1[cardCounter]    = 0;//
        r2[cardCounter]    = 1;//
        }
        else
        {
            cardWasCorrect=@"Wrong X";
            wrongX++;
        r1[cardCounter] = 1;//
        r2[cardCounter] = 0;//
        }
    }
    wasButtonPressed = YES;
    //NSNumber *num = [NSNumber numberWithFloat:noSeconds] ;
    cardReactionTime[cardCounter] = noSeconds;
}

-(void)calculateStats{
    statusMessageLab.text  = @"Calculating\nStats\nPlease\nWait...";
    mySingleton *singleton = [mySingleton sharedSingleton];
    // NSLog(@"Starting Stats");

    NSString *myNumbStr = [[NSString alloc] init];

    //set counter to cards for singleton global var
    singleton.counter = noOfCards;

    [singleton.cardReactionTimeResult removeAllObjects];

    [cardHolder setImage: card[31].image];
    
    totalDelay             = 0;
    averageReaction        = 0;
    totalCorrectDelay      = 0;
    totalWrongDelay        = 0;
    averageCorrectReaction = 0;
    averageWrongReaction   = 0;

    //do the adding up of times
    //for the general results
    for (int x = 1; (x < noOfCards+1); x++) {
        // NSLog(@"Card %i : was timed  : %f", x, cardReactionTime[x]);
        if (cardReactionTime[x] > longestReaction) {
            longestReaction = cardReactionTime[x];
        }
        if (((cardReactionTime[x] < shortestReaction)) && (cardReactionTime[x] > 0.00)){
            shortestReaction = cardReactionTime[x];
        }
        totalDelay +=  cardReactionTime[x];

        //for the wrongs and right answers (wrongs)
        if ( r2[x] == 0 ){  //wrong cards)

            if (cardReactionTime[x] > longestWrongReaction) {
                longestWrongReaction = cardReactionTime[x];

            }
            if (((cardReactionTime[x] < shortestWrongReaction)) && (cardReactionTime[x] > 0.00)){
                shortestWrongReaction = cardReactionTime[x];

            }
            totalWrongDelay +=  cardReactionTime[x];
        }
        //for the wrongs and right answers (corrects)
        if ( r2[x]==1 ){  //correct cards)
            if (cardReactionTime[x] > longestCorrectReaction) {
                longestCorrectReaction = cardReactionTime[x];
            }
            if (((cardReactionTime[x] < shortestCorrectReaction)) && (cardReactionTime[x] > 0.00)){
                shortestCorrectReaction = cardReactionTime[x];
            }
            totalCorrectDelay +=  cardReactionTime[x];
        }
    }
    
    //make sure that missed crads are not averaged, and the result is positive
    //don't do if negative, check
    float CardsTaken = (noOfCards-correctO-correctX-wrongO-wrongX);

//must have picked at least one reaction time
//put code her to select if all blanks

    averageReaction = ABS( totalDelay / noOfCards);

    if(wrongX+wrongO > 0)
        {
        averageWrongReaction = ABS( totalWrongDelay / (wrongX+wrongO));
    }
    if(correctX+correctO > 0)
        {
        averageCorrectReaction = ABS( totalCorrectDelay / (correctX+correctO));
    }
    
    //don't let any silly default results through
    if (CardsTaken == 999) { //check if no button was pressed at all and zero out results if tha happened
        shortestReaction        = 10000;
        averageReaction         = 0;
        totalDelay              = 0;
        longestReaction         = 0;

        shortestWrongReaction   = 10000;
        averageWrongReaction    = 0;
        totalWrongDelay         = 0;
        longestWrongReaction    = 0;

        shortestCorrectReaction = 10000;
        averageCorrectReaction  = 0;
        totalCorrectDelay       = 0;
        longestCorrectReaction  = 0;
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
    [singleton.cardReactionTimeResult addObject:@"MMU Cheshire, Exercise and Sport Science, Tachistoscope IOS Application Results"];

    //mmu copyright message 2013 JAH
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"(c) 2017 MMU written by Jonathan A. Howell for MMU, Tachistoscope V%@ - %@",singleton.version, singleton.vDate]];

    //blank line
    [singleton.cardReactionTimeResult addObject:@" "];

    //subject code
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Subject Code, %@",subjectCodeTxt.text]];
    singleton.subjectName = subjectCodeTxt.text;

    //date of test and time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"E dd-MM-yyyy, hh:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    // NSLog(@"Date of test: %@", strDate);
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Date of Test, %@ ", strDate]];

    //blank line
        [singleton.cardReactionTimeResult addObject:@" "];
    if (cancelButtonPressed) {
        [singleton.cardReactionTimeResult addObject:@"*** The CANCEL Button was pressed to finish this test early ***."];
    
        //blank line
        [singleton.cardReactionTimeResult addObject:@" "];
    }
    //no cards
        [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Number of Cards in Test, %@ ", [NSString stringWithFormat:@"%d", noOfCards]]];

    //stim delay
        [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Stimulation Delay (mS), %@ ", stimOnTime.text]];

    //post delay
        [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Post Stimulus Delay (mS), %@ ", postResponseDelay.text]];

    //blank line
        [singleton.cardReactionTimeResult addObject:@" "];

    //got correct o
        [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Correct O Count, %@ ", [NSString stringWithFormat:@"%d", correctO]]];

    //got correct x
        [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Correct X Count, %@ ", [NSString stringWithFormat:@"%d", correctX]]];

    //got wrong o
        [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Wrong O Count, %@ ", [NSString stringWithFormat:@"%d", wrongO]]];

    //got wrong x
        [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Wrong X Count, %@ ", [NSString stringWithFormat:@"%d", wrongX]]];

    //no button count
        [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Missed Results, %@ ", [NSString stringWithFormat:@"%d", noOfCards-correctO-correctX-wrongO-wrongX]]];
    //blank line
        [singleton.cardReactionTimeResult addObject:@""];

    //shortest reaction
    if ((int)(shortestReaction) == 10000) {
        [singleton.cardReactionTimeResult addObject:@"Shortest Reaction Time (mS), n/a"];
    }else{
        [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Shortest Reaction Time (mS), %@ ", [NSString stringWithFormat:@"%d", ((int)(shortestReaction+roundUpFactor))]]];
    }
    //longest reaction
    if ((int)(shortestReaction) == 10000) {
        [singleton.cardReactionTimeResult addObject:@"Longest Reaction Time (mS), n/a"];
    }else{
        [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Longest Reaction Time (mS), %@ ", [NSString stringWithFormat:@"%d", ((int)(longestReaction+roundUpFactor))]]];
    }
    //average reaction
    if ((int)(shortestReaction) == 10000) {
        [singleton.cardReactionTimeResult addObject:@"Average Reaction Time (mS), n/a"];
    }else{
        [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Average Reaction Time (mS), %@ ", [NSString stringWithFormat:@"%d", ((int)(averageReaction+roundUpFactor))]]];
    }
    //total time in test reaction
        [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Total Reaction Time (mS), %@ ", [NSString stringWithFormat:@"%d", ((int)(totalDelay+roundUpFactor))]]];
    //blank line
    [singleton.cardReactionTimeResult addObject:@""];
    
    //******** wrongs

    //shortest Wrong reaction
    if ((int)(shortestWrongReaction) == 10000) {
        [singleton.cardReactionTimeResult addObject:@"Shortest Wrong Reaction Time (mS), n/a"];
    }else{
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Shortest Wrong Reaction Time (mS), %@ ", [NSString stringWithFormat:@"%d", ((int)(shortestWrongReaction+roundUpFactor))]]];
    }
    
    //longest Wrong reaction
    if ((int)(shortestWrongReaction) == 10000) {
        [singleton.cardReactionTimeResult addObject:@"Longest Wrong Reaction Time (mS), n/a"];
    }else{
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Longest Wrong Reaction Time (mS), %@ ", [NSString stringWithFormat:@"%d", ((int)(longestWrongReaction+roundUpFactor))]]];
    }
    
    //average Wrong reaction
    if ((int)(shortestWrongReaction) == 10000) {
        [singleton.cardReactionTimeResult addObject:@"Average Wrong Reaction Time (mS), n/a"];
    }else{
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Average Wrong Reaction Time (mS), %@ ", [NSString stringWithFormat:@"%d", ((int)(averageWrongReaction+roundUpFactor))]]];
    }
    
    //total Wrong time in test reaction
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Total Wrong Reaction Time (mS), %@ ", [NSString stringWithFormat:@"%d", ((int)(totalWrongDelay+roundUpFactor))]]];
    //blank line
    [singleton.cardReactionTimeResult addObject:@""];
    //******** end wrongs
    
    //******** Corrects
    //shortest Correct reaction
    if ((int)(shortestCorrectReaction) == 10000) {
        [singleton.cardReactionTimeResult addObject:@"Shortest Correct Reaction Time (mS), n/a"];
    }else{
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Shortest Correct Reaction Time (mS), %@ ", [NSString stringWithFormat:@"%d", ((int)(shortestCorrectReaction+roundUpFactor))]]];
    }

    //longest Correct reaction
    if ((int)(shortestCorrectReaction) == 10000) {
        [singleton.cardReactionTimeResult addObject:@"Longest Correct Reaction Time (mS), n/a"];
    }else{
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Longest Correct Reaction Time (mS), %@ ", [NSString stringWithFormat:@"%d", ((int)(longestCorrectReaction+roundUpFactor))]]];
    }
    //average Correct reaction
    if ((int)(shortestCorrectReaction) == 10000) {
        [singleton.cardReactionTimeResult addObject:@"Average Correct Reaction Time (mS), n/a"];
    }else{
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Average Correct Reaction Time (mS), %@ ", [NSString stringWithFormat:@"%d", ((int)(averageCorrectReaction+roundUpFactor))]]];
    }
    
    //total Correct time in test reaction
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Total Correct Reaction Time (mS), %@ ", [NSString stringWithFormat:@"%d", ((int)(totalCorrectDelay+roundUpFactor))]]];
    //blank line
    //******** end corrects
    
        [singleton.cardReactionTimeResult addObject:@" " ];
    //title line - results for cards follow
        [singleton.cardReactionTimeResult addObject:@"Card No., Card, Result, Reaction (mS)"];
    //card no., o or x was displayed, answer, time to react
    //results, one per line upto number of cards
    for (int y=1; y < noOfCards +1; y++) {
        myNumbStr = [NSString stringWithFormat:@"      %d,          %d,        %d,          %d", y, r1[y],r2[y], ((int)(cardReactionTime[y]+roundUpFactor))];
        [singleton.cardReactionTimeResult addObject: myNumbStr];
    }
    //blank line
        [singleton.cardReactionTimeResult addObject:@" " ];
    //end of data message
        [singleton.cardReactionTimeResult addObject:@"End of Tachist Test Data." ];

    // 26 + no of cards array index total
    //blank line
    [singleton.cardReactionTimeResult addObject:@" " ];
    [singleton.cardReactionTimeResult addObject:@" " ];
    [singleton.cardReactionTimeResult addObject:@" " ];//a few blank exttra lines to avoid crash if misscounted lines
    [singleton.cardReactionTimeResult addObject:@" " ];
    [singleton.cardReactionTimeResult addObject:@" " ];

    for (int r=0; r < (singleton.counter+37); r++) {
        //nb if you change the number of line output, alter the 37 to less or more as needed else CRASH -bounds error

        // NSLog(@"%@", [singleton.cardReactionTimeResult objectAtIndex: r]);
    }

    //make a text file from the array of results
    NSMutableString *element        = [[NSMutableString alloc] init];
    NSMutableString *printString    = [NSMutableString stringWithString:@""];
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

    resultsView.text = singleton.resultStrings;
    //[self saveText];
    [self WriteToStringFile:[printString mutableCopy]];

    statusMessageLab.text=@"Waiting\nfor\nNext\nInstruction.";
}

//mail from button press
-(IBAction)sendMail:(id)sender {
    statusMessageLab.text  = @"E-Mail\nResults\nLoading...";
    mySingleton *singleton = [mySingleton sharedSingleton];
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    [mailComposer setMailComposeDelegate:self];
    if ([MFMailComposeViewController canSendMail]){
        [mailComposer setToRecipients:[NSArray arrayWithObjects:emailAdd ,Nil]];
        filename = @"TachistAppData.csv";
        //[mailComposer setSubject:@"iPad Restults from Tachistoscope V3.3 App"];
        [mailComposer setSubject:
        [NSString stringWithFormat:@"%@ - IOS Test Data Tachistoscope V%@ - %@", [NSString stringWithFormat:@"%@", subjectCodeTxt.text], singleton.version, singleton.vDate]];
        
        //[mailComposer setMessageBody:@"Dear Tachistoscope User: " isHTML:YES];

        filepath = [[NSString alloc] init];
        
        filepath = [self.GetDocumentDirectory stringByAppendingPathComponent:self.setFilename];
        
        // Get the resource path and read the file using NSData
        
        NSData *fileData = [NSData dataWithContentsOfFile:filepath];
        
        
        [mailComposer setMessageBody: singleton.resultStrings isHTML:NO];
        [mailComposer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        //add the data as an attachment in csv Excel format
        [mailComposer addAttachmentData:fileData mimeType:@"text/csv" fileName:filename];
        
        [self presentViewController:mailComposer animated:YES completion:^{/*email*/}];
    }else{
        
    } //end of if else to check if mail is able to be sent, send message if not
    statusMessageLab.text=@"Select\nNext\nTask";
} // end of mail function

//set out mail controller warnings screen
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *) error {
    statusMessageLab.text=@"Mail\nController";
    if (error) {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"error" message:[NSString stringWithFormat:@"error %@",[error description]] delegate:nil cancelButtonTitle:@"dismiss" otherButtonTitles:nil,nil];
        [alertview show];
        //[alert release];
        [self dismissViewControllerAnimated:YES completion:^{/*error*/}];
        statusMessageLab.text=@"An mail\nError\nOccurred.";
    }
    else{
        [self dismissViewControllerAnimated:YES completion:^{/*ok*/}];
        statusMessageLab.text=@"E-Mail Sent\nOK.";
    }
statusMessageLab.text=@"Select\nNext\nTask";
}

- (void)saveText
{
//save text results to file for attachment
    statusMessageLab.text=@"Saving\nData\nFile.";
    mySingleton * singleton = [mySingleton sharedSingleton];
    NSFileManager   * filemgr;
    NSData          * databuffer;
    NSString        * dataFile;
    NSString        * docsDir;
    NSArray         * dirPaths;

    filemgr = [NSFileManager defaultManager];

    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    docsDir = dirPaths[0];

    //NSString * fileNameS = [NSString stringWithFormat:@"%@.csv", subjectCodeTxt.text];
    NSString * fileNameS = @"TachistAppData.csv";
    dataFile = [docsDir stringByAppendingPathComponent:fileNameS];

    databuffer = [singleton.resultStrings dataUsingEncoding: NSASCIIStringEncoding];
    [filemgr createFileAtPath: dataFile
                     contents: databuffer attributes:nil];
}

#pragma mark Start

//START
-(void)startCardDisplay {
    statusMessageLab.text=@"START";
    //[self initVars]; // this messes up all the timings? why?
    // NSLog(@"card display start");
    [cardHolder setImage: card[29].image];
    wasButtonPressed=YES;
    [NSTimer scheduledTimerWithTimeInterval:(3) target:self selector:@selector(blankCardDisplay0) userInfo:nil repeats:NO];//used to be 0.5
}

//FINISH part 1/2
-(void)finishCardDisplay {
    XbutLab.hidden            = YES;
    ObutLab.hidden            = YES;
    noBut.hidden              = YES;
    yesBut.hidden             = YES;
    newSubjectBut.hidden      = YES;
    cancelBut.hidden          = YES;
    startBut.hidden           = YES;
    newTestBut.hidden         = YES;
    statusMessageLab.text=@"FINISHED";
    // NSLog(@"card display finish 1/2");
    [cardHolder setImage: card[0].image];
    wasButtonPressed=YES;
    [NSTimer scheduledTimerWithTimeInterval:(0.1) target:self selector:@selector(finishedMessage) userInfo:nil repeats:NO];//used to be 0.5
}

//FINISH part 2/2
-(void)finishCardDisplay1 {
    statusMessageLab.text=@"STATS Calc.";
    // NSLog(@"card display finish 2/2");
    [cardHolder setImage: card[30].image];
    wasButtonPressed=YES;
    [NSTimer scheduledTimerWithTimeInterval:(0.1) target:self selector:@selector(statsCalculatedMessage) userInfo:nil repeats:NO];
    someResultsExist = 1;
    //hide unhide labels, screens and buttons
    //***
    //Action buttons

    hideResultsBut.hidden     = NO;
    saveDataToEmailBut.hidden = NO;
    infoBut.hidden            = NO;

    
    //text views
    cardHolder.hidden         = YES;
    resultsView.hidden        = NO;
    resultsViewBorder.hidden  = NO;
    settingsBG.hidden         = YES;
    infoView.hidden           = YES;
    settingsBG.hidden         = YES;
    
    //settings messages and text inputs
    cardsLab.hidden           = YES;
    stimLab.hidden            = YES;
    respLab.hidden            = YES;
    ms1Lab.hidden             = YES;
    ms2Lab.hidden             = YES;
    noCards.hidden            = YES;
    stimOnTime.hidden         = YES;
    postResponseDelay.hidden  = YES;
    
    //headings and labels
    logoImage.hidden          = NO;
    title1Lab.hidden          = NO;
    title2Lab.hidden          = NO;
    XbutLab.hidden            = YES;
    ObutLab.hidden            = YES;
    
    subjectCodeLab.hidden     = YES;
    subjectCodeTxt.hidden     = YES;
    statusMessageLab.hidden   = NO;
    results.hidden            = YES;
    settingsLab.hidden        = YES;
    JumpingManLogo.hidden     = YES;
    clickMessageLab.hidden    = YES;
    
    if (someResultsExist == 1){
        results.hidden    = NO;
        saveDataToEmailBut.hidden = NO;
    } else {
        results.hidden    = YES;
        saveDataToEmailBut.hidden = YES;
    }
    
    //end of hide section
    
    resultsView.text = @"";// blank the results entry
}

-(void)onCardDisplay1 {
    statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
    
    //hide the buttons
    noBut.hidden     = NO;
    yesBut.hidden    = NO;
    XbutLab.hidden   = NO;
    ObutLab.hidden   = NO;
    startBut.hidden  = YES;
    cardCounter++;
    int t = [self pickACard];
            if (wasButtonPressed == NO) {
        }
wasButtonPressed = NO;
    [cardHolder setImage: card[t].image];
    //start the timer
	self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay1) userInfo:nil repeats:NO];
}

-(void)onCardDisplay2 {
    if (!cancelButtonPressed) {
        noBut.hidden     = NO;
        yesBut.hidden    = NO;
        XbutLab.hidden   = NO;
        ObutLab.hidden   = NO;
        statusMessageLab.text = [NSString stringWithFormat: @"Card #%i \nof [%i]",cardCounter+1, noOfCards];
        cardCounter++;
        int t = [self pickACard];
            if (wasButtonPressed == NO) {
            }
        wasButtonPressed = NO;
        [cardHolder setImage: card[t].image];
        //start the timer
        self.startDate = [NSDate date];
        [NSTimer scheduledTimerWithTimeInterval:(([self delayx])) target:self selector:@selector(blankCardDisplay2) userInfo:nil repeats:NO];
    } else {
        [NSTimer scheduledTimerWithTimeInterval:(0) target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    }
}

-(void)blankCardDisplay0 {
    //blank screen
    //detectorOn = 0;
     
    //// NSLog(@"card display blank");
            [cardHolder setImage: card[0].image];
    //[NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay1) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval: [self delayx1] target:self selector:@selector(onCardDisplay1) userInfo:nil repeats:NO];
}

-(void)blankCardDisplay1 {
    cancelBut.hidden = NO; //at least one shown, you can now cancel if wanted
    //blank screen
    if (noOfCards < 2 ) {
        lastCard =YES;
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    } else {
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(onCardDisplay2) userInfo:nil repeats:NO];
    }
}

-(void)blankCardDisplay2 {
    //blank screen
    if (noOfCards <= cardCounter) {
        lastCard=YES;
        [cardHolder setImage: card[0].image];
        [NSTimer scheduledTimerWithTimeInterval:[self delayx1] target:self selector:@selector(finishCardDisplay) userInfo:nil repeats:NO];
    } else {
        [cardHolder setImage: card[0].image];
       
        [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(onCardDisplay2) userInfo:nil repeats:NO];
    }
}
-(void)finishedMessage {
    noBut.hidden     = YES;
    yesBut.hidden    = YES;
    XbutLab.hidden   = YES;
    ObutLab.hidden   = YES;
    cancelBut.hidden = YES;
    
    [cardHolder setImage: card[30].image]; //blank card
    [NSTimer scheduledTimerWithTimeInterval:(([self delayx1])) target:self selector:@selector(finishCardDisplay1) userInfo:nil repeats:NO];
}

-(void)statsCalculatedMessage {
    [cardHolder setImage: card[30].image];//end message
    [NSTimer scheduledTimerWithTimeInterval:(2) target:self selector:@selector(calculateStats) userInfo:nil repeats:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerDefaultsFromSettingsBundle {
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle) {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    for(NSDictionary *prefSpecification in preferences) {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key) {
            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
        }
    }
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
}
@end
