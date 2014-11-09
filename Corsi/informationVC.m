//
//  informationVC.m
//  Corsi
//
//  Created by Jon Howell on 04/09/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import "informationVC.h"

@interface informationVC ()

@end

@implementation informationVC

@synthesize infoTextView;

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
    NSString * textContents = @"";

    //put some text in the box

     textContents=@"Introduction\n\nThe Corsi Block Test can be used as a measure of short term memory recall ability.\n\nThe original test used 9 coloured blocks that were placed on a table, and the observer touched the blocks in an order the participant was asked to repeat.\n\nThe ability to repeat all the blocks in the sequence originally shown gives a score.\n\nThis App extends this simple test by allowing a number of variations that a researcher can use to explore short term memory in a participant.\n\nThe normal (or forward) test starts by asking the participant to recall three blocks in sequence after showing the blocks all in one colour, and a contrasting colour to highlight the sequence.\n\nThe timings of the test can be set in milliseconds. The start delay is before the first sequence starts, the delay between blocks being shown is the wait time and the length of time the highlight is shown is the show time. These time delays are customisable through the settings screen.\n\nThe test proceeds through stages of increasing length of blocks to be sequenced, until the maximum number of blocks is shown, usually 9.\n\nAs it can be challenging to achieve a high score with nine blocks, the ease of which the test can be performed can be altered regarding the start number of blocks and the end number.\n\nThis will allow children (check permissions / Ethics approval if required) and those with limited memory ability to still score the test.\n\nOnce settings for testing are entered and saved, you should keep the same settings for each participant in a group.\n\nA more difficult test is the 'reverse test', where the participant is shown the blocks in sequence, but has to recall them last to first in opposite order.\\nResults are stored in a temporary file on the iPhone/iPad but can be sent as an email attachment to your address. This allows use within Excel or any editing package that can read CSV files (comma separated variable).\n\nThere is some extra information regarding this test via the web site: www.ess.mmu.ac.uk/apps/corsi.\n\nThe colours for the blocks and all the other settings can be adjusted in the iPad/iPhone settings of the device as well as the settings screen.  The settings made in the App settings screen are temporary until saved by selecting the SAVE button.  When the App is initially run, the device default settings are used.\n\nTo use your saved settings, select LOAD before use.\n\nThe developer of this App is: Mr Jonathan Howell, SAS Technical Services, Manchester Metropolitan University, and any comments or suggestions can be sent by email to j.a.howell@mmu.ac.uk.\n\nThis version, MMU (c) 2014.\n\nMain Functions\n\nThe App is divided into four main sections.  The opening screen allows the settings of the test to be set (there is also an alternative and some additional settings in the Apple Settings of your device under the Corsi Icon).  The green title buttons allow settings for particular things to be set, such as colours, timing and features.  The information button is this file and the results button will display any calculations when the test is completed.  If at any time you press the settings button before a test has completed, the test that is running will be cancelled, and restarted.  Only fully completed tests have data that can be seen or saved.  All data are lost when the App is closed by the Home button.  The App will not run in the background, but may hold if not closed.  The test tab item runs the test using the parameters in the settings section.  Not all colour and feature combinations will be effective, so please test a few out before use.  The use of the Animals feature for the blocks is a non-standard test and you will need to assess how all the features may affect memory as part of your educational use of this App.  You will need to make sure that you have a valid email address in the settings section of your device before you attempt to send an email.\n\nDisclaimer\n\nThis Application is intended to be an educational utility to aid understanding of short term memory and must not be used for any diagnosis, medical or other treatment.  The results are arbitrary and are not calibrated or validated against any other test results that may exist elsewhere.  The user agrees that participant data are the liability of the tester and not the developer.  MMU and the developer express no warranty, expressed or implied as to its use, effectiveness or suitability, and must be used only as an educational utility.  Use of the email function to send data is at the discression of the device user, and at no time does will it send to anyone except those that the user types in as recipients.  No data are sent or saved to any other device or store as part of this App.  All data sent and subsequently stored are the responsibility of the user.  It is highly recommended that all participants are not able to be identified by name.  Any study using this App should be endorsed by a qualified tutor to ensure ethical procedures are taken into account where necessary.  If you use this App and it forms part of any research project, please reference it as the MMU Corsi Block Tapping Test App 2014.\n\nThis App was specifically developed for use by Undergraduate and Higher Degree Courses.  It is the responsibility of the users to read academic and other information to familiarise themselves with the Corsi Block Test. This App is only a small part of a detailed course of study in Sport Psychology, and if you wish to enquire about courses or seek further information, please see the university web site: http:www2.mmu.ac.uk.";
    //infoTextView.font=[UIFont fontWithName:@"Serifa-Roman" size:16];
    infoTextView.text=textContents;
}

-(void)viewDidAppear:(BOOL)animated{
    UIImage *informationImage       = [UIImage imageNamed:@"Information"];
    UIImage *informationImageSel    = [UIImage imageNamed:@"InformationSel"];
    informationImage    = [informationImage     imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    informationImageSel = [informationImageSel  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Information" image:informationImage selectedImage: informationImageSel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
