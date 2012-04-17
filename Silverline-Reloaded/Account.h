//
//  Account.h
//  Silverline-Reloaded
//
//  Created by Marc Rink on 15.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject <NSCoding> {
  NSString *_name;
  NSString *_email;
  NSString *_password;

  NSMutableArray *_toons;
}

@property (assign) NSString *_name;
@property (assign) NSString *_email;
@property (assign) NSString *_password;

// A|C
- (id)initWithName:(NSString *)name 
          andEmail:(NSString *)email
       andPassword:(NSString *)password;
// A|M
- (BOOL)modifyAccountSetEmail:(NSString *)email
                  andPassword:(NSString *)password;
// A|D
- (BOOL)canDeleteAccountWithPassword:(NSString *)password;
// A|V
-(BOOL) verifyAccountWithPassword:(NSString *)password;


@end
