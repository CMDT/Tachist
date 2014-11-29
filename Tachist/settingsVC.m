//
//  settingsVCViewController.m
//  Tachist
//
//  Created by Jon Howell on 04/09/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

// NB. *** on new version, set detials in defaults function

#import "settingsVC.h"
#import "mySingleton.h"
#import "resultsVC.h"

#define kEmail      @"emailAddress"
#define kTester     @"testerName"
#define kSubject    @"subjectName"

#define kInfo       @"infoEnabled"
#define kSounds     @"soundsEnabled"
#define kBeep       @"beepName"

#define kDelay      @"blockDelay"
#define kTime       @"blockTime"
#define kShow       @"blockShow"

#define kVersion0    @"version0"
#define kVersion1    @"version1"
#define kVersion2    @"version2"
#define kVersion3    @"version3"

@interface settingsVC ()

@end

@implementation settingsVC
{
    int waitTime;
    int startTime;
    int showTime;

    BOOL info;
    BOOL sounds;
    
    NSString * beepName;
    NSString * subjectName;
    NSString * email;
    NSString * testerName;
    
    //for plist version group
    NSString * version0; //version number
    NSString * version1; //copyright info
    NSString * version2; //author info
    NSString * version3; //web site info
}

@synthesize
    blockShowLBL,
    blockStartLBL,
    blockWaitLBL,

    infoLBL,
    soundsLBL,
    settingsVC,
    testerLBL,
    emailLBL;
//subjectLBL;//re instate if work out way to fit on screen space

