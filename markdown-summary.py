#!/usr/bin/env python3

import json
import sys

def load_json_data(file_path):
    try:
        with open(file_path, 'r') as file:
            data = json.load(file)
        if not isinstance(data, list) or len(data) == 0:
            raise ValueError("JSON data is not in the expected format.")
        return data[0]
    except json.JSONDecodeError as e:
        print(f"Error decoding JSON: {e}", file=sys.stderr)
        sys.exit(1)
    except ValueError as e:
        print(e, file=sys.stderr)
        sys.exit(1)
    except FileNotFoundError:
        print(f"File not found: {file_path}", file=sys.stderr)
        sys.exit(1)

def generate_markdown_table(data):
    row_order = ["Total", "Critical", "High", "Medium", "Low", "Not Applicable"]
    column_order = [
        "Passed :white_check_mark:",
        "Failed :x:",
        "Not Reviewed :leftwards_arrow_with_hook:",
        "Not Applicable :heavy_minus_sign:",
        "Error :warning:",
    ]

    column_widths = [max(len(row), len(col)) for row, col in zip(row_order, column_order)]
    column_widths = [max(column_widths)] * len(column_widths)

    table = (
        "| "
        + "Compliance: "
        + str(data["compliance"])
        + "% :test_tube:"
        + " | "
        + " | ".join(col.ljust(width) for col, width in zip(column_order, column_widths))
        + " |\n"
    )

    table += (
        "| "
        + "-".ljust(max(column_widths), "-")
        + " | "
        + " | ".join("-".ljust(width, "-") for width in column_widths)
        + " |\n"
    )

    for row in row_order:
        if row == "Total":
            values = [
                str(data["passed"]["total"]),
                str(data["failed"]["total"]),
                str(data["skipped"]["total"]),
                str(data["no_impact"]["total"]),
                str(data["error"]["total"]),
            ]
        elif row == "Not Applicable":
            values = ["-", "-", "-", str(data["no_impact"]["total"]), "-"]
        else:
            values = [
                str(data["passed"].get(row.lower(), "-")),
                str(data["failed"].get(row.lower(), "-")),
                str(data["skipped"].get(row.lower(), "-")),
                "-",
                str(data["error"].get(row.lower(), "-")),
            ]
        table += (
            "| "
            + ("**" + row + "**").ljust(max(column_widths) + 2)
            + " | "
            + " | ".join(val.ljust(width) for val, width in zip(values, column_widths))
            + " |\n"
        )

    return table

def main():
    if len(sys.argv) != 2:
        print("Usage: python markdown-summary.py <path_to_json_file>", file=sys.stderr)
        sys.exit(1)

    file_path = sys.argv[1]
    data = load_json_data(file_path)
    table = generate_markdown_table(data)
    print(table)

if __name__ == "__main__":
    main()