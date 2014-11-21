//
//  timingVC.m
//  Corsi
//
//  Created by Jonathan Howell on 28/09/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import "timingVC.h"
#import "mySingleton.h"

@interface timingVC ()
{
    int showTime;
    int waitTime;
    int startTime;
    
    BOOL entryIsValid;
    
    NSString * timingMessage;
}

@end

@implementation timingVC

@synthesize blockShowTimeSLD,
            blockShowTimeTXT,
            blockStartDelayTXT,
            blockWaitTimeTXT,
            blockStartDelaySLD,
            blockWaitTimeSLD,
            timeMessageTXT;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //delegates for text filed entries
    blockStartDelayTXT.delegate = self;
    blockShowTimeTXT.delegate   = self;
    blockWaitTimeTXT.delegate   = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//sliders for timings
- (IBAction)blockStartDelaySLD:(UISlider *)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];

    int temp = blockStartDelaySLD.value;

    if(temp>10000){
        temp=10000;
        blockStartDelaySLD.value = temp;

    }
    if(temp<0){
        temp=0;
        blockStartDelaySLD.value = temp;

    }
    blockStartDelayTXT.text=[NSString stringWithFormat:@"%0.0f", (float)temp];
    
    singleton.startTime = temp;
}
- (IBAction)blockWaitTimeSLD:(UISlider *)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];

    int temp = blockWaitTimeSLD.value;

    if(temp>10000){
        temp=10000;
        blockWaitTimeSLD.value = temp;

    }
    if(temp<0){
        temp=0;
        blockWaitTimeSLD.value = temp;

    }
blockWaitTimeTXT.text=[NSString stringWithFormat:@"%0.0f", (float)temp];
    
    singleton.waitTime = temp;
}
- (IBAction)blockShowTimeSLD:(UISlider *)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];

    int temp = blockShowTimeSLD.value;

    if(temp>10000){
        temp=10000;
        blockShowTimeSLD.value = temp;

    }
    if(temp<0){
        temp=0;
        blockShowTimeSLD.value = temp;

    }

    blockShowTimeTXT.text=[NSString stringWithFormat:@"%0.0f", (float)temp];
    
    singleton.showTime = temp;
}

-(void)viewDidAppear:(BOOL)animated{
    mySingleton *singleton = [mySingleton sharedSingleton];
    
        timingMessage = @"'Start' is the time delay before the first block shows.\n'Block' is the timing gap between show times, and\n'Show' is the time a block displays as a stimulus.";
    timeMessageTXT.backgroundColor = [UIColor whiteColor];

    timeMessageTXT.text = timingMessage;
    timeMessageTXT.textAlignment = NSTextAlignmentCenter;

    startTime = singleton.startTime;
    waitTime = singleton.waitTime;
    showTime = singleton.showTime;

    blockStartDelaySLD.value = startTime;
    blockWaitTimeSLD.value = waitTime;
    blockShowTimeSLD.value = showTime;
    
    blockStartDelayTXT.text=[NSString stringWithFormat:@"%0.0f", (float)blockStartDelaySLD.value];
    blockWaitTimeTXT.text=[NSString stringWithFormat:  @"%0.0f", (float)blockWaitTimeSLD.value];
    blockShowTimeTXT.text=[NSString stringWithFormat:  @"%0.0f", (float)blockShowTimeSLD.value];
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


    if(textField==self->blockStartDelayTXT){
        blockStartDelayTXT.backgroundColor = [UIColor greenColor];
        textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y), textField.frame.size.width, textField.frame.size.height);
        int oft=textField.frame.origin.y-195;
        [self keyBoardAppeared:oft];
    }
    if(textField==self->blockWaitTimeTXT){
        blockWaitTimeTXT.backgroundColor = [UIColor greenColor];
        textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y), textField.frame.size.width, textField.frame.size.height);
        int oft=textField.frame.origin.y-195;
        [self keyBoardAppeared:oft];
    }
    if(textField==self->blockShowTimeTXT){
        blockShowTimeTXT.backgroundColor = [UIColor greenColor];
        textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y), textField.frame.size.width, textField.frame.size.height);
        int oft=textField.frame.origin.y-195;
        [self keyBoardAppeared:oft];
    }
}

