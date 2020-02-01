# 〇〇Q#（五）：量子纠缠

[本文Github地址](https://github.com/jks-liu/quantum/blob/master/nb/005-quantum-entanglement.ipynb)。由于Github渲染Jupyter里的公式有些问题，建议下载下来查看，这样的话，下面的代码也可以直接运行。

目录：[Github](https://github.com/jks-liu/quantum)，[知乎专栏](https://zhuanlan.zhihu.com/p/98372659)。

这篇文章中，你会学到以下内容

关于量子算法
- 量子纠缠（quantum entanglement）

关于Q#
- `CNOT`量子门，**控制非门（Controlled-NOT gate）**

量子纠缠可能是被大家误解得最多的概念之一。简单来说，当两个（或更多个）量子发生纠缠的时候，你无法仅通过单独地描述这两个（多个）量子来描述这个（由两个或多个量子组成的）系统，你只能描述系统整体的性质。

# 未纠缠态
我们通过两个量子比特的系统举例说明，多量子的系统类似。如果我们有$\psi_1 = \begin{bmatrix} 1 \\ 0 \end{bmatrix}$和$\psi_2 = \frac{1}{\sqrt{2}}\begin{bmatrix} 1 \\ 1 \end{bmatrix}$。那么这两个比特组成的系统为$\psi = \begin{bmatrix} \frac{1}{\sqrt{2}} \\ \frac{1}{\sqrt{2}} \\ 0 \\ 0 \end{bmatrix}$。

反过来如果我们知道$\psi = \begin{bmatrix} \frac{1}{\sqrt{2}} \\ \frac{1}{\sqrt{2}} \\ 0 \\ 0 \end{bmatrix}$，我们也能算出$\psi_1 = \begin{bmatrix} 1 \\ 0 \end{bmatrix}$和$\psi_2 = \frac{1}{\sqrt{2}}\begin{bmatrix} 1 \\ 1 \end{bmatrix}$。（细心的读者可能发现不止这一种$\psi_1$，$\psi_2$满足条件，但与本主题不相关，暂且不表。）

# 纠缠态
但是如果$\psi = \begin{bmatrix} \frac{1}{\sqrt{2}} \\ 0 \\ 0 \\ \frac{1}{\sqrt{2}} \end{bmatrix}$，我们会发现解不出一个$\psi_1$，$\psi_2$让它们的张量积为$\psi$。那么我们就可以说这是一种**量子纠缠**态。

# 纠缠态的意义
还以$\psi = \begin{bmatrix} \frac{1}{\sqrt{2}} \\ 0 \\ 0 \\ \frac{1}{\sqrt{2}} \end{bmatrix}$这个纠缠态为例，我们有以下结论。如果我们测量这个系统，那么

- 结果为$|00\rangle$的概率为$||\frac{1}{\sqrt{2}}||^2=\frac{1}{2}$
- 结果为$|01\rangle$的概率为$0$
- 结果为$|10\rangle$的概率为$0$
- 结果为$|11\rangle$的概率为$||\frac{1}{\sqrt{2}}||^2=\frac{1}{2}$

即$\psi_1$，$\psi_2$要么全是$|0\rangle$，要么全是$|1\rangle$。或者说如果我们先测量$\psi_1$并且结果是$|0\rangle$，那么我们可以肯定再测量$\psi_2$的时候结果也是$|0\rangle$，反之亦然。或者说把这两个量子一个拿到火星上一个拿到水星上，然后对它们进行测量，那么必然会是一样的测量结果，这就是爱因斯坦所说的鬼魅般的超距作用。

上面说完了纠缠是什么样子的，那么纠缠为什么是这个样子？这就是一个哲学问题了。也许一开始会觉得反常识，但常识是什么，常识只是我们多看了几遍熟悉了它，它就变成了常识。所以，对于量子力学的某些结论，有时我们不需要刻意去“弄懂”它，多看几遍，熟悉了自然就“懂”了。

# 在Q#中实现量子纠缠


```qsharp
operation quantum_entanglement(): Unit {
    using (qs = Qubit[2]) {
        H(qs[0]);
        CNOT(qs[0], qs[1]);
        if (M(qs[0]) == Zero) {
            Message("qs0 is Zero");
        } else {
            Message("qs0 is One");
        }
        
        if (M(qs[1]) == Zero) {
            Message("qs1 is Zero");
        } else {
            Message("qs1 is One");
        }
        
        Reset(qs[0]);
        Reset(qs[1]);
    }
}
```




<ul><li>quantum_entanglement</li></ul>




```qsharp
%simulate quantum_entanglement
```

    qs0 is Zero
    qs1 is Zero
    




    ()



反复运行上面的程序，会有随机的运行结果。但两个量子比特的值始终保持一样。

下面我们从狄拉克符号和数学计算两个角度来解释上面的程序。

## 狄拉克记号解释
1. 首先我们初始化了两个量子比特，值分别是$|0\rangle$，$|0\rangle$，系统的值为$|00\rangle$；
1. 对第一个量子作用量子门`H`，值分别是$|+\rangle=(|0\rangle+|1\rangle)/\sqrt{2}$，$|0\rangle$，系统的值为$(|00\rangle+|10\rangle)/\sqrt{2}$
1. 对系统（两个量子）作用`CNOT`量子门，即**控制非门（Controlled-NOT gate）**。它的作用就像它的名字所暗示的，以第一个参数的值控制第二个参数的变化，当第一个参数是$|1\rangle$的时候，第二个参数取反；当第一个参数是$|0\rangle$的时候，就什么也不变。即它将
    - $|00\rangle$变成$|00\rangle$
    - $|01\rangle$变成$|01\rangle$
    - $|10\rangle$变成$|11\rangle$
    - $|11\rangle$变成$|10\rangle$  
    所以将$(|00\rangle+|10\rangle)/\sqrt{2}$变为$(|00\rangle+|11\rangle)/\sqrt{2}$

## 数学解释
1. 首先我们初始化了两个量子比特，值分别是$\begin{bmatrix} 1 \\ 0 \end{bmatrix}$，$\begin{bmatrix} 1 \\ 0 \end{bmatrix}$，系统的值为$\begin{bmatrix} 1 \\ 0 \\ 0 \\ 0 \end{bmatrix}$；
1. 对第一个量子作用量子门`H`，值分别是$\frac{1}{\sqrt{2}}\begin{bmatrix} 1 \\ 1 \end{bmatrix}$，$\begin{bmatrix} 1 \\ 0 \end{bmatrix}$，系统的值为$\begin{bmatrix} \frac{1}{\sqrt{2}} \\ 0 \\ \frac{1}{\sqrt{2}} \\ 0 \end{bmatrix}$
1. 对系统（两个量子）作用`CNOT`量子门，其中

$$CNOT = \begin{bmatrix} 1&0&0&0 \\ 0&1&0&0 \\ 0&0&0&1 \\ 0&0&1&0 \end{bmatrix} \\ \begin{bmatrix} 1&0&0&0 \\ 0&1&0&0 \\ 0&0&0&1 \\ 0&0&1&0 \end{bmatrix}\begin{bmatrix} \frac{1}{\sqrt{2}} \\ 0 \\ \frac{1}{\sqrt{2}} \\ 0 \end{bmatrix} = \begin{bmatrix} \frac{1}{\sqrt{2}} \\ 0 \\ 0 \\ \frac{1}{\sqrt{2}} \end{bmatrix}$$
