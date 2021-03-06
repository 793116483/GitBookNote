* **将OC文件.m 转成 C++文件 的指令：**xcrun -sdk iphoneos clang -arch arm64 -rewrite-objc ~/路径/xxxx.m -o ~/路径/xxxx.cpp 

# 程序启动过程

1. ##### 开始按顺序编译文件和文件中的代码，将所有static的类对象、分类对象 及其 class\_ro\_t \( 成员变量列表、属性列表、对象方法和类方法实现 列表\) 加载到内存中；（没有实现的方法不会加载到内存中）

   1. ##### 编译完后 至少会存在2个列表： 类对象列表 和 分类对象列表。
2. ##### 运行时 runtime ：

   1. ##### 调用+load前的准备：生成 包含+load方法的 struct loadable\_class类型\(包含 Class cls 和 IMP method\) 列表 和 struct loadable\_category类型\(包含 Category cat 和 IMP method\)列表

      1. ##### 先拿到编译顺序的类对象列表，通过遍历  _实现了+load方法_  的类对象列表，对每个类对象进行super\_class递归，先把父类的+load方法地址加到 对应的列表中，然后回朔添加子类的+load方法地址 \(就是IMP method\)；
      2. ##### 然后拿到编译顺序的分类对象列表，通过上述过程遍历 _实现了+load方法_  分类对象列表。
   2. ##### 拿到上述准备好的2个列表\(loadable\_classes 和 loadable\_categorys\)通过函数地址执行+load 方法 \(加锁线程安全\)。

      1. ##### 相当于如果子类实现了+load方法则会先加载父类的+load方法 \(每个类的+load方法内 self 就是当前类对象而非子类对象，无关继承多态\)，如果子类没有实现+load方法父类的+load方法会按编译顺序一个类一个类调用；
      2. ##### +load 方法是在加载 类 和 分类时调用 ，系统调用是通过 方法函数地址直接调用，而不是通过 发消息传递的方式。
      3. ##### 每个 +load 方法只会被系统调用一次。
   3. ##### 然后再按编译顺序加载所有分类对象的+load方法；分类对象中的数据\(属性、对象方法、类方法、协议 列表\)被附加到类对象中的 class\_rw\_t 中的对应列表中

      1. ##### class\_rw\_t 运行时决议的：

         1. ##### 先将 编译时决议 类对象的 class\_ro\_t 复制一份到 class\_rw\_t 中的 属性列表、方法列表、协议列表；
         2. ##### 然后 按编译顺序 将 分类对象的 属性列表、对象方法列表、类方法列表 和 协议列表 放到类对象的对应列表头部\(表中旧数据向后移动\)，最后列表中的数据是后编译的放到前面。
3. ##### 执行 main 函数 --&gt; UIApplicationMain\(\)函数 --&gt; 创建 \[ UIApplication、AppDelegate 对象、主线程、mainRunLoop 、keyWindow\(解读info.plist 找到 Main -&gt; Main.storyboard -&gt; 初始VC -&gt; vc.view加到主窗口\) \] --&gt; 通知 AppDelegate 对象的对应顺序监听方法 --&gt; 显示APP

# 面试题：

* #### 0. MVC、MVP 与 MVVM

  * #### MVC：

    * ##### model 用于存数据，
    * ##### View只是单纯展示\(与model无关联，变种后的可以拥有model\)，
    * ##### Controller用于数据获取、设置给view及响应事件；
  * #### MVP：

    * ##### model 用于存数据，
    * ##### View将属性view暴露出来单纯展示，
    * ##### P是处理 对应模块的view\(设置显示内容及响应事件\)和model 数据处理；model 与 View 毫无关联，P是将以应功能从Controller 解放出来。
  * #### MVVM：

    * ##### model用于存数据，
    * ##### ViewModel 处理对应模块的view\(事件响应\) 和 model数据处理，并且自身添加model所有属性用于被view监听改变，
    * ##### View 拥有 viewModel 并监听该对象属性的改变
