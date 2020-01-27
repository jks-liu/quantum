# 〇〇Q#（四）：多个量子比特

[本文Github地址](https://github.com/jks-liu/quantum/blob/master/nb/004-multi-qubits.ipynb)。由于Github渲染Jupyter里的公式有些问题，建议下载下来查看，这样的话，下面的代码也可以直接运行。

目录：[Github](https://github.com/jks-liu/quantum)，[知乎专栏](https://zhuanlan.zhihu.com/p/98372659)。

这篇文章中，你会学到以下内容

关于量子算法
- 多量子系统
- 大小端问题
- No-Cloning Theorem

关于数学
- 向量/矩阵的张量积（Tensor product）$A \otimes B$
- 狄拉克符号（Dirac Notation）

关于Q#
- 初始化多个量子比特
- 用`open`导入函数库
- 使用`DumpRegister`打印量子状态信息用于Debug

# 张量积（Tensor product）
我们大多了解向量的乘法，这里我们再介绍另一种乘法，张量积。

定义$A$（$m \times n$维）和$B$（$k \times l$维）的张量积$A \otimes B = \begin{bmatrix} a_{1,1}B & ... \\ ... & a_{m,n}B \end{bmatrix}$（展开$B$），是一个$(m*k) \times (n*l)$维矩阵。看几个例子比较容易理解。

$$\begin{bmatrix} 1 \\ 2 \end{bmatrix} \otimes \begin{bmatrix} 3 \\ 4 \end{bmatrix} = \begin{bmatrix} 1\begin{bmatrix} 3 \\ 4 \end{bmatrix} \\ 2\begin{bmatrix} 3 \\ 4 \end{bmatrix} \end{bmatrix} = \begin{bmatrix} 3 \\ 4 \\ 6 \\ 8 \end{bmatrix}$$

$$\begin{bmatrix} 1 \\ 2 \end{bmatrix} \otimes \begin{bmatrix} 3 & 4 \end{bmatrix} = \begin{bmatrix} 1\begin{bmatrix} 3 & 4 \end{bmatrix} \\ 2\begin{bmatrix} 3 & 4 \end{bmatrix} \end{bmatrix} = \begin{bmatrix} 3 & 4 \\ 6 & 8 \end{bmatrix}$$


$$\begin{bmatrix} 1 & 2 \end{bmatrix} \otimes \begin{bmatrix} 3 \\ 4 \end{bmatrix} = \begin{bmatrix} 1\begin{bmatrix} 3 \\ 4 \end{bmatrix} & 2\begin{bmatrix} 3 \\ 4 \end{bmatrix} \end{bmatrix} = \begin{bmatrix} 3 & 6 \\ 4 & 8 \end{bmatrix}$$

$$\begin{bmatrix} 1 & 2 \\ 3 & 4 \end{bmatrix} \otimes \begin{bmatrix} 5 & 6 \\ 7 & 8 \end{bmatrix} = \begin{bmatrix} 1\begin{bmatrix} 5 & 6 \\ 7 & 8 \end{bmatrix} & 2\begin{bmatrix} 5 & 6 \\ 7 & 8 \end{bmatrix} \\ 3\begin{bmatrix} 5 & 6 \\ 7 & 8 \end{bmatrix} & 4\begin{bmatrix} 5 & 6 \\ 7 & 8 \end{bmatrix} \end{bmatrix}=...$$

## Mixed product property
矩阵的乘法和张量积经常出现在同一个公式中，下面这个性质是量子力学中最常用的性质之一：

$$(A \otimes B)(C \otimes D) = (AC) \otimes (BD)$$

# 多量子比特
有了上面的介绍，多量子比特的表示就很自然了。多量子比特就是单量子比特的张量积。

## 狄拉克符号（Dirac Notation）
在继续之前，介绍一些量子力学常用的符号。

对于一个列向量$\psi$，我们通常将其写成**ket**向量的形式$|\psi\rangle$，其共轭转置通常写为**bra**向量的形式$\langle\psi|$。两个向量$\phi$和$\psi$内积一般写为**braket**的形式$\langle\phi|\psi\rangle$。即

$$\psi = |\psi\rangle \\ \psi^{\dagger} = \langle\psi| \\ <\phi,\psi> = \langle\phi|\psi\rangle$$

另外，矢态`Zero`记为$|0\rangle$，矢态`One`记为$|1\rangle$。当矢态为`Zero`或`One`的时候，张量积记为以下形式，并推广到更高维：

$$|0\rangle \otimes |0\rangle = |00\rangle \\ |0\rangle \otimes |1\rangle = |01\rangle \\ |1\rangle \otimes |0\rangle = |10\rangle \\ |1\rangle \otimes |1\rangle = |11\rangle$$

有两个矢态由于比较常用，所以专门给它们一个狄拉克记号：

$$|+\rangle = H|0\rangle = \frac{1}{\sqrt{2}}\begin{bmatrix} 1 \\ 1 \end{bmatrix} \\ |-\rangle = H|1\rangle = \frac{1}{\sqrt{2}}\begin{bmatrix} 1 \\ -1 \end{bmatrix}$$

同时有如下指数形式，请自行推广到高次

$$|0\rangle \otimes |0\rangle = |0\rangle^{\otimes 2} \\ |1\rangle \otimes |1\rangle = |1\rangle^{\otimes 2} \\ |+\rangle \otimes |+\rangle = |+\rangle^{\otimes 2} \\ |-\rangle \otimes |-\rangle = |-\rangle^{\otimes 2}$$

我们先来看一个例子，比如两个量子比特的矢态分别是$\psi_1 = \begin{bmatrix} 1 \\ 0 \end{bmatrix}$和$\psi_2 = \frac{1}{\sqrt{2}}\begin{bmatrix} 1 \\ 1 \end{bmatrix}$。那么这两个量子比特组成的系统的矢态为它们的张量积

$$\psi_1 \otimes \psi_2 = \begin{bmatrix} 1*\frac{1}{\sqrt{2}}\begin{bmatrix} 1 \\ 1 \end{bmatrix} \\ 0*\frac{1}{\sqrt{2}}\begin{bmatrix} 1 \\ 1 \end{bmatrix} \end{bmatrix} = \begin{bmatrix} \frac{1}{\sqrt{2}} \\ \frac{1}{\sqrt{2}} \\ 0 \\ 0 \end{bmatrix}$$

我们用狄拉克记号把上面的公式重写一遍：$\psi_1 = |0\rangle$，$\psi_2 = \frac{1}{\sqrt{2}}\big(|0\rangle+|1\rangle\big) = H|0\rangle = |+\rangle$

$$\psi_1 \otimes \psi_2 = |0\rangle \otimes \frac{1}{\sqrt{2}}\big(|0\rangle+|01\rangle\big) = \frac{1}{\sqrt{2}}\big(|00\rangle+|01\rangle\big)$$

可以看到原始张量积为一个4维列向量，它们分别对应$|00\rangle$，$|01\rangle$。$|10\rangle$和$|11\rangle$这4个状态。向量中每个值范数的平方即为对应状态的概率，和单量子系统是一样的。也就是说，当我们测量这个系统（即测量这两个量子比特）的时候，结果为$|00\rangle$的概率为$||\frac{1}{\sqrt{2}}||^2=\frac{1}{2}$。

显然对于$N$个量子组成的系统，其矢态对应一个$2^N$维的列向量。

## 大小端问题

让我们在代码中实现上面的例子。


```qsharp
open Microsoft.Quantum.Diagnostics;

operation two_qubits(): Unit {
    using (qs = Qubit[2]) {
        H(qs[0]);        
        DumpRegister((), qs);
        Reset(qs[0]);
    }
}
```




<ul><li>two_qubits</li></ul>




```qsharp
%simulate two_qubits
```

    # wave function for qubits with ids (least to most significant): 0;1
    ∣0❭:	 0.707107 +  0.000000 i	 == 	***********          [ 0.500000 ]     --- [  0.00000 rad ]
    ∣1❭:	 0.707107 +  0.000000 i	 == 	***********          [ 0.500000 ]     --- [  0.00000 rad ]
    ∣2❭:	 0.000000 +  0.000000 i	 == 	                     [ 0.000000 ]                   
    ∣3❭:	 0.000000 +  0.000000 i	 == 	                     [ 0.000000 ]                   
    




    ()



我们使用`DumpRegister`来打印量子比特的状态。其有两个输入参数，第一个我们暂时忽略，第二个参数即我们需要查看的量子比特数组。使用前我们需要从名字空间中导入`open Microsoft.Quantum.Diagnostics;`。

以$|0\rangle$为例说明其输出。`0.707107 +  0.000000 i`为其矢态的分量，即上面的$\frac{1}{\sqrt{2}}$。`[ 0.500000 ]`即上面所提到的概率。其它量这里暂时略过。

细心的读者可能已经发现程序中`H(qs[0]);`是对第一个比特进行操作，和上面的公式不太一样。这是因为Q#默认使用的是小端序，从`DumpRegister`输出的第一行就可以看出来`least to most significant`。而我们在文档及其它大部分资料中一般都是大端序。

但大部分时候我们不考虑大小端的问题也不影响我们的理解。

# No-Cloning Theorem
本节可跳过，不影响后面的理解。

我们能够执行`DumpRegister`函数是因为我们不是在一台真正的量子计算机上运行上面的代码。在一台真正的量子计算机上，我们无法复制一个量子比特，就如同本节标题的定理所暗示的一样。无法复制也就意味着无法在不干扰原系统的情况下准确观测它的状态。

我们可以从海森堡测不准原理来理解No-Cloning Theorem。根据测不准原理，对于量子A（当然量子是一个抽象的概念，这里为便于理解可以把它认为是一个实物粒子）会有两个量x和y（比如位置和动量）不可能同时精确测量。如果我们可以把量子A的状态复制到量子B上，那么我们就可以在A上精确测量x，在B上精确测量y，显然这就违背了测不准原理。

No-Cloning Theorem的严谨证明其实也很简单，以后有空再写。
