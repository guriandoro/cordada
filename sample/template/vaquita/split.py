"""Split an amount between people."""


def split_cents(total_cents, people):
    """Split a total, in integer cents, between `people` people.

    Returns one share per person. The shares must add up to the total.
    """
    if people < 1:
        raise ValueError("need at least one person")
    share = round(total_cents / people)
    return [share] * people