* #### 1.OC 类本质是结构体，对像是一个结构体指针

```
struct objc_class {
    Class _Nonnull isa  OBJC_ISA_AVAILABILITY;

#if !__OBJC2__
    Class _Nullable super_class                              OBJC2_UNAVAILABLE;
    const char * _Nonnull name                               OBJC2_UNAVAILABLE;
    long version                                             OBJC2_UNAVAILABLE;
    long info                                                OBJC2_UNAVAILABLE;
    long instance_size                                       OBJC2_UNAVAILABLE;
    struct objc_ivar_list * _Nullable ivars                  OBJC2_UNAVAILABLE;
    struct objc_method_list * _Nullable * _Nullable methodLists                    OBJC2_UNAVAILABLE;
    struct objc_cache * _Nonnull cache                       OBJC2_UNAVAILABLE;   哈希表查找和缓存
    struct objc_protocol_list * _Nullable protocols          OBJC2_UNAVAILABLE;
#endif

} OBJC2_UNAVAILABLE;

// NSObject 类
struct NSObject_IMPL {
   Class isa ;
}
```

#### ![](/images/objc_class结构体.png)

* #### 1.1 哈希表\(散列表\)的实现原理？OC中哪些用到哈希表？

  * ##### 哈希表：利用空间换时间（以插入 key 、value 为例）

    * ###### 首先开辟一个内存地址的数组且置NSULL，数组的长度为 len ;
    * ###### 利用 key & \(len-1\) 得到哈希值 i \(&lt;len\) 作为数组下标；取出对应位置的 &lt;\_key,\_value&gt;；
    * ###### 对比 key 与 \_key ：

      * ###### 如果相等 或是 NSULL：则直接更新该位置的 key 和 value ;
      * ###### 如果不等\(哈希碰撞\)：while\(i--\){直到找到相等的 key 或 NSULL 空位置时更新内容，然后退出}；如果没有找到空位置 或 key相等，则对哈希表重新扩容（旧表中的key,value值重新按照上面的步骤重新操作更新哈希表）
  * ##### 字典、对象动态绑定属性、查找方法时的缓存、weak表
* #### 2.一个 NSObject 对像点用多少内存？

  * **系统分配了16个字节内存给 NSOjbect 实例对像**\(内部规定最少16个字节，子类对像 超过16个字节的以**16个字节对齐**，即16的整倍数\)，可以通过 **malloc\_size** 函数获得；

  * **但 NSObject 实例对像实际占用内存就是成员变量的大小 8个字节**（相对64位环境下，成员变量 isa 指针大小，子类对像 超过8个字节的以**8个字节对齐**，即8的整倍数），可以通过 **class\_getInstanceSize** 函数获得；
* #### 3. 如果基类NSObject 实现一个对象方法-\(void\)text，那么即可以用该类NSObject及其子类 调用类方法+\(void\)text 的方式调用;

  * **因为基元类对象的 superclass 指向了基类对象，发送的消息不会区分是对象方法还是类方法。**
* #### 4. 对象的isa指针指向哪里？

  * ###### instance 对象的 isa 指针指向 class对象;
  * ###### class 对象的 isa 指针指向 元类对类；
  * ###### 元类对象的 isa 指针指向 基元类对象。
* #### 5.OC的类信息存放在哪里？

  * ###### 对象方法列表、成员变量列表、协议信息列表，存放在class对象中；
  * ###### 类方法存放在 元类对象中；
  * ###### 成员变量的具体值，存放在 实例对象。
