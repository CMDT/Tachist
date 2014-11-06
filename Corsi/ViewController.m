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
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary: [[UITabBarItem appearance] titleTextAttributesForState:UIControlStateNormal]];
    [attributes setValue:[UIFont fontWithName:@"Serifa-Roman" size:10] forKey:NSFontAttributeName];
    [[UITabBarItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
}


@end
