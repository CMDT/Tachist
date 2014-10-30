//
//  ViewController.m
//  Corsi
//
//  Created by Jon Howell on 02/09/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import "ViewController.h"
#import "mySingleton.h"

@interface ViewController ()

@end

@implementation ViewController
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIImage *testImage      = [UIImage imageNamed:@"Test"];
    UIImage *testImageSel   = [UIImage imageNamed:@"Test"];
    testImage               = [testImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    testImageSel            = [testImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem         = [[UITabBarItem alloc] initWithTitle:@"Test" image:testImage selectedImage: testImageSel];

}


@end
