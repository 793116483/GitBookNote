# OC的一些代码功能

### 一、多线程代码
- 在主线程中执行

```objc
// 功能： 在主线程执行一块代码
// 参数1：方法
// 参数2：方法所需的参数
// 参数3：在子线程中是否等待在主线程中执行完指定的方法后再在子线程中执行余下的代码
[self performSelectorOnMainThread:@selector(selector) withObject:(nullable id) waitUntilDone:(BOOL)]
```


### 二、定义类型
#### 1、定义枚举类型
```objc
// 普通的枚举
typedef NS_ENUM(NSInteger , QJEnum){
  QJEnumTop
};

// 二进制 位移枚举
typedef NS_OPTIONS(NSInteger, QJDirc) {
    QJDircTop = 1<<1 ,
};
```


### 三、代码块 功能
```objc
    UIView * view = ({
        UIView * view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, 100, 100);
        // 最后一行作为值返回 , 这样写的代码块内容整体与 view相关设置，看着层次分明
        view ;
    });
```
