import torch.nn as nn
import torch
import numpy as np
import json
import sys


def padding(cfgPath, saveFile=True):
    with open(cfgPath) as f:
        a = json.load(f)
    channel = a['paddingSim']['channelIn']
    row = a['paddingSim']['rowNumIn']
    col = a['paddingSim']['colNumIn']
    enPadding = a['paddingSim']['enPadding']
    src = a['paddingSim']['src_py']
    dst = a['paddingSim']['dst_py']
    computeChannel = a['total']['COMPUTE_CHANNEL_NUM']
    zeroData = a['paddingSim']['zeroDara']
    zeroNum = a['paddingSim']['zeroNum']

    x = torch.randint(0, 127, (channel, row, col))
    xx = np.array(x)
    y = x
    if enPadding:
        pad = nn.ConstantPad2d(padding=(zeroNum, zeroNum, zeroNum, zeroNum), value=zeroData)
        y = pad(x)
    yy = np.array(y)
    if (saveFile):
        fp1 = open(src, 'w')
        fp2 = open(dst, 'w')

        def save_xx(high, width, channel, xx, fp):
            out = []
            for h in range(high):
                for w in range(width):
                    for c in range(channel):
                        out.append(xx[c][h][w])
                        if len(out) == computeChannel:
                            out.reverse()
                            for m in out:
                                m = m.item()
                                fp.write('%02x' % m)
                            fp.write('\n')
                            out = []
            fp.close()

        save_xx(xx.shape[1], xx.shape[2], xx.shape[0], xx, fp1)
        save_xx(yy.shape[1], yy.shape[2], yy.shape[0], yy, fp2)
    return [xx, yy]


if __name__ == '__main__':
    # print(sys)
    padding("../simData/config.json")