* #### 6.KVO 实现原理？

  1. **使用runtime 动态创建一个子类 NSKVONotifying\_QJStudent；**

     ```
     ![](/assets/runtime创建KVO类并重写四个方法.png)
     ```

  2. **重写 -setAge: 、 -class 、-dealloc 和 -\_isKVOA 实例对象方法。**

     1. NSKVONotifying\_QJStudent 内部大致实现，重写了几个方法: -setAge: 、 -class 、-dealloc 和 -\_isKVOA

     2. ```
        -(Class)class{
            return class_getSuperclass(object_getClass(self));
        }

        -(void)setAge:(NSInteger)age {

           // _NSSet类型ValueAndNotify : _NSSetObjectValueAndNotify 等
            _NSSetLongLongValueAndNotify(...);

            [self willChangeValueForKey:@"age"];
            [super setAge:age];
            // 内部通知了观察者改变了 age 值
            [self didChangeValueForKey:@"age"];

        }

        // NSObject 实例对象方法 didChangeValueForKey 的伪代码
        -(void)didChangeValueForKey:(NSString *)key{
            // NSLog(@"didChangeValueForKey 前");

            // 判断如果是KVO对象，则通知观察者当前对象的key值改变了
            // [observer observeValueForKeyPath:key ofObject:self change:@{..} context:nil];
            // [super didChangeValueForKey:key];

            // NSLog(@"didChangeValueForKey 后");
        }
        ```

        ```
        QJStudent  objc = [QJStudent new];
        QJStudent  objc2 = [QJStudent new];
        //        objc_getClass(<#const char * _Nonnull name#>)
        //        object_getClass(<#id  _Nullable obj#>)
        NSLog(@"添加观察之前：%p , %p" ,
              [objc methodForSelector:@selector(setAge:)],
              [objc2 methodForSelector:@selector(setAge:)]);
        [objc addObserver:objc2 forKeyPath:@"age" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        NSLog(@"添加观察之后：%p , %p" ,
              [objc methodForSelector:@selector(setAge:)],
              [objc2 methodForSelector:@selector(setAge:)]);
        ```

            // 打印信息
            2021-01-24 21:30:48.599451+0800 domeText[5854:532542] 添加观察之前：0x100003bc0 , 0x100003bc0
            2021-01-24 21:30:48.600453+0800 domeText[5854:532542] 添加观察之后：0x7fff211a2368 , 0x100003bc0
            (lldb) p (IMP)0x100003bc0   // 查看方法的实现
              (IMP) $0 = 0x0000000100003bc0 (domeText`-[QJStudent setAge:] at main.m:21)
            (lldb) p (IMP)0x7fff211a2368  // objc 对象添加观察之后的 -setAge: 方法实现
              (IMP) $1 = 0x00007fff211a2368 (Foundation`_NSSetLongLongValueAndNotify)
            (lldb) p objc->isa            // objc 对象添加观察之后的 -setAge: 方法实现
              (Class) $2 = NSKVONotifying_QJStudent
* #### 7. 如何手动触发 KVO ？

  1. ##### object1 先实现对 age属性 KVO 的监听

     ```
     [object1 addObserver:observer forKeyPath:@"age" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
     ```
  2. ##### 手动调用如下两个方法，触发 KVO

     ```
     [object1 willChangeValueForKey:@"age"];
     // 中间可以添加 object1->_age = 10 ;
     [object1 didChangeValueForKey:@"age"];
     ```
* #### 8. 直接修改成员变量会不会触发 KVO 监听？

  * ##### 不会触发，因为必须通过 set方法 才能触发。
* #### 9. KVC实现原理？

  * ##### KVC赋值的过程原理：会触发KVO

    * ```
      [objc setValue:@10 forKey:@"age"];

      //        if (isKVO类实例 && [objc respondsToSelector:NSSelectorFromString(@"setAge:")]) {
      //            [objc willChangeValueForKey:@"age"];
      //        }

      //        // 1.按顺序查找 setAge: 、_setAge: 方法，找到则执行该方法
      //        // 2.如果没有找到，判断是否可以直接访问成员变量，如果不可以则调用 -setValue:forUndefinedKey:报错
      //        // 3.如果允许访问，则按顺序查找 _age、_isAge、age、isAge
      //        // 4.如果还没找到则调用 -setValue:forUndefinedKey:报错

      //        if (isKVO类实例 && [objc respondsToSelector:NSSelectorFromString(@"setAge:")]) {
      //            [objc didChangeValueForKey:@"age"]; // 可以触发 observer 对 objc 对象的 age key名 监听
      //        }
      ```
    * +\(BOOL\)accessInstanceVariablesDirectly 表示 是否允许直接访问实例的成员变量![](/assets/KVC实现原理.png)
  * ##### KVC 取值的过程原理：

    * ##### \[objc valueForKey:@"age"\];![](/assets/KVC获取值的过程.png)

