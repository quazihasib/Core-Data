//
//  ViewController.m
//  CoreDataExample5
//
//  Created by Quazi Ridwan Hasib on 31/5/17.
//  Copyright © 2017 Quazi Ridwan Hasib. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize firstNameTF;
@synthesize lastNameTF;
@synthesize ageTF;
@synthesize contButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)contButtonPressed:(id)sender {
    
    NSString* firstName = firstNameTF.text;
    NSString* lastName = lastNameTF.text;
    NSString* age = ageTF.text;
    NSNumber *n = @([age intValue]);
    [self createPersons: firstName: lastName: n];
    
    if(firstName.length==0 || lastName.length==0 || age.length==0)
    {
        [self showAlert];
    }
    else{
        [self shouldPerformSegueWithIdentifier:@"startSegue" sender:self];
    }
    
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"start"]){
    }
    return YES;
}

//alert to write tell the user to write names
-(void)showAlert{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@""
                                 message:[NSString stringWithFormat:@"Please Fill All The Sections"]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   [self dismissViewControllerAnimated:YES completion:nil];
                               }];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

//create data for persons
-(void)createPersons:(NSString*)fn :(NSString*)ln :(NSNumber*) age{
    
    AppDelegate *a=[[AppDelegate alloc]init];
    
    // Create Managed Object
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:a.managedObjectContext];
    
    //Create a Person
    NSManagedObject *newPerson = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:a.managedObjectContext];
    [newPerson setValue:fn forKey:@"firstName"];
    [newPerson setValue:ln forKey:@"lastName"];
    [newPerson setValue:age forKey:@"age"];

    // Save Managed Object Context
    NSError *error = nil;
    if (![newPerson.managedObjectContext save:&error]) {
        NSLog(@"Unable to save managed object context.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    else{
        NSLog(@"Saved");
    }
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}


@end
