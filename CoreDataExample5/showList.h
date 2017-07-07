//
//  UIViewController+showList.h
//  coreDataEx4
//
//  Created by Quazi Ridwan Hasib on 28/5/17.
//  Copyright © 2017 Quazi Ridwan Hasib. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface showList: UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UISearchBar *searchbarContacts;

@property(nonatomic,retain) UITableView* tb;
-(void)reloadDatas;
-(void)deleteDatas;
@end
