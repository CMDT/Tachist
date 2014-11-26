//
//  colourSelVC.m
//  Corsi
//
//  Created by Jon Howell on 24/11/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import "colourSelVC.h"
#import "mySingleton.h"

@interface colourSelVC (){
    int showc;          // rows for each colour
    int blockc;
    int backgr;
    NSString * mess;    //message
}

@end

@implementation colourSelVC{
//
}

@synthesize
showPicker, blockPicker, backPicker,
showCol,
backCol,
blockCol1,blockCol2, blockCol3, blockCol4, blockCol5,
colourArrayBack, colourArrayShow, colourArrayBlock, backBTN, messageTextView, images;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mySingleton *singleton = [mySingleton sharedSingleton];
    UIColor * bac;
    bac = (singleton.currentBackgroundColour);
    UIColor * blc;
    blc = (singleton.currentBlockColour);
    UIColor * sho;
    sho = (singleton.currentShowColour);

    backCol.backgroundColor    = bac;
    showCol.backgroundColor    = sho;
    blockCol1.backgroundColor  = blc;
    blockCol2.backgroundColor  = blc;
    blockCol3.backgroundColor  = blc;
    blockCol4.backgroundColor  = blc;
    blockCol5.backgroundColor  = blc;

    self.colourArrayBack  = [[NSArray alloc] initWithObjects:
                             @"Black",          //0 colour number
                             @"Blue",           //1
                             @"Green",          //2
                             @"Red",            //3
                             @"Cyan",           //4
                             @"White",          //5
                             @"Yellow",         //6
                             @"Magenta",        //7
                             @"Gray",           //8
                             @"Orange",         //9
                             @"Brown",          //10
                             @"Purple",         //11
                             @"Dark Gray",      //12
                             @"light Gray",     //13
                             nil
                             ];

    //now copy the array to the other two for the picker controls
    self.colourArrayShow  = [[NSArray alloc] initWithArray:colourArrayBack copyItems:YES];
    self.colourArrayBlock  = [[NSArray alloc] initWithArray:colourArrayBack copyItems:YES];

    [self colourChecks]; //initialise messages after check on combinations

    images =[[NSArray alloc]initWithObjects:
             [[UIImageView alloc] initWithImage:[UIImage
                                                 imageNamed:@"black25.png"]],
             [[UIImageView alloc] initWithImage:[UIImage
                                                 imageNamed:@"blue25.png"]],
             [[UIImageView alloc] initWithImage:[UIImage
                                                 imageNamed:@"green25.png"]],
             [[UIImageView alloc] initWithImage:[UIImage
                                                 imageNamed:@"red25.png"]],
             [[UIImageView alloc] initWithImage:[UIImage
                                                 imageNamed:@"cyan25.png"]],
             [[UIImageView alloc] initWithImage:[UIImage
                                                 imageNamed:@"white25.png"]],
             [[UIImageView alloc] initWithImage:[UIImage
                                                 imageNamed:@"yellow25.png"]],
             [[UIImageView alloc] initWithImage:[UIImage
                                                 imageNamed:@"magenta25.png"]],
             [[UIImageView alloc] initWithImage:[UIImage
                                                 imageNamed:@"gray25.png"]],
             [[UIImageView alloc] initWithImage:[UIImage
                                                 imageNamed:@"orange25.png"]],
             [[UIImageView alloc] initWithImage:[UIImage
                                                 imageNamed:@"brown25.png"]],
             [[UIImageView alloc] initWithImage:[UIImage
                                                 imageNamed:@"darkGray25.png"]],
             [[UIImageView alloc] initWithImage:[UIImage
                                                 imageNamed:@"lightGray25.png"]],
                       nil];
}

-(IBAction)bSpin
{
    mySingleton *singleton = [mySingleton sharedSingleton];
    //need to pick a random value - this returns an int32 //modulus by a number to get the remainder
    //this will be between 0 and number-1
    int value = [self colourUIToString:singleton.currentBackgroundColour];
    [backPicker selectRow:value inComponent:0 animated:YES]; [backPicker reloadComponent: 0];

    value = [self colourUIToString:singleton.currentShowColour];
    [showPicker selectRow:value inComponent:0 animated:YES]; [showPicker reloadComponent: 0];
    
    value = [self colourUIToString:singleton.currentBlockColour];
    [blockPicker selectRow:value inComponent:0 animated:YES]; [blockPicker reloadComponent: 0];
}

