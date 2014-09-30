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
}
@end

@implementation timingVC

@synthesize blockShowTimeLBL,blockShowTimeSLD,blockStartDelayLBL,
blockShowTimeTXT,blockStartDelayTXT,blockWaitTimeTXT, blockStartDelaySLD,blockWaitTimeLBL,blockWaitTimeSLD;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//sliders for timings
- (IBAction)blockStartDelaySLD:(UISlider *)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
blockStartDelayLBL.text=[NSString stringWithFormat:@"%d", (int)blockStartDelaySLD.value];
    
    blockStartDelayTXT.text=[NSString stringWithFormat:@"%0.0f", (float)blockStartDelaySLD.value];
    
    singleton.startTime = blockStartDelaySLD.value;
}
- (IBAction)blockWaitTimeSLD:(UISlider *)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
blockWaitTimeLBL.text=[NSString stringWithFormat:@"%d", (int)blockWaitTimeSLD.value];
blockWaitTimeTXT.text=[NSString stringWithFormat:@"%0.0f", (float)blockWaitTimeSLD.value];
    
        singleton.waitTime = blockWaitTimeSLD.value;
}
- (IBAction)blockShowTimeSLD:(UISlider *)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
blockShowTimeLBL.text=[NSString stringWithFormat:@"%d", (int)blockShowTimeSLD.value];
    blockShowTimeTXT.text=[NSString stringWithFormat:@"%0.0f", (float)blockShowTimeSLD.value];
    
        singleton.showTime = blockShowTimeSLD.value;
}

-(void)viewDidAppear:(BOOL)animated{
    mySingleton *singleton = [mySingleton sharedSingleton];

    startTime = singleton.startTime;
    waitTime = singleton.waitTime;
    showTime = singleton.showTime;

    blockStartDelayLBL.text=[[NSString alloc]initWithFormat:@"%i",startTime];
    blockShowTimeLBL.text=[[NSString alloc]initWithFormat:@"%i",showTime];
    blockWaitTimeLBL.text=[[NSString alloc]initWithFormat:@"%i",waitTime];

    blockStartDelaySLD.value=startTime;
    blockWaitTimeSLD.value=waitTime;
    blockShowTimeSLD.value=showTime;
    
    blockStartDelayTXT.text=[NSString stringWithFormat:@"%0.0f", (float)blockStartDelaySLD.value];
    blockWaitTimeTXT.text=[NSString stringWithFormat:@"%0.0f", (float)blockWaitTimeSLD.value];
    blockShowTimeTXT.text=[NSString stringWithFormat:@"%0.0f", (float)blockShowTimeSLD.value];
}


@end
