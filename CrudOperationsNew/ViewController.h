//
//  ViewController.h
//  CrudOperationsNew
//
//  Created by Nagam Pawan on 9/30/16.
//  Copyright © 2016 Nagam Pawan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TableViewCell.h"
#import "AppDelegate.h"
#import "Entity.h"

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchResultController;
@property (strong, nonatomic) NSIndexPath *selectedPath;
@property (strong, nonatomic) NSMutableArray *employeeObjects;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)leftSwipe:(id)sender;
- (IBAction)rightSwipe:(id)sender;
- (IBAction)deleteButton:(id)sender;
- (IBAction)editButton:(id)sender;
- (IBAction)addButton:(id)sender;

@end

