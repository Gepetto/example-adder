from .libexample_adder import add as _add


def add(a, b):
    return _add(int(a), int(b))
