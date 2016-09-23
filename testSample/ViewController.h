//
//  ViewController.h
//  testSample
//
//  Created by Mittal J. Banker on 21/09/16.
//  Copyright © 2016 digicorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>{
     NSMutableArray *tableData;
     IBOutlet UITableView *tableViewSource;
}


@end

