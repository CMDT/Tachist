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
    int blockSize;
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
@synthesize  blockSizeLBL,blockFinishNumLBL,blockStartNumLBL,blockShowLBL,
blockStartLBL,blockWaitLBL,forwardLBL,rotateLBL,infoLBL;
//@synthesize bl1,bl2,bl3,bl4,bl5,bl6,bl7,bl8,bl9,CBTView,infoFinishLBL,infoRoundLBL,infoSelectLBL,infoStartLBL,myMessageLBL;

//@synthesize currentBackgroundColour,currentBlockColour,currentShowColour;

-(void)viewWillAppear:(BOOL)animated{
    //set up the screen from the singleton
    //only save if SAVE button pressed

}
-(void)viewDidAppear:(BOOL)animated{
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
        rotateLBL.text=@"Rotate";
    } else {
        rotateLBL.text=@"Square";
    }
    
    //start, finish and sizes on screen from singleton
    blockStartNumLBL.text=[NSString stringWithFormat:@"%d",singleton.start];
    blockFinishNumLBL.text=[NSString stringWithFormat:@"%d",singleton.finish];
    blockSizeLBL.text=[NSString stringWithFormat:@"%d",singleton.blockSize];

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
    // Not much here as this routine is only run once when the app has been unloaded from memory and loads fresh.
    // the App relies on buttons starting actions.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)setDefaults:(id)sender {
    //also used in Load Settings from k data store
    //edit this to take data from k data store in Apple Settings pane

    mySingleton *singleton = [mySingleton sharedSingleton];

    NSURL *defaultPrefsFile     = [[NSBundle mainBundle]
                                   URLForResource:@"Root" withExtension:@"plist"];

    NSDictionary *defaultPrefs  = [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];

    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //read the user defaults in the iPhone/iPad bundle

    currentBlockColour          = [defaults objectForKey:kBlockCol];
    if(currentBlockColour  == nil ){
        currentBlockColour =  [UIColor blueColor];
    }
    
    currentBackgroundColour          = [defaults objectForKey:kBackCol];
    if(currentBackgroundColour  == nil ){
        currentBackgroundColour =  [UIColor blackColor];
    }
    
    currentShowColour          = [defaults objectForKey:kShowCol];
    if(currentShowColour  == nil ){
        currentShowColour =  [UIColor blueColor];
    }
    
    NSString *temp        = [defaults objectForKey:kStart];
    if( temp == nil ){
        start =  3;
        [defaults setObject:@"3" forKey:kStart];
    }else{
        start=[temp intValue];
        [defaults setObject:temp forKey:kStart];
    }
    temp        = [defaults objectForKey:kFinish];
    if( temp == nil ){
        finish =  9;
        [defaults setObject:@"9" forKey:kFinish];
    }else{
        finish=[temp intValue];
        [defaults setObject:temp forKey:kFinish];
    }
    temp        = [defaults objectForKey:kSize];
    if( temp == nil ){
        blockSize =  30;
        [defaults setObject:@"30" forKey:kSize];
    }else{
        blockSize=[temp intValue];
        [defaults setObject:temp forKey:kSize];
    }
    temp        = [defaults objectForKey:kDelay];
    if( temp == nil ){
        waitTime=  500;
        [defaults setObject:@"500" forKey:kDelay];
    }else{
        waitTime=[temp intValue];
        [defaults setObject:temp forKey:kDelay];
    }
    temp        = [defaults objectForKey:kShow];
    if( temp == nil ){
        showTime =  200;
        [defaults setObject:@"200" forKey:kShow];
    }else{
        showTime=[temp intValue];
        [defaults setObject:temp forKey:kShow];
    }
    temp        = [defaults objectForKey:kTime];
    if( temp == nil ){
        startTime =  1000;
        [defaults setObject:@"1000" forKey:kTime];
    }else{
        startTime=[temp intValue];
        [defaults setObject:temp forKey:kTime];
    }

    singleton.currentBackgroundColour=[UIColor blackColor];
    singleton.currentBlockColour=[UIColor blueColor];
    singleton.currentShowColour=[UIColor orangeColor];

    //for testing what is written, can be rem'd out later
    NSLog(@"tester      :%@",[defaults objectForKey:kTester]);
    NSLog(@"subject     :%@",[defaults objectForKey:kSubject]);
    NSLog(@"email       :%@",[defaults objectForKey:kEmail]);
    NSLog(@"start       :%@",[defaults objectForKey:kStart]);
    NSLog(@"finish      :%@",[defaults objectForKey:kFinish]);
    NSLog(@"size        :%@",[defaults objectForKey:kSize]);
    NSLog(@"forward     :%@",[defaults objectForKey:kForward]);
    NSLog(@"info        :%@",[defaults objectForKey:kInfo]);
    NSLog(@"rotation    :%@",[defaults objectForKey:kRot]);
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

-(void)saveSettings{
    //Saving
    //NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    // saving an NSString
    //[prefs setObject:@"TextToSave" forKey:@"keyToLookupString"];

    // saving an NSInteger
    //[prefs setInteger:42 forKey:@"integerKey"];

    // saving a Double
    //[prefs setDouble:3.1415 forKey:@"doubleKey"];

    // saving a Float
    //[prefs setFloat:1.2345678 forKey:@"floatKey"];

    // This is suggested to synch prefs, but is not needed (I didn't put it in my tut)
    //[prefs synchronize];

    //mySingleton *singleton = [mySingleton sharedSingleton];

    NSURL *defaultPrefsFile     = [[NSBundle mainBundle]
                                   URLForResource:@"Root" withExtension:@"plist"];

    NSDictionary *defaultPrefs  = [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];

    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
   // [[NSUserDefaults standardUserDefaults] synchronize];
    //one for each setting
    //[defaults setObject:@"TextToSave" forKey:@"keyToLookupString"];
}

-(void)loadSettings{
    //Retrieving
    //NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    // getting an NSString
    //NSString *myString = [prefs stringForKey:@"keyToLookupString"];

    // getting an NSInteger
    //NSInteger myInt = [prefs integerForKey:@"integerKey"];

    // getting an Float
    //float myFloat = [prefs floatForKey:@"floatKey"];

    //mySingleton *singleton = [mySingleton sharedSingleton];

    NSURL *defaultPrefsFile     = [[NSBundle mainBundle]
                                   URLForResource:@"Root" withExtension:@"plist"];

    NSDictionary *defaultPrefs  = [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];

    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
    // [[NSUserDefaults standardUserDefaults] synchronize];
    //one for each setting
    //[defaults setObject:@"TextToSave" forKey:@"keyToLookupString"];
}
@end
