//
//  colourSelVC.h
//  Corsi
//
//  Created by Jon Howell on 24/11/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface colourSelVC : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView * backPicker;
@property (strong, nonatomic) IBOutlet UIPickerView * showPicker;
@property (strong, nonatomic) IBOutlet UIPickerView * blockPicker;
@property (strong, nonatomic) IBOutlet UITextView   * messageTextView;

@property (strong, nonatomic) IBOutlet UIImageView  * backCol;
@property (strong, nonatomic) IBOutlet UIImageView  * showCol;
@property (strong, nonatomic) IBOutlet UIImageView  * blockCol;

@property (strong, nonatomic)          NSArray      * colourArrayBack;
@property (strong, nonatomic)          NSArray      * colourArrayShow;
@property (strong, nonatomic)          NSArray      * colourArrayBlock;

@end
