import torch

from MakePytorchBackend import AddGPU


def add_gpu(a, b):
    assert isinstance(a, torch.cuda.FloatTensor) \
        and isinstance(b, torch.cuda.FloatTensor)
    assert a.numel() == b.numel()

    c = a.new()
    AddGPU(a, b, c)
    return c
