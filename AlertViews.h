//
//  NSObject+AlertViews.h
//  CoreDataExample5
//
//  Created by Quazi Ridwan Hasib on 31/5/17.
//  Copyright © 2017 Quazi Ridwan Hasib. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertViews:NSObject

-(void)showAddressAlert:(id)a : (NSString*)fname : (int)val;
-(void)addAddressInfo:(NSString*)fName :(NSString*)country :(NSString*)phoneNumber :(NSString*)street :(id)s;
-(NSString*)cleanNSString:(NSString*) s;

@end