-(void)viewDidAppear:(BOOL)animated{
    [self bSpin];

    mySingleton *singleton = [mySingleton sharedSingleton];

    UIColor * bac;
    bac = (singleton.currentBackgroundColour);
    UIColor * blc;
    blc = (singleton.currentBlockColour);
    UIColor * sho;
    sho = (singleton.currentShowColour);

    backCol.backgroundColor    = bac;
    showCol.backgroundColor    = sho;
    blockCol1.backgroundColor  = blc;
    blockCol2.backgroundColor  = blc;
    blockCol3.backgroundColor  = blc;
    blockCol4.backgroundColor  = blc;
    blockCol5.backgroundColor  = blc;


}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 80)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    label.textAlignment=NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%@ %@",  colourArrayBack[row]];

    return label;
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

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    id objectReturn;
    if (pickerView.tag == 0) {
        objectReturn = [colourArrayBack objectAtIndex:row];
    }
    if (pickerView.tag == 1) {
        objectReturn = [colourArrayShow objectAtIndex:row];
    }
    if (pickerView.tag == 2) {
        objectReturn = [colourArrayBlock objectAtIndex:row];
    }
    return objectReturn;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
    {
    backBTN.hidden=NO;

    if (pickerView.tag==0) { //block
    switch(row)
        {
            case 0:
            blockCol1.backgroundColor = [UIColor blackColor];
            blockCol2.backgroundColor = [UIColor blackColor];
            blockCol3.backgroundColor = [UIColor blackColor];
            blockCol4.backgroundColor = [UIColor blackColor];
            blockCol5.backgroundColor = [UIColor blackColor];
            blockc=0;
            break;
            case 1:
            blockCol1.backgroundColor = [UIColor blueColor];
            blockCol2.backgroundColor = [UIColor blueColor];
            blockCol3.backgroundColor = [UIColor blueColor];
            blockCol4.backgroundColor = [UIColor blueColor];
            blockCol5.backgroundColor = [UIColor blueColor];
            blockc=1;
            break;
            case 2:
            blockCol1.backgroundColor = [UIColor greenColor];
            blockCol2.backgroundColor = [UIColor greenColor];
            blockCol3.backgroundColor = [UIColor greenColor];
            blockCol4.backgroundColor = [UIColor greenColor];
            blockCol5.backgroundColor = [UIColor greenColor];
            blockc=2;
            break;
            case 3:
            blockCol1.backgroundColor = [UIColor redColor];
            blockCol2.backgroundColor = [UIColor redColor];
            blockCol3.backgroundColor = [UIColor redColor];
            blockCol4.backgroundColor = [UIColor redColor];
            blockCol5.backgroundColor = [UIColor redColor];
            blockc=3;
            break;
            case 4:
            blockCol1.backgroundColor = [UIColor cyanColor];
            blockCol2.backgroundColor = [UIColor cyanColor];
            blockCol3.backgroundColor = [UIColor cyanColor];
            blockCol4.backgroundColor = [UIColor cyanColor];
            blockCol5.backgroundColor = [UIColor cyanColor];
            blockc=4;
            break;
            case 5:
            blockCol1.backgroundColor = [UIColor whiteColor];
            blockCol2.backgroundColor = [UIColor whiteColor];
            blockCol3.backgroundColor = [UIColor whiteColor];
            blockCol4.backgroundColor = [UIColor whiteColor];
            blockCol5.backgroundColor = [UIColor whiteColor];
            blockc=5;
            break;
            case 6:
            blockCol1.backgroundColor = [UIColor yellowColor];
            blockCol2.backgroundColor = [UIColor yellowColor];
            blockCol3.backgroundColor = [UIColor yellowColor];
            blockCol4.backgroundColor = [UIColor yellowColor];
            blockCol5.backgroundColor = [UIColor yellowColor];
            blockc=6;
            break;
            case 7:
            blockCol1.backgroundColor = [UIColor magentaColor];
            blockCol2.backgroundColor = [UIColor magentaColor];
            blockCol3.backgroundColor = [UIColor magentaColor];
            blockCol4.backgroundColor = [UIColor magentaColor];
            blockCol5.backgroundColor = [UIColor magentaColor];
            blockc=7;
            break;
            case 8:
            blockCol1.backgroundColor = [UIColor grayColor];
            blockCol2.backgroundColor = [UIColor grayColor];
            blockCol3.backgroundColor = [UIColor grayColor];
            blockCol4.backgroundColor = [UIColor grayColor];
            blockCol5.backgroundColor = [UIColor grayColor];
            blockc=8;
            break;
            case 9:
            blockCol1.backgroundColor = [UIColor orangeColor];
            blockCol2.backgroundColor = [UIColor orangeColor];
            blockCol3.backgroundColor = [UIColor orangeColor];
            blockCol4.backgroundColor = [UIColor orangeColor];
            blockCol5.backgroundColor = [UIColor orangeColor];
            blockc=9;
            break;
            case 10:
            blockCol1.backgroundColor = [UIColor brownColor];
            blockCol2.backgroundColor = [UIColor brownColor];
            blockCol3.backgroundColor = [UIColor brownColor];
            blockCol4.backgroundColor = [UIColor brownColor];
            blockCol5.backgroundColor = [UIColor brownColor];
            blockc=10;
            break;
            case 11:
            blockCol1.backgroundColor = [UIColor purpleColor];
            blockCol2.backgroundColor = [UIColor purpleColor];
            blockCol3.backgroundColor = [UIColor purpleColor];
            blockCol4.backgroundColor = [UIColor purpleColor];
            blockCol5.backgroundColor = [UIColor purpleColor];
            blockc=11;
            break;
            case 12:
            blockCol1.backgroundColor = [UIColor darkGrayColor];
            blockCol2.backgroundColor = [UIColor darkGrayColor];
            blockCol3.backgroundColor = [UIColor darkGrayColor];
            blockCol4.backgroundColor = [UIColor darkGrayColor];
            blockCol5.backgroundColor = [UIColor darkGrayColor];
            blockc=12;
            break;
            case 13:
            blockCol1.backgroundColor = [UIColor lightGrayColor];
            blockCol2.backgroundColor = [UIColor lightGrayColor];
            blockCol3.backgroundColor = [UIColor lightGrayColor];
            blockCol4.backgroundColor = [UIColor lightGrayColor];
            blockCol5.backgroundColor = [UIColor lightGrayColor];
            blockc=13;
            break;
            default:
            blockc=16;
        }
    }
    
        if (pickerView.tag==2) { //backgr
            switch(row)
        { //background
            case 0:
                backCol.backgroundColor = [UIColor blackColor];
                backgr=0;
                break;
            case 1:
                backCol.backgroundColor = [UIColor blueColor];
                backgr=1;
                break;
            case 2:
                backCol.backgroundColor = [UIColor greenColor];
                backgr=2;
                break;
            case 3:
                backCol.backgroundColor = [UIColor redColor];
                backgr=3;
                break;
            case 4:
                backCol.backgroundColor = [UIColor cyanColor];
                backgr=4;
                break;
            case 5:
                backCol.backgroundColor = [UIColor whiteColor];
                backgr=5;
                break;
            case 6:
                backCol.backgroundColor = [UIColor yellowColor];
                backgr=6;
                break;
            case 7:
                backCol.backgroundColor = [UIColor magentaColor];
                backgr=7;
                break;
            case 8:
                backCol.backgroundColor = [UIColor grayColor];
                backgr=8;
                break;
            case 9:
                backCol.backgroundColor = [UIColor orangeColor];
                backgr=9;
                break;
            case 10:
                backCol.backgroundColor = [UIColor brownColor];
                backgr=10;
                break;
            case 11:
                backCol.backgroundColor = [UIColor purpleColor];
                backgr=11;
                break;
            case 12:
                backCol.backgroundColor = [UIColor darkGrayColor];
                backgr=12;
                break;
            case 13:
                backCol.backgroundColor = [UIColor lightGrayColor];
                backgr=13;
                break;
            default:
                blockc=15;
        }
    }
    
    if (pickerView.tag==1)
        { //show
        switch(row)
        { //show
            case 0:
                showCol.backgroundColor = [UIColor blackColor];
                showc=0;
                break;
            case 1:
                showCol.backgroundColor = [UIColor blueColor];
                showc=1;
                break;
            case 2:
                showCol.backgroundColor = [UIColor greenColor];
                showc=2;
                break;
            case 3:
                showCol.backgroundColor = [UIColor redColor];
                showc=3;
                break;
            case 4:
                showCol.backgroundColor = [UIColor cyanColor];
                showc=4;
                break;
            case 5:
                showCol.backgroundColor = [UIColor whiteColor];
                showc=5;
                break;
            case 6:
                showCol.backgroundColor = [UIColor yellowColor];
                showc=6;
                break;
            case 7:
                showCol.backgroundColor = [UIColor magentaColor];
                showc=7;
                break;
            case 8:
                showCol.backgroundColor = [UIColor grayColor];
                showc=8;
                break;
            case 9:
                showCol.backgroundColor = [UIColor orangeColor];
                showc=9;
                break;
            case 10:
                showCol.backgroundColor = [UIColor brownColor];
                showc=10;
                break;
            case 11:
                showCol.backgroundColor = [UIColor purpleColor];
                showc=11;
                break;
            case 12:
                showCol.backgroundColor = [UIColor darkGrayColor];
                showc=12;
                break;
            case 13:
                showCol.backgroundColor = [UIColor lightGrayColor];
                showc=13;
                break;
            default:
                blockc=14;
        }
    }
    [self colourChecks];
}

