//
//  informationVC.h
//  Tachist
//
//  Created by Jon Howell on 04/09/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface informationVC : UIViewController{
    UITextView *infoTextView;
}

@property (nonatomic,retain) IBOutlet UITextView *infoTextView;

@end