-(void)checkTimingValuesAreValid{
    //check each entry and return the default if not

    mySingleton *singleton = [mySingleton sharedSingleton];

    int startTemp = [blockStartDelayTXT.text intValue];
    int waitTemp = [blockWaitTimeTXT.text intValue];
    int showTemp = [blockShowTimeTXT.text intValue];
    
    bool flag=YES;
    entryIsValid = YES;
    
    if (startTemp<0) {
        startTemp=0;
        flag=NO;
        blockStartDelayTXT.backgroundColor  = [UIColor cyanColor];
    }
    if (startTemp>10000) {
        startTemp=10000;
        flag=NO;
        blockStartDelayTXT.backgroundColor  = [UIColor cyanColor];
    }
    if (waitTemp<0) {
        waitTemp=0;
        flag=NO;
        blockWaitTimeTXT.backgroundColor    = [UIColor cyanColor];

    }
    if (waitTemp>10000) {
        waitTemp=10000;
        flag=NO;
        blockWaitTimeTXT.backgroundColor    = [UIColor cyanColor];

    }
    if (showTemp<0) {
        showTemp=0;
        flag=NO;
        blockShowTimeTXT.backgroundColor    = [UIColor cyanColor];
    }
    if (showTemp>10000) {
        showTemp=10000;
        flag=NO;
        blockShowTimeTXT.backgroundColor    = [UIColor cyanColor];
    }
    blockStartDelaySLD.value = startTemp;
    blockWaitTimeSLD.value   = waitTemp;
    blockShowTimeSLD.value   = showTemp;
    
    blockStartDelayTXT.text  = [NSString stringWithFormat:@"%d", startTemp];
    blockWaitTimeTXT.text    = [NSString stringWithFormat:@"%d", waitTemp];
    blockShowTimeTXT.text    = [NSString stringWithFormat:@"%d", showTemp];

    singleton.startTime = [blockStartDelayTXT.text intValue];
    singleton.waitTime  = [blockWaitTimeTXT.text intValue];
    singleton.showTime  = [blockShowTimeTXT.text intValue];

    if (flag==YES) {
        entryIsValid = YES;
    }else{
        entryIsValid = NO;
    }
}

-(void)textFieldDidEndEditing:(UITextField *) textField {
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    //move the screen back to the original place
    
    [self keyBoardDisappeared:0];
   
        blockStartDelayTXT.backgroundColor  = [UIColor whiteColor];
        blockWaitTimeTXT.backgroundColor    = [UIColor whiteColor];
        blockShowTimeTXT.backgroundColor    = [UIColor whiteColor];
    
    [self checkTimingValuesAreValid];
    
    if (entryIsValid) {

        timingMessage = @"'Start' is the time delay before the first block shows.\n'Block' is the timing gap between show times, and\n'Show' is the time a block displays as a stimulus.";
        timeMessageTXT.backgroundColor = [UIColor whiteColor];
        timeMessageTXT.text = timingMessage;
        timeMessageTXT.textAlignment = NSTextAlignmentCenter;
    }else{
        blockStartDelaySLD.value = [blockStartDelayTXT.text intValue];
        blockWaitTimeSLD.value   = [blockWaitTimeTXT.text intValue];
        blockShowTimeSLD.value   = [blockShowTimeTXT.text intValue];

        singleton.startTime = [blockStartDelayTXT.text intValue];
        singleton.waitTime  = [blockWaitTimeTXT.text intValue];
        singleton.showTime  = [blockShowTimeTXT.text intValue];
    
    timingMessage = @"The value in cyan has exceeded\nthe limits of between 0 to 10000,\nand has been adjusted.";

    timeMessageTXT.backgroundColor = [UIColor colorWithRed:190.0/255 green:255.0/255 blue:255.0/255 alpha:0.75];
    
    timeMessageTXT.text = timingMessage;
        timeMessageTXT.textAlignment = NSTextAlignmentCenter;
    }
}

-(void) keyBoardAppeared :(int)oft
{
    //move screen up or down as needed to avoid text field entry
    CGRect frame = self.view.frame;
    //oft= the y of the text field?  make some code to find it
    [UIView animateWithDuration:0.5
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
{
    //move the screen back to original position
    CGRect frame = self.view.frame;
    //oft= the y of the text field?  make some code to find it
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.view.frame = CGRectMake(frame.origin.x, oft, frame.size.width, frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }
     ];
    blockStartDelaySLD.value = [blockStartDelayTXT.text intValue];
    blockWaitTimeSLD.value = [blockWaitTimeTXT.text intValue];
    blockShowTimeSLD.value = [blockShowTimeTXT.text intValue];
}

@end
