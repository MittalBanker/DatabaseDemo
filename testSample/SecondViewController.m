//
//  SecondViewController.m
//  testSample
//
//  Created by Mittal J. Banker on 22/09/16.
//  Copyright © 2016 digicorp. All rights reserved.
//

#import "SecondViewController.h"
#import "DBManager.h"
#import "ViewController.h"
@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad 2");
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear 2");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear 2");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear 2");
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear 2");
}

-(void)loadView{
    [super loadView];
    NSLog(@"loadView 2");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)saveData:(id)sender{
    BOOL saveDataSuccess;
    UIAlertView *alert;
    NSString *alertString = @"Data Insertion failed";
    if ([regNoTextField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>0 &&[nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>0 &&
        [departmentTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>0 &&[yearTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>0 )
    {
        saveDataSuccess = [[DBManager getSharedInstance]saveData:
                           regNoTextField.text name:nameTextField.text department:
                           departmentTextField.text year:yearTextField.text];
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle: nil];
        ViewController *seconViewController = [ mainStoryBoard instantiateViewControllerWithIdentifier:@"firstView"];
        [self.navigationController pushViewController:seconViewController animated:YES];
    }
    else{
        alertString = @"Enter all fields";
    }
    if (saveDataSuccess == NO) {
        alert = [[UIAlertView alloc]initWithTitle:
                 alertString message:nil
                                         delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(IBAction)getDataByNo:(id)sender{
    
    if([regNoTextFieldToFind.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:@"Register Number is empty" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        return;
    }
    NSArray *data = [[DBManager getSharedInstance]findByRegisterNumber:
                     regNoTextFieldToFind.text];
    nameTextField.text = [data objectAtIndex:0];
    departmentTextField.text = [data objectAtIndex:1];
    yearTextField.text = [data objectAtIndex:2];
    regNoTextField.text = regNoTextFieldToFind.text;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
