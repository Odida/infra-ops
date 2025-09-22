import re
import sys


def is_valid_semver(version):
    pattern = (
        r"^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-(?:0|[1-9A-Za-z-][0-9A-Za-z-]*)"
        r"(?:\.(?:0|[1-9A-Za-z-][0-9A-Za-z-]*))*)?(?:\+[\dA-Za-z-]+(\.[\dA-Za-z-]+)*)?$"
    )
    return re.match(pattern, version) is not None


if __name__ == "__main__":
    version = sys.argv[1]
    if is_valid_semver(version):
        print(f"{version} is a valid semantic version.")
        sys.exit(0)
    else:
        print(f"{version} is not a valid semantic version.")
        sys.exit(1)
