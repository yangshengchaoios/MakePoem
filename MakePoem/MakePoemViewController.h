//
//  MakePoemViewController.h
//  MakePoem
//
//  Created by jian zhang on 12-5-23.
//  Copyright (c) 2012年 txtws.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MakePoemViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
{ 
    
    IBOutlet UIPickerView *pickerCondition;
    IBOutlet UITextField*_inputText;
    IBOutlet UILabel* _outputLabel;
}

-(IBAction)makePoemButtonClicked:(UIButton*)sender;
-(IBAction)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end
