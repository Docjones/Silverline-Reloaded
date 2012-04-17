//
//  NSMutableArray+Players.m
//  Silverline-Reloaded
//
//  Created by Marc Rink on 17.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSMutableArray+Players.h"
#import "Player.h"

@implementation NSMutableArray (Players)
-(Player *)getPlayerWithSocket:(AsyncSocket *)socket {
  for (Player *p in self) {
    if ([[p _connection] isEqual:socket]) {
      return p;
    }
  }
  return nil;
}
@end
