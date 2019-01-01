import torch
import MakePytorchPlusPlus as MPP


def test_foo():
    foo = MPP.Foo()
    print(foo)
    foo.setKey(3)
    print(foo)
    print(foo.getKey())


def test_add_gpu():
    if not torch.cuda.is_available():
        return
    a = torch.cuda.FloatTensor(4)
    b = torch.cuda.FloatTensor(4)
    a.normal_()
    b.normal_()
    c = MPP.add_gpu(a, b)
    print(a, b, c)


if __name__ == '__main__':
    test_foo()
    test_add_gpu()
