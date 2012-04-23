//
//  Character.h
//  Silverline-Reloaded
//
//  Created by Marc Rink on 23.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Character : NSObject <NSCoding> {

  NSMutableArray *container;
  NSUInteger index;
  
  NSString *name;
  int xpos;
  int ypos;
}

@property (retain) NSString *name;
@property (assign) int xpos;
@property (assign) int ypos;
@property (assign) NSUInteger index;
@property (assign) NSMutableArray *container;

// C|C
- (id)initWithName:(NSString *)n;

// C|L
-(NSString *)list;

@end
