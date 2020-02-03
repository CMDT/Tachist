//
//  mySingleton.m
//  Tachist
//
//  Created by Jon Howell on 04/09/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import "mySingleton.h"

static mySingleton * sharedSingleton = nil;

@implementation mySingleton {
    //
}

// eg::: @synthesize offset;
@synthesize
    currentStatusColour,
    showTime,
    start,
    startTime,
    finish,
    counter,
    waitTime,
    messageTime,
    oldSubjectName,
    subjectName,
    testerName,
    testDate,
    testTime,
    imageForDisplay,
    cardReactionTimeResult,
    resultStrings,      //string
    resultStringRows,   //array

    email,
    onScreenInfo,
    sounds,
    beepEffect,

    displayStrings,     //result item
    displayStringRows,  //array
    
    displayStringsTitle,//result title
    displayStringTitles,//array

    segIndex;           //sounds

#pragma mark -
#pragma mark Singleton Methods

+ (mySingleton *) sharedSingleton {
    if(sharedSingleton==nil) {
        sharedSingleton = [[super allocWithZone:NULL]init];
    }
    return sharedSingleton;
}

+(id)allocWithZone:(NSZone *)zone {
    return [self sharedSingleton];
}

- (id)copyWithZone:(NSZone *) zone {
    return self;
}

- (id) init {
    if(self = [super init]) {
    //only runs if no data or first run to give default values
        
        currentStatusColour    = [UIColor yellowColor];
        start                  = 3;
        finish                 = 9;
        counter                = 0;
        waitTime               = 1500;
        startTime              = 1500;
        showTime               = 1500;
        messageTime            = 2000; //for on screen instructions and messages in time interval delay
        onScreenInfo           = YES;
        sounds                 = YES;
        beepEffect             = @"BEEPJAZZ";
        segIndex               = 5;
        resultStrings          = @"";
        displayStrings         = @"";
        resultStringRows       = [NSMutableArray new];//clear the arrays of any data
        displayStringRows      = [NSMutableArray new];
        displayStringTitles    = [NSMutableArray new];
        cardReactionTimeResult = [NSMutableArray new];
        email                  = @"me@text.com";
        }
    return self;
}
@end
