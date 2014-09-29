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

@end

@implementation timingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//sliders for timings
//- (IBAction)blockStartDelaySLD:(UISlider *)sender{
//blockStartDelayLBL.text=[NSString stringWithFormat:@"%d", (int)blockStartDelaySLD.value];
//}
//- (IBAction)blockWaitTimeSLD:(UISlider *)sender{
//blockWaitTimeLBL.text=[NSString stringWithFormat:@"%d", (int)blockWaitTimeSLD.value];
//}
//- (IBAction)blockShowTimeSLD:(UISlider *)sender{
//blockShowTimeLBL.text=[NSString stringWithFormat:@"%d", (int)blockShowTimeSLD.value];
//}

-(void)updateTiming{
    mySingleton *singleton = [mySingleton sharedSingleton];
    //blockStartDelayLBL.text=[[NSString alloc]initWithFormat:@"%i",startTime];
    //blockShowTimeLBL.text=[[NSString alloc]initWithFormat:@"%i",showTime];
    //blockWaitTimeLBL.text=[[NSString alloc]initWithFormat:@"%i",waitTime];
    //blockStartDelaySLD.value=startTime;
    //blockWaitTimeSLD.value=waitTime;
    //blockShowTimeSLD.value=showTime;
    //singleton.showTime=showTime;
    //singleton.waitTime=waitTime;
    //singleton.startTime=startTime;
}

-(void)viewDidAppear:(BOOL)animated{
    mySingleton *singleton = [mySingleton sharedSingleton];
}
-(void)viewWillDisappear:(BOOL)animated{
    mySingleton *singleton = [mySingleton sharedSingleton];
}

@end
