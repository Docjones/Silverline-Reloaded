//
//  Account.m
//  Silverline-Reloaded
//
//  Created by Marc Rink on 15.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Account.h"

@implementation Account
@synthesize name,password,email,characters,index;

// Init/deinit
// A|C
- (id)initWithName:(NSString *)n 
          andEmail:(NSString *)e 
       andPassword:(NSString *)p {
  self = [super init];
  if (self) {
    [self setName:n];
    [self setEmail:e];
    [self setPassword:p];
    [self setCharacters:[[NSMutableArray alloc] init]];
  }
  return self;
}

- (void)dealloc {
  [name release];
  [password release];
  [email release];
  [characters release]; 
  [super dealloc];
}

-(NSString *)description {
  return [NSString stringWithFormat:@"%@, %@, %@",self.name,self.password,self.email];
}

//NSCoding protocol
- (id)initWithCoder:(NSCoder *)coder {
  self=[super init];
  if (self) {
    name=[[coder decodeObjectForKey:@"AccountName"] retain];
    password=[[coder decodeObjectForKey:@"AccountPassword"] retain];
    email=[[coder decodeObjectForKey:@"AccountEmail"] retain];
    characters=[[coder decodeObjectForKey:@"AccountCharacters"] retain]	;
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
  [encoder encodeObject:name forKey:@"AccountName"];
  [encoder encodeObject:password forKey:@"AccountPassword"];
  [encoder encodeObject:email forKey:@"AccountEmail"];
  [encoder encodeObject:characters forKey:@"AccountCharacters"];
}


// Methods
// A|M
- (BOOL)modifyAccountSetEmail:(NSString *)e
                  andPassword:(NSString *)p {
  [self setPassword:p];
  [self setEmail:e];
  return YES;
}

// A|D
- (BOOL)canDeleteAccountWithPassword:(NSString *)p {
  if ([[self password] isEqualToString:p]) {
    return YES;
  }
  return NO;
}

// A|V
-(BOOL) verifyAccountWithPassword:(NSString *)p {
  if ([[self password] isEqualToString:p]) {
    return YES;
  } 
  return NO;
}

@end
