from json import loads
import subprocess


def run_task_cmd(args: list[str]) -> str:
    task_cmd = subprocess.run(
        ["task", *args],
        capture_output=True
    )

    return task_cmd.stdout.decode('utf-8').strip()


def get_task_data(task_identifier: str) -> dict | None:
    if raw_result := run_task_cmd([task_identifier, "export"]):
        return loads(raw_result)[0]


def get_new_annotations(new: dict, old: dict) -> list:
    if "annotations" not in new:
        return []

    n_annots_old = len(old.get("annotations", []))
    n_annots_new = len(new.get("annotations", []))
    return new["annotations"][n_annots_old:n_annots_new]
