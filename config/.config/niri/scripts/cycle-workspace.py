#!/usr/bin/env python3
import enum
import re
import sys
import subprocess


def run(cmd):
    return subprocess.check_output(cmd, text=True)


def parse_windows(text):
    windows = []
    current = None

    for line in text.splitlines():
        m = re.match(r"Window ID (\d+):(?: \(focused\))?", line)
        if m:
            if current:
                windows.append(current)
            current = {
                "id": int(m.group(1)),
                "focused": "(focused)" in line,
                "workspace": None,
                "column": 0,
                "tile": 0,
            }
            continue

        if not current:
            continue

        m = re.search(r"Workspace ID:\s*(\d+)", line)
        if m:
            current["workspace"] = int(m.group(1))

        m = re.search(r"Scrolling position:\s*column\s*(\d+),\s*tile\s*(\d+)", line)
        if m:
            current["column"] = int(m.group(1))
            current["tile"] = int(m.group(2))

    if current:
        windows.append(current)

    return windows


def main():
    if len(sys.argv) != 2:
        print(f"usage: {sys.argv[0]} <workspace-id>")
        sys.exit(1)
    a1 = [
        {"id": 2, "focused": True, "workspace": 3, "column": 1, "tile": 1},
        {"id": 3, "focused": False, "workspace": 4, "column": 1, "tile": 1},
        {"id": 31, "focused": False, "workspace": 4, "column": 2, "tile": 1},
        {"id": 5, "focused": False, "workspace": 5, "column": 1, "tile": 1},
        {"id": 7, "focused": False, "workspace": 5, "column": 2, "tile": 1},
        {"id": 35, "focused": False, "workspace": 5, "column": 3, "tile": 1},
        {"id": 8, "focused": False, "workspace": 15, "column": 1, "tile": 1},
        {"id": 19, "focused": False, "workspace": 15, "column": 3, "tile": 1},
        {"id": 33, "focused": False, "workspace": 15, "column": 2, "tile": 1},
    ]

    workspace_id = int(sys.argv[1])

    output = run(["niri", "msg", "windows"])
    windows = parse_windows(output)
    # go over the workspaces and replace the ids with 1,2,3,4... so the least number will become 1 and the next one will become 2 and so on, this way we can cycle through the workspaces without worrying about the actual ids and name it "simple_workspace_id"
    workspace_ids = sorted({w["workspace"] for w in windows})
    for w in windows:
        w["simple_workspace_id"] = workspace_ids.index(w["workspace"]) + 1

    ws_windows = [w for w in windows if w["simple_workspace_id"] == workspace_id]
    ws_windows.sort(key=lambda w: (w["column"], w["tile"], w["id"]))

    if not ws_windows:
        print(f"No windows on workspace {workspace_id}")
        sys.exit(1)

    columns = sorted({w["column"] for w in ws_windows})
    focused = next((w for w in ws_windows if w["focused"]), None)

    if focused is None:
        target_column = columns[0]
    else:
        idx = columns.index(focused["column"])
        target_column = columns[(idx + 1) % len(columns)]

    target = next(w for w in ws_windows if w["column"] == target_column)

    subprocess.run(
        ["niri", "msg", "action", "focus-window", "--id", str(target["id"])],
        check=True,
    )


if __name__ == "__main__":
    main()
