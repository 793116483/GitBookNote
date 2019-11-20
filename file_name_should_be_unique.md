# 出现的问题解决方法

#### stackoverflow（全英文，IT问答网站）
- 基本上开发中遇到的问题都有
- 只能是英文

#### -[NSInvocation setArgument:atIndex:]: index (4) out of bounds [-1, 3]
- 原因：系统给该方法传参的个数 **>** 该方法需要传参的个数，导致系统漰溃
