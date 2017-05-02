//
//  Menu.h
//  BrickBreaker
//
//  Created by Gajaharan Satkunanandan on 02/05/2017.
//  Copyright © 2017 Gajaharan Satkunanandan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameMenu : SKSpriteNode

@property (nonatomic) int levelNumber;

-(void)hide;
-(void)show;

@end