### 分类

* #### 10. 分类中存放哪些内容？Categroy 实现原理？

  1. ##### 实现原理：

     1. ##### Categroy 编译之后的底层结构是 struct categroy\_t \(最新的代码\) 对象，存放着分类信息\(分类名、类名、对象方法列表、类方法列表、协议列表 和 属性列表\)；
     2. ##### 在程序运行时runtime 按编译好的所有分类顺序将分类\(对象方法列表、类方法列表、协议列表 和 属性列表\) 附加\(插入到每个列表的头部\)到对应的类对象中，注意：后编译分类的信息最终按顺序放到类对像中对应列表的最前面。
  2. ##### 为什么 分类是在运行时加载到类中去呢？

     * ##### 因为编译文件的顺序是无法确定的，类对象有可能后编译加载到内存中，那么如果分类先编译加载到内存的话就没法找到类对象，所以必须等所有文件编译完后在 运行时才能添加到类对象中。
  3. ##### Categroy 内容信息：
* * ```
    struct objc_category { // 旧代码的结构体名
        char * _Nonnull category_name                            OBJC2_UNAVAILABLE;    // 分类名
        char * _Nonnull class_name                               OBJC2_UNAVAILABLE;    // 类名
        struct objc_method_list * _Nullable instance_methods     OBJC2_UNAVAILABLE;    // 对象方法列表
        struct objc_method_list * _Nullable class_methods        OBJC2_UNAVAILABLE;    // 类方法列表
        struct objc_protocol_list * _Nullable protocols          OBJC2_UNAVAILABLE;    // 协议列表
        struct objc_property_list * _Nullable propertys          OBJC2_UNAVAILABLE;    // 属性列表
    }
    ```
* #### 11. Categroy  与 类扩展 的区别？

  1. ##### 分类是有分类名，但 类扩展是没有名的；
  2. ##### 分类中不能添加成员变量，但 类扩展可以添加；
  3. ##### 分类中添加的属性只声明 getter & setter 方法不会自动生成实现该方法，但 类扩展添加的属性是自动实现的；
  4. ##### 分类的数据信息是在 runtime 运行时 附加到类对像中的，而类扩展中的信息是在 编译时 与类组成一个完整的类对象的。
* #### 12. Categroy 有+load方法吗？+load方法什么时候调用的？load方法能继承吗？

  1. ##### 分类有+load方法；
  2. ##### +load方法在运行时加载 类、分类时调用；

     1. ##### 先调类对象的+load方法\(类中又是先父类后子类的顺序\)，后分类的；
     2. ##### 调用是直接使用+load方法地址调用的，不是发送消息；
  3. ##### load方法可以继承，子类发送消息时，子类没有就会去父类找。
* #### 13. +load、+initialize 方法有什么区别？它们在categroy中的调用顺序？以及出现继成时它们之间的调用过程？

  * #### 两个方法的区别：

    * ##### 调用方式：+load是直接通过地址调用；而 +initialize 是通过类对象发送消息方式objc\_msgSend调用;
    * ##### 调用时刻：+load是runtime加载类、分类的时候调用\(只会调用1次\)；而 +initialize 是第一次使用类时初始化发送initialize 消息时调用\(由于消息传递机制，当子类没有实现该方法时，父类的+initialize方法会被多次调用\)。\(两个方法第一次被调用时都是使用了递归机制\)
    * ##### 调用顺序：

      * ##### +load

        1. ##### 先调用类的+load方法：

           1. ##### 先父类的+load，后子类的+load；
           2. ##### 非继承关系的类+load方法调用顺序是按编译顺序调用
        2. ##### 后调用分类的+load方法：所有分类间的+load方法调用是安编译顺序调用的。
      * ##### +initialize

        1. ##### 先父类初始化，再子类初始化\(可能最终调用父类的方法，因为调用消息传递机制\)。
