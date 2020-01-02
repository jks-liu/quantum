# 安装微软QDK

既然是编程语言，当然就会有编程环境。我们使用微软的QDK（Microsoft Quantum Development Kit）。

由于Q#是一门DSL，所以一般会和其它的一门通用语言一起使用。微软提供了三个个选项，C#，Python和Jupyter。在这个系列中，我主要基于Jupyter，因为这可以让我们专注于Q#。关于C#和Python相关的使用，请参考[官方文档](install)。

当然，我们还要先安装Python 3和Jupyter。按照惯例，如何安装和使用Pyhton和Jypyter留给大家做课后练习。安装完后，按照以下步骤安装QDK。


1. 从[这个地址安装.Net][dotnet]
2. 使用以下命令在.Net中安装量子编程组件  
`dotnet tool install -g Microsoft.Quantum.IQSharp`
3. 使用以下命令在Jupyter添加Q#的支持  
`dotnet iqsharp install`

如果你使用Python3.8，大概在执行`jupyter notebook`会有以下错误：

```bash
D:\jks-liu\quantum\nb>jupyter notebook
Traceback (most recent call last):
  File "c:\program files\python38\lib\runpy.py", line 192, in _run_module_as_main
    return _run_code(code, main_globals, None,
  File "c:\program files\python38\lib\runpy.py", line 85, in _run_code
    exec(code, run_globals)
  File "C:\Program Files\Python38\Scripts\jupyter-notebook.EXE\__main__.py", line 9, in <module>
  File "c:\program files\python38\lib\site-packages\jupyter_core\application.py", line 268, in launch_instance
    return super(JupyterApp, cls).launch_instance(argv=argv, **kwargs)
  File "c:\program files\python38\lib\site-packages\traitlets\config\application.py", line 663, in launch_instance
    app.initialize(argv)
  File "<c:\program files\python38\lib\site-packages\decorator.py:decorator-gen-7>", line 2, in initialize
  File "c:\program files\python38\lib\site-packages\traitlets\config\application.py", line 87, in catch_config_error
    return method(app, *args, **kwargs)
  File "c:\program files\python38\lib\site-packages\notebook\notebookapp.py", line 1720, in initialize
    self.init_webapp()
  File "c:\program files\python38\lib\site-packages\notebook\notebookapp.py", line 1482, in init_webapp
    self.http_server.listen(port, self.ip)
  File "c:\program files\python38\lib\site-packages\tornado\tcpserver.py", line 152, in listen
    self.add_sockets(sockets)
  File "c:\program files\python38\lib\site-packages\tornado\tcpserver.py", line 165, in add_sockets
    self._handlers[sock.fileno()] = add_accept_handler(
  File "c:\program files\python38\lib\site-packages\tornado\netutil.py", line 279, in add_accept_handler
    io_loop.add_handler(sock, accept_handler, IOLoop.READ)
  File "c:\program files\python38\lib\site-packages\tornado\platform\asyncio.py", line 99, in add_handler
    self.asyncio_loop.add_reader(fd, self._handle_events, fd, IOLoop.READ)
  File "c:\program files\python38\lib\asyncio\events.py", line 501, in add_reader
    raise NotImplementedError
NotImplementedError
```

按照[这个答案](https://stackoverflow.com/a/58430041)，请修改文件`Python38安装路径\Lib\site-packages\tornado\platform\asyncio.py`，在`class BaseAsyncIOLoop`前加上
```python
import sys

if sys.platform == 'win32':
    asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())
```

安装完后你就可以新开一个Q#的Kernel啦。

# 测试
在第一个Cell里输入
```Q#
operation hello_world(): Unit {
    Message("Hello World!");
}
```
在第二个Cell输入
```
%simulate hello_world
```
如果可以看到结果，就OK啦。

Notebook可以参考[Install QDK](../nb/install-qdk.ipynb)

# 备注
我在两天电脑上安装过以上环境，其中一个有以下错误，分享出来仅供参考。

```bash
C:\Users\xx>dotnet tool install -g Microsoft.Quantum.IQSharp
error NU1101: パッケージ microsoft.quantum.iqsharp が見つかりません。ソース Microsoft Visual Studio Offline Packages には、この ID のパッケージが存在しません。
ツール パッケージを復元できませんでした。
ツール 'microsoft.quantum.iqsharp' をインストールできませんでした。この失敗は次の原因で生じた可能性があります。

* プレビュー リリースをインストールしようとしており、--version オプションを使用してバージョンを指定しなかった。
* この名前のパッケージが見つかったが、.NET Core ツールではなかった。
* 恐らくインターネットの接続の問題で、必須の NuGet フィードにアクセスできない。
* ツールの名前のタイプミス。

パッケージの名前付けの強制を含む他の理由については、https://aka.ms/failure-installing-tool にアクセスしてください
```
请忽略我的日文系统。。。

经过一番Google，好像是没有Nuget的源。我这里是Visual Studio的原因。我在Visual Studio 2019的Tools->Options->NuGet Package Manager->Package Sources添加了如下配置，按道理这个配置本来就应该有的：
```
name: nuget
Source: https://api.nuget.org/v3/index.json
```

[dotnet]: https://dotnet.microsoft.com/download
[install]: https://docs.microsoft.com/en-us/quantum/install-guide/?view=qsharp-preview
