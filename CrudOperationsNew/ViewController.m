//
//  ViewController.m
//  CrudOperationsNew
//
//  Created by Nagam Pawan on 9/30/16.
//  Copyright © 2016 Nagam Pawan. All rights reserved.
//

#import "ViewController.h"
//#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchData];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)leftSwipe:(id)sender {
    
    CGPoint location = [sender locationInView:self.tableView];
    self.selectedPath = [self.tableView indexPathForRowAtPoint:location];
    
    TableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.selectedPath];
    
    cell.editButton.hidden = NO;
    cell.deleteButton.hidden = NO;
}

- (IBAction)rightSwipe:(id)sender {
    CGPoint location = [sender locationInView:self.tableView];
    self.selectedPath = [self.tableView indexPathForRowAtPoint:location];
    
    TableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.selectedPath];
    
    cell.editButton.hidden = YES;
    cell.deleteButton.hidden = YES;

}

- (IBAction)deleteButton:(UIButton*)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(TableViewCell *)sender.superview.superview];
    
    NSManagedObjectContext *context = [self getContext];
    
    [context deleteObject:[self.employeeObjects objectAtIndex:indexPath.row]];
    
    NSError *error = nil;
    [context save:&error];
    
    TableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    
    [self.employeeObjects removeObjectAtIndex:indexPath.row];
    cell.editButton.hidden = YES;
    cell.deleteButton.hidden = YES;
    
    [self.tableView reloadData];
}

- (IBAction)editButton:(UIButton*)sender {
    NSManagedObject *employeeObject =[ self.employeeObjects objectAtIndex:self.selectedPath.row];
    
    
    UIAlertController* controller=[UIAlertController alertControllerWithTitle:@"Re-Enter Employee Details" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.text=[employeeObject valueForKey:@"name"];
        
    }];
    
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text= [NSString stringWithFormat:@"%@",[employeeObject valueForKey:@"Age"]];
        
    }];
    
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text=[employeeObject valueForKey:@"gender"];
        
    }];
    
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text=[employeeObject valueForKeyPath:@"designation"];
    }];
    
    
    UIAlertAction* alertaction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        UITextField* name = [controller.textFields objectAtIndex:0];
        
        UITextField* age = [controller.textFields objectAtIndex:1];
        
        UITextField* gender = [controller.textFields objectAtIndex:2];
        
        UITextField* designation = [controller.textFields objectAtIndex:3];
        
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(TableViewCell *)sender.superview.superview];
        
        
        NSManagedObjectContext* context=[self getContext];
        
        
        [employeeObject setValue:name.text forKey:@"name"];
        [employeeObject setValue:age.text forKey:@"age"];
        [employeeObject setValue:gender.text forKey:@"gender"];
        [employeeObject setValue:designation.text forKey:@"designation"];
        NSError* error=nil;
        
        if (![context save:&error
              ]) {
            NSLog(@"Failed to save data");
        }
        else{
            
            NSLog(@"Saved Data");
        }
        
        
        
        
        
        
        
        
        TableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        
        
        cell.editButton.hidden = YES;
        cell.deleteButton.hidden = YES;
        [self fetchData];
        
    }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    
    
    [controller addAction:alertaction];
    [controller addAction:cancelAction];
    
    [self presentViewController:controller animated:YES completion:nil];
    
    
    [self fetchData];
    [self.tableView reloadData];
    

}

- (IBAction)addButton:(id)sender {
    
    UIAlertController* controller=[UIAlertController alertControllerWithTitle:@"Add Employee Details" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"Enter Name";
        
    }];
    
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"Enter Age";
        
    }];
    
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"Enter Gender";
        
    }];
    
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"Enter Designation";
    }];
    
    
    UIAlertAction* alertaction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        UITextField* name = [controller.textFields objectAtIndex:0];
        
        UITextField* age = [controller.textFields objectAtIndex:1];
        
        UITextField* gender = [controller.textFields objectAtIndex:2];
        
        UITextField* designation = [controller.textFields objectAtIndex:3];
        
        
        NSManagedObjectContext* context=[self getContext];
        NSManagedObject* emp=[NSEntityDescription insertNewObjectForEntityForName:@"Entity" inManagedObjectContext:context];
        [emp setValue:name.text forKey:@"name"];
        [emp setValue:age.text forKey:@"age"];
        [emp setValue:gender.text forKey:@"gender"];
        [emp setValue:designation.text forKey:@"designation"];
        NSError* error=nil;
        
        if (![context save:&error
              ]) {
            NSLog(@"Failed to save data");
        }
        else{
            
            NSLog(@"Saved Data");
        }
        
        
        [self fetchData];
        
    }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    
    
    [controller addAction:alertaction];
    [controller addAction:cancelAction];
    
    [self presentViewController:controller animated:YES completion:nil];
    
    
    [self fetchData];
    [self.tableView reloadData];
    
    

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.employeeObjects.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSManagedObject *employee = [self.employeeObjects objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = [employee valueForKey:@"name"];
    cell.ageLabel.text = [employee valueForKey:@"age"];
    cell.genderLabel.text = [employee valueForKey:@"gender"];
    cell.designationLabel.text = [employee valueForKey:@"designation"];
    return cell;
}

-(NSManagedObjectContext *)getContext{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
    
    return context;
    
}

-(void)fetchData{
    
    NSManagedObjectContext* context=[self getContext];
    NSFetchRequest* req=[[NSFetchRequest alloc] initWithEntityName:@"Entity"];
    NSError* error=nil;
    
    self.employeeObjects=[[NSMutableArray alloc] initWithArray:[context executeFetchRequest:req error:&error]];
    [self.tableView reloadData];
    
}
@end
