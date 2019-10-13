//
//  QJOneModel(单例模式).h
//  模式Dome
//
//  Created by 瞿杰 on 2019/9/28.
//  Copyright © 2019 yiniu. All rights reserved.
//  实现所有对象通用单例宏:
//  1、在 .h 文件中调用 DISPATCH_ONE_H(FunctionName) 宏 ，用的时候 [selfClass shareFunctionName];
//  2、在 .m 文件中调用 DISPATCH_ONE_M(FunctionName) 宏 ，注意 FunctionName 这个参数与上面的宏参数一致

// .h文件中调用这个宏
#define DISPATCH_ONE_H(FunctionName)                            \
+(instancetype)share##FunctionName;                             \
                            
// ARC 环境
#if __has_feature(objc_arc)
// .m文件中调用这个宏
#define DISPATCH_ONE_M(FunctionName)                            \
static id _instance = nil;                                      \
+(instancetype)allocWithZone:(struct _NSZone *)zone             \
{                                                               \
    static dispatch_once_t onceToken;                           \
    dispatch_once(&onceToken, ^{                                \
    _instance = [super allocWithZone:zone];                     \
    });                                                         \
    return _instance;                                           \
}                                                               \
+(instancetype)share##FunctionName                              \
{                                                               \
    return [[self alloc] init];                                 \
}                                                               \
                                                                \
-(id)copy                                                       \
{                                                               \
    return _instance;                                           \
}                                                               \
-(id)mutableCopy                                                \
{                                                               \
    return _instance;                                           \
}
    
// MRC 环境
#else

#define DISPATCH_ONE_M(functionName)                            \
static id _instance = nil;                                      \
+(instancetype)allocWithZone:(struct _NSZone *)zone             \
{                                                               \
    static dispatch_once_t onceToken;                           \
    dispatch_once(&onceToken, ^{                                \
    _instance = [super allocWithZone:zone];                     \
    });                                                         \
    return _instance;                                           \
}                                                               \
+(instancetype)share##functionName                              \
{                                                               \
    return [[self alloc] init];                                 \
}                                                               \
                                                                \
-(id)copy                                                       \
{                                                               \
    return _instance;                                           \
}                                                               \
-(id)mutableCopy                                                \
{                                                               \
    return _instance;                                           \
}                                                               \
-(oneway void)release                                           \
{                                                               \
}                                                               \
-(instancetype)retain                                           \
{                                                               \
    return _instance;                                           \
}                                                               \
-(NSUInteger)retainCount                                        \
{                                                               \
    return MAXFLOAT;                                            \
}

#endif


