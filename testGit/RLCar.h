//
//  RLCar.h
//  testGit
//
//  Created by 张冲 on 2017/8/21.
//  Copyright © 2017年 张冲. All rights reserved.
//

#import <Realm/Realm.h>

@interface RLCar : RLMObject
/*汽车品牌*/
@property NSString *carbrand;
/*汽车价格*/
@property NSInteger carprice;
@end
