//
//  NSMutableArray+Accounts.h
//  Silverline-Reloaded
//
//  Created by Marc Rink on 17.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

#import "Account.h"

@interface NSMutableArray (Accounts)
-(Account *)getAccountWithName:(NSString *)name andPassword:(NSString *)password;
-(Account *)getAccountWithName:(NSString *)name;
-(NSString *)handleMessage:(NSArray *)p withSocket:(AsyncSocket*)socket ;
@end

