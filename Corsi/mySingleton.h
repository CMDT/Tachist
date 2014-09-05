//
//  mySingleton.h
//  Corsi
//
//  Created by Jon Howell on 04/09/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//


@interface mySingleton : NSObject {
    // add all the objects that you want to be globally abailable here:
    
    //eg::: int offset;
    UIColor *currentBackgroundColour;
    UIColor *currentBlockColour;
    UIColor *currentShowColour;
    
    int start;
    int finish;
    int blockSize;
    int waitTime;
    int startTime;
    int showTime;
    int clickNumber;
    
    BOOL forwardTestDirection;
    BOOL blockRotation;
    BOOL onScreenInfo;
    
    NSString *oldSubjectName;
    NSString *subjectName;
    NSString *resultStrings;
    NSString *testDate;
    NSString *testTime;
    NSString *email;
    
    long double timerTime;
    
    UIView *bl1;
    UIView *bl2;
    UIView *bl3;
    UIView *bl4;
    UIView *bl5;
    UIView *bl6;
    UIView *bl7;
    UIView *bl8;
    UIView *bl9;
}

//eg::: @property (nonatomic) int  offset;
@property (nonatomic, retain) UIColor *currentBackgroundColour;
@property (nonatomic, retain) UIColor *currentShowColour;
@property (nonatomic, retain) UIColor *currentBlockColour;

@property (nonatomic) int   start;
@property (nonatomic) int   finish;
@property (nonatomic) int   blockSize;
@property (nonatomic) int   waitTime;
@property (nonatomic) int   startTime;
@property (nonatomic) int   showTime;
@property (nonatomic) int   clickNumber;

@property (nonatomic) BOOL forwardTestDirection;
@property (nonatomic) BOOL blockRotation;
@property (nonatomic) BOOL onScreenInfo;

@property (nonatomic,retain) NSString *oldSubjectName;
@property (nonatomic,retain) NSString *subjectName;
@property (nonatomic,retain) NSString *resultStrings;
@property (nonatomic,retain) NSString *testDate;
@property (nonatomic,retain) NSString *testTime;
@property (nonatomic,retain) NSString *email;

@property (nonatomic) long double timerTime;

@property (nonatomic, retain) UIView *bl1;
@property (nonatomic, retain) UIView *bl2;
@property (nonatomic, retain) UIView *bl3;
@property (nonatomic, retain) UIView *bl4;
@property (nonatomic, retain) UIView *bl5;
@property (nonatomic, retain) UIView *bl6;
@property (nonatomic, retain) UIView *bl7;
@property (nonatomic, retain) UIView *bl8;
@property (nonatomic, retain) UIView *bl9;


//set up singleton shared

+(mySingleton *)sharedSingleton;

@end

