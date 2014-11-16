//
//  detailsVC.m
//  Corsi
//
//  Created by Jonathan Howell on 14/11/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import "detailsVC.h"
#import "mySingleton.h"

#define kEmail      @"emailAddress"
#define kTester     @"testerName"
#define kSubject    @"subjectName"

@interface detailsVC ()

@end

@implementation detailsVC

@synthesize
    emailTXT,
    testerNameTXT,
    participantTXT;

- (void)viewDidLoad {
    [super viewDidLoad];

    //delegates for text filed entries
    emailTXT.delegate           = self;
    testerNameTXT.delegate      = self;
    participantTXT.delegate     = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    //set up the plist params
    mySingleton *singleton = [mySingleton sharedSingleton];
    NSString *pathStr               = [[NSBundle mainBundle] bundlePath];
    NSString *settingsBundlePath    = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
    NSString *defaultPrefsFile      = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
    NSDictionary *defaultPrefs      = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    NSUserDefaults *defaults        = [NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //save the updated names to plist
    [defaults setObject:singleton.subjectName forKey:kSubject];
    [defaults setObject:singleton.testerName forKey:kTester];
    [defaults setObject:singleton.email forKey:kEmail];


}

-(void)viewDidAppear:(BOOL)animated{
        //set up the plist params
    NSString *pathStr               = [[NSBundle mainBundle] bundlePath];
    NSString *settingsBundlePath    = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
    NSString *defaultPrefsFile      = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
    NSDictionary *defaultPrefs      = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    NSUserDefaults *defaults        = [NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //subject name
    participantTXT.text     = [defaults objectForKey:kSubject];
    if([participantTXT.text  isEqualToString: @ "" ]){
        participantTXT.text =  @"Participant";
        [defaults setObject:@"Participant" forKey:kSubject];
    }
    //tester name
    testerNameTXT.text     = [defaults objectForKey:kTester];
    if([testerNameTXT.text isEqualToString: @ "" ]){
        testerNameTXT.text =  @"Me";
        [defaults setObject:@"Me" forKey:kTester];
    }
    //email name
    emailTXT.text     = [defaults objectForKey:kEmail];
    if([emailTXT.text isEqualToString: @ "" ]){
        emailTXT.text =  @"me@mymailaddress.com";
        [defaults setObject:@"me@mymailaddress.com" forKey:kEmail];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //used to clear keyboard if screen touched
    // NSLog(@"Touches began with this event");
    [self.view endEditing:YES];

    [super touchesBegan:touches withEvent:event];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //***** change all to suit inputs *****
    //the number refers to the scrolling of the text input field to avoid the keyboard when it appears, then it is moved back afterwards to the 0 origin

    //page1
    // change the color of the text box when you touch it
    //turned off the screen move, as not needed on this page

    if(textField==self->emailTXT){
        emailTXT.backgroundColor = [UIColor greenColor];
        //textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y), textField.frame.size.width, textField.frame.size.height);
        //int oft=textField.frame.origin.y-190;
        //[self keyBoardAppeared:oft];
    }
    if(textField==self->participantTXT){
        participantTXT.backgroundColor = [UIColor greenColor];
        //textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y), textField.frame.size.width, textField.frame.size.height);
        //int oft=textField.frame.origin.y-190;
        //[self keyBoardAppeared:oft];
    }
    if(textField==self->testerNameTXT){
        testerNameTXT.backgroundColor = [UIColor greenColor];
        //textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y), textField.frame.size.width, textField.frame.size.height);
        //int oft=textField.frame.origin.y-190;
        //[self keyBoardAppeared:oft];
    }
}

-(void)textFieldDidEndEditing:(UITextField *) textField {
    mySingleton *singleton = [mySingleton sharedSingleton];
    //move the screen back to the original place
    [self keyBoardDisappeared:0];
    participantTXT.backgroundColor  = [UIColor whiteColor];
    testerNameTXT.backgroundColor   = [UIColor whiteColor];
    emailTXT.backgroundColor        = [UIColor whiteColor];


    singleton.subjectName   = participantTXT.text;
    singleton.testerName    = testerNameTXT.text;
    singleton.email         = emailTXT.text;
}

-(void) keyBoardAppeared :(int)oft
//not needed here
{
    //move screen up or down as needed to avoid text field entry
    CGRect frame = self.view.frame;
    //oft= the y of the text field?  make some code to find it
    [UIView animateWithDuration:1.0
                          delay:0.5
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.view.frame = CGRectMake(frame.origin.x, -oft, frame.size.width, frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }
     ];
}

-(void) keyBoardDisappeared :(int)oft
//not needed here
{
    //move the screen back to original position
    CGRect frame = self.view.frame;
    //oft= the y of the text field?  make some code to find it
    [UIView animateWithDuration:1.0
                          delay:0.5
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.view.frame = CGRectMake(frame.origin.x, oft, frame.size.width, frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }
     ];
}

@end
