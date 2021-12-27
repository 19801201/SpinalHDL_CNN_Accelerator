import torch.nn as nn
import torch
import numpy as np
import json
import sys
import paddingMode


def dataGenerate(cfgPath, saveDataGenerateFile=True):
    _, paddingData = paddingMode.padding(cfgPath, True)
    with open(cfgPath) as f:
        a = json.load(f)
    dst_dataGenerate_py = a['featureGenerateSim']['dst_py']
    dst_dataGenerate_scala = a['featureGenerateSim']['dst_scala']
    computeChannel = a['total']['COMPUTE_CHANNEL_NUM']
    KERNEL_NUM = a['featureGeneratePara']['KERNEL_NUM']
    FEATURE_RAM_ADDR_WIDTH = a['featureGeneratePara']['FEATURE_RAM_ADDR_WIDTH']

    h = paddingData.shape[1]
    w = paddingData.shape[2]
    c = paddingData.shape[0]
    d = []
    d.append(paddingData[:, 0:h - 2, 0:w - 2])
    d.append(paddingData[:, 0:h - 2, 1:w - 1])
    d.append(paddingData[:, 0:h - 2, 2:w])
    d.append(paddingData[:, 1:h - 1, 0:w - 2])
    d.append(paddingData[:, 1:h - 1, 1:w - 1])
    d.append(paddingData[:, 1:h - 1, 2:w])
    d.append(paddingData[:, 2:h, 0:w - 2])
    d.append(paddingData[:, 2:h, 1:w - 1])
    d.append(paddingData[:, 2:h, 2:w])
    for i in range(9):
        fp = open(dst_dataGenerate_py + "d" + str(i)+".txt", 'w')

        def save_xx(high, width, channel, xx, fp):
            for i in range(high):
                for j in range(width):
                    out = []
                    for k in range(channel):
                        out.append(xx[k][i][j])
                        if len(out) == computeChannel:
                            out.reverse()
                            for m in out:
                                m = m.item()
                                fp.write('%02x' % m)
                            fp.write('\n')
                            out = []
            fp.close()

        save_xx(h - 2, w - 2, c, d[i], fp)


dataGenerate("../simData/config.json", False)
