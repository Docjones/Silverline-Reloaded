//
//  Account.m
//  Silverline-Reloaded
//
//  Created by Marc Rink on 15.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Account.h"

@implementation Account
@synthesize _name,_password,_email,_toons,index;

// Init/deinit
// A|C
- (id)initWithName:(NSString *)name 
          andEmail:(NSString *)email 
       andPassword:(NSString *)password {
  self = [super init];
  if (self) {
    [self set_name:name];
    [self set_email:email];
    [self set_password:password];
    [self set_toons:[[NSMutableArray alloc] init]];
  }
  return self;
}

- (void)dealloc {
  [_name release];
  [_password release];
  [_email release];
  [_toons release]; 
  [super dealloc];
}

-(NSString *)description {
  return [NSString stringWithFormat:@"%@, %@, %@",self._name,self._password,self._email];
}

//NSCoding protocol
- (id)initWithCoder:(NSCoder *)coder {
  self=[super init];
  if (self) {
    self._name=[[coder decodeObjectForKey:@"AccountName"] retain];
    self._password=[[coder decodeObjectForKey:@"AccountPassword"] retain];
    self._email=[[coder decodeObjectForKey:@"AccountEmail"] retain];
    //    _toons=[[coder decodeObjectForKey:@"AccountToons"] retain]	;
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
  [encoder encodeObject:_name forKey:@"AccountName"];
  [encoder encodeObject:_password forKey:@"AccountPassword"];
  [encoder encodeObject:_email forKey:@"AccountEmail"];
  // [encoder encodeObject:_toons forKey:@"AccountToons"];
}


// Methods
// A|M
- (BOOL)modifyAccountSetEmail:(NSString *)email
                  andPassword:(NSString *)password {
  [self set_password:password];
  [self set_email:email];
  return YES;
}

// A|D
- (BOOL)canDeleteAccountWithPassword:(NSString *)password {
  if ([[self _password] isEqualToString:password]) {
    return YES;
  }
  return NO;
}

// A|V
-(BOOL) verifyAccountWithPassword:(NSString *)password {
  if ([[self _password] isEqualToString:password]) {
    return YES;
  } 
  return NO;
}

@end
