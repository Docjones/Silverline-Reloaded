//
//  NSMutableArray+Accounts.m
//  Silverline-Reloaded
//
//  Created by Marc Rink on 17.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "AsyncSocket.h"

#import "NSMutableArray+Accounts.h"
#import "Account.h"

@implementation NSMutableArray (Accounts)
-(Account *)getAccountWithName:(NSString *)name andPassword:(NSString *)password {
  Account *a=[self getAccountWithName:name];
  if ([[a password] isEqualToString:password]) {
    return a;
  }
  return nil;
}

-(Account *)getAccountWithName:(NSString *)name {
  for (Account *a in self) {
    if ([[a name] isEqualToString:name]) {
      return a;
    }
  }
  return nil;
}

////////////////////////////////////////////
// Messagehandler
////////////////////////////////////////////
-(NSString *)handleMessage:(NSArray *)p withSocket:(AsyncSocket*)socket {
  
  NSLog(@"Account Message: %@",p);
  
  if ([[p objectAtIndex:0] isEqualTo:@"C"]) {
    return [self createAccountWithName:[p objectAtIndex:1]
                              andEmail:[p objectAtIndex:2]
                           andPassword:[p objectAtIndex:3]];
  }
  if ([[p objectAtIndex:0] isEqualTo:@"M"]) {
    return [self modifyAccountWithName:[p objectAtIndex:1]
                              andEmail:[p objectAtIndex:2]
                           andPassword:[p objectAtIndex:3]];
  }
  if ([[p objectAtIndex:0] isEqualTo:@"D"]) {
    return [self deleteAccountWithName:[p objectAtIndex:1]
                              andEmail:[p objectAtIndex:2]
                           andPassword:[p objectAtIndex:3]];
  }
  if ([[p objectAtIndex:0] isEqualTo:@"V"]) {
    return [self verifyAccountWithName:[p objectAtIndex:1]
                           andPassword:[p objectAtIndex:2]];
  }
  return nil;
}


// A|C
-(NSString *)createAccountWithName:(NSString *)name 
                          andEmail:(NSString *)email 
                       andPassword:(NSString *)password {
  Account *a=[self getAccountWithName:name];
  if (a) {
    return @"A|C|Error 0001: Account already exists";
  }
  a=[[Account alloc] initWithName:name 
                         andEmail:email
                      andPassword:password];
  [self addObject:a];
  NSUInteger i=[self indexOfObject:a];
  [a setIndex:i];
  [a release];
  return [NSString stringWithFormat:@"A|C|Success|%d",i];
}

// A|M
-(NSString *)modifyAccountWithName:(NSString *)name 
                          andEmail:(NSString *)email 
                       andPassword:(NSString *)password {
  Account *a=[self getAccountWithName:name];
  if ([a modifyAccountSetEmail:email andPassword:password]) {
    NSUInteger i=[a index];
    [a release];
    return [NSString stringWithFormat:@"A|M|Success|%d",i];
  }
  [a release];
  return @"A|M|Error 0001: Account does not exist";
}

// A|D
-(NSString *)deleteAccountWithName:(NSString *)name 
                          andEmail:(NSString *)email 
                       andPassword:(NSString *)password {
  Account *a=[self getAccountWithName:name];
  if ([a canDeleteAccountWithPassword:password]) {
    [self removeObject:a];
    [a release];
    return @"A|D|Success";
  }
  return @"A|D|Error 0001: Account does not exist";
}

// A|V
-(NSString *)verifyAccountWithName:(NSString *)name 
                       andPassword:(NSString *)password {
  Account *a=[self getAccountWithName:name];
  if (a) {
    if ([a verifyAccountWithPassword:password]) {
      NSUInteger i=[a index];
      [a release];
      return [NSString stringWithFormat:@"A|C|Success|%d",i];
    } else {
      [a release];
      return @"A|V|Error 0002: Password wrong";
    }
  } else {
    return @"A|V|Error 0001: Account does not exist";
  }
}

@end

