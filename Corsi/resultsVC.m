//
//  resultsVC.m
//  Corsi
//
//  Created by Jon Howell on 04/09/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import "resultsVC.h"
#import "mySingleton.h"

@interface resultsVC ()

@end

@implementation resultsVC

@synthesize
//results Labels

datelbl,
timelbl,
subjectlbl,
testDate;

@synthesize
startDate,
fileMgr,
homeDir,
filename,
filepath,
emaillbl
;
@synthesize resultTxtView,title;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{

    mySingleton *singleton = [mySingleton sharedSingleton];

    UIImage *resultsImage           = [UIImage imageNamed:@"Results"];
    UIImage *resultsImageSel        = [UIImage imageNamed:@"ResultsSel"];
    resultsImage        = [resultsImage     imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    resultsImageSel     = [resultsImageSel  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Results"        image:resultsImage selectedImage:       resultsImageSel];

    //make a text file from the array of results
    NSMutableString *element = [[NSMutableString alloc] init];
    NSMutableString *printString = [NSMutableString stringWithString:@""];
    int final=[singleton.resultStringRows.count];
    for(int i=0; i< final; i++)
        {
        element = [singleton.resultStringRows objectAtIndex: i];
        [printString appendString:[NSString stringWithFormat:@"\n%@", element]];
        }
    [printString appendString:@""];

    // NSLog(@"string to write pt1:%@",printString);
    //CREATE FILE to save in Documents Directory
    //nb Have to set info.plist environment variable to allow iTunes sharing if want to tx to iTunes etc this dir.

    //UIViewController *files = [[UIViewController alloc] init];

    singleton.resultStrings = printString;

    resultTxtView.text = singleton.resultStrings;
    //[self saveText];
    [self WriteToStringFile:[printString mutableCopy]];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSString *) setFilename{
    mySingleton *singleton = [mySingleton sharedSingleton];
    NSString *extn = @"csv";
    filename = [NSString stringWithFormat:@"%@.%@", singleton.oldSubjectName, extn];
    return filename;
}

//find the home directory for Document
-(NSString *)GetDocumentDirectory{
    fileMgr  = [NSFileManager defaultManager];
    NSString * docsDir;
    NSArray  * dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir  = dirPaths[0];
    return docsDir;
}

/*Create a new file*/
-(void)WriteToStringFile:(NSMutableString *)textToWrite{
    mySingleton *singleton = [mySingleton sharedSingleton];
    //int trynumber = 0;
    filepath = [[NSString alloc] init];
    NSError *err;
    
    //get sub name and add date
    filepath = [self.GetDocumentDirectory stringByAppendingPathComponent:self.setFilename];
    
    // not needed as all file names have date added to end of name
    //check if file exists
    
    //BOOL fileExists = TRUE;
    //if([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
    //exists, error, add +1 to filename and repeat
    //BOOL fileExists = TRUE;
    
    
    //singleton.subjectName = [singleton.oldSubjectName stringByAppendingString: [NSString stringWithFormat:@"_%@_%i",[self getCurrentDateTimeAsNSString], trynumber]];
    //[self WriteToStringFile:textToWrite];
    //    }
    //else
    //    {
    //not exists, write
    //BOOL fileExists = FALSE;
    
    singleton.subjectName = [singleton.oldSubjectName stringByAppendingString: [NSString stringWithFormat:@"_%@",[self getCurrentDateTimeAsNSString]]];
    
    //}
    //
    
    BOOL ok;
    ok = [textToWrite writeToFile:filepath atomically:YES encoding:NSASCIIStringEncoding error:&err];
    if (!ok) {
        (statusMessageLab.text=filepath, [err localizedFailureReason]);
        //NSLog(@"Error writing file at %@\n%@", filepath, [err localizedFailureReason]);
    }
}


-(NSString*)getCurrentDateTimeAsNSString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"ddMMyyHHmmss"];
    NSDate *now = [NSDate date];
    NSString *retStr = [format stringFromDate:now];
    
    return retStr;
}

- (void)saveText
{
    statusMessageLab.text=@"Saving\nData\nFile.";
    mySingleton     * singleton = [mySingleton sharedSingleton];
    
    NSFileManager   * filemgr;
    NSData          * databuffer;
    NSString        * dataFile;
    NSString        * docsDir;
    NSArray         * dirPaths;
    
    filemgr = [NSFileManager defaultManager];
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    NSString * fileNameS = [NSString stringWithFormat:@"%@.csv", subjectlbl.text];
    dataFile = [docsDir stringByAppendingPathComponent:fileNameS];
    
    databuffer = [singleton.resultStrings dataUsingEncoding: NSASCIIStringEncoding];
    [filemgr createFileAtPath: dataFile
                     contents: databuffer attributes:nil];
}


- (IBAction)showEmail:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    NSString *emailTitle = [NSString stringWithFormat:@"Corsi App Data for: %@",singleton.oldSubjectName];
    NSString *messageBody = [NSString stringWithFormat:@"The test data for the subject:%@ taken at the date: %@ and time: %@, is attached as a text/csv file.  \n\nThe file is comma separated variable, csv extension.  \n\nThe data can be read by MS-Excel, then analysed by your own functions. \n\nSent by Corsi App.",singleton.oldSubjectName, singleton.testDate, singleton.testTime];
    //NSArray  *toRecipents = [NSArray arrayWithObject:@"j.a.howell@mmu.ac.uk"];
    NSArray  *toRecipents = [NSArray arrayWithObject:singleton.email];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    filepath = [[NSString alloc] init];
    
    filepath = [self.GetDocumentDirectory stringByAppendingPathComponent:self.setFilename];
    
    // Get the resource path and read the file using NSData
    
    NSData *fileData = [NSData dataWithContentsOfFile:filepath];
    
    // Determine the MIME type
    NSString *mimeType; /*
                         if ([extension isEqualToString:@"jpg"]) {
                         mimeType = @"image/jpeg";
                         } else if ([extension isEqualToString:@"png"]) {
                         mimeType = @"image/png";
                         } else if ([extension isEqualToString:@"doc"]) {
                         mimeType = @"application/msword";
                         } else if ([extension isEqualToString:@"csv"]) { */
    mimeType = @"text/csv";
    /*
     } else if ([extension isEqualToString:@"ppt"]) {
     mimeType = @"application/vnd.ms-powerpoint";
     } else if ([extension isEqualToString:@"html"]){
     mimeType = @"text/html";
     } else if ([extension isEqualToString:@"pdf"]) {
     mimeType = @"application/pdf";
     } */
    
    // Add attachment
    [mc addAttachmentData:fileData mimeType:mimeType fileName:filename];
    
    // P              resent mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

@end
