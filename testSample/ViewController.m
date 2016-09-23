//
//  ViewController.m
//  testSample
//
//  Created by Mittal J. Banker on 21/09/16.
//  Copyright © 2016 digicorp. All rights reserved.
//

#import "ViewController.h"
#import "MyTableViewCell.h"
#import "SecondViewController.h"
#import "DBManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    tableData = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork ioeioioeuiowuewueopowpieopwieopwieoiowpeiowieowieoiowieowieowoeiopweiowieoiwoeiowpeiopwieoiwopeiwopeiopwieopiwopeiopw", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
    tableData = [[DBManager getSharedInstance]selectData];
    tableViewSource.estimatedRowHeight = 36.0;
    tableViewSource.rowHeight = UITableViewAutomaticDimension;
     NSLog(@"viewDidLoad 1");
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [self.tableView setEditing:editing animated:animated];
    [super setEditing:editing animated:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear 1");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
        NSLog(@"viewDidAppear 1");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
        NSLog(@"viewDidDisappear 1");
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
        NSLog(@"viewWillDisappear 1");
}

-(void)loadView{
    [super loadView];
    NSLog(@"loadView 1");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//    }
    
    cell.lblTitle.text = [tableData objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
   // UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main"
       //                                             bundle: nil];
   // SecondViewController *seconViewController = [ mainStoryBoard instantiateViewControllerWithIdentifier:@"secondView"];
   // [self.navigationController pushViewController:seconViewController animated:YES];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES; //tableview must be editable or nothing will work...
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath { //implement the delegate method
    
    __block BOOL deleteDataSuccess;
    UIAlertController *alert;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        alert = [UIAlertController alertControllerWithTitle:@"Message" message:@"Are You Sure?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertYes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            deleteDataSuccess = [[DBManager getSharedInstance]deleteData:[tableData objectAtIndex:indexPath.row]];
                if(deleteDataSuccess==YES){
                    [tableData removeObjectAtIndex:indexPath.row];
                    [self.tableView endEditing:YES];
                    [self.tableView reloadData];
                    
                }
            
        }];
        [alert addAction:alertYes];
        UIAlertAction *alertNO = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.tableView endEditing:YES];
        }];
        [alert addAction:alertNO];
        [self presentViewController:alert animated:YES completion:nil];
    }   
}
@end
