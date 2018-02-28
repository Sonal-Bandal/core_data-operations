//
//  ViewController.m
//  finalcoredata
//
//  Created by Felix-ITS 004 on 21/02/18.
//  Copyright © 2018 sonal. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.itemName becomeFirstResponder];
    
    self.itemName.delegate=self;
    
    self.itemRate.delegate=self;
    
    self.searchItem.delegate=self;
    
    self.itemRate.text=@"";
    
    [self fetchData];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self fetchData];
    [self.myTableView reloadData];
}

-(void)fetchData
{
    NSError *error;
    
    NSObject *myObj;
    
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSManagedObjectContext *context=[delegate managedObjectContext];
    
    NSEntityDescription *entityDesc=[NSEntityDescription entityForName:@"Item" inManagedObjectContext:context];
    
    
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    
    [request setEntity:entityDesc];
    
    
    if (self.searchItem.text.length>0) {
        NSPredicate *namepredicate=[NSPredicate predicateWithFormat:@"(itemName contains[cd]  %@)",self.searchItem.text];
        [request setPredicate:namepredicate];
    }
    
    [request setEntity:entityDesc];
    
    
    self.allObjects=[context executeFetchRequest:request error:&error];
    
    if (self.allObjects.count>0) {
        myObj=[self.allObjects firstObject];
        
        NSString *name,*rate;
        name=[myObj valueForKey:@"itemName"];
        
        self.itemName.text=[myObj valueForKey:@"itemName"];
        
        rate=[myObj valueForKey:@"itemRate"];
        
        self.itemRate.text=[NSString stringWithFormat:@"%@",rate];
        
        [context save:&error];
        
    }
    
    NSLog(@"%@",self.allObjects);
    
    self.itemNameArray=[self.allObjects valueForKey:@"itemName"];
    
    NSLog(@"%@",self.itemNameArray);
    
    self.itemRateArray=[self.allObjects valueForKey:@"itemRate"];
    
    NSLog(@"%@",self.itemRateArray);
    
    [self.myTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)insertData
{
    
    NSError *error;
    
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSManagedObjectContext *context=[delegate managedObjectContext];
    
    NSManagedObject *obj=[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:context];
    
    [obj setValue:self.itemName.text forKey:@"itemName"];
    
        NSNumberFormatter *formater=[[NSNumberFormatter alloc]init];
    
        formater.numberStyle=NSNumberFormatterDecimalStyle;
    
        NSNumber *mynumber=[formater numberFromString:self.itemRate.text];
    
    [obj setValue:mynumber forKey:@"itemRate"];
    
    [context save:&error];
    
    [self.myTableView reloadData];
    
    if (!obj) {
        NSLog(@"error");
    }
    
    
    self.itemName.text=@"";
    self.itemRate.text=@"";
    
    
}

- (IBAction)insertAction:(UIButton *)sender
{
    [self insertData];
    
    [self fetchData];
    
    [self .myTableView reloadData];
}

-(void)updateData
{
    
    NSError *error;
    
    
    NSManagedObject *obj;
    
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSManagedObjectContext *context=[delegate managedObjectContext];
    
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Item" inManagedObjectContext:context];
    
    NSPredicate *nameP=[NSPredicate predicateWithFormat:@"(itemName contains [cd]   %@)",self.itemName.text];
    
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    
    
    
    [request setEntity:entity];
    
    [request setPredicate:nameP];
    
    NSArray *allobj=[context executeFetchRequest:request error:&error];
    
    if (allobj.count==1) {
        obj=[allobj firstObject];
        
        NSString *name,*rate;
        name=self.itemName.text;
        rate=self.itemRate.text;
        
        
        NSNumberFormatter *f=[[NSNumberFormatter alloc]init];
        
        f.numberStyle=NSNumberFormatterDecimalStyle;
        NSNumber *mynumber=[f numberFromString:self.itemRate.text];
        
        
        
        [obj setValue:name forKey:@"itemName"];
        
        [obj setValue:mynumber forKey:@"itemRate"];
        
        [context save:&error];
        
        [self.myTableView reloadData];
    }
}

- (IBAction)updateAction:(UIButton *)sender
{
    [self updateData];
    
    [self fetchData];
    
    [self.myTableView reloadData];
}


-(void)deleteData
{
    
    NSError *error;
    
    NSManagedObject *object;
    
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSManagedObjectContext *context=[delegate managedObjectContext];
    
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"Item" inManagedObjectContext:context];
    
    NSPredicate *namepredicate=[NSPredicate predicateWithFormat:@"(itemName contains[cd]  %@)",self.itemName.text];
    
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    
    [request setEntity:entityDescription];
    
    [request setPredicate:namepredicate];
    
    NSArray *result=[context executeFetchRequest:request error:&error];
    
    if (result.count>=1) {
        object=[result firstObject];
        
        [context deleteObject:object];
        
        [context save:&error];
        
        [self.myTableView reloadData];
        
        
    }
    
    NSLog(@"delete success");
    
    
}
- (IBAction)deleteAction:(UIButton *)sender
{
    [self deleteData];
    [self fetchData];
    [self.myTableView reloadData];
}

- (IBAction)showDetailsAction:(UIButton *)sender
{
    [self fetchData];
    [self.myTableView reloadData];
    NSLog(@"search conpleted successfully");

    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allObjects.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.textLabel.text=[self.itemNameArray objectAtIndex:indexPath.row];
    
    id rate=[self.itemRateArray objectAtIndex:indexPath.row];
    
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",rate];
    
    return cell;
}
//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    NSError *error;
//    
//        AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//    
//        NSManagedObjectContext *context=[delegate managedObjectContext];
//    
//    
//       NSFetchRequest *fetch=[NSFetchRequest fetchRequestWithEntityName:@"Item"];
//
//        NSPredicate *searchpredicate=[NSPredicate predicateWithFormat:@"(itemName contains[cd]   %@)",self.itemName.text];
//    
//        [fetch setPredicate:searchpredicate];
//    
//       NSObject *object=[context executeFetchRequest:fetch error:&error];
//    
//       if (!object)
//        {
//            object=[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:context];
//            
//            [object setValue:self.itemName.text forKey:@"itemName"];
//            
//            NSNumberFormatter *formater=[[NSNumberFormatter alloc]init];
//            
//            formater.numberStyle=NSNumberFormatterDecimalStyle;
//            
//            NSNumber *mynumber=[formater numberFromString:self.itemRate.text];
//            
//            [object setValue:mynumber forKey:@"itemRate"];
//            
//            
//
//            
//    
//            [context save:&error];
//    
//        }
//    if (object)
//    {
//        NSLog(@"duplicate entry");
//        NSLog(@"ERROR: Could not save context--%@", error);
//
//        
//    }
//        if(![context save:&error]){
//            NSLog(@"ERROR: Could not save context--%@", error);
//       }
//    return YES;
//}
    @end
