//
//  colourVC.m
//  Corsi
//
//  Created by Jonathan Howell on 28/09/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import "colourVC.h"
#import "mySingleton.h"

@interface colourVC ()
{
}
@end

@implementation colourVC

@synthesize
mainColourView, backButton, statusMessage,
b0,b1,b10,b11,b12,b13,b2,b3,b4,b5,b6,b7,b8,b9,
s0,s1,s10,s11,s12,s13,s2,s3,s4,s5,s6,s7,s8,s9,
c0,c1,c10,c11,c12,c13,c2,c3,c4,c5,c6,c7,c8,c9;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    //radio type graphic buttons
    //s0 = [[UIButton alloc] initWithFrame:CGRectMake(0, 80, 30, 30)];
    [s0 setTag:0];
    [s0 setImage:[UIImage imageNamed:@"black72.png"] forState:UIControlStateNormal];
    [s0 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [s0 addTarget:self action:@selector(showSelected:) forControlEvents:UIControlEventTouchUpInside];

    [s1 setTag:1];
    [s1 setImage:[UIImage imageNamed:@"blue72.png"] forState:UIControlStateNormal];
    [s1 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [s1 addTarget:self action:@selector(showSelected:) forControlEvents:UIControlEventTouchUpInside];

    [s2 setTag:2];
    [s2 setImage:[UIImage imageNamed:@"green72.png"] forState:UIControlStateNormal];
    [s2 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [s2 addTarget:self action:@selector(showSelected:) forControlEvents:UIControlEventTouchUpInside];

    [s3 setTag:3];
    [s3 setImage:[UIImage imageNamed:@"red72.png"] forState:UIControlStateNormal];
    [s3 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [s3 addTarget:self action:@selector(showSelected:) forControlEvents:UIControlEventTouchUpInside];

    [s4 setTag:4];
    [s4 setImage:[UIImage imageNamed:@"cyan72.png"] forState:UIControlStateNormal];
    [s4 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [s4 addTarget:self action:@selector(showSelected:) forControlEvents:UIControlEventTouchUpInside];

    [s5 setTag:5];
    [s5 setImage:[UIImage imageNamed:@"white72.png"] forState:UIControlStateNormal];
    [s5 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [s5 addTarget:self action:@selector(showSelected:) forControlEvents:UIControlEventTouchUpInside];

    [s6 setTag:6];
    [s6 setImage:[UIImage imageNamed:@"yellow72.png"] forState:UIControlStateNormal];
    [s6 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [s6 addTarget:self action:@selector(showSelected:) forControlEvents:UIControlEventTouchUpInside];

    [s7 setTag:7];
    [s7 setImage:[UIImage imageNamed:@"magenta72.png"] forState:UIControlStateNormal];
    [s7 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [s7 addTarget:self action:@selector(showSelected:) forControlEvents:UIControlEventTouchUpInside];

    [s8 setTag:8];
    [s8 setImage:[UIImage imageNamed:@"grey72.png"] forState:UIControlStateNormal];
    [s8 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [s8 addTarget:self action:@selector(showSelected:) forControlEvents:UIControlEventTouchUpInside];

    [s9 setTag:9];
    [s9 setImage:[UIImage imageNamed:@"orange72.png"] forState:UIControlStateNormal];
    [s9 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [s9 addTarget:self action:@selector(showSelected:) forControlEvents:UIControlEventTouchUpInside];

    [s10 setTag:10];
    [s10 setImage:[UIImage imageNamed:@"brown72.png"] forState:UIControlStateNormal];
    [s10 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [s10 addTarget:self action:@selector(showSelected:) forControlEvents:UIControlEventTouchUpInside];

    [s11 setTag:11];
    [s11 setImage:[UIImage imageNamed:@"purple72.png"] forState:UIControlStateNormal];
    [s11 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [s11 addTarget:self action:@selector(showSelected:) forControlEvents:UIControlEventTouchUpInside];

    [s12 setTag:12];
    [s12 setImage:[UIImage imageNamed:@"darkgrey72.png"] forState:UIControlStateNormal];
    [s12 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [s12 addTarget:self action:@selector(showSelected:) forControlEvents:UIControlEventTouchUpInside];

    [s13 setTag:13];
    [s13 setImage:[UIImage imageNamed:@"lightgrey72.png"] forState:UIControlStateNormal];
    [s13 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [s13 addTarget:self action:@selector(showSelected:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:s0];
    [self.view addSubview:s1];
    [self.view addSubview:s2];
    [self.view addSubview:s3];
    [self.view addSubview:s4];
    [self.view addSubview:s5];
    [self.view addSubview:s6];
    [self.view addSubview:s7];
    [self.view addSubview:s8];
    [self.view addSubview:s9];
    [self.view addSubview:s10];
    [self.view addSubview:s11];
    [self.view addSubview:s12];
    [self.view addSubview:s13];

    //radio buttons
    //c0 = [[UIButton alloc] initWithFrame:CGRectMake(0, 80, 30, 30)];
    [c0 setTag:0];
    [c0 setImage:[UIImage imageNamed:@"black72.png"] forState:UIControlStateNormal];
    [c0 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [c0 addTarget:self action:@selector(canvasSelected:) forControlEvents:UIControlEventTouchUpInside];

    [c1 setTag:1];
    [c1 setImage:[UIImage imageNamed:@"blue72.png"] forState:UIControlStateNormal];
    [c1 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [c1 addTarget:self action:@selector(canvasSelected:) forControlEvents:UIControlEventTouchUpInside];

    [c2 setTag:2];
    [c2 setImage:[UIImage imageNamed:@"green72.png"] forState:UIControlStateNormal];
    [c2 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [c2 addTarget:self action:@selector(canvasSelected:) forControlEvents:UIControlEventTouchUpInside];

    [c3 setTag:3];
    [c3 setImage:[UIImage imageNamed:@"red72.png"] forState:UIControlStateNormal];
    [c3 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [c3 addTarget:self action:@selector(canvasSelected:) forControlEvents:UIControlEventTouchUpInside];

    [c4 setTag:4];
    [c4 setImage:[UIImage imageNamed:@"cyan72.png"] forState:UIControlStateNormal];
    [c4 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [c4 addTarget:self action:@selector(canvasSelected:) forControlEvents:UIControlEventTouchUpInside];

    [c5 setTag:5];
    [c5 setImage:[UIImage imageNamed:@"white72.png"] forState:UIControlStateNormal];
    [c5 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [c5 addTarget:self action:@selector(canvasSelected:) forControlEvents:UIControlEventTouchUpInside];

    [c6 setTag:6];
    [c6 setImage:[UIImage imageNamed:@"yellow72.png"] forState:UIControlStateNormal];
    [c6 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [c6 addTarget:self action:@selector(canvasSelected:) forControlEvents:UIControlEventTouchUpInside];

    [c7 setTag:7];
    [c7 setImage:[UIImage imageNamed:@"magenta72.png"] forState:UIControlStateNormal];
    [c7 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [c7 addTarget:self action:@selector(canvasSelected:) forControlEvents:UIControlEventTouchUpInside];

    [c8 setTag:8];
    [c8 setImage:[UIImage imageNamed:@"grey72.png"] forState:UIControlStateNormal];
    [c8 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [c8 addTarget:self action:@selector(canvasSelected:) forControlEvents:UIControlEventTouchUpInside];

    [c9 setTag:9];
    [c9 setImage:[UIImage imageNamed:@"orange72.png"] forState:UIControlStateNormal];
    [c9 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [c9 addTarget:self action:@selector(canvasSelected:) forControlEvents:UIControlEventTouchUpInside];

    [c10 setTag:10];
    [c10 setImage:[UIImage imageNamed:@"brown72.png"] forState:UIControlStateNormal];
    [c10 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [c10 addTarget:self action:@selector(canvasSelected:) forControlEvents:UIControlEventTouchUpInside];

    [c11 setTag:11];
    [c11 setImage:[UIImage imageNamed:@"purple72.png"] forState:UIControlStateNormal];
    [c11 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [c11 addTarget:self action:@selector(canvasSelected:) forControlEvents:UIControlEventTouchUpInside];

    [c12 setTag:12];
    [c12 setImage:[UIImage imageNamed:@"darkgrey72.png"] forState:UIControlStateNormal];
    [c12 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [c12 addTarget:self action:@selector(canvasSelected:) forControlEvents:UIControlEventTouchUpInside];

    [c13 setTag:13];
    [c13 setImage:[UIImage imageNamed:@"lightgrey72.png"] forState:UIControlStateNormal];
    [c13 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [c13 addTarget:self action:@selector(canvasSelected:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:c0];
    [self.view addSubview:c1];
    [self.view addSubview:c2];
    [self.view addSubview:c3];
    [self.view addSubview:c4];
    [self.view addSubview:c5];
    [self.view addSubview:c6];
    [self.view addSubview:c7];
    [self.view addSubview:c8];
    [self.view addSubview:c9];
    [self.view addSubview:c10];
    [self.view addSubview:c11];
    [self.view addSubview:c12];
    [self.view addSubview:c13];

    //radio buttons
    //b0 = [[UIButton alloc] initWithFrame:CGRectMake(0, 80, 30, 30)];
    [b0 setTag:0];
    [b0 setImage:[UIImage imageNamed:@"black72.png"] forState:UIControlStateNormal];
    [b0 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [b0 addTarget:self action:@selector(blockSelected:) forControlEvents:UIControlEventTouchUpInside];

    [b1 setTag:1];
    [b1 setImage:[UIImage imageNamed:@"blue72.png"] forState:UIControlStateNormal];
    [b1 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [b1 addTarget:self action:@selector(blockSelected:)forControlEvents:UIControlEventTouchUpInside];

    [b2 setTag:2];
    [b2 setImage:[UIImage imageNamed:@"green72.png"] forState:UIControlStateNormal];
    [b2 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [b2 addTarget:self action:@selector(blockSelected:)forControlEvents:UIControlEventTouchUpInside];

    [b3 setTag:3];
    [b3 setImage:[UIImage imageNamed:@"red72.png"] forState:UIControlStateNormal];
    [b3 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [b3 addTarget:self action:@selector(blockSelected:) forControlEvents:UIControlEventTouchUpInside];

    [b4 setTag:4];
    [b4 setImage:[UIImage imageNamed:@"cyan72.png"] forState:UIControlStateNormal];
    [b4 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [b4 addTarget:self action:@selector(blockSelected:) forControlEvents:UIControlEventTouchUpInside];

    [b5 setTag:5];
    [b5 setImage:[UIImage imageNamed:@"white72.png"] forState:UIControlStateNormal];
    [b5 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [b5 addTarget:self action:@selector(blockSelected:)forControlEvents:UIControlEventTouchUpInside];

    [b6 setTag:6];
    [b6 setImage:[UIImage imageNamed:@"yellow72.png"] forState:UIControlStateNormal];
    [b6 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [b6 addTarget:self action:@selector(blockSelected:) forControlEvents:UIControlEventTouchUpInside];

    [b7 setTag:7];
    [b7 setImage:[UIImage imageNamed:@"magenta72.png"] forState:UIControlStateNormal];
    [b7 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [b7 addTarget:self action:@selector(blockSelected:) forControlEvents:UIControlEventTouchUpInside];

    [b8 setTag:8];
    [b8 setImage:[UIImage imageNamed:@"grey72.png"] forState:UIControlStateNormal];
    [b8 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [b8 addTarget:self action:@selector(blockSelected:) forControlEvents:UIControlEventTouchUpInside];

    [b9 setTag:9];
    [b9 setImage:[UIImage imageNamed:@"orange72.png"] forState:UIControlStateNormal];
    [b9 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [b9 addTarget:self action:@selector(blockSelected:)forControlEvents:UIControlEventTouchUpInside];

    [b10 setTag:10];
    [b10 setImage:[UIImage imageNamed:@"brown72.png"] forState:UIControlStateNormal];
    [b10 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [b10 addTarget:self action:@selector(blockSelected:) forControlEvents:UIControlEventTouchUpInside];

    [b11 setTag:11];
    [b11 setImage:[UIImage imageNamed:@"purple72.png"] forState:UIControlStateNormal];
    [b11 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [b11 addTarget:self action:@selector(blockSelected:) forControlEvents:UIControlEventTouchUpInside];

    [b12 setTag:12];
    [b12 setImage:[UIImage imageNamed:@"darkgrey72.png"] forState:UIControlStateNormal];
    [b12 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [b12 addTarget:self action:@selector(blockSelected:)forControlEvents:UIControlEventTouchUpInside];

    [b13 setTag:13];
    [b13 setImage:[UIImage imageNamed:@"lightgrey72.png"] forState:UIControlStateNormal];
    [b13 setImage:[UIImage imageNamed:@"check72grey.png"] forState:UIControlStateSelected];
    [b13 addTarget:self action:@selector(blockSelected:)forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:b0];
    [self.view addSubview:b1];
    [self.view addSubview:b2];
    [self.view addSubview:b3];
    [self.view addSubview:b4];
    [self.view addSubview:b5];
    [self.view addSubview:b6];
    [self.view addSubview:b7];
    [self.view addSubview:b8];
    [self.view addSubview:b9];
    [self.view addSubview:b10];
    [self.view addSubview:b11];
    [self.view addSubview:b12];
    [self.view addSubview:b13];

    [self showCurrentBlock];
    [self showCurrentShow];
    [self showCurrentCanvas];
}
-(void)showSelectedCase:(int)block{
    [s0 setSelected:NO];
    [s1 setSelected:NO];
    [s2 setSelected:NO];
    [s3 setSelected:NO];
    [s4 setSelected:NO];
    [s5 setSelected:NO];
    [s6 setSelected:NO];
    [s7 setSelected:NO];
    [s8 setSelected:NO];
    [s9 setSelected:NO];
    [s10 setSelected:NO];
    [s11 setSelected:NO];
    [s12 setSelected:NO];
    [s13 setSelected:NO];
    
    switch (block) {
        case 0:
            [s0 setSelected:YES];
            break;
        case 1:
            [s1 setSelected:YES];
            break;
        case 2:
            [s2 setSelected:YES];
            break;
        case 3:
            [s3 setSelected:YES];
            break;
        case 4:
            [s4 setSelected:YES];
            break;
        case 5:
            [s5 setSelected:YES];
            break;
        case 6:
            [s6 setSelected:YES];
            break;
        case 7:
            [s7 setSelected:YES];
            break;
        case 8:
            [s8 setSelected:YES];
            break;
        case 9:
            [s9 setSelected:YES];
            break;
        case 10:
            [s10 setSelected:YES];
            break;
        case 11:
            [s11 setSelected:YES];
            break;
        case 12:
            [s12 setSelected:YES];
            break;
        case 13:
            [s13 setSelected:YES];
            break;
        default:
            break;
    }
}


-(void)showSelected:(id)sender{
    switch ([sender tag]) {
    case 0:
        [self showSelectedCase:0];
        break;
    case 1:
            [self showSelectedCase:1];
        break;
    case 2:
            [self showSelectedCase:2];
        break;
    case 3:
            [self showSelectedCase:3];
        break;
    case 4:
            [self showSelectedCase:4];
        break;
    case 5:
            [self showSelectedCase:5];
        break;
    case 6:
            [self showSelectedCase:6];
        break;
    case 7:
            [self showSelectedCase:7];
        break;
    case 8:
            [self showSelectedCase:8];
        break;
    case 9:
            [self showSelectedCase:9];
        break;
    case 10:
            [self showSelectedCase:10];
        break;
    case 11:
            [self showSelectedCase:11];
        break;
    case 12:
            [self showSelectedCase:12];
        break;
    case 13:
            [self showSelectedCase:13];
        break;
    default:
    // do nothing
        break;
    }
}

-(void)canvasSelectedCase:(int)block{
    [c0 setSelected:NO];
    [c1 setSelected:NO];
    [c2 setSelected:NO];
    [c3 setSelected:NO];
    [c4 setSelected:NO];
    [c5 setSelected:NO];
    [c6 setSelected:NO];
    [c7 setSelected:NO];
    [c8 setSelected:NO];
    [c9 setSelected:NO];
    [c10 setSelected:NO];
    [c11 setSelected:NO];
    [c12 setSelected:NO];
    [c13 setSelected:NO];
    
    switch (block) {
        case 0:
            [c0 setSelected:YES];
            break;
        case 1:
            [c1 setSelected:YES];
            break;
        case 2:
            [c2 setSelected:YES];
            break;
        case 3:
            [c3 setSelected:YES];
            break;
        case 4:
            [c4 setSelected:YES];
            break;
        case 5:
            [c5 setSelected:YES];
            break;
        case 6:
            [c6 setSelected:YES];
            break;
        case 7:
            [c7 setSelected:YES];
            break;
        case 8:
            [c8 setSelected:YES];
            break;
        case 9:
            [c9 setSelected:YES];
            break;
        case 10:
            [c10 setSelected:YES];
            break;
        case 11:
            [c11 setSelected:YES];
            break;
        case 12:
            [c12 setSelected:YES];
            break;
        case 13:
            [c13 setSelected:YES];
            break;
        default:
            break;
    }
}


-(void)canvasSelected:(id)sender{
    switch ([sender tag]) {
        case 0:
            [self canvasSelectedCase:0];
            break;
        case 1:
            [self canvasSelectedCase:1];
            break;
        case 2:
            [self canvasSelectedCase:2];
            break;
        case 3:
            [self canvasSelectedCase:3];
            break;
        case 4:
            [self canvasSelectedCase:4];
            break;
        case 5:
            [self canvasSelectedCase:5];
            break;
        case 6:
            [self canvasSelectedCase:6];
            break;
        case 7:
            [self canvasSelectedCase:7];
            break;
        case 8:
            [self canvasSelectedCase:8];
            break;
        case 9:
            [self canvasSelectedCase:9];
            break;
        case 10:
            [self canvasSelectedCase:10];
            break;
        case 11:
            [self canvasSelectedCase:11];
            break;
        case 12:
            [self canvasSelectedCase:12];
            break;
        case 13:
            [self canvasSelectedCase:13];
            break;
        default:
            // do nothing
            break;
    }
}

-(void)blockSelectedCase:(int)block{
    [b0 setSelected:NO];
    [b1 setSelected:NO];
    [b2 setSelected:NO];
    [b3 setSelected:NO];
    [b4 setSelected:NO];
    [b5 setSelected:NO];
    [b6 setSelected:NO];
    [b7 setSelected:NO];
    [b8 setSelected:NO];
    [b9 setSelected:NO];
    [b10 setSelected:NO];
    [b11 setSelected:NO];
    [b12 setSelected:NO];
    [b13 setSelected:NO];
    
    switch (block) {
        case 0:
            [b0 setSelected:YES];
            break;
        case 1:
            [b1 setSelected:YES];
            break;
        case 2:
            [b2 setSelected:YES];
            break;
        case 3:
            [b3 setSelected:YES];
            break;
        case 4:
            [b4 setSelected:YES];
            break;
        case 5:
            [b5 setSelected:YES];
            break;
        case 6:
            [b6 setSelected:YES];
            break;
        case 7:
            [b7 setSelected:YES];
            break;
        case 8:
            [b8 setSelected:YES];
            break;
        case 9:
            [b9 setSelected:YES];
            break;
        case 10:
            [b10 setSelected:YES];
            break;
        case 11:
            [b11 setSelected:YES];
            break;
        case 12:
            [b12 setSelected:YES];
            break;
        case 13:
            [b13 setSelected:YES];
            break;
        default:
            break;
    }
}

-(void)blockSelected:(id)sender{
    switch ([sender tag]) {
        case 0:
            [self blockSelectedCase:0];
            break;
        case 1:
            [self blockSelectedCase:1];
            break;
        case 2:
            [self blockSelectedCase:2];
            break;
        case 3:
            [self blockSelectedCase:3];
            break;
        case 4:
            [self blockSelectedCase:4];
            break;
        case 5:
            [self blockSelectedCase:5];
            break;
        case 6:
            [self blockSelectedCase:6];
            break;
        case 7:
            [self blockSelectedCase:7];
            break;
        case 8:
            [self blockSelectedCase:8];
            break;
        case 9:
            [self blockSelectedCase:9];
            break;
        case 10:
            [self blockSelectedCase:10];
            break;
        case 11:
            [self blockSelectedCase:11];
            break;
        case 12:
            [self blockSelectedCase:12];
            break;
        case 13:
            [self blockSelectedCase:13];
            break;
        default:
            // do nothing
            break;
    }
}

-(void)showCurrentShow {
    mySingleton *singleton = [mySingleton sharedSingleton];

    UIColor *colour = singleton.currentShowColour;

    if (colour==[UIColor blackColor]) {
        [s0 setSelected:YES];
    }
    if (colour==[UIColor blueColor]) {
        [s1 setSelected:YES];
    }
    if (colour==[UIColor greenColor]) {
        [s2 setSelected:YES];
    }
    if (colour==[UIColor redColor]) {
        [s3 setSelected:YES];
    }
    if (colour==[UIColor cyanColor]) {
        [s4 setSelected:YES];
    }
    if (colour==[UIColor whiteColor]) {
        [s5 setSelected:YES];
    }
    if (colour==[UIColor yellowColor]) {
        [s6 setSelected:YES];
    }
    if (colour==[UIColor magentaColor]) {
        [s7 setSelected:YES];
    }
    if (colour==[UIColor grayColor]) {
        [s8 setSelected:YES];
    }
    if (colour==[UIColor orangeColor]) {
        [s9 setSelected:YES];
    }
    if (colour==[UIColor brownColor]) {
        [s10 setSelected:YES];
    }
    if (colour==[UIColor purpleColor]) {
        [s11 setSelected:YES];
    }
    if (colour==[UIColor darkGrayColor]) {
        [s12 setSelected:YES];
    }
    if (colour==[UIColor lightGrayColor]) {
        [s13 setSelected:YES];
    }
}
-(void)showCurrentCanvas {
    mySingleton *singleton = [mySingleton sharedSingleton];

    UIColor *colour = singleton.currentBackgroundColour;

    if (colour==[UIColor blackColor]) {
        [c0 setSelected:YES];
    }
    if (colour==[UIColor blueColor]) {
        [c1 setSelected:YES];
    }
    if (colour==[UIColor greenColor]) {
        [c2 setSelected:YES];
    }
    if (colour==[UIColor redColor]) {
        [c3 setSelected:YES];
    }
    if (colour==[UIColor cyanColor]) {
        [c4 setSelected:YES];
    }
    if (colour==[UIColor whiteColor]) {
        [c5 setSelected:YES];
    }
    if (colour==[UIColor yellowColor]) {
        [c6 setSelected:YES];
    }
    if (colour==[UIColor magentaColor]) {
        [c7 setSelected:YES];
    }
    if (colour==[UIColor grayColor]) {
        [c8 setSelected:YES];
    }
    if (colour==[UIColor orangeColor]) {
        [c9 setSelected:YES];
    }
    if (colour==[UIColor brownColor]) {
        [c10 setSelected:YES];
    }
    if (colour==[UIColor purpleColor]) {
        [c11 setSelected:YES];
    }
    if (colour==[UIColor darkGrayColor]) {
        [c12 setSelected:YES];
    }
    if (colour==[UIColor lightGrayColor]) {
        [c13 setSelected:YES];
    }
}
-(void)showCurrentBlock {
    mySingleton *singleton = [mySingleton sharedSingleton];

    UIColor *colour = singleton.currentBlockColour;

    if (colour==[UIColor blackColor]) {
        [b0 setSelected:YES];
    }
    if (colour==[UIColor blueColor]) {
        [b1 setSelected:YES];
    }
    if (colour==[UIColor greenColor]) {
        [b2 setSelected:YES];
    }
    if (colour==[UIColor redColor]) {
        [b3 setSelected:YES];
    }
    if (colour==[UIColor cyanColor]) {
        [b4 setSelected:YES];
    }
    if (colour==[UIColor whiteColor]) {
        [b5 setSelected:YES];
    }
    if (colour==[UIColor yellowColor]) {
        [b6 setSelected:YES];
    }
    if (colour==[UIColor magentaColor]) {
        [b7 setSelected:YES];
    }
    if (colour==[UIColor grayColor]) {
        [b8 setSelected:YES];
    }
    if (colour==[UIColor orangeColor]) {
        [b9 setSelected:YES];
    }
    if (colour==[UIColor brownColor]) {
        [b10 setSelected:YES];
    }
    if (colour==[UIColor purpleColor]) {
        [b11 setSelected:YES];
    }
    if (colour==[UIColor darkGrayColor]) {
        [b12 setSelected:YES];
    }
    if (colour==[UIColor lightGrayColor]) {
        [b13 setSelected:YES];
    }
}

#pragma mark Block Colours Setting Actions
- (IBAction)BlockColourBlaBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentBlockColour=[UIColor blackColor];
    [self checkColourCombinations];
}
- (IBAction)BlockColourBluBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentBlockColour=[UIColor blueColor];
    [self checkColourCombinations];
}
- (IBAction)BlockColourRedBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentBlockColour=[UIColor redColor];
    [self checkColourCombinations];
}
- (IBAction)BlockColourOraBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentBlockColour=[UIColor orangeColor];
    [self checkColourCombinations];
}
- (IBAction)BlockColourGreBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentBlockColour=[UIColor greenColor];
    [self checkColourCombinations];
}
- (IBAction)BlockColourYelBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentBlockColour=[UIColor yellowColor];
    [self checkColourCombinations];
}
- (IBAction)BlockColourMagBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentBlockColour=[UIColor magentaColor];
    [self checkColourCombinations];
}
- (IBAction)BlockColourGraBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentBlockColour=[UIColor grayColor];
    [self checkColourCombinations];
}
- (IBAction)BlockColourWhiBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentBlockColour=[UIColor whiteColor];
    [self checkColourCombinations];
}
- (IBAction)BlockColourCyaBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentBlockColour=[UIColor cyanColor];
    [self checkColourCombinations];
}
- (IBAction)BlockColourPurBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentBlockColour=[UIColor purpleColor];
    [self checkColourCombinations];
}
- (IBAction)BlockColourBroBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentBlockColour=[UIColor brownColor];
    [self checkColourCombinations];
}
- (IBAction)BlockColourDkGBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentBlockColour=[UIColor darkGrayColor];
    [self checkColourCombinations];
}
- (IBAction)BlockColourLtGBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentBlockColour=[UIColor lightGrayColor];
    [self checkColourCombinations];
}

#pragma mark Show Highlight Colours Setting Actions
- (IBAction)BlockHighlightColourBlaBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentShowColour=[UIColor blackColor];
    [self checkColourCombinations];
}
- (IBAction)BlockHighlightColourGraBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentShowColour=[UIColor grayColor];
    [self checkColourCombinations];
}
- (IBAction)BlockHighlightColourBluBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentShowColour=[UIColor blueColor];
    [self checkColourCombinations];
}
- (IBAction)BlockHighlightColourRedBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentShowColour=[UIColor redColor];
    [self checkColourCombinations];
}
- (IBAction)BlockHighlightColourOraBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentShowColour=[UIColor orangeColor];
    [self checkColourCombinations];
}
- (IBAction)BlockHighlightColourMagBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];

    singleton.currentShowColour=[UIColor magentaColor];
    [self checkColourCombinations];
}
- (IBAction)BlockHighlightColourGreBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentShowColour=[UIColor greenColor];
    [self checkColourCombinations];
}
- (IBAction)BlockHighlightColourCyaBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentShowColour=[UIColor cyanColor];
    [self checkColourCombinations];
}
- (IBAction)BlockHighlightColourYelBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentShowColour=[UIColor yellowColor];
    [self checkColourCombinations];
}
- (IBAction)BlockHighlightColourWhiBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentShowColour=[UIColor whiteColor];
    [self checkColourCombinations];
}

- (IBAction)BlockHighlightColourPurBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentShowColour=[UIColor purpleColor];
    [self checkColourCombinations];
}
- (IBAction)BlockHighlightColourBroBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentShowColour=[UIColor brownColor];
    [self checkColourCombinations];
}
- (IBAction)BlockHighlightColourDkGBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentShowColour=[UIColor darkGrayColor];
    [self checkColourCombinations];
}
- (IBAction)BlockHighlightColourLtGBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentShowColour=[UIColor lightGrayColor];
    [self checkColourCombinations];
}
#pragma mark Background Colours Setting Actions

- (IBAction)BlockBackgroundColourBlaBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentStatusColour=[UIColor yellowColor];
    singleton.currentBackgroundColour=[UIColor blackColor];
    [self checkColourCombinations];
}
- (IBAction)BlockBackgroundColourGraBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentStatusColour=[UIColor blackColor];
    singleton.currentBackgroundColour=[UIColor grayColor];
    [self checkColourCombinations];
}
- (IBAction)BlockBackgroundColourBluBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentStatusColour=[UIColor whiteColor];
    singleton.currentBackgroundColour=[UIColor blueColor];
    [self checkColourCombinations];
}
- (IBAction)BlockBackgroundColourRedBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentStatusColour=[UIColor yellowColor];
    singleton.currentBackgroundColour=[UIColor redColor];
    [self checkColourCombinations];
}
- (IBAction)BlockBackgroundColourOraBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentStatusColour=[UIColor blackColor];
    singleton.currentBackgroundColour=[UIColor orangeColor];
    [self checkColourCombinations];
}
- (IBAction)BlockBackgroundColourGreBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentStatusColour=[UIColor blackColor];
    singleton.currentBackgroundColour=[UIColor greenColor];
    [self checkColourCombinations];
}
- (IBAction)BlockBackgroundColourCyaBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentStatusColour=[UIColor blackColor];
    singleton.currentBackgroundColour=[UIColor cyanColor];
    [self checkColourCombinations];
}
- (IBAction)BlockBackgroundColourYelBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentStatusColour=[UIColor blueColor];
    singleton.currentBackgroundColour=[UIColor yellowColor];
    [self checkColourCombinations];
}
- (IBAction)BlockBackgroundColourWhiBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentStatusColour=[UIColor blueColor];
    singleton.currentBackgroundColour=[UIColor whiteColor];
    [self checkColourCombinations];
}
- (IBAction)BlockBackgroundColourPurBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentStatusColour=[UIColor whiteColor];
    singleton.currentBackgroundColour=[UIColor purpleColor];
    [self checkColourCombinations];
}
- (IBAction)BlockBackgroundColourMagBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
        singleton.currentStatusColour=[UIColor blackColor];
    singleton.currentBackgroundColour=[UIColor magentaColor];
    [self checkColourCombinations];
}
- (IBAction)BlockBackgroundColourBroBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentStatusColour=[UIColor yellowColor];
    singleton.currentBackgroundColour=[UIColor brownColor];
    [self checkColourCombinations];
}
- (IBAction)BlockBackgroundColourDkGBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentStatusColour=[UIColor whiteColor];
    singleton.currentBackgroundColour=[UIColor darkGrayColor];
    [self checkColourCombinations];
}
- (IBAction)BlockBackgroundColourLtGBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.currentStatusColour=[UIColor blackColor];
    singleton.currentBackgroundColour=[UIColor lightGrayColor];
    [self checkColourCombinations];
}

