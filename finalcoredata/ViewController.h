//
//  ViewController.h
//  finalcoredata
//
//  Created by Felix-ITS 004 on 21/02/18.
//  Copyright © 2018 sonal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>


-(void)fetchData;

-(void)insertData;

-(void)deleteData;

-(void)updateData;

@property NSArray *allObjects,*itemNameArray,*itemRateArray;


@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) IBOutlet UITextField *itemName;


@property (strong, nonatomic) IBOutlet UITextField *itemRate;
@property (strong, nonatomic) IBOutlet UITextField *searchItem;
- (IBAction)insertAction:(UIButton *)sender;
- (IBAction)updateAction:(UIButton *)sender;
- (IBAction)deleteAction:(UIButton *)sender;
- (IBAction)showDetailsAction:(UIButton *)sender;


@end

