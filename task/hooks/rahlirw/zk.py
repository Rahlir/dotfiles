from re import match
import subprocess


def is_annotation_backlink(annotation):
    if match(r'^Referenced by task://[0-9a-f]{8} \(.+\)\.$', annotation['description']):
        return True
    return False

def run_zk_cmd(args: list[str]) -> str:
    zk_cmd = subprocess.run(
        ["zk", *args],
        capture_output=True
    )

    return zk_cmd.stdout.decode('utf-8').strip()


def generate_project_string(project: str) -> str:
    project_modified = project
    zk_project_name = project_modified.replace(".", "-")
    link = run_zk_cmd(["list", "-f", "{{link}}", "--quiet", f"projects/{zk_project_name}"])
    # Cycle while link was not found AND project_modified still contains
    # some parent projects (because zk_project_name with replaced "." is
    # not same as project_modified which contains dots)
    while not link and project_modified != zk_project_name:
        project_modified = project_modified[0:project_modified.rfind(".")]
        zk_project_name = project_modified.replace(".", "-")
        link = run_zk_cmd(["list", "-f", "{{link}}", "--quiet", f"projects/{zk_project_name}"])

    if not link:
        link = f"@{project}"

    return link
