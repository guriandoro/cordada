import unittest

from vaquita.split import split_cents


class SplitTest(unittest.TestCase):
    def test_even_split(self):
        self.assertEqual(split_cents(90000, 3), [30000, 30000, 30000])

    def test_one_person_pays_everything(self):
        self.assertEqual(split_cents(4550, 1), [4550])

    def test_no_people_is_an_error(self):
        with self.assertRaises(ValueError):
            split_cents(1000, 0)

    def test_shares_add_up_to_the_total(self):
        # $ 10.000 between 3: nobody may lose a cent.
        self.assertEqual(sum(split_cents(1000000, 3)), 1000000)

    def test_leftover_cents_go_to_the_first_people(self):
        self.assertEqual(split_cents(100, 3), [34, 33, 33])


if __name__ == "__main__":
    unittest.main()
