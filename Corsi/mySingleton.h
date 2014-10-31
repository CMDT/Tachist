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
    UIColor *currentStatusColour;

    long double timerTime;

    int   start;
    int   finish;

    float blockSize;
    float waitTime;
    float startTime;
    float showTime;
    float messageTime;

    BOOL forwardTestDirection;
    BOOL blockRotation;
    BOOL onScreenInfo;
    BOOL animals;
    BOOL sounds;

    NSString *beepEffect;//from plist
    NSString *oldSubjectName;
    NSString *subjectName;
    NSString *testerName;
    NSString *testDate;
    NSString *testTime;
    NSString *email;
    NSString *resultStrings;
    NSString *displayStrings;

    NSMutableArray *resultStringRows;//for Excel and data csv format
    NSMutableArray *displayStringRows;//for screen display formatted to look nice
    
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
@property (nonatomic, retain) UIColor *currentStatusColour;

@property (nonatomic) int       start;
@property (nonatomic) int       finish;
@property (nonatomic) NSString *beepEffect;

@property (nonatomic) float     blockSize;
@property (nonatomic) float     waitTime;
@property (nonatomic) float     startTime;
@property (nonatomic) float     showTime;
@property (nonatomic) float     messageTime;
@property (nonatomic) int       clickNumber;

@property (nonatomic) BOOL      forwardTestDirection;
@property (nonatomic) BOOL      blockRotation;
@property (nonatomic) BOOL      onScreenInfo;
@property (nonatomic) BOOL      animals;
@property (nonatomic) BOOL      sounds;

@property (nonatomic,retain) NSString *oldSubjectName;
@property (nonatomic,retain) NSString *subjectName;
@property (nonatomic,retain) NSString *testerName;
@property (nonatomic,retain) NSMutableArray *resultStringRows;
@property (nonatomic,retain) NSMutableArray *displayStringRows;
@property (nonatomic,retain) NSString *resultStrings;
@property (nonatomic,retain) NSString *displayStrings;
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

