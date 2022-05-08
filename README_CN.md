# 基于Spinal HDL的CNN加速器

![GitHub](https://img.shields.io/github/license/liuwei9/spinal_yolo)

## 用SpinalHDL实现支持各种网络的加速器

- 本项目使用 SpinalHDL 1.7.0，实现了一些CNN中的常用算子，可以通过高层次的编译器来指导其生成不同网络的加速器。
- 本项目旨在做SpinalHDL层面通用的，在Verilog层面专用的加速器。
- 本项目最终实现一个Npu模块，可以放入工程中，如图。


![block_design](./img/block_design.png)

- FPGA中的资源占用情况如图：

![resource](./img/resource.png)

## 描述

这个仓库托管了一个用SpinalHDL编写的CNN加速器实现。以下是一些特性：

- 拿来即用
- 完整的卷积、量化、shape实现
- 可配置的参数化接口
- 可选的卷积核类型
- 在代码层面优化了FPGA资源占用
- 手写实现了丰富的工具类库
- 对DMA、AXI的访问控制
- 自动生成用于例化Xilinx IP的tcl文件
- 易于运行的顶层文件
- 实现了卷积操作的仿真

## 生成RTL代码

您可以在以下位置找到三个可运行的顶层模块:
- `src/main/scala/top.scala`
- `src/main/scala/Npu.scala`
- `src/test/scala/TbConv.scala`

提示：
- 运行它可能需要一些时间。
- `top.scala`用于实现卷积操作。
- `Npu.scala`用于实现完整的项目流程。
- `TbConv.scala`用于实现卷积的仿真。
- 运行`TbConv.scala`需要提前准备好图片和权重文件。




