//
//  NSObject+AlertViews.m
//  CoreDataExample5
//
//  Created by Quazi Ridwan Hasib on 31/5/17.
//  Copyright © 2017 Quazi Ridwan Hasib. All rights reserved.
//

#import "AlertViews.h"
#import "showList.h"
#import "AppDelegate.h"

@implementation AlertViews: NSObject

//show the address information options
-(void)showAddressAlert:(id)a : (NSString*)fname :(int)val{
    id s = a;
    UIAlertController * alert=[UIAlertController
                               alertControllerWithTitle:@"Add Information" message:@""preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* showAddressButton = [UIAlertAction
                                        actionWithTitle:@"Show Address"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action){
                                            @try {
                                                [self showDetailsByName:fname :s];
                                            } @catch (NSException *exception) {
                                                NSLog(@"No info found.");
                                            } @finally {
                                            }
                                        }];
    UIAlertAction* addressButton = [UIAlertAction
                                    actionWithTitle:@"Add address info"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action){
                                        [self addressInfoPressed:a:fname];
                                    }];
    UIAlertAction* editButton = [UIAlertAction
                                 actionWithTitle:@"Edit info"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action){
                                     [self edit:s :fname :val];
                                 }];
    [alert addAction:showAddressButton];
    [alert addAction:addressButton];
    [alert addAction:editButton];
    
    [a presentViewController:alert animated:YES completion:nil];
}

//edit person name
-(void)edit:(id)s :(NSString*) fname :(int)val{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Contact Info" message:@"Insert Contact Information." preferredStyle:UIAlertControllerStyleAlert];
    __block NSString *firstName;
    __block UITextField* t1;
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        t1=textField;
        textField.placeholder = @"Name";
    }];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        firstName= t1.text;
        AppDelegate *a=[[AppDelegate alloc]init];
        
        NSMutableArray *results = [[NSMutableArray alloc]init];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:a.managedObjectContext];
        [fetchRequest setEntity:entity];
        results = [[a.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        NSManagedObject* favoritsGrabbed;
        if (results.count > 0) {
            favoritsGrabbed = [results objectAtIndex:val];
            [favoritsGrabbed setValue:firstName forKey:@"firstName"];
            [a saveContext];
            
        } else {
            NSLog(@"Enter Corect name");
        }
        
        showList* sh = [[showList alloc]init];
        [sh reloadDatas];
        
    }];
    [alert addAction:defaultAction];
    
    [s presentViewController:alert animated:YES completion:nil];
    
}

//insert address information
- (void)addressInfoPressed:(id)s :(NSString*) fname{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Address Info" message:@"Insert Address Information." preferredStyle:UIAlertControllerStyleAlert];
    __block NSString *country, *phoneNumber, *street;
    __block UITextField* t1;
    __block UITextField* t2;
    __block UITextField* t3;
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        t1=textField;
        textField.placeholder = @"country";
        country= ((UITextField *)[alert.textFields objectAtIndex:0]).text;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        t2=textField;
        textField.placeholder = @"phone numner";
        phoneNumber= ((UITextField *)[alert.textFields objectAtIndex:0]).text;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        t3=textField;
        textField.placeholder = @"street";
        street= ((UITextField *)[alert.textFields objectAtIndex:0]).text;
    }];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        country= t1.text;
        phoneNumber = t2.text;
        street= t3.text;
        
        [self addAddressInfo:fname :country :phoneNumber :street:s];
    }];
    [alert addAction:defaultAction];
    [s presentViewController:alert animated:YES completion:nil];
}

//Add address information
-(void)addAddressInfo:(NSString*)fName :(NSString*)country :(NSString*)phoneNumber :(NSString*)street :(id)s{
    
    AppDelegate *a=[[AppDelegate alloc]init];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:a.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSString *firstName = fName;
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"firstName == %@", firstName]];
    NSMutableArray *arr = [[a.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSManagedObject *person = (NSManagedObject *)[arr objectAtIndex:[arr count]-1];
    
    // Create Address
    NSEntityDescription *entityAddress = [NSEntityDescription entityForName:@"Address" inManagedObjectContext:a.managedObjectContext];
    NSManagedObject *newAddress = [[NSManagedObject alloc] initWithEntity:entityAddress insertIntoManagedObjectContext:a.managedObjectContext];
    
    // Set street, phone number and country
    [newAddress setValue:street forKey:@"street"];
    [newAddress setValue:phoneNumber forKey:@"phoneNumber"];
    [newAddress setValue:country forKey:@"country"];
    // Add Address to Person
    [person setValue:[NSSet setWithObject:newAddress] forKey:@"addresses"];
    
    // Save Managed Object Context
    NSError *error = nil;
    if (![a.managedObjectContext save:&error]) {
        NSLog(@"Unable to save managed object context.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    else{
        NSLog(@"saved");
    }
    
    [self showDetailsByName:fName:s];
}

//show person's details using firstname
-(void)showDetailsByName:(NSString*)name :(id) s{
    AppDelegate *a=[[AppDelegate alloc]init];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:a.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSString *firstName = name;
    NSLog(@"firstName:%@",firstName);
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"firstName == %@", firstName]];
    NSMutableArray *arr = [[a.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSManagedObject *person = (NSManagedObject *)[arr objectAtIndex:[arr count]-1];
    //find address
    NSManagedObject *address = [person valueForKey:@"addresses"];
    NSManagedObject *country = [address valueForKey:@"country"];
    NSManagedObject *phoneNumber = [address valueForKey:@"phoneNumber"];
    NSManagedObject *street = [address valueForKey:@"street"];
    
    NSString* fullAddress;
    NSString* sCountry = [NSString stringWithFormat:@"%@",country];
    sCountry = [self cleanNSString:sCountry];
    NSString* sPhoneNumber = [NSString stringWithFormat:@"%@",phoneNumber];
    sPhoneNumber = [self cleanNSString:sPhoneNumber];
    NSString* sStreet = [NSString stringWithFormat:@"%@",street];
    sStreet = [self cleanNSString:sStreet];
    
    if(sCountry.length==0 && sPhoneNumber.length==0 && sStreet.length==0){
        fullAddress=@"No address found";
    }
    else{
        fullAddress = [NSString stringWithFormat:@"Phone:%@, Country:%@, Street:%@",phoneNumber, country,street];
        fullAddress = [self cleanNSString:fullAddress];
    }
    //NSLog(@"fullAddress:%@",fullAddress);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Show Address" message:fullAddress preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //NSLog(@"You pressed button OK");
    }];
    
    [alert addAction:defaultAction];
    [s presentViewController:alert animated:YES completion:nil];
}

//remove brackets, double qoutes, white spaces from the string
-(NSString*)cleanNSString:(NSString*) s{
    
    s = [[s stringByReplacingOccurrencesOfString:@"(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    s = [[s stringByReplacingOccurrencesOfString:@"{" withString:@""] stringByReplacingOccurrencesOfString:@"}" withString:@""];
    
    s = [s stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    s = [s stringByReplacingOccurrencesOfString:@"\\s"
                                     withString:@""
                                        options:NSRegularExpressionSearch
                                          range:NSMakeRange(0, [s length])];
    return s;
}

@end
