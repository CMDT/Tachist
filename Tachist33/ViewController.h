//
//  ViewController.h
//  Tachist33
//
//  Created by Jon Howell on 12/09/2013.
//  Copyright (c) 2013 Manchester Metropolitan University - ESS - psyc. All rights reserved.
//  this version 7/9/16
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ViewController : UIViewController <MFMailComposeViewControllerDelegate, UITextFieldDelegate>
{
NSDate        * startDate;
IBOutlet UIImageView * detector; //put an image up when the screen is tapped

NSFileManager * fileMgr;
NSString      * homeDir;
NSString      * filename;
NSString      * filepath;
NSString      * vDate; //version date
}

@property(nonatomic,retain) NSFileManager   * fileMgr;
@property(nonatomic,retain) NSString        * homeDir;
@property(nonatomic,retain) NSString        * filename;
@property(nonatomic,retain) NSString        * filepath;
@property(nonatomic,retain) NSString        * vDate;

-(NSString *) GetDocumentDirectory;
-(void) WriteToStringFile:(NSMutableString *)textToWrite;
-(NSString *) setFilename;

@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, strong) IBOutlet UITextField * noCards;
@property (nonatomic, strong) IBOutlet UITextField * stimOnTime;
@property (nonatomic, strong) IBOutlet UITextField * postResponseDelay;
@property (nonatomic, strong) IBOutlet UITextField * subjectCodeTxt;

// button press to send the mail
- (IBAction)sendMail:(id)sender;

- (IBAction)yesPressed;
- (IBAction)noPressed;

//-(void)onCardDisplay;
//-(void)blankCardDisplay;
- (void)startCardDisplay;
- (void)finishCardDisplay;

@end