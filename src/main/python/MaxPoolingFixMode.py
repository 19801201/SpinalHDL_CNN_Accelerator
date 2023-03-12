import torch
from torch import nn as nn
import math
import os
#修改这三个参数产生不同的文件用于仿真测试
kernel_size = 2
padding = 0
stride = 1
path = "F:\\dataCompare\\TbMaxPoolingFix\\k{kernel_size}p{padding}s{stride}\\"

mkpath = path.format(kernel_size=kernel_size, padding=padding, stride=stride)
# 如果目录不存在那么创建一个目录
if not os.path.exists(mkpath):
    os.makedirs(mkpath)

torch.set_printoptions(profile='full')  # 输出tensor的所有信息，不再有省略号
a = torch.randint(0, 100, (512, 20, 20), dtype=torch.int8)  # 随机生成数据，以16进制，每8通道一行的格式输出到文件中
with open(mkpath + 'srcRaw.txt', 'w') as f:
    for j in range(a.shape[2]):
        for k in range(a.shape[1]):
            for i in range(math.ceil(a.shape[0] / 8)):
                for temp in range(8):
                    if len(hex(a[temp + i * 8, k, j])) == 3:
                        f.write('0' + (hex(a[temp + i * 8, k, j])[2:]))
                    else:
                        f.write((hex(a[temp + i * 8, k, j])[2:]))
                f.write('\n')

a = a.float()
a = nn.MaxPool2d(kernel_size=kernel_size, padding=padding, stride=stride)(a)
a = a.type(torch.int8)
# 随机生成的数据，经过MaxPool2d算子后，以16进制，每8通道一行的格式输出到文件中
with open(mkpath + 'srcResult.txt', 'w') as f:
    for j in range(a.shape[2]):
        for k in range(a.shape[1]):
            for i in range(math.ceil(a.shape[0] / 8)):
                for temp in range(8):
                    if len(hex(a[temp + i * 8, k, j])) == 3:
                        f.write('0' + (hex(a[temp + i * 8, k, j])[2:]))
                    else:
                        f.write((hex(a[temp + i * 8, k, j])[2:]))
                f.write('\n')
