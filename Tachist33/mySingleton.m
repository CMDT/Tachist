//
//  mySingleton.m
//  Tachist3
//
//  Created by Jonathan Howell on 18/05/2013.
//
//  Updated 16/11/15 jah for ios9
//  this version 7/9/16

#import "mySingleton.h"

static mySingleton * sharedSingleton = nil;

@implementation mySingleton {

}

//Counters
@synthesize counter;
@synthesize offset;
@synthesize lineWidth;
@synthesize lineColour;
@synthesize scalingFactor;
@synthesize crossType;
@synthesize picturePos;

@synthesize resultStrings;
@synthesize subjectName;

//image
@synthesize imageForDisplay;

//Flags BOOL
@synthesize boxShow;
@synthesize hypot;
@synthesize floatAngle;

//Array
@synthesize cardReactionTimeResult;

#pragma mark -
#pragma mark Singleton Methods

+ (mySingleton *) sharedSingleton {
    if(sharedSingleton  ==nil) {
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
        counter         = 0;
        offset          = 30;
        lineWidth       = 1;
        lineColour      = [UIColor blueColor];
        scalingFactor   = 1;
        boxShow         = YES;
        hypot           = NO;
        floatAngle      = NO;
        crossType       = 1;

        resultStrings   = @"";
        subjectName     = @"TempSubject";
        
        picturePos=CGRectMake(10,50,1000,800);    //approx, will be updated in a moment anyway
        cardReactionTimeResult = [[NSMutableArray alloc]initWithObjects:@"", nil]; //15/11/15 for ios 9 added @"",
    }
    return self;
}
@end
