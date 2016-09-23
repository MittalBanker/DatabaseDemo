//
//  SecondViewController.h
//  testSample
//
//  Created by Mittal J. Banker on 22/09/16.
//  Copyright © 2016 digicorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController
{
    IBOutlet UITextField *regNoTextField;
    IBOutlet UITextField *regNoTextFieldToFind;
    IBOutlet UITextField *nameTextField;
    IBOutlet UITextField *departmentTextField;
    IBOutlet UITextField *yearTextField;
}
-(IBAction)saveData:(id)sender;
@end
