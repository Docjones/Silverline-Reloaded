//
//  Account.h
//  Silverline-Reloaded
//
//  Created by Marc Rink on 15.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject <NSCoding> {
  NSString *name;
  NSString *email;
  NSString *password;

  NSMutableArray *characters;
  
  NSUInteger index;
}

@property (retain) NSString *name;
@property (retain) NSString *email;
@property (retain) NSString *password;
@property (retain) NSMutableArray *characters;
@property (assign) NSUInteger index;

// A|C
- (id)initWithName:(NSString *)n
          andEmail:(NSString *)e
       andPassword:(NSString *)p;
// A|M
- (BOOL)modifyAccountSetEmail:(NSString *)e
                  andPassword:(NSString *)p;
// A|D
- (BOOL)canDeleteAccountWithPassword:(NSString *)p;
// A|V
-(BOOL) verifyAccountWithPassword:(NSString *)p;


@end
