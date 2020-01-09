# 〇〇Q#（三）：随机数

这篇文章中，你会学到以下内容

关于量子算法
- 随机数生成算法
- 量子的两个基本状态
- 初始化一个量子比特
- 测量一个量子比特
- 复位一个量子比特

关于数学
- 向量/矩阵的共轭转置，$M^{\dagger}$
- 向量的内积，$<u, v>$
- 向量的范数（Norm），$||v||$

关于Q#
- Q#的`operation`结构
- 使用`Message`打印Debug信息
- 分支（`if`）语句
- 注释`//`

# 随机数算法的实现


```qsharp
operation random_number(): Unit {
    using (q=Qubit()) {
        // Q#中会自动将新申请的量子比特初始化为Zero
        H(q);
        if (M(q) == Zero) {
            Message("随机数是Zero");
        } else {
            // M(q)是One
            Message("随机数是One");
        }
        Reset(q);
    }
}
```




<ul><li>random_number</li></ul>



# 量子算法解析

首先，**量子比特（qubit）**有两个基本状态，一个是`Zero`，一个是`One`。这两个都是Q#的关键字。

算法核心有以下三步:
1. **初始化qubit** 使用`q=Qubit()`向系统申请一个qubit，并将其状态初始化为`Zero`；
2. **叠加态** 使用`H(q)`将qubit置于叠加态；
3. **测量** 使用`M(q)`测量qubit。测量处于叠加态的qubit，会有一半的概率得到`Zero`，一半的概率得到`One`。


# 数学描述
数学上，`Zero`和`One`分别对应一个向量，在量子力学语境中，一般称其为**态矢（State Vector）**。

$$
Zero = \begin{bmatrix} 1 \\ 0 \end{bmatrix},
One = \begin{bmatrix} 0 \\ 1 \end{bmatrix}
$$

下面我们来复习一下数学知识。

## 共轭转置（Adjoint，Hermitian（Conjugate） transpose）
我们用$v^*$表示$v$的复数共轭（conjugate）。

对于矩阵$M$（不要求方阵），其共轭转置$M^{\dagger}$符合以下定义：$(M^{\dagger})_{m,n}=(M_{n,m})^*$。比如：

$$\begin{bmatrix} 0  \\ i \end{bmatrix}^{\dagger} = \begin{bmatrix} 0 & -i \end{bmatrix}$$

$$\begin{bmatrix} 0 & -i \\ i & 0 \end{bmatrix}^{\dagger} = \begin{bmatrix} 0 & -i \\ i & 0 \end{bmatrix}$$

共轭转置这个定义和大家熟悉的转置有区别，我们用$M^T$表示$M$的转置。


## 向量的内积与范数（Norm）
若无特殊说明，向量默认为**列向量**。

对于内积大家应该对这个概论比较熟悉。我这里拿出来强调的原因是，好像大部分人只接触过实数域的情况，复数域上有些需要注意的地方。

在实数域上，向量$u$，$v$的内积$<u,v>$为$u^Tv$。其满足交换率。

在复数域上，向量$u$，$v$的内积$<u,v>$为$u^{\dagger}v$。其不满足交换率。但显然$<u,v>=<v,u>^*$。

不追求严谨的话，范数可以理解为绝对值，或向量的模。显然向量$v$（复数域上）的范数$||v||$为$\sqrt{<v,v>}$。

# 量子比特
下面我们回到态矢。态矢也是一个复数域的向量，所以以后若无特殊说明，向量都是复数域上的。

对于单个量子比特q，记其态矢为$\psi=\begin{bmatrix} \alpha \\ \beta \end{bmatrix}$。那我们有以下结论：

1. 当我们测量q（判断它是`Zero`还是`One`）时，有$||\alpha||^2$的概率是`Zero`，有$||\beta||^2 = 1$的概率是`One`;
2. 显然，考虑概率的和必为1，$||\alpha||^2 + ||\beta||^2 = 1$

# 量子算法再解析

前面我们说过，本算法有三步:
1. **初始化qubit** 
2. **叠加态** 
3. **测量** 

量子比特q的态矢变化如下

**初始化**会将其态矢设为`Zero`，即

$$\psi = \begin{bmatrix} 1 \\ 0 \end{bmatrix}$$。

为了得到**叠加态**，我们会用到一个矩阵$H=\frac{1}{\sqrt{2}}\begin{bmatrix} 1 & 1 \\ 1 & -1 \end{bmatrix}$，将其与原态矢$\psi$相乘，使其变为

$$
\psi \Leftarrow H\psi 
= \frac{1}{\sqrt{2}}\begin{bmatrix} 1 & 1 \\ 1 & -1 \end{bmatrix}\begin{bmatrix} 1 \\ 0 \end{bmatrix} 
= \frac{1}{\sqrt{2}}\begin{bmatrix} 1 \\ 1 \end{bmatrix}
$$

上面出现的矩阵乘法就当大家都是会的，我就不细说了。

显然，根据上面讲的，当**测量**这个qubit时，各有一半的概率获得`Zero`或`One`。

以下为运行上面算法的可能结果之一：


```qsharp
%simulate random_number
```

    随机数是One
    




    ()



# Q#语法
上面的代码很简单，相信大家肯定没问题的。就强调几个

- 以分号结尾；
- 变量`q`的作用域只在`using`词法块里；
- 语句`H(q)`就直接改变了`q`的状态，无须写成`q=H(q)`之类的赋值语法。当然了，你想写也写不了；
- 注释以`//`开头。