* #### 14. Categroy 能否添加成员变量？如果可以，如何给 Categroy添加成员变量？

  * ##### 不可以，但可以使用runtime给对象添加关联属性值实现属性功能；
  * #### 给object关联key属性的value值的底层实现原理：

    1. ##### 从全局拿到一个 AssociationManager类型的 manager 变量；
    2. ##### manager 内部拿到 AssociationHashMap类型的 对象 hashMap；
    3. ##### hashMap\[object经过位运算处理\] 拿到对应的 ObjectAssociationMap类型的 对象 objectMap，如果不存在时创建这个Map对象 并且 修改object 的 has\_asso = YES ;

       1. ##### object 的 has\_asso 用于标记该对象存在关联对象，当object对象释放时把object关联的所有关联对象从hashMap中移除掉；
    4. ##### 将 value 和 内存策略 包装成 ObjectAssociation 类型的 变量 赋值给 objectMap\[key\] ；

       1. ##### value == nil 时会将 objectMap\[key\] 的旧记录擦除掉；

### Block

* #### 15. block 本质是什么？

  1. ##### 本质就是一个OC对象，内部有 isa指针、指针函数funcPtr 、实例结构体大小 和 引用局部变量时捕获生成的 成员变量等；
  2. ##### 关于捕获：

     1. ##### 只捕获局部变量，全局变量不会捕获，因为block如果在其他地方调用全局变量还是能拿到，而局部变量是拿不到的，所以需要访问自身的成员变量不管在哪个地方都能拿到；
     2. ##### static 静态局部变量捕获到的是生成同名的同类型指针，对该static局部变量地址的引用；非静态局部变量捕获到的是生成同名的同类型成员变量，对该局部变量值的引用。
* #### 16. block 哪几种类型？
* 1. ##### \_\_NSGlobalBlock : block内部不引用auto局部变量\(如：引用 全局变量、静态变量 和 不用引外部变量\) ，block存放在全局区；

     1. ###### 该类型的对象 调用 copy 什么也不做，还是全局block;
  2. ##### \_\_NSStackBlock : 只存在MRC环境下，block内部引用了外部的 auto局部变量\(即非static静态的局部变量\)，存放在栈区；

     1. ###### 该类型的对象 调用 copy 会将\_\_NSStackBlock 存入到 堆区；变成 \_\_NSMallockBlock 类型；
     2. ###### 如果block是放在栈区，对引用外部的局部 auto OC对象不会强引用；属性于assige赋值。
  3. ##### \_\_NSMallockBlock : 在MRC环境下， \_\_NSStackBlock 这种类型对象使用 copy 时，存放在堆区；在ARC环境下，block 内部引用了外部的 非static静态局部变量，会自动实现了 copy 操作，存放在堆区；

     1. ###### 该类型的对象 调用 copy ，引用计数器+1；
     2. ###### 放在堆区的block，如果外部的局部auto OC对象是强引用那么block就是对该OC对象强引用，如果外部的是弱引用变量那么block就是对该OC对象弱用；\(即外部是什么类型的内部就是什么类型\)。
* #### 17.\_\_block 修饰的局部变量,block内部结构？

  * ##### 注意：在MRC环境下，\_\_block可以解决循环引用问题，因为被包装的局部变量是对象类型时不管强弱引用系统都不会做强引用该局部变量\(不会做retain操作\);

  ##### ![](/assets/__block修饰的局部变量形成的内部结构.png)

  ##### 
* #### 18. block 解决循环引用？

  * ##### ARC环境下：使用 \_\_weak 和 \_\_unsafe\_unretained （使用时注意不会自动置nil，可能会引起坏内存访问）
  * ##### MRC环境下：使用 \_\_safe\_unretained 和 \_\_block 修饰变量

