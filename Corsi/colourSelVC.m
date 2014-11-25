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
showCol,
backCol,
blockCol1,blockCol2, blockCol3, blockCol4, blockCol5,
colourArrayBack, colourArrayShow, colourArrayBlock, backBTN, messageTextView;

- (void)viewDidLoad {
    [self.backPicker setBackgroundColor:[UIColor blackColor]];
    [self.showPicker setBackgroundColor:[UIColor yellowColor]];
    [self.blockPicker setBackgroundColor:[UIColor darkGrayColor]];

    self.backCol.backgroundColor    = [UIColor blackColor];
    self.showCol.backgroundColor    = [UIColor yellowColor];
    self.blockCol1.backgroundColor  = [UIColor darkGrayColor];
    self.blockCol2.backgroundColor  = [UIColor darkGrayColor];
    self.blockCol3.backgroundColor  = [UIColor darkGrayColor];
    self.blockCol4.backgroundColor  = [UIColor darkGrayColor];
    self.blockCol5.backgroundColor  = [UIColor darkGrayColor];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.colourArrayBack  = [[NSArray alloc] initWithObjects:
                            @"black",
                            @"blue",
                            @"green",
                            @"red",
                            @"cyan",
                            @"white",
                            @"yellow",
                            @"magenta",
                            @"gray",
                            @"orangeColor",
                            @"brownColor",
                            @"purpleColor",
                            @"darkGrayColor",
                            @"lightGray",
                             nil
                            ];
    
    self.colourArrayShow  = [[NSArray alloc] initWithObjects:
                             @"black",
                             @"blue",
                             @"green",
                             @"red",
                             @"cyan",
                             @"white",
                             @"yellow",
                             @"magenta",
                             @"gray",
                             @"orangeColor",
                             @"brownColor",
                             @"purpleColor",
                             @"darkGrayColor",
                             @"lightGray",
                             nil
                             ];
                             //@"Blue",
                             //@"Green",
                             //@"Orange",
                             //@"Purple",
                             //@"Red",
                             //@"Yellow" ,
                             //nil];
    
    self.colourArrayBlock  = [[NSArray alloc] initWithObjects:
                              @"black",
                              @"blue",
                              @"green",
                              @"red",
                              @"cyan",
                              @"white",
                              @"yellow",
                              @"magenta",
                              @"gray",
                              @"orangeColor",
                              @"brownColor",
                              @"purpleColor",
                              @"darkGrayColor",
                              @"lightGray",
                              nil
                              ];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.backPicker setBackgroundColor:[UIColor blackColor]];
    [self.showPicker setBackgroundColor:[UIColor yellowColor]];
    [self.blockPicker setBackgroundColor:[UIColor darkGrayColor]];

    self.backCol.backgroundColor    = [UIColor blackColor];
    self.showCol.backgroundColor    = [UIColor yellowColor];
    self.blockCol1.backgroundColor  = [UIColor darkGrayColor];
    self.blockCol2.backgroundColor  = [UIColor darkGrayColor];
    self.blockCol3.backgroundColor  = [UIColor darkGrayColor];
    self.blockCol4.backgroundColor  = [UIColor darkGrayColor];
    self.blockCol5.backgroundColor  = [UIColor darkGrayColor];
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
    return [self.colourArrayBlock count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    id objectReturn;
    if (pickerView.tag==0) {
        objectReturn = [colourArrayBack objectAtIndex:row];
    }
    if (pickerView.tag==1) {
        objectReturn = [colourArrayShow objectAtIndex:row];
    }
    if (pickerView.tag==2) {
        objectReturn = [colourArrayBlock objectAtIndex:row];
    }
    return objectReturn;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
    {
    backBTN.hidden=NO;
    int blockc=14;
    if (pickerView.tag==0) { //block
    switch(row)
        {
            case 0:
            self.blockCol1.backgroundColor = [UIColor blackColor];
            self.blockCol2.backgroundColor = [UIColor blackColor];
            self.blockCol3.backgroundColor = [UIColor blackColor];
            self.blockCol4.backgroundColor = [UIColor blackColor];
            self.blockCol5.backgroundColor = [UIColor blackColor];
            blockc=0;
            break;
            case 1:
            self.blockCol1.backgroundColor = [UIColor blueColor];
            self.blockCol2.backgroundColor = [UIColor blueColor];
            self.blockCol3.backgroundColor = [UIColor blueColor];
            self.blockCol4.backgroundColor = [UIColor blueColor];
            self.blockCol5.backgroundColor = [UIColor blueColor];
            blockc=1;
            break;
            case 2:
            self.blockCol1.backgroundColor = [UIColor greenColor];
            self.blockCol2.backgroundColor = [UIColor greenColor];
            self.blockCol3.backgroundColor = [UIColor greenColor];
            self.blockCol4.backgroundColor = [UIColor greenColor];
            self.blockCol5.backgroundColor = [UIColor greenColor];
            blockc=2;
            break;
            case 3:
            self.blockCol1.backgroundColor = [UIColor redColor];
            self.blockCol2.backgroundColor = [UIColor redColor];
            self.blockCol3.backgroundColor = [UIColor redColor];
            self.blockCol4.backgroundColor = [UIColor redColor];
            self.blockCol5.backgroundColor = [UIColor redColor];
            blockc=3;
            break;
            case 4:
            self.blockCol1.backgroundColor = [UIColor cyanColor];
            self.blockCol2.backgroundColor = [UIColor cyanColor];
            self.blockCol3.backgroundColor = [UIColor cyanColor];
            self.blockCol4.backgroundColor = [UIColor cyanColor];
            self.blockCol5.backgroundColor = [UIColor cyanColor];
            blockc=4;
            break;
            case 5:
            self.blockCol1.backgroundColor = [UIColor whiteColor];
            self.blockCol2.backgroundColor = [UIColor whiteColor];
            self.blockCol3.backgroundColor = [UIColor whiteColor];
            self.blockCol4.backgroundColor = [UIColor whiteColor];
            self.blockCol5.backgroundColor = [UIColor whiteColor];
            blockc=5;
            break;
            case 6:
            self.blockCol1.backgroundColor = [UIColor yellowColor];
            self.blockCol2.backgroundColor = [UIColor yellowColor];
            self.blockCol3.backgroundColor = [UIColor yellowColor];
            self.blockCol4.backgroundColor = [UIColor yellowColor];
            self.blockCol5.backgroundColor = [UIColor yellowColor];
            blockc=6;
            break;
            case 7:
            self.blockCol1.backgroundColor = [UIColor magentaColor];
            self.blockCol2.backgroundColor = [UIColor magentaColor];
            self.blockCol3.backgroundColor = [UIColor magentaColor];
            self.blockCol4.backgroundColor = [UIColor magentaColor];
            self.blockCol5.backgroundColor = [UIColor magentaColor];
            blockc=7;
            break;
            case 8:
            self.blockCol1.backgroundColor = [UIColor grayColor];
            self.blockCol2.backgroundColor = [UIColor grayColor];
            self.blockCol3.backgroundColor = [UIColor grayColor];
            self.blockCol4.backgroundColor = [UIColor grayColor];
            self.blockCol5.backgroundColor = [UIColor grayColor];
            blockc=8;
            break;
            case 9:
            self.blockCol1.backgroundColor = [UIColor orangeColor];
            self.blockCol2.backgroundColor = [UIColor orangeColor];
            self.blockCol3.backgroundColor = [UIColor orangeColor];
            self.blockCol4.backgroundColor = [UIColor orangeColor];
            self.blockCol5.backgroundColor = [UIColor orangeColor];
            blockc=9;
            break;
            case 10:
            self.blockCol1.backgroundColor = [UIColor brownColor];
            self.blockCol2.backgroundColor = [UIColor brownColor];
            self.blockCol3.backgroundColor = [UIColor brownColor];
            self.blockCol4.backgroundColor = [UIColor brownColor];
            self.blockCol5.backgroundColor = [UIColor brownColor];
            blockc=10;
            break;
            case 11:
            self.blockCol1.backgroundColor = [UIColor purpleColor];
            self.blockCol2.backgroundColor = [UIColor purpleColor];
            self.blockCol3.backgroundColor = [UIColor purpleColor];
            self.blockCol4.backgroundColor = [UIColor purpleColor];
            self.blockCol5.backgroundColor = [UIColor purpleColor];
            blockc=11;
            break;
            case 12:
            self.blockCol1.backgroundColor = [UIColor darkGrayColor];
            self.blockCol2.backgroundColor = [UIColor darkGrayColor];
            self.blockCol3.backgroundColor = [UIColor darkGrayColor];
            self.blockCol4.backgroundColor = [UIColor darkGrayColor];
            self.blockCol5.backgroundColor = [UIColor darkGrayColor];
            blockc=12;
            break;
            case 13:
            self.blockCol1.backgroundColor = [UIColor lightGrayColor];
            self.blockCol2.backgroundColor = [UIColor lightGrayColor];
            self.blockCol3.backgroundColor = [UIColor lightGrayColor];
            self.blockCol4.backgroundColor = [UIColor lightGrayColor];
            self.blockCol5.backgroundColor = [UIColor lightGrayColor];
            blockc=13;
            break;
        }
    }
    int backgr = 14;
        if (pickerView.tag==2) { //backgr
            switch(row)
        { //background
            case 0:
                self.backCol.backgroundColor = [UIColor blackColor];
                backgr=0;
                break;
            case 1:
                self.backCol.backgroundColor = [UIColor blueColor];
                backgr=1;
                break;
            case 2:
                self.backCol.backgroundColor = [UIColor greenColor];
                backgr=2;
                break;
            case 3:
                self.backCol.backgroundColor = [UIColor redColor];
                backgr=3;
                break;
            case 4:
                self.backCol.backgroundColor = [UIColor cyanColor];
                backgr=4;
                break;
            case 5:
                self.backCol.backgroundColor = [UIColor whiteColor];
                backgr=5;
                break;
            case 6:
                self.backCol.backgroundColor = [UIColor yellowColor];
                backgr=6;
                break;
            case 7:
                self.backCol.backgroundColor = [UIColor magentaColor];
                backgr=7;
                break;
            case 8:
                self.backCol.backgroundColor = [UIColor grayColor];
                backgr=8;
                break;
            case 9:
                self.backCol.backgroundColor = [UIColor orangeColor];
                backgr=9;
                break;
            case 10:
                self.backCol.backgroundColor = [UIColor brownColor];
                backgr=10;
                break;
            case 11:
                self.backCol.backgroundColor = [UIColor purpleColor];
                backgr=11;
                break;
            case 12:
                self.backCol.backgroundColor = [UIColor darkGrayColor];
                backgr=12;
                break;
            case 13:
                self.backCol.backgroundColor = [UIColor lightGrayColor];
                backgr=13;
                break;
        }
    }
    int showc=14;
    if (pickerView.tag==1)
        { //show
        switch(row)
        { //show
            case 0:
                self.showCol.backgroundColor = [UIColor blackColor];
                showc=0;
                break;
            case 1:
                self.showCol.backgroundColor = [UIColor blueColor];
                showc=1;
                break;
            case 2:
                self.showCol.backgroundColor = [UIColor greenColor];
                showc=2;
                break;
            case 3:
                self.showCol.backgroundColor = [UIColor redColor];
                showc=3;
                break;
            case 4:
                self.showCol.backgroundColor = [UIColor cyanColor];
                showc=4;
                break;
            case 5:
                self.showCol.backgroundColor = [UIColor whiteColor];
                showc=5;
                break;
            case 6:
                self.showCol.backgroundColor = [UIColor yellowColor];
                showc=6;
                break;
            case 7:
                self.showCol.backgroundColor = [UIColor magentaColor];
                showc=7;
                break;
            case 8:
                self.showCol.backgroundColor = [UIColor grayColor];
                showc=8;
                break;
            case 9:
                self.showCol.backgroundColor = [UIColor orangeColor];
                showc=9;
                break;
            case 10:
                self.showCol.backgroundColor = [UIColor brownColor];
                showc=10;
                break;
            case 11:
                self.showCol.backgroundColor = [UIColor purpleColor];
                showc=11;
                break;
            case 12:
                self.showCol.backgroundColor = [UIColor darkGrayColor];
                showc=12;
                break;
            case 13:
                self.showCol.backgroundColor = [UIColor lightGrayColor];
                showc=13;
                break;
        }
    }
    backBTN.hidden=NO;
    NSString * mess=@"";
    if (backgr == showc) {
        mess=@"Cannot have Show and Background Colours the same";
        backBTN.hidden=YES;
    }
    if (blockc == showc) {
        mess=@"Cannot have Show and Block Colours the same";
        backBTN.hidden=YES;
    }
    if (blockc == backgr) {
        mess=@"Although you can select the same block and background colours, it is not used often due to the unusual effect in a test.";
        backBTN.hidden=NO;
    }
    self.messageTextView.text=mess;
}

@end
