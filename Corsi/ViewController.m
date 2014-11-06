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

/*
 todo
 
 excel move across one column due to missing test no.  Find added line feed and delete.
 font size increase for labels and messages to fit better.
 add new screen for participant and email added to plist and singleton.
 change subject to particpant in plist
 check out the version number.
 add screen shots when done x 6 or so.
 add descriptions and licence info.
 see about charging 1 dollar per app.
 check functions and remove dead code.
 tidy up code.
 make opening credits screen, same as start, but with added message.
 
*/
@end
