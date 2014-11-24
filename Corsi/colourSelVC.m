//
//  colourSelVC.m
//  Corsi
//
//  Created by Jon Howell on 24/11/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import "colourSelVC.h"

@interface colourSelVC ()

@end

@implementation colourSelVC{
    
}
@synthesize
showPicker, blockPicker, backPicker,
showCol, backCol, blockCol, colourArrayBack, colourArrayBlock, colourArrayShow;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.colourArrayBack  = [[NSArray alloc] initWithObjects:
                        @"Blue",
                        @"Green",
                        @"Orange",
                        @"Purple",
                        @"Red",
                        @"Yellow" ,
                        nil];
    
    self.colourArrayShow  = [[NSArray alloc] initWithObjects:
                        @"Blue",
                        @"Green",
                        @"Orange",
                        @"Purple",
                        @"Red",
                        @"Yellow" ,
                        nil];
    
    self.colourArrayBlock  = [[NSArray alloc] initWithObjects:
                        @"Blue",
                        @"Green",
                        @"Orange",
                        @"Purple",
                        @"Red",
                        @"Yellow" ,
                        nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [backPicker setBackgroundColor:[UIColor cyanColor]];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// returns the number of 'columns' to display.
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 6;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag==0) {

    //return [self.colourArrayBack objectAtIndex:row];
    }
    return [self.colourArrayBack objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSLog(@"Selected Row %ld", (long)row);
    if (pickerView.tag==0) {
    switch(row)
    {
        case 0:
        //self.color.text = @"Blue #0000FF";
        self.backCol.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green: 0.0f/255.0f blue:255.0f/255.0f alpha:255.0f/255.0f];
        break;
        case 1:
        //self.color.text = @"Green #00FF00";
        self.backCol.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green: 255.0f/255.0f blue:0.0f/255.0f alpha:255.0f/255.0f];
        break;
        case 2:
        //self.color.text = @"Orange #FF681F";
        self.backCol.backgroundColor = [UIColor colorWithRed:205.0f/255.0f green:   140.0f/255.0f blue:31.0f/255.0f alpha:255.0f/255.0f];
        break;
        case 3:
        //self.color.text = @"Purple #FF00FF";
        self.backCol.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:   0.0f/255.0f blue:255.0f/255.0f alpha:255.0f/255.0f];
        break;
        case 4:
        //self.color.text = @"Red #FF0000";
        self.backCol.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:   0.0f/255.0f blue:0.0f/255.0f alpha:255.0f/255.0f];
        break;
        case 5:
        //self.color.text = @"Yellow #FFFF00";
        self.backCol.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:   255.0f/255.0f blue:0.0f/255.0f alpha:255.0f/255.0f];
        break;
    }
    }
    
}

@end
