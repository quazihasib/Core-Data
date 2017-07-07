//
//  UIViewController+showList.m
//  coreDataEx4
//
//  Created by Quazi Ridwan Hasib on 28/5/17.
//  Copyright © 2017 Quazi Ridwan Hasib. All rights reserved.
//

#import "showList.h"
#import "AppDelegate.h"
#import "AlertViews.h"


@implementation showList : UIViewController

NSArray *result;
UITableView* tb;
NSIndexPath* nx;
NSString *searchTexts;

@synthesize searchbarContacts;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AppDelegate *a = [[AppDelegate alloc]init];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:a.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    result = [a.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}


#pragma mark - SearchBar Delegate Methods

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //searchText = [searchText lowercaseString];
    searchTexts = searchText;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)SearchBar
{
    SearchBar.showsCancelButton=YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)theSearchBar
{
    [theSearchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)SearchBar
{
    @try
    {
        SearchBar.showsCancelButton=NO;
        [SearchBar resignFirstResponder];
        //[tableViewContactData reloadData];
    }
    @catch (NSException *exception) {
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)SearchBar
{
    [SearchBar resignFirstResponder];
    NSString* fullAddress = [self getAddress];
  
    //show address using alert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Show Address" message:fullAddress preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//get address for showing from search bar
-(NSString*)getAddress{
    NSString* fullAddress;
    @try {
        //fetch the result
        AppDelegate *a=[[AppDelegate alloc]init];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:a.managedObjectContext];
        [fetchRequest setEntity:entity];
        NSString *firstName = searchTexts;
        //NSLog(@"firstName:%@",firstName);
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"firstName =[c] %@", firstName]];
        NSMutableArray *arr = [[a.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        NSManagedObject *person = (NSManagedObject *)[arr objectAtIndex:[arr count]-1];
        NSManagedObject *address = [person valueForKey:@"addresses"];
        NSManagedObject *country = [address valueForKey:@"country"];
        NSManagedObject *phoneNumber = [address valueForKey:@"phoneNumber"];
        NSManagedObject *street = [address valueForKey:@"street"];
        //get address details
        AlertViews *al=[[AlertViews alloc]init];
        NSString* sCountry = [NSString stringWithFormat:@"%@",country];
        sCountry = [al cleanNSString:sCountry];
        NSString* sPhoneNumber = [NSString stringWithFormat:@"%@",phoneNumber];
        sPhoneNumber = [al cleanNSString:sPhoneNumber];
        NSString* sStreet = [NSString stringWithFormat:@"%@",street];
        sStreet = [al cleanNSString:sStreet];
        
        if(sCountry.length==0 && sPhoneNumber.length==0 && sStreet.length==0){
            fullAddress=@"No address found";
        }
        else{
            fullAddress = [NSString stringWithFormat:@"Phone:%@, Country:%@, Street:%@",phoneNumber, country,street];
            fullAddress = [al cleanNSString:fullAddress];
        }
    } @catch (NSException *exception) {
        fullAddress=@"No address found";
    } @finally {
        
    }
    //NSLog(@"FULL address:%@",fullAddress);
    return fullAddress;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    tb = tableView;
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tb = tableView;
    //NSLog(@"person count:%lu",(unsigned long)[result count]);
    return [result count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorColor = [UIColor clearColor];
    tb = tableView;
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    AppDelegate *a = [[AppDelegate alloc]init];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:a.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSMutableArray* obj = [[a.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSManagedObject* mn = [obj objectAtIndex:indexPath.row];
    //NSLog(@"Loaded:%@",[newDevices valueForKey:@"name"]);
    cell.textLabel.text = [mn valueForKey:@"firstName"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *a = [[AppDelegate alloc]init];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:a.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *result = [a.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSManagedObject *person = (NSManagedObject *)[result objectAtIndex:indexPath.row];
    NSString* fName = [person valueForKey:@"firstName"];
    AlertViews *al = [[AlertViews alloc]init];
    int val=(int)indexPath.row;
    [al showAddressAlert: self: fName : val];
    
    nx=indexPath;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


-(void)reloadDatas{
    [tb reloadData];
}

-(void)deleteDatas{
    
    [tb deleteRowsAtIndexPaths:[NSArray arrayWithObject:nx] withRowAnimation:UITableViewRowAnimationLeft] ;
    //[tb reloadData];
}


@end
