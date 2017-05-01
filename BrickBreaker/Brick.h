//
//  Brick.h
//  BrickBreaker
//
//  Created by Gajaharan Satkunanandan on 01/05/2017.
//  Copyright © 2017 Gajaharan Satkunanandan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
    Green = 1,
    Blue = 2,
    Grey = 3,
    Yellow = 4,
    Purple = 5,
    Red = 6
} BrickType;

static const uint32_t BRICK_CATEGORY  = 0x1 << 3;

@interface Brick : SKSpriteNode

@property (nonatomic) BrickType type;
@property (nonatomic) BOOL indestructible;

-(instancetype)initWithType:(BrickType)type;
-(void)hit;

@end
