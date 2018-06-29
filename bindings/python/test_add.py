import unittest

from libexample_adder import add


class TestAdder(unittest.TestCase):
    def test_adder(self):
        self.assertEqual(add(4, 3), 7)


if __name__ == '__main__':
    unittest.main()
