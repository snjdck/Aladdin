控制台乱码问题
打开flash builder使用的SDK的目录,打开bin目录,打开jvm.config文件,在java.args=开始的那行后面加入个参数,修改后的结果为:
java.args=-Xmx384m -Dsun.io.useCanonCaches=false -Dfile.encoding=utf-8 -Dsun.jnu.encoding=utf-8
list组件取消滚动支持,改为一个容器负责切割数据,赋值给list