-(void)viewDidAppear:(BOOL)animated{
//assign images to tab bar items
    UIImage *settingsImage          = [UIImage imageNamed:@"settings"];
    UIImage *settingsImageSel       = [UIImage imageNamed:@"settings"];
    settingsImage       = [settingsImage    imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    settingsImageSel    = [settingsImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:settingsImage selectedImage: settingsImageSel];
    self.tabBarController.tabBar.hidden = NO;
    mySingleton *singleton = [mySingleton sharedSingleton];

    NSString * pathStr               = [[NSBundle mainBundle] bundlePath];
    NSString * settingsBundlePath    = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
    NSString * defaultPrefsFile      = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
    NSDictionary * defaultPrefs      = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    NSUserDefaults *defaults         = [NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];

    singleton.testerName             = [defaults  objectForKey:kTester];
    singleton.subjectName            = [defaults  objectForKey:kSubject];
    singleton.email                  = [defaults  objectForKey:kEmail];

    emailLBL.text   = singleton.email;
    testerLBL.text  = singleton.testerName;

    //on screen info during tests flag
    if(singleton.onScreenInfo==YES){
        infoLBL.text=@"Info.";
    } else {
        infoLBL.text=@"No Info";
    }
    
    //sounds flag
    if(singleton.sounds==YES){
        soundsLBL.text=@"Sounds";
        beepName=singleton.beepEffect;
        [self effectPicker:beepName];
    } else {
        soundsLBL.text=@"Quiet";
    }
    
    [self effectPicker:beepName];
    
    startTime = singleton.startTime;
    waitTime  = singleton.waitTime;
    showTime  = singleton.showTime;

    blockStartLBL.textAlignment = NSTextAlignmentCenter;
    blockShowLBL.textAlignment  = NSTextAlignmentCenter;
    blockWaitLBL.textAlignment  = NSTextAlignmentCenter;

    blockStartLBL.text = [[NSString alloc]initWithFormat:@"%i", startTime];
    blockShowLBL.text  = [[NSString alloc]initWithFormat:@"%i", showTime];
    blockWaitLBL.text  = [[NSString alloc]initWithFormat:@"%i", waitTime];

    testerLBL.text=singleton.testerName;
    emailLBL.text=singleton.email;
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
    mySingleton *singleton = [mySingleton sharedSingleton];
    //set up the plist params
        NSString *pathStr               = [[NSBundle mainBundle] bundlePath];
        NSString *settingsBundlePath    = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
        NSString *defaultPrefsFile      = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
        NSDictionary *defaultPrefs      = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
        NSUserDefaults *defaults        = [NSUserDefaults standardUserDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];

    //read the user defaults from the iPhone/iPad bundle
    // if any are set to nil (no value on first run), put a temporary one in
    
//*************************************************************
//version, set anyway *****************************************
//*************************************************************
        version0 =  @"v2.0.0.29.11.14";        // version   *** keep short
        version1 =  @"MMU (c) 2014";           // copyright *** limited line space
        version2 =  @"j.a.howell@mmu.ac.uk";   // author    *** to display on device
        version3 =  @"http://www.mmu.ac.uk";   // web site  *** settings screen
//*************************************************************
        [defaults setObject:version0 forKey:kVersion0];   //***
        [defaults setObject:version1 forKey:kVersion1];   //***
        [defaults setObject:version2 forKey:kVersion2];   //***
        [defaults setObject:version3 forKey:kVersion3];   //***
//*************************************************************
//version set end *********************************************
//*************************************************************

//subject name
    subjectName     = [defaults objectForKey:kSubject];
    if(subjectName  == nil ){
        subjectName =  @"Par";
        [defaults setObject:@"Par" forKey:kSubject];
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
        email =  @"me@test.com";
        [defaults setObject:@"me@test.com" forKey:kEmail];
    }
//beep Effect Name
    beepName     = [defaults objectForKey:kBeep];
    if(beepName  == nil ){
        beepName =  @"BEEPJAZZ";
        singleton.segIndex = 5;
        [defaults setObject:@"BEEPJAZZ" forKey:kBeep];
    }

//wait time
    NSString* temp = [defaults objectForKey:kDelay];
    if( temp == nil ){
        waitTime=  1500;
        [defaults setInteger:waitTime forKey:kDelay];
    }
//show time
    temp        = [defaults objectForKey:kShow];
    if( temp == nil ){
        showTime =  1500;
        [defaults setInteger:showTime forKey:kShow];
    }
//start time
    temp        = [defaults objectForKey:kTime];
    if( temp == nil ){
        startTime =  1500;
        [defaults setInteger:startTime forKey:kTime];
    }
//set sounds
    temp        = [defaults objectForKey:kSounds];
    if( temp == nil ){
        sounds =  YES;
        [defaults setBool:YES forKey:kSounds];
    }
//set status messages
    temp        = [defaults objectForKey:kInfo];
    if( temp == nil ){
        info =  YES;
        [defaults setBool:YES forKey:kInfo];
    }
}

-(NSString*)effectPicker:(NSString*)effectName{
    mySingleton *singleton = [mySingleton sharedSingleton];
    NSString *effectName1;
    //make an array of colour names
    NSArray *items = @[
         @"KLICK", @"BEEPPURE",
         @"BEEP_FM", @"BEEPDOUB",
         @"AMFMBEEP", @"BEEPJAZZ"
         ];
    //find the index value of each
    long item = [items indexOfObject: effectName];
    
    //select the item number
    switch (item) {
        case 0:
            // Item 1
            effectName1 = @"KLICK";
            singleton.segIndex = 0;
            break;
        case 1:
            // Item 2
            effectName1 = @"BEEPPURE";
            singleton.segIndex = 1;
            break;
        case 2:
            // Item 3
            effectName1 = @"BEEP_FM";
            singleton.segIndex = 2;
            break;
        case 3:
            // Item 4
            effectName1 = @"BEEPDOUB";
            singleton.segIndex = 3;
            break;
        case 4:
            // Item 5
            effectName1 = @"AMFMBEEP";
            singleton.segIndex = 4;
            break;
        case 5:
            // Item 6
            effectName1 = @"BEEPJAZZ";
            singleton.segIndex = 5;
            break;

        default:
            effectName1 = @"BEEPJAZZ";
            singleton.segIndex = 5;
            break;
    }
    return effectName1;
}

-(IBAction)saveSettings:(id)sender{

    mySingleton *singleton   = [mySingleton sharedSingleton];

    NSURL *defaultPrefsFile  = [[NSBundle mainBundle]
                               URLForResource:@"Root" withExtension:@"plist"];
    NSDictionary *defaults1  = [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults1];
    //
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    //read the user defaults from the iPhone/iPad bundle
    // if any are set to nil (no value on first run), put a temporary one in
    //NSLog(@"Saving settings to singleton...");

    //sounds
        [defaults setObject:[NSString stringWithFormat:@"%@", singleton.beepEffect] forKey:kBeep];
    
    //others

        [defaults setObject:[NSString stringWithFormat:@"%.0f", singleton.startTime] forKey:kDelay];
        [defaults setObject:[NSString stringWithFormat:@"%.0f", singleton.showTime] forKey:kShow];
        [defaults setObject:[NSString stringWithFormat:@"%.0f", singleton.waitTime] forKey:kTime];
        [defaults setObject:[NSString stringWithFormat:@"%@", singleton.beepEffect] forKey:kBeep];
        [defaults setBool:singleton.sounds forKey:kSounds];
        [defaults setBool:singleton.onScreenInfo forKey:kInfo];
        [defaults setObject:[NSString stringWithFormat:@"%@", singleton.subjectName] forKey:kSubject];
        [defaults setObject:[NSString stringWithFormat:@"%@", singleton.email] forKey:kEmail];
        [defaults setObject:[NSString stringWithFormat:@"%@", singleton.testerName] forKey:kTester];
        [defaults synchronize];//make sure all are updated
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"TACHISTOSCOPE TEST SETTINGS"
                                                     message:@"\nThe settings were \n\n'SAVED' \n\nfor the tests.\n\nYou can recall these with \n'Load' on this screen."
                                                    delegate:self
                                           cancelButtonTitle:nil //@"Cancel"
                                           otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
}

-(IBAction)loadSettings:(id)sender{
//load from the plist, or put in a default if missing
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    NSURL *defaultPrefsFile     = [[NSBundle mainBundle]
                                   URLForResource:@"Root" withExtension:@"plist"];
    
    NSDictionary *defaultPrefs  = [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    
    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];

    [defaults synchronize];
    
//read the user defaults from the iPhone/iPad bundle
    // if any are set to nil (no value on first run), put a temporary one in
 
    [self setDefaults];

//everything else
    singleton.testerName              = [defaults  objectForKey:kTester];
    singleton.subjectName             = [defaults  objectForKey:kSubject];
    singleton.email                   = [defaults  objectForKey:kEmail];
    singleton.onScreenInfo            = [defaults  boolForKey:kInfo];
    singleton.sounds                  = [defaults  boolForKey:kSounds];
    singleton.beepEffect              = [defaults  objectForKey:kBeep];
    [self effectPicker:singleton.beepEffect];
    singleton.startTime               = [[defaults objectForKey:kDelay] doubleValue];
    singleton.waitTime                = [[defaults objectForKey:kTime] doubleValue];
    singleton.showTime                = [[defaults objectForKey:kShow] doubleValue];
    
    //singleton.version             = [defaults objectForKey:kVersion];

    [defaults synchronize];
    [self refreshView];

    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"TACHISTOSCOPE TEST SETTINGS"
                                                     message:@"\nThe settings were \n\n'LOADED' \n\nfor the tests."
                                                    delegate:self
                                           cancelButtonTitle:nil //@"Cancel"
                                           otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
}

-(void)refreshView {
    //make the colours change as now changed
    [self viewDidLoad];
    [self viewDidAppear:YES]; // If viewWillAppear also contains code
}

@end
