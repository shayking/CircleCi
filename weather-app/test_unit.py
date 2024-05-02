"""
author: shay
interviewed by eilay
"""
import unittest
import requests
class TestPython(unittest.TestCase):
    def test(self):
        url = "http://127.0.0.1:8000"
        response = requests.get(url)
        self.assertEqual(response.status_code, 200)


if __name__ == '__main__':
    unittest.main()