-(void)checkColourCombinations{
//check colour combinations, and if OK, allow back button
    mySingleton *singleton = [mySingleton sharedSingleton];
    BOOL isColourOK = YES;

    if(singleton.currentBackgroundColour == singleton.currentShowColour){
        //cant have background and show the same
        statusMessage.text=@"Canvas and Show Colours must be different";
        statusMessage.textAlignment=NSTextAlignmentCenter;
        statusMessage.backgroundColor=[UIColor clearColor];
        statusMessage.textColor=[UIColor redColor];
        isColourOK = NO;
    }
    if(singleton.currentBlockColour == singleton.currentShowColour){
        //cant have block and show the same
        statusMessage.text=@"Block and Show Colours must be different";
        statusMessage.textAlignment=NSTextAlignmentCenter;
        statusMessage.backgroundColor=[UIColor clearColor];
        statusMessage.textColor=[UIColor redColor];
        isColourOK = NO;
    }
    //allowing block and background to be same for extra options of scene display with animals or invisible block test
    
    //if(singleton.currentBlockColour == singleton.currentBackgroundColour){
        //cant have block and backgrond the same
        //statusMessage.text=@"Canvas and Block Colours must be different";
        //statusMessage.textAlignment=NSTextAlignmentCenter;
        //statusMessage.backgroundColor=[UIColor clearColor];
        //statusMessage.textColor=[UIColor redColor];
        //isColourOK = NO;
    //}
    
    if(isColourOK){
        backButton.hidden=NO;
        statusMessage.hidden=YES;
    } else {
        backButton.hidden=YES;
        statusMessage.hidden=NO;
    }
}
@end
