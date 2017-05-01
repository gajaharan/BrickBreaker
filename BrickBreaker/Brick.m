//
//  Brick.m
//  BrickBreaker
//
//  Created by Gajaharan Satkunanandan on 01/05/2017.
//  Copyright © 2017 Gajaharan Satkunanandan. All rights reserved.
//

#import "Brick.h"

@implementation Brick

-(instancetype)initWithType:(BrickType)type
{
    
    switch (type) {
        case Green:
            self = [super initWithImageNamed:@"BrickGreen"];
            break;
        case Blue:
            self = [super initWithImageNamed:@"BrickBlue"];
            break;
        default:
            self = nil;
            break;
    }
    
    if (self) {
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.categoryBitMask = BRICK_CATEGORY;
        self.physicsBody.dynamic = NO;
        self.type = type;
        
    }
    
    return self;
}

-(void)hit
{
    switch (self.type) {
        case Green:
            [self runAction:[SKAction removeFromParent]];
            break;
            
        case Blue:
            self.texture = [SKTexture textureWithImageNamed:@"BrickGreen"];
            self.type = Green;
            break;
        default:
            break;
    }
}

@end
