//
//  ViewController.h
//  CoreDataExample5
//
//  Created by Quazi Ridwan Hasib on 31/5/17.
//  Copyright © 2017 Quazi Ridwan Hasib. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *firstNameTF;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTF;
@property (weak, nonatomic) IBOutlet UITextField *ageTF;
@property (weak, nonatomic) IBOutlet UIButton *contButton;

- (IBAction)textFieldDoneEditing:(id)sender;




@end

