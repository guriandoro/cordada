"""Split an amount between people."""


def split_cents(total_cents, people):
    """Split a total, in integer cents, between `people` people.

    Returns one share per person. The shares must add up to the total:
    the leftover cents go one each to the first people.
    """
    if people < 1:
        raise ValueError("need at least one person")
    share, leftover = divmod(total_cents, people)
    return [share + 1 if i < leftover else share for i in range(people)]
