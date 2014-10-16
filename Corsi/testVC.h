//
//  testVC.h
//  Corsi
//
//  Created by Jon Howell on 04/09/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface testVC : UIViewController{

}
@property (retain, nonatomic) IBOutlet UILabel *headingLBL;
@property (retain, nonatomic) IBOutlet UILabel *statusMessageLBL;
@property (retain, nonatomic) IBOutlet UIImageView *MessageView;
@property (retain, nonatomic) IBOutlet UITextView *MessageTextView;

//labels for the stages, hide if not needed
@property (retain, nonatomic) IBOutlet UILabel *blkLBL;
@property (retain, nonatomic) IBOutlet UILabel *blkNoLBL;
@property (retain, nonatomic) IBOutlet UILabel *blkOfLBL;
@property (retain, nonatomic) IBOutlet UILabel *blkTotalLBL;

//labels for the stages if needed, hide if not
@property (retain, nonatomic) IBOutlet UILabel *setLBL;
@property (retain, nonatomic) IBOutlet UILabel *setNoLBL;
@property (retain, nonatomic) IBOutlet UILabel *setOfLBL;
@property (retain, nonatomic) IBOutlet UILabel *setTotalLBL;

//buttons over images
@property (strong, nonatomic) IBOutlet UIButton *box1BTN;
@property (strong, nonatomic) IBOutlet UIButton *box2BTN;
@property (strong, nonatomic) IBOutlet UIButton *box3BTN;
@property (strong, nonatomic) IBOutlet UIButton *box4BTN;
@property (strong, nonatomic) IBOutlet UIButton *box5BTN;
@property (strong, nonatomic) IBOutlet UIButton *box6BTN;
@property (strong, nonatomic) IBOutlet UIButton *box7BTN;
@property (strong, nonatomic) IBOutlet UIButton *box8BTN;
@property (strong, nonatomic) IBOutlet UIButton *box9BTN;

//buttons for control
@property (strong, nonatomic) IBOutlet UIButton *startBTN;

//images for the boxes
@property (strong, nonatomic) IBOutlet UIView  *box1image;
@property (strong, nonatomic) IBOutlet UIView  *box2image;
@property (strong, nonatomic) IBOutlet UIView  *box3image;
@property (strong, nonatomic) IBOutlet UIView  *box4image;
@property (strong, nonatomic) IBOutlet UIView  *box5image;
@property (strong, nonatomic) IBOutlet UIView  *box6image;
@property (strong, nonatomic) IBOutlet UIView  *box7image;
@property (strong, nonatomic) IBOutlet UIView  *box8image;
@property (strong, nonatomic) IBOutlet UIView  *box9image;
@property (strong, nonatomic) IBOutlet UIView *testViewerView;

-(IBAction)startTest:(id)sender;

-(void)randomise_boxes;
-(void)display_blocks;
-(void)hide_blocks;
-(void)showInfo;
-(void)hideInfo;
-(void)awakeFromNib;

-(float) delayDelay;
-(float) delayWait;
-(float) delayShow;

-(NSString*) make9order;

-(int)pickABox;

-(void)box1;
-(void)box2;
-(void)box3;
-(void)box4;
-(void)box5;
-(void)box6;
-(void)box7;
-(void)box8;
-(void)box9;

-(void)but1;
-(void)but2;
-(void)but3;
-(void)but4;
-(void)but5;
-(void)but6;
-(void)but7;
-(void)but8;
-(void)but9;

-(void)nextStage;
-(void)stageEnd;
-(void)endTests;




@end
