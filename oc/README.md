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


### 四、分类 功能
* 颜色

```objc
+ (UIColor *)colorFromHexString:(NSString *)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters

    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];

    // Separate into r, g, b substrings

    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;

    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [self colorFromR:r G:g B:b];
}

+ (UIColor *)colorFromHexNumber:(unsigned int)hex
{
    /**
     * mac内存存储为小端：FFFFFF00 <-高位在后
     */
    unsigned char r, g, b;
    r = (hex & 0xFF0000) >> 16;
    g = (hex & 0x00FF00) >> 8;
    b = (hex & 0x0000FF);
    return [self colorFromR:r G:g B:b];
}

+ (UIColor *)colorFromR:(unsigned char)r G:(unsigned char)g B:(unsigned char)b
{
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

```
