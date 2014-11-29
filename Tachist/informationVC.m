//
//  informationVC.m
//  Tachist
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
-(void)viewWillAppear:(BOOL)animated{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    NSString * textContents = @"";

    //put some text in the box

    textContents=@"\n\n\n\n\nIntroduction\n\nThe Tachistoscope Test...";

    //infoTextView.font=[UIFont fontWithName:@"Serifa-Roman" size:16];
    infoTextView.text=textContents;
}

-(void)viewDidAppear:(BOOL)animated{
    UIImage *infoImage           = [UIImage imageNamed:@"information"];
    UIImage *infoImageSel        = [UIImage imageNamed:@"information"];
    infoImage        = [infoImage     imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    infoImageSel     = [infoImageSel  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Information" image:infoImage selectedImage: infoImageSel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
