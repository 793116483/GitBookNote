# xcode快捷键

#### 搜索弹出一个过滤框：
- shift + command + O

#### 选择的一块代码向上或向下快捷键：
- 上移：option + command + [
- 下移：option + command + ]


#### 快速创建一个类文件
- command + N

#### 快速创建一个项目
- shift + command + N


#### Xcode 项目中，xib 内控件拖线到邦定的类文件中
- control + 拖动

#### 查看系统框架的类、方法、属性的详情信息
- option + 确定


---

# xcode 配制
#### 某个类文件需要使用非ACR环境 配制
![](./images/某一个类文件使用非ARC配制.png)


---

# xcode关键字
- **nullable** : 可以为null
- **null_resettable** : 设置可以为 null , 但getter方法返回不能 null
- **nonnull** : 不能为null
- **_Nonnull** : 用宏 NS_ASSUME_NONNULL_BEGIN 与 NS_ASSUME_NONNULL_END 修饰中间定义的属性对象默认是不为空

- **__kindof** : 相当于 的意思
    - 表示可以为当前类及其子类

# 泛形
- 类中属性不确定类型时用泛形，比如 NSArray 的 ObjectType
    - 创建
        ```objc
        // NSArray<ObjectType> , ObjectType 指的是泛形(不确定)
        // __covariant 协变 : 用于父类指向子类 不产生警告
        // __contravariant 逆变 ： 用于子类指向父类 不产生警告

        @interface NSArray<__covariant ObjectType> : NSObject

        - (ObjectType)objectAtIndex:(NSUInteger)index;

        @end
        ```

    - 使用
        ```objc
        // 指定了NSArray 类内使用 NSString * 代表泛形，即 ObjectType = NSString *
        NSArray<NSString *> array = [[NSArray alloc] init];
        ```

        - __covariant 协变 : 用于子类 指向 父类 不产生警告
        ```objc
        NSArray<QJFather *> array_f ;
        NSArray<QJSun *> array_s = [[NSArray alloc] init];
        // 指定泛型的类型是父类 转成 子类
        // array_f 内部可以包含父类及其子类对象
        array_f = array_s;
        ```
        - __contravariant 逆变 ： 用于子类 指向 父类 不产生警告
        ```objc
        NSArray<QJFather *> array_f = [[NSArray alloc] init];
        NSArray<QJSun *> array_s ;
        // 指定泛型的类型是父类 转成 子类
        array_s = array_f;
        ```