### Runtime

* #### 底层面试题：[https://blog.51cto.com/14121524/2475958](https://blog.51cto.com/14121524/2475958)
* #### 19. objc\_msgSend 函数查找调用方法的三个阶段？

  * #### 消息发送：

    * ##### 通过消息接收者reserver的isa指针 找到类对象 或 元类对象\(reserver\_class\)，然后从该对象中的cach方法缓存中查找，如果没找到就从class\_rw\_t中方法列表查找，如果找到则调用IMP函数 并 缓存到 cache 中；
    * ##### 如果没有找到就从 superclass 中按上面步骤查找，如果找到了就调用方法 并 缓存到 reserver\_class 的 cache 中；如果一直没找到就进入下一步 动态方法解析\(通过判断不重复进入这一步\)。
  * #### 动态方法解析：

    * +\(BOOL\)resolveInstanceMethod:\(SEL\)sel 和 +\(BOOL\)resolveClassMethod:\(SEL\)sel

    * ##### 根据不同的方法，动态给对象添加方法\(class\_addMethod 函数\) ，标记已经动态解析；然后系统又重新走消息发送 。
  * #### 消息转发机制：\(注意：类对象发送消息也有消息转发机制\)

    * ##### 更换消息接收者：-或+\(id\)forwardingTargetForSelector:\(SEL\)aSelector；如果返回 nil 进入完全消息转发；返回有值则重新发送消息；
    * ##### 完全消息转发：

      * ##### 获取方法签名：-或+\(NSMethodSignature\*\)methodSignatureForSelector:\(SEL\)aSelector

        * ###### 如果返回nil或不正确的方法签名，则直接报错打不到方法；
        * ###### @encode\(&lt;\#type-name\#&gt;\) 可以获取对应类型的 签名类型，如：指针对应@
      * ##### -或+\(void\)forwardInvocation:\(NSInvocation \*\)anInvocation 内可以不处理消息 或 处理消息\(可获取和修改所有的参数，包括返回值参数\)
* #### 20. @dynamic key \(不会自动生成 getter 、 setter 方法 和 \_key成员变量\)；@synthesize key=\_key（自动生成 getter 、setter 方法 和 指定的\_key成员变量）

### RunLoop

* #### 底层面试题：[https://blog.51cto.com/14121524/2475958](https://blog.51cto.com/14121524/2475958)
* #### 21.runloop 与 线程的关系？

  * ##### 与线程是一一对应的关系，子线程的runloop需要手动开启，第一次获取即创建runloop，底层由一个全局的Dictionray管理，线程做为key，runloop做为value;
* #### 22. runloop 内部实现？

  * #### ![](/assets/runloop实现机制1.png)
* #### 23. runloop 如何实现休眠的？

  * ##### 从用户态转成内核态。

### 多线程

* #### 24. 如何保证多读单写安全？

  * ##### 通过 pthread\_rwlock 读写锁；
  * ##### 或通过 [dispatch\_barrier\_async](https://www.jianshu.com/p/540c2b22ba38)（栅栏函数）实现单写功能，读取功能的所有异步任务保证都是添加到同一个并发队列中。
* #### 25. 如保控制最大并发数量？

  * ##### 通过 [NSOperationQueue](https://www.jianshu.com/p/9161a6490977) 或 [Dispatch Semaphore](https://www.jianshu.com/p/8549a35b7bf2) 信号量控制。
* #### 26. CADisplayLink 与 NSTimer 定时器准确吗？使用什么定时器比较准确？

  * ##### 不准确：因为这两个定时器是基于runloop 实现的，如果runloop在处理耗时的任务时定时器就会有延时执行；
  * ##### 使用 GCD 的定时器准备，因为是基于内核实现的，与Runloop 毫无关系：
  * ```
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, <#dispatchQueue#>);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, <#intervalInSeconds#> * NSEC_PER_SEC, <#leewayInSeconds#> * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
                    <#code to be executed when timer fires#>
                });
    dispatch_resume(timer);
    ```



