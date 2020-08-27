#! https://zhuanlan.zhihu.com/p/199649086
# 〇〇Q#（六）：Deutsch算法

有了前面那么久的铺垫，我们终于可以写一个不那么平凡的算法。Deutsch算法将是我们学习的第一个真正意义上的量子算法。同时，它几乎是最简单的量子算法。

[本文Github地址](https://github.com/jks-liu/quantum/blob/master/nb/006-deuthch's-algorithm.ipynb)。由于Github渲染Jupyter里的公式有些问题，建议下载下来查看，这样的话，下面的代码也可以直接运行。

目录：[Github](https://github.com/jks-liu/quantum)，[知乎专栏](https://zhuanlan.zhihu.com/p/98372659)。

这篇文章中，你会学到以下内容

关于量子算法
- 量子并行（quantum parallelism）
- 量子算法可以获得函数的整体性质
- 量子线路图（Quantum Circuit）
- Deutsch算法（Deutsch's Algorithm）
- Oracle
- 泡利矩阵（Pauli Matrices）
- 模2加法（Addition modulo 2 $\oplus$）

关于`Q#`
- `operation`作为参数

# 量子并行（quantum parallelism）

对于经典的计算模型，当我们计算$f(x)$的时候，一次只能只能计算一个$x$的值。对于量子计算机，一般的科普读物会说量子计算机可以同时计算多个$x$的值。这样说并不很准确。量子计算机每次也只计算一个$x$，但这个$x$是一个量子态，它可以是以前提到的**叠加态**。

# Deutsch算法解决的问题

Deutsch算法是Deutsch Jozsa算法的简化版本。我们不妨看看Deutsch Jozsa算法解决的问题。

**问题**

我们有谓词函数$f(x)$，所谓谓词函数就是一个返回0或1的函数。函数定义域是一个N比特的数，并且我们限定其一定是以下两种函数之一：

- *常函数（Constant）*：对于所有的$x$，$f(x)$的取值相同（0或1）
- *平衡函数（Balanced）*：有一半的$x$等于0，有一半的函数等于1

Deutsch算法解决的就是以上问题$N=1$时的特例，即定义域就是$\{0,1\}$。Deutsch算法就是判断$f(0)$是否等于$f(1)$。如果用数学语言描述就是，函数$f(x)$的定义域为$\{0, 1\}$，值域也是$\{0, 1\}$。我们的目标是判断这个函数是下面的哪一类：
1. $f(0) = f(1)$，常函数
2. $f(0) \not= f(1)$，平衡函数

说得更加精确一点，Deutsch算法的输入是一个函数，输出的是一个关于这个函数是否满足某个*性质*的判断。

# 传统算法

传统算法需要计算$f(x)$两次，然后判断，没什么可说的。

# 量子算法

量子算法只需要一次计算。

这里强调，量子算法并没有直接计算$f(0)$和$f(1)$的值，而是直接获得了我们想要的函数的某个**整体性质**。

# 量子线路图（Quantum Circuit）
从[上一篇文章](./005-quantum-entanglement.ipynb)我们可以看到，狄拉克记号在描述量子算法的时候更加的简洁。现在，我们再介绍另一种图形化的表示方法，量子线路图。

我们以下图为例：
[Deutsch-Jozsa algorithm's quantum circuit](https://en.wikipedia.org/wiki/Deutsch%E2%80%93Jozsa_algorithm), licensed under the [Creative Commons Attribution-Share Alike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/deed.en) by Peplm.

![Deutsch-Jozsa algorithm's quantum circuit](https://raw.githubusercontent.com/jks-liu/quantum/master/nb/Deutsch-Jozsa-algorithm-quantum-circuit.png)

此图为Deutsch-Jozsa算法，当$n=1$时，就是本文要讲的Deutsch算法。当$n\neq{}1$时的更一般情况，以后再讲。Deutsch算法可以说是最简单的一个算法。

我们先忽略这个Deutsch算法内在原理，看看这个图说了些什么。量子线路图是非常直观的，简单易懂。

- 系统的初始状态为n个$|0\rangle$和1个$|1\rangle$，所以$|\psi_{0}\rangle=|0\rangle^{\otimes{}n}|1\rangle$。在量子线路图中，每一个量子比特用一根线表示，斜杠加上一个n是n个量子比特的简略表示；
- 再对每一个量子比特作用$H$门，得到$|\psi_{1}\rangle$;
- 在对这n+1个比特作用一个$U_f$门，得到$|\psi_{2}\rangle$;
- 在对前n个比特作用$H$门，得到$|\psi_{3}\rangle$；
- 最后再测量前n个比特。

可以看到，量子线路图可以让我们以一种非常直观的方式来了解系统的演变。

## Oracle

Oracle可以认为是一个黑盒子，它以某种量子化的方法执行一个传统的函数，如上图所示，它计算$f(x)$。Oracle可以认为是沟通传统函数和量子函数的一个桥梁。

下面我们仔细看看上面那个Oracle $U_f$做了什么（我们仅考虑$n=1$的情况）。$U_f$的输入是量子比特x和y，输出如下：

- 量子比特x：保持不变（并不是十分准确，见下文描述）
- 量子比特y：演变为$y\oplus{}f(x)$（$\oplus{}$是模2加法，有点类似异或）

**模2加法**介绍
- $|0\rangle\oplus|0\rangle=|0\rangle$
- $|0\rangle\oplus|1\rangle=|1\rangle$
- $|1\rangle\oplus|1\rangle=|0\rangle$

既然是量子比，那就可以有叠加态，比如：

$$|-\rangle\oplus|1\rangle=\frac{|0\rangle-|1\rangle}{\sqrt{2}}\oplus|1\rangle=\frac{|0\rangle\oplus|1\rangle-|1\rangle\oplus|1\rangle}{\sqrt{2}}=\frac{|1\rangle-|0\rangle}{\sqrt{2}}=-|-\rangle$$

显然也有：

$$|+\rangle\oplus|1\rangle=|+\rangle$$

提示：$|-\rangle\oplus|1\rangle=-|-\rangle$是一个很重要的结论，下面我们还会用到。

## Oracle $U_f$

下面，我们继续仔细研究上面这个Oracle $U_f$。我们尝试给它不同的输入，看看它的输出。当然，输出与$f(x)$的性质有关，我们分情况讨论（由于情况很多，我这边选择比较典型的）：

**Case 0**：

- $f(0)=f(1)=0$

这种显然是最简单的，输出于输入完全相同

**Case 1**

- $f(0)=f(1)=1$
- 输入$x=|0\rangle$
- 输入$y=|1\rangle$

则输出如下：

- 输出$x=|0\rangle$，保持不变
- 输出$y\oplus{}f(x)=|1\rangle\oplus|1\rangle=|0\rangle$

**Case 2**

- $f(0)=f(1)=1$
- 输入$x=|0\rangle$
- 输入$y=|-\rangle=\frac{|0\rangle-|1\rangle}{\sqrt{2}}$

则输出如下：

- 输出$x=|0\rangle$，保持不变
- 输出$y\oplus{}f(x)=|-\rangle\oplus|1\rangle=-|-\rangle$，如前文提到的

**Case 3**

- $f(0)=f(1)=1$
- 输入$x=|1\rangle$
- 输入$y=|-\rangle=\frac{|0\rangle-|1\rangle}{\sqrt{2}}$

则输出如下：

- 输出$x=|1\rangle$，保持不变
- 输出$y\oplus{}f(x)=|-\rangle\oplus|1\rangle=-|-\rangle$，如前文提到的

可以看到Case 2与Case 3几乎是一样的

**Case 4**

- $f(0)=0$，$f(1)=1$
- 输入$x=|0\rangle$
- 输入$y=|-\rangle=\frac{|0\rangle-|1\rangle}{\sqrt{2}}$

则输出如下：

- 输出$x=|0\rangle$，保持不变
- 输出$y\oplus{}f(x)=|-\rangle\oplus|0\rangle=|-\rangle$，保持不变

**Case 5**

- $f(0)=0$，$f(1)=1$
- 输入$x=|1\rangle$
- 输入$y=|-\rangle=\frac{|0\rangle-|1\rangle}{\sqrt{2}}$

则输出如下：

- 输出$x=|1\rangle$，保持不变
- 输出$y\oplus{}f(x)=|-\rangle\oplus|1\rangle=-|-\rangle$，如前文提到的

显然Case 4与Case 5就不太一样了

**Case 6**

Case 6就是本节的核心了，这个输入就是上面图中的输入，两个量子比特斗处于叠加态

- $f(0)=0$，$f(1)=1$
- 输入$x=|+\rangle$
- 输入$y=|-\rangle=\frac{|0\rangle-|1\rangle}{\sqrt{2}}$

显然，输入是上面Case 4和Case 5的组合。由于量子门（当然也包括这里的Oracle）是线性的，所以输出也是Case 4和Case 5的组合

$$\frac{\text{Case 4}}{{\sqrt{2}}}+\frac{\text{Case 5}}{{\sqrt{2}}}=\frac{|0\rangle|-\rangle}{{\sqrt{2}}}+\frac{|1\rangle\big(-|-\rangle\big)}{{\sqrt{2}}}=\frac{|0\rangle-|1\rangle}{\sqrt{2}}|-\rangle=|-\rangle|-\rangle$$

回顾我们前面说的，量子比特x在Oracle $U_f$下是保持不变的，当时我们说这不准确。从上面的计算可以看出，当x是一个叠加态时，两个不变的线性叠加可能让它改变。

**Case 7**

我们再稍微改一下Case 6，

- $f(0)=f(1)=1$
- 输入$x=|+\rangle$
- 输入$y=|-\rangle=\frac{|0\rangle-|1\rangle}{\sqrt{2}}$

它是Case 2和Case 3的组合，但结果却是相当的平凡，因为Case 2和Case 3中$y\oplus{}f(x)$的值是相同的

$$\frac{\text{Case 2}}{{\sqrt{2}}}+\frac{\text{Case 3}}{{\sqrt{2}}}=-|+\rangle|-\rangle$$

比较Case 6和Case 7，我们发现Case 6对应于平衡函数，Case 7对应于常函数。相应的，x分别演变为$|-\rangle$和$|+\rangle$。区别$|-\rangle$和$|+\rangle$是很简单的，因为

- $H|-\rangle=|1\rangle$
- $H|+\rangle=|0\rangle$

# Deutsch算法实现

上面讲了这么久，我们就用`Q#`来实现以下吧。


```qsharp
operation deutsch(oracle: ((Qubit, Qubit) => Unit)): Unit {
    // Alloc x and y
    using ((x, y) = (Qubit(), Qubit())) {
    
        // Set x to |+>
        H(x);
        
        // Set y to |->
        X(y);
        H(y);
        
        // Apply the Oracle
        oracle(x, y);
        
        // Check if x is |+> or |->
        H(x);
        if (M(x) == Zero) {
            Message("f(x) is constant");
        } else {
            Message("f(x) is balanced");
        }
        
        // Do not forget reset all Qubits before exit
        Reset(x);
        Reset(y);
    }
}
```




<ul><li>deutsch</li></ul>



下面我们来实现几个Oracle。比如$f(0)=f(1)=0$。显然这个Oracle什么都不需要做。


```qsharp
operation oracle_constant(x: Qubit, y: Qubit): Unit {
}

operation run_oracle_constant(): Unit {
    deutsch(oracle_constant);
}
```




<ul><li>oracle_constant</li><li>run_oracle_constant</li></ul>




```qsharp
%simulate run_oracle_constant
```

    f(x) is constant





    ()



再比如$f(0)=0$，$f(1)=1$。


```qsharp
operation oracle_balanced(x: Qubit, y: Qubit): Unit {
    CNOT(x, y);
}

operation run_oracle_balanced(): Unit {
    deutsch(oracle_balanced);
}
```




<ul><li>oracle_balanced</li><li>run_oracle_balanced</li></ul>




```qsharp
%simulate run_oracle_balanced
```

    f(x) is balanced





    ()



请小伙伴们自行尝试其它情况。

# 总结

上面的算法让我们看到了量子算法的强大，有一些点也是我们需要注意的。量子Deutsch算法与经典Deutsch解决的问题看起来是相似的，但严格来说又是不同的。我们可以看到，在量子算法中我们引入了Oracle，Oracle是沟通经典算法与量子算法之间的桥梁。但是如何构建Oracle仍然是一个具有挑战性的问题。

Deutsch算法解决的问题虽然没有应用价值，但可以说理解它可以帮助我们理解其它更复杂的量子算法。Deutsch算法中用到的一些技巧也会出现在其它的量子算法中。

# 习题
以前我说过，我们不需要“学会”量子算法，我们需要熟悉它。做一些经典的习题（这些习题都是经过认真挑选过的，它们的结论都很重要），尤其是对于量子力学这种反直觉的系统特别的重要。这些习题，也是为以后的算法讲解做准备。

每篇文章的习题答案会在下一篇文章给出。

下面四个重要的矩阵称为泡利矩阵（Pauli Matrices）。
$$\sigma_0=I=\begin{bmatrix} 1&0 \\ 0&1 \end{bmatrix}  \\ \sigma_1=\sigma_x=X=\begin{bmatrix} 0&1 \\ 1&0 \end{bmatrix}  \\ \sigma_2=\sigma_y=Y=\begin{bmatrix} 0&-i \\ i&0 \end{bmatrix}  \\ \sigma_3=\sigma_z=Z=\begin{bmatrix} 1&0 \\ 0&-1 \end{bmatrix}$$

其中$X$也被称之为$NOT$，因为
$$X|0\rangle=|1\rangle \quad X|1\rangle=|0\rangle$$

## 习题6-1
求证：$H=(X+Z)/2$

## 习题6-2
分别求$X$，$Y$和$Z$的特征值和特征向量。
