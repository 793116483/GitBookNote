* **将OC文件.m 转成 C++文件 的指令：**xcrun -sdk iphoneos clang -arch arm64 -rewrite-objc ~/路径/xxxx.m -o ~/路径/xxxx.cpp 

# 面试题：

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
    struct objc_cache * _Nonnull cache                       OBJC2_UNAVAILABLE;
    struct objc_protocol_list * _Nullable protocols          OBJC2_UNAVAILABLE;
#endif

} OBJC2_UNAVAILABLE;

// NSObject 类
struct NSObject_IMPL {
   Class isa ;
}
```

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

  * ###### 对象方法、成员变量、协议信息，存放在class对象中；
  * ###### 类方法存放在 元类对象中；
  * ###### 成员变量的具体值，存放在 实例对象。





