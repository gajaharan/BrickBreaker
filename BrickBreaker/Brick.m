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
        case Grey:
            self = [super initWithImageNamed:@"BrickGrey"];
            break;
        case Yellow:
            self = [super initWithImageNamed:@"BrickYellow"];
            break;
        case Purple:
            self = [super initWithImageNamed:@"BrickPurple"];
            break;
        case Red:
            self = [super initWithImageNamed:@"BrickRed"];
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
        self.indestructible = (type == Grey);
    }
    
    return self;
}

-(void)hit
{
    switch (self.type) {
        case Green:
            [self runAction:[SKAction removeFromParent]];
            break;
        case Yellow:
            [self runAction:[SKAction removeFromParent]];
            self.texture = [SKTexture textureWithImageNamed:@"BrickBlue"];
            self.type = Blue;
            break;
        case Blue:
            self.texture = [SKTexture textureWithImageNamed:@"BrickGreen"];
            self.type = Green;
            break;
        default:
             // Grey bricks are indestructible.
            break;
    }
}

@end
