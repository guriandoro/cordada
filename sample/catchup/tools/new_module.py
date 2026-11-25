#!/usr/bin/env python3
"""Scaffold vaquita/<name>.py and tests/test_<name>.py. Refuses to overwrite.

Usage: python3 tools/new_module.py <name> "<one-line purpose>"
"""
import pathlib
import sys

if len(sys.argv) != 3 or not sys.argv[1].isidentifier():
    sys.exit(__doc__)
name, purpose = sys.argv[1], sys.argv[2]
root = pathlib.Path(__file__).resolve().parent.parent
module = root / "vaquita" / f"{name}.py"
test = root / "tests" / f"test_{name}.py"
for path in (module, test):
    if path.exists():
        sys.exit(f"refusing to overwrite {path.relative_to(root)}")
module.write_text(f'"""{purpose}"""\n')
test.write_text(
    "import unittest\n\n"
    f"import vaquita.{name}  # noqa: F401\n\n\n"
    f"class {name.title().replace('_', '')}Test(unittest.TestCase):\n"
    "    def test_placeholder(self):\n"
    "        self.fail(\"write the real tests first\")\n\n\n"
    "if __name__ == \"__main__\":\n    unittest.main()\n"
)
print(f"created {module.relative_to(root)} and {test.relative_to(root)}")
