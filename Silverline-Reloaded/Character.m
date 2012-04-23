//
//  Character.m
//  Silverline-Reloaded
//
//  Created by Marc Rink on 23.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Character.h"

@implementation Character

@synthesize name,xpos,ypos,container,index;

// A|C
- (id)initWithName:(NSString *)n {
  self = [super init];
  if (self) {
    [self setName:n];
    // Spawnpoint goes here.
    [self setXpos:5];
    [self setYpos:5];
  }
  return self;
}

- (void)dealloc {
  [name release];
  [super dealloc];
}

- (id)initWithCoder:(NSCoder *)coder {
  if (self) {
    xpos=[coder decodeIntForKey:@"PlayerXpos"];
    ypos=[coder decodeIntForKey:@"PlayerYpos"];
    name=[coder decodeObjectForKey:@"PlayerName"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
  [encoder encodeInt:xpos forKey:@"PlayerXpos"];
  [encoder encodeInt:ypos forKey:@"PlayerYpos"];
  [encoder encodeObject:name forKey:@"PlayerName"];
}

// Methods
// C|L
-(NSString *)list {
  return [NSString stringWithFormat:@"C|L|%d|%@\r\n",[self index],[self name]];
}

@end
