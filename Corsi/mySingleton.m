//
//  mySingleton.m
//  Corsi
//
//  Created by Jon Howell on 04/09/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import "mySingleton.h"

static mySingleton * sharedSingleton = nil;

@implementation mySingleton {
    
}

// eg::: @synthesize offset;
@synthesize
            currentShowColour,
            currentBlockColour,
            currentBackgroundColour,
            currentStatusColour,
            blockSize,
            bl1,
            bl2,
            bl3,
            bl4,
            bl5,
            bl6,
            bl7,
            bl8,
            bl9,
            clickNumber,
            showTime,
            start,
            startTime,
            finish,
            timerTime,
            waitTime,
            messageTime,
            oldSubjectName,
            subjectName,
            testerName,
            testDate,
            testTime,
            resultStrings,
            email,
            forwardTestDirection,
            blockRotation,
            onScreenInfo
            ;

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
        
        //eg:::       offset=30;
        currentBackgroundColour = [UIColor blueColor];
        currentBlockColour = [UIColor cyanColor];
        currentShowColour  = [UIColor orangeColor];
        currentStatusColour= [UIColor yellowColor];
        start       = 3;
        finish      = 9;
        blockSize   = 30;
        waitTime    = 1500;
        startTime   = 1000;
        showTime    = 600;
        messageTime = 2000; //for on screen instructions and messages in time interval delay
        timerTime   = 0.0;
        clickNumber = 0;
        blockRotation = NO;
        onScreenInfo  = YES;
        forwardTestDirection = YES;
        oldSubjectName = @"Subject 1";
        
    }
    return self;
}
@end
