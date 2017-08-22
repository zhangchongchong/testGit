//
//  RLUser.h
//  testGit
//
//  Created by 张冲 on 2017/8/21.
//  Copyright © 2017年 张冲. All rights reserved.
//

#import <Realm/Realm.h>

@interface RLUser : RLMObject
@property NSString *userName;
@property NSInteger age;
@property RLMArray *cars;
@end
