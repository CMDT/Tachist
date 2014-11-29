//
//  detailsVC.h
//  Tachist
//
//  Created by Jonathan Howell on 14/11/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailsVC : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField * testerNameTXT;
@property (strong, nonatomic) IBOutlet UITextField * emailTXT;
@property (strong, nonatomic) IBOutlet UITextField * participantTXT;

@end