-(UIColor *)numToUIColor:(int)colourNumber{
    UIColor * myColour;
    switch (colourNumber) {
        case 0:
            myColour = [UIColor blackColor];
            break;
        case 1:
            myColour = [UIColor blueColor];
            break;
        case 2:
            myColour = [UIColor greenColor];
            break;
        case 3:
            myColour = [UIColor redColor];
            break;
        case 4:
            myColour = [UIColor cyanColor];
            break;
        case 5:
            myColour = [UIColor whiteColor];
            break;
        case 6:
            myColour = [UIColor yellowColor];
            break;
        case 7:
            myColour = [UIColor magentaColor];
            break;
        case 8:
            myColour = [UIColor grayColor];
            break;
        case 9:
            myColour = [UIColor orangeColor];
            break;
        case 10:
            myColour = [UIColor brownColor];
            break;
        case 11:
            myColour = [UIColor purpleColor];
            break;
        case 12:
            myColour = [UIColor darkGrayColor];
            break;
        case 13:
            myColour = [UIColor lightGrayColor];
            break;
        default:
            break;
    }
    return myColour;
}

-(int)colourUIToString:(UIColor*)myUIColour{
    int myColour;

    //make an array of colour names
    NSArray *items =
    @[
      [UIColor blackColor],
      [UIColor blueColor],
      [UIColor greenColor],
      [UIColor redColor],
      [UIColor cyanColor],
      [UIColor whiteColor],
      [UIColor yellowColor],
      [UIColor magentaColor],
      [UIColor grayColor],
      [UIColor orangeColor],
      [UIColor brownColor],
      [UIColor purpleColor],
      [UIColor darkGrayColor],
      [UIColor lightGrayColor]
      ];
    //find the index value of each
    long item = [items indexOfObject: myUIColour];

    //select the item number
    switch (item) {
        case 0:
            myColour = 0;
            break;
        case 1:

            myColour = 1;
            break;
        case 2:

            myColour = 2;
            break;
        case 3:

            myColour = 3;
            break;
        case 4:

            myColour = 4;
            break;
        case 5:
            // Item 6
            myColour = 5;
            break;
        case 6:
            // Item 7
            myColour = 6;
            break;
        case 7:
            // Item 8
            myColour = 7;
            break;
        case 8:
            // Item 9
            myColour = 8;
            break;
        case 9:
            // Item 10
            myColour = 9;
            break;
        case 10:
            // Item 11
            myColour = 10;
            break;
        case 11:
            // Item 12
            myColour = 11;
            break;
        case 12:
            // Item 13
            myColour = 12;
            break;
        case 13:
            // Item 14
            myColour = 13;
            break;
        default:
            myColour = 0;
            break;
    }
    return myColour;
}


