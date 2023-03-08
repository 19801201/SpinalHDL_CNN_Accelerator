import torch
from torch import nn as nn
import math

torch.set_printoptions(profile='full')  # 输出tensor的所有信息，不再有省略号
a = torch.randint(0, 100, (512, 20, 20),dtype=torch.int8) # 随机生成数据，以16进制，每8通道一行的格式输出到文件中
with open('raw.txt', 'w') as f:
    for j in range(a.shape[2]):
        for k in range(a.shape[1]):
            for i in range(math.ceil(a.shape[0] / 8)):
                for temp in range(8):
                    if len(hex(a[temp + i * 8, k, j])) == 3 :
                        f.write('0'+(hex(a[temp + i * 8, k, j])[2:]))
                    else:
                        f.write((hex(a[temp + i * 8, k, j])[2:]))
                f.write('\n')

a = a.float()
a = nn.MaxPool2d(kernel_size=5, padding=0, stride=1)(a)
a = a.type(torch.int8)
# 随机生成的数据，经过MaxPool2d算子后，以16进制，每8通道一行的格式输出到文件中
with open('maxpool2d.txt', 'w') as f:
    for j in range(a.shape[2]):
        for k in range(a.shape[1]):
            for i in range(math.ceil(a.shape[0] / 8)):
                for temp in range(8):
                    if len(hex(a[temp + i * 8, k, j])) == 3:
                        f.write('0' + (hex(a[temp + i * 8, k, j])[2:]))
                    else:
                        f.write((hex(a[temp + i * 8, k, j])[2:]))
                f.write('\n')


with open('result.txt', 'w') as f:
    for j in range(a.shape[2]):
        for k in range(a.shape[1]):
            for i in range(math.ceil(a.shape[0] / 8)):
                for temp in range(8):
                    if len(hex(a[temp + i * 8, k, j])) == 3:
                        f.write('0' + (hex(a[temp + i * 8, k, j])[2:]))
                    else:
                        f.write((hex(a[temp + i * 8, k, j])[2:]))
                f.write('\n')



