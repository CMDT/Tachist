//
//  settingsVCViewController.m
//  Corsi
//
//  Created by Jon Howell on 04/09/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import "settingsVC.h"
#import "mySingleton.h"

#define kEmail      @"emailAddress"
#define kTester     @"testerName"
#define kSubject    @"subjectName"

#define kStart      @"startBlocks"
#define kFinish     @"finishBlocks"
#define kSize       @"blockSize"

#define kForward    @"forwardTestEnabled"
#define kInfo       @"infoEnabled"
#define kRot        @"rotationEnabled"
#define kAnimals    @"animalsEnabled"
#define kSounds     @"soundsEnabled"
#define kBeep       @"beepName"

#define kBlockCol   @"blockColour"
#define kShowCol    @"highlightColour"
#define kBackCol    @"backgroundColour"

#define kDelay      @"blockDelay"
#define kTime       @"blockTime"
#define kShow       @"blockShow"

#define kVersion    @"version"

@interface settingsVC ()

@end

@implementation settingsVC
{
    int start;
    int finish;
    float blockSize;
    int waitTime;
    int startTime;
    int showTime;
    int rot1;
    int rot2;
    int rot3;
    int rot4;
    int rot5;
    int rot6;
    int rot7;
    int rot8;
    int rot9;
    
    BOOL forward;
    BOOL info;
    BOOL rotation;
    BOOL animals;
    BOOL sounds;
    
    NSString *blockCol;
    NSString *showCol;
    NSString *backCol;
    NSString *beepName;
    NSString *subjectName;
    NSString *email;
    NSString *testerName;

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

//maybe some missing, check

@synthesize showLBL,blockLBL,canvasLBL;

@synthesize block1View,block2View,block3View,block4View,block5View;
@synthesize block6View,block7View,block8View,block9View,settingsViewerVIEW;
@synthesize blockSizeLBL,blockFinishNumLBL,blockStartNumLBL,blockShowLBL,
blockStartLBL,blockWaitLBL,forwardLBL,rotateLBL,infoLBL,animalsLBL,soundsLBL,settingsVC;

-(void)viewWillAppear:(BOOL)animated{
    //when the view loads, before display does the code here
    //[self loadSettings:self];
}

-(void)viewWillDisappear:(BOOL)animated{
    //when the view exits, save the plist settings for cold start data retreval
    //[self saveSettings:self];
}
-(void)viewDidAppear:(BOOL)animated{
    //assign images to tab bar items
    UIImage *settingsImage          = [UIImage imageNamed:@"Settings"];
    UIImage *settingsImageSel       = [UIImage imageNamed:@"SettingsSel"];
    settingsImage       = [settingsImage    imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    settingsImageSel    = [settingsImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:settingsImage selectedImage: settingsImageSel];
    
    mySingleton *singleton = [mySingleton sharedSingleton];

    [showLBL setBackgroundColor:singleton.currentShowColour];
    [block5View setBackgroundColor:singleton.currentShowColour];
    [blockLBL setBackgroundColor:singleton.currentBlockColour];

    [block1View setBackgroundColor:singleton.currentBlockColour];
    [block2View setBackgroundColor:singleton.currentBlockColour];
    [block3View setBackgroundColor:singleton.currentBlockColour];
    [block4View setBackgroundColor:singleton.currentBlockColour];
    [block6View setBackgroundColor:singleton.currentBlockColour];
    [block7View setBackgroundColor:singleton.currentBlockColour];
    [block8View setBackgroundColor:singleton.currentBlockColour];
    [block9View setBackgroundColor:singleton.currentBlockColour];
    
    [canvasLBL setBackgroundColor: singleton.currentBackgroundColour];
    [settingsViewerVIEW setBackgroundColor:singleton.currentBackgroundColour];
    
    //forward or revers test flag
    if(singleton.forwardTestDirection==YES){
        forwardLBL.text=@"Forward";
    } else {
        forwardLBL.text=@"Reverse";
    }
    //on screen info during tests flag
    if(singleton.onScreenInfo==YES){
        infoLBL.text=@"Info.";
    } else {
        infoLBL.text=@"No Info";
    }
    //rotation flag
    if(singleton.blockRotation==YES){
        rotateLBL.text=@"Rotated";
    } else {
        rotateLBL.text=@"Level";
    }
    //animals flag
    if(singleton.animals==YES){
        animalsLBL.text=@"Animals";
    } else {
        animalsLBL.text=@"Blocks";
    }
    //sounds flag
    if(singleton.sounds==YES){
        soundsLBL.text=@"Sounds";
        beepName=singleton.beepEffect;
    } else {
        soundsLBL.text=@"Quiet";
    }
    

    //start, finish and sizes on screen from singleton
    blockStartNumLBL.text=[NSString stringWithFormat:@"%d",singleton.start];
    blockFinishNumLBL.text=[NSString stringWithFormat:@"%d",singleton.finish];
    blockSizeLBL.text=[NSString stringWithFormat:@"%2.0f",singleton.blockSize];

    startTime = singleton.startTime;
    waitTime = singleton.waitTime;
    showTime = singleton.showTime;

    blockStartLBL.text=[[NSString alloc]initWithFormat:@"%i",startTime];
    blockShowLBL.text=[[NSString alloc]initWithFormat:@"%i",showTime];
    blockWaitLBL.text=[[NSString alloc]initWithFormat:@"%i",waitTime];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self setDefaults];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDefaults{
    //also used in Load Settings from k data store
    //edit this to take data from k data store in Apple Settings pane

    //+++
    //for reading default value for Terminal
    //NSString *testValue = [[NSUserDefaults standardUserDefaults] stringForKey:kFirstNameKey];
    //if (testValue == nil)
    //{
        // no default values have been set, create them here based on what's in our Settings bundle info
        NSString *pathStr = [[NSBundle mainBundle] bundlePath];
        NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
        //NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
        NSString *defaultPrefsFile = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
        //NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
        NSDictionary *defaultPrefs = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
       // NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
//}
    //+++
        
    //NSURL *defaultPrefsFile     = [[NSBundle mainBundle]
                                   //URLForResource:@"Root" withExtension:@"plist"];

    //NSDictionary *defaultPrefs  = [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];

    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
    
    [[NSUserDefaults standardUserDefaults] synchronize];

    //read the user defaults from the iPhone/iPad bundle
    // if any are set to nil (no value on first run), put a temporary one in
    
//block colour
    currentBlockColour     = [defaults objectForKey:kBlockCol];
    if(currentBlockColour  == nil ){
        currentBlockColour =  [UIColor blueColor];
        blockCol =@"Blue";
        [defaults setObject:@"Blue" forKey:kBlockCol];
    }
//bacground colour
    currentBackgroundColour     = [defaults objectForKey:kBackCol];
    if(currentBackgroundColour  == nil ){
        currentBackgroundColour =  [UIColor blackColor];
        backCol =@"Black";
        [defaults setObject:@"Black" forKey:kBackCol];
    }
//show colour
    currentShowColour     = [defaults objectForKey:kShowCol];
    if(currentShowColour  == nil ){
        currentShowColour =  [UIColor orangeColor];
        showCol =@"Orange";
        [defaults setObject:@"Orange" forKey:kShowCol];
    }
    //subject name
    subjectName     = [defaults objectForKey:kSubject];
    if(subjectName  == nil ){
        subjectName =  @"Participant";
        [defaults setObject:@"Participant" forKey:kSubject];
    }
    //tester name
    testerName     = [defaults objectForKey:kTester];
    if(testerName  == nil ){
        testerName =  @"Me";
        [defaults setObject:@"Me" forKey:kTester];
    }
    //email name
    email     = [defaults objectForKey:kEmail];
    if(email  == nil ){
        email =  @"me@gmail.com";
        [defaults setObject:@"me@gmail.com" forKey:kEmail];
    }
    //beep Effect Name
    beepName     = [defaults objectForKey:kBeep];
    if(beepName  == nil ){
        beepName =  @"KLICK";
        [defaults setObject:@"KLICK" forKey:kBeep];
    }
    //start block
    NSString *temp = [defaults objectForKey:kStart];
    if( temp == nil ){
        start =  3;
        [defaults setObject:@"3" forKey:kStart];
    }
    //finish block
    temp        = [defaults objectForKey:kFinish];
    if( temp == nil ){
        finish =  9;
        [defaults setObject:@"9" forKey:kFinish];
    }
    temp        = [defaults objectForKey:kSize];
    if( temp == nil ){
        blockSize =  30.00;
        [defaults setObject:@"30.00" forKey:kSize];
    }
    temp        = [defaults objectForKey:kDelay];
    if( temp == nil ){
        waitTime=  500;
        [defaults setObject:@"500" forKey:kDelay];
    }
    temp        = [defaults objectForKey:kShow];
    if( temp == nil ){
        showTime =  200;
        [defaults setObject:@"200" forKey:kShow];
    }
    temp        = [defaults objectForKey:kTime];
    if( temp == nil ){
        startTime =  1000;
        [defaults setObject:@"1000" forKey:kTime];
    }
    //set rotate
    temp        = [defaults objectForKey:kRot];
    if( temp == nil ){
        rotation =  NO;
        [defaults setBool:NO forKey:kRot];
    }
    //set animals
    temp        = [defaults objectForKey:kAnimals];
    if( temp == nil ){
        animals =  NO;
        [defaults setBool:NO forKey:kAnimals];
    }
    //set sounds
    temp        = [defaults objectForKey:kSounds];
    if( temp == nil ){
        sounds =  NO;
        [defaults setBool:NO forKey:kSounds];
    }
    //set status messages
    temp        = [defaults objectForKey:kInfo];
    if( temp == nil ){
        info =  YES;
        [defaults setBool:YES forKey:kInfo];
    }
    //set forward/reverse
    temp        = [defaults objectForKey:kForward];
    if( temp == nil ){
        forward =  YES;
        [defaults setBool:YES forKey:kForward];
    }

    //for testing what is written, can be rem'd out later
    NSLog(@"What is in the plist on first load:-->");
    NSLog(@"tester      :%@",[defaults objectForKey:kTester]);
    NSLog(@"subject     :%@",[defaults objectForKey:kSubject]);
    NSLog(@"email       :%@",[defaults objectForKey:kEmail]);
    NSLog(@"start       :%@",[defaults objectForKey:kStart]);
    NSLog(@"finish      :%@",[defaults objectForKey:kFinish]);
    NSLog(@"size        :%@",[defaults objectForKey:kSize]);
    NSLog(@"forward     :%@",[defaults objectForKey:kForward]);
    NSLog(@"info        :%@",[defaults objectForKey:kInfo]);
    NSLog(@"rotation    :%@",[defaults objectForKey:kRot]);
    NSLog(@"animals     :%@",[defaults objectForKey:kAnimals]);
    NSLog(@"sounds      :%@",[defaults objectForKey:kSounds]);
    NSLog(@"beep        :%@",[defaults objectForKey:kBeep]);
    NSLog(@"block col   :%@",[defaults objectForKey:kBlockCol]);
    NSLog(@"show col    :%@",[defaults objectForKey:kShowCol]);
    NSLog(@"back col    :%@",[defaults objectForKey:kBackCol]);
    NSLog(@"delay       :%@",[defaults objectForKey:kDelay]);
    NSLog(@"time        :%@",[defaults objectForKey:kTime]);
    NSLog(@"show        :%@",[defaults objectForKey:kShow]);
    NSLog(@"version     :%@",[defaults objectForKey:kVersion]);
}

-(UIColor*)colourPicker:(NSString*)colourName{
    UIColor *colourUIName;
    //make an array of colour names
    NSArray *items = @[
                       @"Black", @"Blue", @"Green", @"Red", @"Cyan",
                       @"White", @"Yellow", @"Magenta", @"Grey",
                       @"Orange", @"Brown", @"Purple",
                       @"Dark Grey", @"Light Grey"
                       ];
    //find the index value of each
    long item = [items indexOfObject: colourName];
    
    //select the item number
    switch (item) {
        case 0:
            // Item 1
            colourUIName = [UIColor blackColor];
            break;
        case 1:
            // Item 2
            colourUIName = [UIColor blueColor];
            break;
        case 2:
            // Item 3
            colourUIName = [UIColor greenColor];
            break;
        case 3:
            // Item 4
            colourUIName = [UIColor redColor];
            break;
        case 4:
            // Item 5
            colourUIName = [UIColor cyanColor];
            break;
        case 5:
            // Item 6
            colourUIName = [UIColor whiteColor];
            break;
        case 6:
            // Item 7
            colourUIName = [UIColor yellowColor];
            break;
        case 7:
            // Item 8
            colourUIName = [UIColor magentaColor];
            break;
        case 8:
            // Item 9
            colourUIName = [UIColor grayColor];
            break;
        case 9:
            // Item 10
            colourUIName = [UIColor orangeColor];
            break;
        case 10:
            // Item 11
            colourUIName = [UIColor brownColor];
            break;
        case 11:
            // Item 12
            colourUIName = [UIColor purpleColor];
            break;
        case 12:
            // Item 13
            colourUIName = [UIColor darkGrayColor];
            break;
        case 13:
            // Item 14
            colourUIName = [UIColor lightGrayColor];
            break;
        default:
            colourUIName = [UIColor orangeColor];
            break;
    }
    return colourUIName;
}

-(NSString*)colourUIToString:(UIColor*)myUIColour{
    NSString * myColour;
    
    //make an array of colour names
    NSArray *items = @[
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
            myColour = @"Grey";
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
            myColour = @"Dark Grey";
            break;
        case 13:
            // Item 14
            myColour = @"Light Grey";
            break;
        default:
            myColour = @"Orange";
            break;
    }
    return myColour;
}

-(IBAction)saveSettings:(id)sender{

    mySingleton *singleton = [mySingleton sharedSingleton];

    NSURL *defaultPrefsFile = [[NSBundle mainBundle]
                               URLForResource:@"Root" withExtension:@"plist"];
    NSDictionary *defaults1 =
    [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults1];
    //
    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];

    //read the user defaults from the iPhone/iPad bundle
    // if any are set to nil (no value on first run), put a temporary one in
    NSLog(@"Saving settings to singleton...");
    //block colour

        [defaults setObject:[self colourUIToString:singleton.currentBlockColour] forKey:kBlockCol];

    //background colour

        [defaults setObject:[self colourUIToString:singleton.currentBackgroundColour] forKey:kBackCol];

    //show colour

        [defaults setObject:[self colourUIToString:singleton.currentShowColour] forKey:kShowCol];
    //sounds
        //[defaults setObject:[NSString stringWithFormat:@"%@", singleton.beepEffect] forKey:kBeep]; //only saved from plist at present
    //others
        [defaults setObject:[NSString stringWithFormat:@"%d", singleton.start] forKey:kStart];
        [defaults setObject:[NSString stringWithFormat:@"%d", singleton.finish] forKey:kFinish];
        [defaults setObject:[NSString stringWithFormat:@"%2.0f", singleton.blockSize] forKey:kSize];
        [defaults setObject:[NSString stringWithFormat:@"%2.0f", singleton.startTime] forKey:kDelay];
        [defaults setObject:[NSString stringWithFormat:@"%2.0f", singleton.showTime] forKey:kShow];
        [defaults setObject:[NSString stringWithFormat:@"%2.0f", singleton.waitTime] forKey:kTime];
        [defaults setBool:singleton.blockRotation forKey:kRot];
        [defaults setBool:singleton.animals forKey:kAnimals];
        [defaults setBool:singleton.sounds forKey:kSounds];
        [defaults setBool:singleton.onScreenInfo forKey:kInfo];
        [defaults setBool:singleton.forwardTestDirection forKey:kForward];
        [defaults synchronize];//make sure all are updated
}

-(IBAction)loadSettings:(id)sender{

    mySingleton *singleton = [mySingleton sharedSingleton];
    
    NSURL *defaultPrefsFile     = [[NSBundle mainBundle]
                                   URLForResource:@"Root" withExtension:@"plist"];
    
    NSDictionary *defaultPrefs  = [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    
    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];

    [defaults synchronize];
    
    //read the user defaults from the iPhone/iPad bundle
    // if any are set to nil (no value on first run), put a temporary one in
    
    blockCol          = [defaults objectForKey:kBlockCol];
    if(currentBlockColour  == nil ){
        currentBlockColour =  [UIColor blueColor];
        blockCol =@"Blue";
        [defaults setObject:@"Blue" forKey:kBlockCol];
    }else{
        currentBlockColour = [self colourPicker:blockCol];
    }
    //background colour
    backCol         = [defaults objectForKey:kBackCol];
    if(currentBackgroundColour  == nil ){
        currentBackgroundColour =  [UIColor blackColor];
        backCol =@"Black";
        [defaults setObject:@"Black" forKey:kBackCol];
    }else{
        currentBackgroundColour = [self colourPicker:backCol];
    }
    //show colour
    showCol          = [defaults objectForKey:kShowCol];
    if(currentShowColour  == nil ){
        currentShowColour =  [UIColor orangeColor];
        showCol =@"Orange";
        [defaults setObject:@"Orange" forKey:kShowCol];
    }else{
        currentShowColour = [self colourPicker:showCol];
    }
    
    NSString *temp        = [defaults objectForKey:kStart];
    if( temp == nil ){
        start =  3;
        [defaults setObject:@"3" forKey:kStart];
    }
    temp        = [defaults objectForKey:kFinish];
    if( temp == nil ){
        finish =  9;
        [defaults setObject:@"9" forKey:kFinish];
    }
    temp        = [defaults objectForKey:kSize];
    if( temp == nil ){
        blockSize =  30.00;
        [defaults setObject:@"30.00" forKey:kSize];
    }
    temp        = [defaults objectForKey:kDelay];
    if( temp == nil ){
        waitTime=  500;
        [defaults setObject:@"500" forKey:kDelay];
    }
    temp        = [defaults objectForKey:kShow];
    if( temp == nil ){
        showTime =  200;
        [defaults setObject:@"200" forKey:kShow];
    }
    temp        = [defaults objectForKey:kTime];
    if( temp == nil ){
        startTime =  1000;
        [defaults setObject:@"1000" forKey:kTime];
    }
    //subject name
    temp     = [defaults objectForKey:kSubject];
    if(temp  == nil ){
        subjectName =  @"Participant";
        [defaults setObject:@"Participant" forKey:kSubject];
    }
    //tester name
    temp     = [defaults objectForKey:kTester];
    if(temp  == nil ){
        testerName =  @"Me";
        [defaults setObject:@"Me" forKey:kTester];
    }
    //email name
    temp     = [defaults objectForKey:kEmail];
    if(temp  == nil ){
        email =  @"me@gmail.com";
        [defaults setObject:@"me@gmail.com" forKey:kEmail];
    }
    //set rotate
    temp        = [defaults objectForKey:kRot];
    if( temp == nil ){
        rotation =  NO;
        [defaults setBool:NO forKey:kRot];
    }
    //set animals
    temp        = [defaults objectForKey:kAnimals];
    if( temp == nil ){
        animals =  NO;
        [defaults setBool:NO forKey:kAnimals];
    }
    //set sounds
    temp        = [defaults objectForKey:kSounds];
    if( temp == nil ){
        sounds =  NO;
        [defaults setBool:NO forKey:kSounds];
    }
    //beep Effect Name
    beepName     = [defaults objectForKey:kBeep];
    if(beepName  == nil ){
        beepName =  @"KLICK";
        [defaults setObject:@"KLICK" forKey:kBeep];
    }
    //set status messages
    temp        = [defaults objectForKey:kInfo];
    if( temp == nil ){
        info =  YES;
        [defaults setBool:YES forKey:kInfo];
    }
    //set forward/reverse
    temp        = [defaults objectForKey:kForward];
    if( temp == nil ){
        forward =  YES;
        [defaults setBool:YES forKey:kForward];
    }
    
    //for testing what is written, can be rem'd out later
    NSLog(@"Loading from PLIST... sending to singleton");
    singleton.testerName              = [defaults  objectForKey:kTester];
    singleton.subjectName             = [defaults  objectForKey:kSubject];
    singleton.email                   = [defaults  objectForKey:kEmail];
    singleton.start                   = [[defaults objectForKey:kStart] doubleValue];
    singleton.finish                  = [[defaults objectForKey:kFinish] doubleValue];
    singleton.blockSize               = [[defaults objectForKey:kSize] doubleValue];
    singleton.forwardTestDirection    = [defaults  boolForKey:kForward];
    singleton.onScreenInfo            = [defaults  boolForKey:kInfo];
    singleton.blockRotation           = [defaults  boolForKey:kRot];
    singleton.animals                 = [defaults  boolForKey:kAnimals];
    singleton.sounds                  = [defaults  boolForKey:kSounds];
    singleton.beepEffect              = [defaults  objectForKey:kBeep];
    singleton.currentBlockColour      = currentBlockColour;
    singleton.currentShowColour       = currentShowColour;
    singleton.currentBackgroundColour = currentBackgroundColour;
    singleton.startTime               = [[defaults objectForKey:kDelay] doubleValue];
    singleton.waitTime                = [[defaults objectForKey:kTime] doubleValue];
    singleton.showTime                = [[defaults objectForKey:kShow] doubleValue];
    
    //singleton.version             = [defaults objectForKey:kVersion];

    [defaults synchronize];
    [self refreshView];
}

-(void)refreshView {
    //make the colours change as now changed
    [self viewDidLoad];
    [self viewDidAppear:YES]; // If viewWillAppear also contains code
}
@end
