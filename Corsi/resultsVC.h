//
//  resultsVC.h
//  Corsi
//
//  Created by Jon Howell on 04/09/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface resultsVC : UIViewController <MFMailComposeViewControllerDelegate>
{
    
IBOutlet UILabel     * statusMessageLab;
//text views for text displays ie results or help screens

// for file manager
    NSFileManager   * fileMgr;
    NSString        * homeDir;
    NSString        * filename;
    NSString        * filepath;

// for calculations and functions
    NSDate          * startDate;
    NSDate          * testDate;
    UILabel         * datelbl;
    UILabel         * timelbl;
    UILabel         * emaillbl;
    UILabel         * subjectlbl;
    UITextView      * resultTxtView;
}

//file ops stuff
@property(nonatomic,retain) NSFileManager * fileMgr;
@property(nonatomic,retain) NSString      * homeDir;
@property(nonatomic,retain) NSString      * filename;
@property(nonatomic,retain) NSString      * filepath;

//dates
@property (nonatomic, copy) NSDate * startDate;
@property (nonatomic, copy) NSDate * testDate;

@property (nonatomic, strong) IBOutlet UILabel    * datelbl;
@property (nonatomic, strong) IBOutlet UILabel    * timelbl;
@property (nonatomic, strong) IBOutlet UILabel    * emaillbl;
@property (nonatomic, strong) IBOutlet UILabel    * subjectlbl;
@property (nonatomic, strong) IBOutlet UITextView * resultTxtView;

-(IBAction)showEmail:(id)sender;
//-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *) error;
-(NSString *) GetDocumentDirectory;
-(NSString *) setFilename;
-(void) WriteToStringFile:(NSMutableString *)textToWrite;

@end
