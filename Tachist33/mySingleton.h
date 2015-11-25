//
//  mySingleton.h
//  Tachist33
//
//  Created by Jonathan Howell on 18/05/2013.
//
// Updated formios 9 jah 16/11/15
// added iphone screen 25/11/15

#import <Foundation/Foundation.h>

@interface mySingleton : NSObject {
    // add all the objects that you want to be globally abailable here:

    int offset;
    int counter;
    int lineWidth;
    int scalingFactor;

    BOOL boxShow;
    BOOL hypot;
    BOOL floatAngle;
    
    int  crossType;
    
    CGRect picturePos;
    
    UIColor             * lineColour;
    
    UIImage             * imageForDisplay;
    
    NSMutableArray      * cardReactionTimeResult;

    NSString            * resultsStrings;
    NSString            * subjectName;
}

@property (nonatomic) int  offset;
@property (nonatomic) int  counter;
@property (nonatomic) int  lineWidth;
@property (nonatomic) int  scalingFactor;

@property (nonatomic) BOOL boxShow;
@property (nonatomic) BOOL hypot;
@property (nonatomic) BOOL floatAngle;

@property (nonatomic) int  crossType;

@property (nonatomic) CGRect picturePos;

@property (nonatomic,retain) UIColor            * lineColour;

@property (nonatomic) UIImage                   * imageForDisplay;

@property (nonatomic, retain) NSMutableArray    * cardReactionTimeResult;

@property (nonatomic, retain) NSString          * resultStrings;
@property (nonatomic, retain) NSString          * subjectName;

//Flags BOOL

//Strings

//set up singleton shared

+(mySingleton *)sharedSingleton;

@end