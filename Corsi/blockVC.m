//
//  blockVC.m
//  Corsi
//
//  Created by Jonathan Howell on 28/09/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import "blockVC.h"
#import "mySingleton.h"

@interface blockVC ()

@end

@implementation blockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark Settings Actions Buttons
/*- (IBAction)blockStartPlusBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    start++;
    startMinusBTN.alpha=1;
    startPlusBTN.alpha=1;
    if (start>=9) {
        start=9;
        startPlusBTN.alpha=0.3;
    }else{

        startMinusBTN.alpha=1;
    }
    if (finish<=start) {
        finish=start;
        startPlusBTN.alpha=0.3;
    }
    if (finish>=9) {
        finishPlusBTN.alpha=0.3;
    }
    singleton.start=start;
    [self updateSizesOfBlocks];
    [self updateBlockNumbers];
}
- (IBAction)blockFinishPlusBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    finish++;
    finishMinusBTN.alpha=1;
    finishPlusBTN.alpha=1;
    if (finish>=9) {
        finishPlusBTN.alpha=0.3;
        finish=9;
    }else{
        finishMinusBTN.alpha=1;
    }
    if (start>=finish) {
        start=finish;
        finishPlusBTN.alpha=0.3;
    }
    if (start>=9) {
        startPlusBTN.alpha=0.3;
    }
    singleton.finish=finish;
    [self updateSizesOfBlocks];
    [self updateBlockNumbers];
}

- (IBAction)blockSizePlusBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    blockSize=blockSize+5;
    sizeMinusBTN.alpha=1;
    sizePlusBTN.alpha=1;
    if (blockSize>55) {
        sizePlusBTN.alpha=0.3;
        blockSize=55;
    }else{
        sizeMinusBTN.alpha=1;
    }
    singleton.blockSize=blockSize;
    [self updateSizesOfBlocks];
    [self updateBlockNumbers];


}
- (IBAction)blockStartMinusBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    start--;
    startMinusBTN.alpha=1;
    startPlusBTN.alpha=1;
    if (start<=3) {
        startMinusBTN.alpha=0.3;
        start=3;
    }else{
        startPlusBTN.alpha=1;
    }
    if (finish<=start) {
        finish=start;
        startMinusBTN.alpha=0.3;
    }
    if (finish<=3) {
        finishMinusBTN.alpha=0.3;
    }
    singleton.start=start;
    [self updateSizesOfBlocks];
    [self updateBlockNumbers];
}
- (IBAction)blockFinishMinusBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    finish--;
    finishMinusBTN.alpha=1;
    finishPlusBTN.alpha=1;
    if (finish<=3) {
        finishMinusBTN.alpha=0.3;
        finish=3;
    }else{
        finishPlusBTN.alpha=1;
    }
    if (start>=finish) {
        finish=start;
        finishMinusBTN.alpha=0.3;
    }
    if (start<=3) {
        startMinusBTN.alpha=0.3;
    }
    singleton.finish=finish;
    [self updateSizesOfBlocks];
    [self updateBlockNumbers];
}
- (IBAction)blockSizeMinusBTN:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    blockSize=blockSize-5;
    sizeMinusBTN.alpha=1;
    sizePlusBTN.alpha=1;
    if (blockSize<10) {
        sizeMinusBTN.alpha=0.3;
        blockSize=10;
    }else{
        sizePlusBTN.alpha=1;
    }
    singleton.blockSize=blockSize;
    [self updateSizesOfBlocks];
    [self updateBlockNumbers];

}

- (IBAction)forwardTestSWT:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    if(forwardTestSWT.isOn){
        forwardTestDirection=YES;
    }else{
        forwardTestDirection=NO;
    }
    singleton.forwardTestDirection=forwardTestDirection;
}
- (IBAction)onScreenInfoSWT:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    if(onScreenInfoSWT.isOn){
        screenInfoDisplayed=YES;

    }else{
        screenInfoDisplayed=NO;
    }
    singleton.onScreenInfo=screenInfoDisplayed;
}
- (IBAction)blockRotateSWT:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    BOOL rotate;
    if (blockRotateSWT.isOn)
        {
        //arbitary rotate from current position to new position, don't care about absolute angle
        //[self updateSizesOfBlocks];
        [self newRotationAngle:(id)sender];
        [self setRotAngle];
        rotate=YES;
        }else{
            [self setRot90];
            [self updateSizesOfBlocks];
            rotate=NO;
        }
    singleton.blockRotation=rotate;
}


-(float)randomDegrees359
{
    float degrees = 0;
    degrees = arc4random_uniform(360); //returns a value from 0 to 359, not 360;
                                       //NSLog(@"Degs=%f",degrees);
    return degrees;
}

-(float)random9
{
    float num = 1;
    for (int r=1; r<+arc4random_uniform(321); r++)
        {
        while (num>0)
            {
            num = arc4random_uniform(10); //1-9
            }
        }
    return num;
}

-(int)randomPt
{
    float split1=0;
    if (arc4random_uniform(11)>5.5)
        {
        split1=-1;
        }
    else
        {
        split1=1;
        }
    int posrand=0;
    posrand=(int)arc4random_uniform(60)*split1;
    return posrand;
}


-(void)updateBlockNumbers{
    mySingleton *singleton = [mySingleton sharedSingleton];
    blockStartNumLBL.text=singleton.start;
    blockFinishNumLBL.text=singleton.finish;
    blockSizeLBL.text=singleton.blockSize;

    //save data
    singleton.blockSize=blockSize;
    singleton.start=start;
    singleton.finish=finish;

    //set the number of blocks on the biggest valid number
    int blockCount = blockFinishNumLBL.text.intValue;
    switch (blockCount) {
        case 3:
            block1View.hidden=YES;
            block2View.hidden=YES;
            block3View.hidden=NO;
            block4View.hidden=NO;
            block5View.hidden=NO;
            block6View.hidden=YES;
            block7View.hidden=YES;
            block8View.hidden=YES;
            block9View.hidden=YES;

            break;
        case 4:
            block1View.hidden=YES;
            block2View.hidden=YES;
            block3View.hidden=NO;
            block4View.hidden=NO;
            block5View.hidden=NO;
            block6View.hidden=YES;
            block7View.hidden=NO;
            block8View.hidden=YES;
            block9View.hidden=YES;

            break;
        case 5:
            block1View.hidden=NO;
            block2View.hidden=YES;
            block3View.hidden=NO;
            block4View.hidden=NO;
            block5View.hidden=NO;
            block6View.hidden=YES;
            block7View.hidden=NO;
            block8View.hidden=YES;
            block9View.hidden=YES;

            break;
        case 6:
            block1View.hidden=NO;
            block2View.hidden=YES;
            block3View.hidden=NO;
            block4View.hidden=NO;
            block5View.hidden=NO;
            block6View.hidden=YES;
            block7View.hidden=NO;
            block8View.hidden=NO;
            block9View.hidden=YES;

            break;
        case 7:
            block1View.hidden=NO;
            block2View.hidden=YES;
            block3View.hidden=NO;
            block4View.hidden=NO;
            block5View.hidden=NO;
            block6View.hidden=NO;
            block7View.hidden=NO;
            block8View.hidden=NO;
            block9View.hidden=YES;

            break;
        case 8:
            block1View.hidden=NO;
            block2View.hidden=NO;
            block3View.hidden=NO;
            block4View.hidden=NO;
            block5View.hidden=NO;
            block6View.hidden=NO;
            block7View.hidden=NO;
            block8View.hidden=NO;
            block9View.hidden=YES;

            break;
        case 9:
            block1View.hidden=NO;
            block2View.hidden=NO;
            block3View.hidden=NO;
            block4View.hidden=NO;
            block5View.hidden=NO;
            block6View.hidden=NO;
            block7View.hidden=NO;
            block8View.hidden=NO;
            block9View.hidden=NO;

            break;
        default:
            block1View.hidden=NO;
            block2View.hidden=NO;
            block3View.hidden=NO;
            block4View.hidden=NO;
            block5View.hidden=NO;
            block6View.hidden=NO;
            block7View.hidden=NO;
            block8View.hidden=NO;
            block9View.hidden=NO;
            
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    mySingleton *singleton = [mySingleton sharedSingleton];
}
-(void)viewWillDisappear:(BOOL)animated{
    mySingleton *singleton = [mySingleton sharedSingleton];
}
*/
@end
