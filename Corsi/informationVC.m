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

@synthesize infoLabel;

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
