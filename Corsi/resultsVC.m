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

@implementation resultsVC{
    //IBOutlet UITextView *resultsViewBorder;
    NSString *resultsTempString;
    UILabel *titleLab;//title
    UILabel *resultLab;//result
}

@synthesize
//results Labels

    datelbl,
    timelbl,
    subjectlbl,
    resultsTxtView,
    testDate,
    startDate,
    fileMgr,
    homeDir,
    filename,
    filepath,
    emaillbl,
    tableView,
    arrItems //  temp array of itmes for results display
;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //default message in view text box
    arrItems = [[NSMutableArray alloc] initWithObjects:
                @"Item 1",
                @"Item 2",
                @"Item 3",
                @"Item 4",
                @"Item 5",
                @"Item six",
                nil
                ];
}

-(void)viewDidAppear:(BOOL)animated{
    UIImage *resultsImage           = [UIImage imageNamed:@"results"];
    UIImage *resultsImageSel        = [UIImage imageNamed:@"resultsSel"];
    resultsImage                    = [resultsImage     imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    resultsImageSel                 = [resultsImageSel  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    tableView.hidden=YES;
    resultsTxtView.hidden=NO;
    
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Results" image:resultsImage selectedImage: resultsImageSel];
    mySingleton *singleton = [mySingleton sharedSingleton];

    resultsTempString = @"Corsi Tapping Test results will appear here once a test has been completed.\n\nThe previous test will stay visible until a new test is completed or you press the Home Button on your device.\n\nData can be sent by email as an attachment of type CSV.\n\nPlease ensure that you have set the email of the recipient in the device settings file before you select the email button.";
    //resultsTxtView.font=[UIFont fontWithName:@"Serifa-Roman" size:16];
    resultsTxtView.text = resultsTempString;
    //make a text file from the array of results for email csv attachment
    NSMutableString *element     = [[NSMutableString alloc] init];
    NSMutableString *printString = [NSMutableString stringWithString:@""];
    
    long final=singleton.resultStringRows.count;
    
    for(long i=0; i< final; i++)
        {
        element = [singleton.resultStringRows objectAtIndex: i];
        [printString appendString:[NSString stringWithFormat:@"\n%@", element]];
        }
    [printString appendString:@""];

    //make a text file from the array of results for formatted display on screen
    NSMutableString *element2 = [[NSMutableString alloc] init];
    NSMutableString *printString2 = [NSMutableString stringWithString:@""];
    long final2=singleton.displayStringRows.count;
    for(long i=0; i< final2; i++)
        {
        element2 = [singleton.displayStringRows objectAtIndex: i];
        [printString2 appendString:[NSString stringWithFormat:@"\n%@", element2]];
        }
    [printString2 appendString:@""];

    // NSLog(@"string to write pt1:%@",printString);
    //CREATE FILE to save in Documents Directory
    //nb Have to set info.plist environment variable to allow iTunes sharing if want to tx to iTunes etc this dir.

    //UIViewController *files = [[UIViewController alloc] init];

    singleton.resultStrings  = printString;//email csv
    singleton.displayStrings = printString2;//screen
    
    //check if data exists, if not, display the holding message
    if ([printString2 isEqualToString:@""]) {
        resultsTxtView.text  = resultsTempString;
        tableView.hidden=YES;
        resultsTxtView.hidden=NO;

    }else{
        resultsTxtView.text  = singleton.displayStrings;
        tableView.hidden=NO;
        resultsTxtView.hidden=YES;
    }
    //[self saveText];
    [self WriteToStringFile:[printString mutableCopy]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    mySingleton *singleton = [mySingleton sharedSingleton];
    // Return the number of rows in the section.
    //return [arrItems count];
    long a=[singleton.displayStringRows count];
    long b=[singleton.displayStringTitles count];
    //to stop exceeding past array bounds
    if (a<b) {
        return a;
    }else{
        return b;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    mySingleton *singleton = [mySingleton sharedSingleton];
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    // Configure the cell...
    //cell.textLabel.text = [arrItems objectAtIndex:indexPath.row];
    //old way when cell had no labels in it
    //  cell.textLabel.text = [singleton.displayStringRows objectAtIndex:indexPath.row];
    //  cell.textLabel.font = [UIFont systemFontOfSize:8.0];
    
    //new way with one long label for titles and one short one, starting jhalfway for the data
    titleLab = (UILabel *)[cell viewWithTag:100];
    [titleLab setText:[singleton.displayStringTitles objectAtIndex:indexPath.row]];//title on left
    resultLab = (UILabel *)[cell viewWithTag:200];
    [resultLab setText:[singleton.displayStringRows objectAtIndex:indexPath.row]];//results on right (or none if heading
    
    //done in storyboard
    //[titleLab setFont: [UIFont fontWithName:@"Arial" size:12.0]];
    //[resultLab setFont: [UIFont fontWithName:@"Arial" size:9.0]];
    
    return cell;
    
/*
 //example of label and button populating a cell
 - (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath { 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tvcItems"]; 
 UILabel *lblName = (UILabel *)[cell viewWithTag:100]; 
 [lblName setText:[maTheData objectAtIndex:[indexPath row]]]; 
 UIButton *btnName = (UIButton *)[cell viewWithTag:200]; 
 [btnName setTitle:[maTheData objectAtIndex:[indexPath row]] forState:UIControlStateNormal]; 
 return cell; 
 } -
 
 */
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //sets row heights
    if (indexPath.row == 0) {
        return 35;//first row is for heading, hence bigger
    } else {
        return 25;//all other rows
    }
}

- (void)tableView: (UITableView*)tableView
  willDisplayCell: (UITableViewCell*)cell
forRowAtIndexPath: (NSIndexPath*)indexPath
{
    if (indexPath.row==0) {
        //cell.backgroundColor = [UIColor colorWithRed: 1.0 green: 0.8 blue: 0.8 alpha: 1.0];
        //cell.textLabel.backgroundColor = [UIColor clearColor];
        //cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        titleLab.backgroundColor=[UIColor colorWithRed: 1.0 green: 0.8 blue: 0.8 alpha: 1.0];
        resultLab.backgroundColor=[UIColor colorWithRed: 1.0 green: 0.8 blue: 0.8 alpha: 1.0];
    }else{
    //cell.backgroundColor = indexPath.row % 2
    //? [UIColor colorWithRed: 1.0 green: 1.0 blue: 0.95 alpha: 0.9]
    //: [UIColor whiteColor];
    //cell.textLabel.backgroundColor = [UIColor clearColor];
    //cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        titleLab.backgroundColor=[UIColor colorWithRed: 1.0 green: 1.0 blue: 0.95 alpha: 0.9];
        resultLab.backgroundColor=[UIColor colorWithRed: 1.0 green: 1.0 blue: 0.95 alpha: 0.9];
    }
}

-(NSString *) setFilename{
    mySingleton *singleton = [mySingleton sharedSingleton];
    NSString *extn = @"csv";
    filename = [NSString stringWithFormat:@"%@.%@", singleton.subjectName, extn];
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

/* Create a new file */
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
    
    
    //singleton.subjectName = [singleton.olsSubjectName stringByAppendingString: [NSString stringWithFormat:@"_%@_%i",[self getCurrentDateTimeAsNSString], trynumber]];
    //[self WriteToStringFile:textToWrite];
    //    }
    //else
    //    {
    //not exists, write
    //BOOL fileExists = FALSE;
    
    singleton.oldSubjectName = [singleton.subjectName stringByAppendingString: [NSString stringWithFormat:@"_%@",[self getCurrentDateTimeAsNSString]]];
    
    //}
    //
    
    BOOL ok;
    ok = [textToWrite writeToFile:filepath atomically:YES encoding:NSASCIIStringEncoding error:&err];
    if (!ok) {
        //(statusMessageLab.text=filepath, [err localizedFailureReason]);
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

-(NSString*)getCurrentDate
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd/MM/yyyy"];
    NSDate *now = [NSDate date];
    NSString *retStr = [format stringFromDate:now];

    return retStr;
}

-(NSString*)getCurrentTime
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm:ss"];
    NSDate *now = [NSDate date];
    NSString *retStr = [format stringFromDate:now];

    return retStr;
}

- (void)saveText
{
    //statusMessageLab.text=@"Saving\nData\nFile.";
    mySingleton     * singleton = [mySingleton sharedSingleton];
    
    NSFileManager   * filemgr;
    NSData          * databuffer;
    NSString        * dataFile;
    NSString        * docsDir;
    NSArray         * dirPaths;
    
    filemgr = [NSFileManager defaultManager];
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    //NSString * fileNameS = [NSString stringWithFormat:@"%@.csv", subjectlbl.text];

    NSString * fileNameS = [NSString stringWithFormat:@"corsi.csv"];

    dataFile = [docsDir stringByAppendingPathComponent:fileNameS];
    
    databuffer = [singleton.resultStrings dataUsingEncoding: NSASCIIStringEncoding];
    [filemgr createFileAtPath: dataFile
                     contents: databuffer attributes:nil];
}


- (IBAction)showEmail:(id)sender {
    NSLog(@"Sending Email");
    mySingleton *singleton = [mySingleton sharedSingleton];

    singleton.testDate=[self getCurrentDate];
    singleton.testTime=[self getCurrentTime];

    NSString *emailTitle = [NSString stringWithFormat:@"Corsi App Data: %@",singleton.oldSubjectName];
    NSString *messageBody = [NSString stringWithFormat:@"The test data for the subject:%@ taken at the date: %@ and time: %@, is attached as a text/csv file.\n\nThe file is comma separated variable, csv extension.\n\nThe data can be read by MS-Excel, then analysed by your own functions.\n\nThe screen Data follows, the attached file is formatted for MS-Excel as a CSV \n\n%@.\n\nSent by Corsi App.",singleton.subjectName, singleton.testDate, singleton.testTime, singleton.displayStrings];
    
    //NSArray  *toRecipents = [NSArray arrayWithObject:@"j.a.howell@mmu.ac.uk"];//testing only
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
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    NSLog(@"Finished Email");
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
        //NSLog(@"Mail cancelled");
        break;
        case MFMailComposeResultSaved:
        //NSLog(@"Mail saved");
        break;
        case MFMailComposeResultSent:
        //NSLog(@"Mail sent");
        break;
        case MFMailComposeResultFailed:
        //NSLog(@"Mail sent failure: %@", [error localizedDescription]);
        break;
        default:
        //NSLog(@"Mail problem, not sent, failed, saved or cancelled... some other fault");
        break;
    }
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
//NSLog(@"Email View now closed.");
}
@end