-(void)colourChecks{
    mySingleton *singleton = [mySingleton sharedSingleton];
    BOOL isValidColour = YES;

    backBTN.hidden=NO;
    mess=@"Colour selection valid.";
    messageTextView.backgroundColor=[UIColor greenColor];

    if (backgr == showc) {
        messageTextView.backgroundColor=[UIColor redColor];
        mess=@"Cannot have Show and Background Colours the same";
        backBTN.hidden=YES;
        isValidColour = NO;
    }
    if (blockc == showc) {
        messageTextView.backgroundColor=[UIColor redColor];
        mess=@"Cannot have Show and Block Colours the same";
        backBTN.hidden=YES;
        isValidColour = NO;
    }
    if ((blockc == backgr) && (blockc!=showc)) {
        messageTextView.backgroundColor=[UIColor yellowColor];
        mess=@"Although you can select the same block and background colours, it is not used often due to the unusual effect in a test.";
        backBTN.hidden=NO;
        isValidColour = YES;

    }
    self.messageTextView.text = mess;// display message
    if (isValidColour) {
        //if valid, update singleton colours
        singleton.currentBlockColour=[self numToUIColor:blockc];
        singleton.currentShowColour=[self numToUIColor:showc];
        singleton.currentBackgroundColour=[self numToUIColor:backgr];
    }
}
@end
