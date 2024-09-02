from datetime import datetime, timedelta
from json import loads
from os import environ
from pathlib import Path
import ssl
import subprocess
from tomllib import load
import unicodedata

import truststore
from urllib3 import PoolManager

from rahlirw.dateutils import (
    datetime_to_taskdate,
    taskdate_to_datetime,
    timedelta_to_isostring,
)

CONFIG = None


def get_config():
    global CONFIG
    if not CONFIG:
        config_path = None
        for path_from_home in [".config/bugwarrior/bugwarrior.toml", ".bugwarrior.toml"]:
            check = Path(environ["HOME"], path_from_home)
            if check.exists():
                config_path = check
                break

        if not config_path:
            raise FileNotFoundError("Could not find bugwarrior config file.")

        with config_path.open("rb") as c_file:
            toml_data = load(c_file)
            jira_config = None
            for c_key in toml_data.keys():
                if 'jira' in c_key:
                    jira_config = toml_data[c_key]
                    break
        
        if not jira_config:
            raise ValueError("bugwarrior file does not seem to contain jira config.")

        CONFIG = {
            "PAT": jira_config.get("PAT"),
            "base_uri": jira_config.get("base_uri")
        }
    return CONFIG


def api_get(path: str, query: str | None = None) -> dict:
    config = get_config()
    headers = {
        "Accept": "application/json",
        "Authorization": f"Bearer {config["PAT"]}"
    }

    url = f"{config['base_uri']:s}/rest/api/2/{path:s}"
    if query:
        url += f"?{query:s}"

    ctx = truststore.SSLContext(ssl.PROTOCOL_TLS_CLIENT)
    http = PoolManager(ssl_context=ctx)
    response = http.request("GET", url, headers=headers)

    return loads(response.data)


def run_task_cmd(args: list[str]) -> str:
    task_cmd = subprocess.run(
        ["task", *args],
        capture_output=True
    )

    return task_cmd.stdout.decode('utf-8').strip()


def get_task_data(task_identifier: str) -> list[dict]:
    raw_result = run_task_cmd([task_identifier, "export"])
    return loads(raw_result)


def tasks_by_jids(jids: str | list[str], get_uuids=False) -> list[str]:
    if isinstance(jids, str):
        query_str = f"jiraid:{jids:s}"
    else:
        query_str = [f"jiraid:{jid:s}" for jid in jids]
        query_str = " or ".join(query_str)
        query_str = f"( {query_str:s} )"
    return run_task_cmd([query_str, "uuids" if get_uuids else "ids"]).split()


def get_sprint_state(sprint_str: str) -> str | None:
    sprint_str = sprint_str[sprint_str.index('[')+1:sprint_str.index(']')]
    for raw_val in sprint_str.split(","):
        keyval = raw_val.split("=")
        if keyval[0] == "state":
            return keyval[1]


def set_agilestatus(task: dict):
    """
    Set agilestatus of the task based on whether it is included in an active
    sprint. If no sprint in which the task is included is either 'ACTIVE' or
    'FUTURE', it will not modify agilestatus.
    """
    sprint_id = None
    jira_fields = api_get("field")
    for field in jira_fields:
        if field["name"] == "Sprint":
            sprint_id = field["id"]
            break

    if sprint_id:
        old_agilestatus = task.get("agilestatus")
        sprint_field = api_get(f"issue/{task["jiraid"]:s}", f"fields={sprint_id:s}")
        for sprint_str in sprint_field["fields"][sprint_id]:
            sprint_state = get_sprint_state(sprint_str)
            if sprint_state == "ACTIVE":
                if old_agilestatus != "active":
                    print("Setting agilestatus to 'active'")
                task["agilestatus"] = "active"
                return
            elif sprint_state == "FUTURE":
                task["agilestatus"] = "backlog"

        if task["agilestatus"] == "backlog" and old_agilestatus != "backlog":
            print("Setting agilestatus to 'backlog'")


def update_project_name(task: dict):
    """
    If the task has a project name of the form 'hsctr-*', query jira for epic
    with this ID and use its normalized 'summary' as the task's project.
    """
    if (project := task.get("project")) and project.startswith("hsctr-"):
        project_sum_fields = api_get(f"issue/{project:s}", "fields=summary")

        if "fields" in project_sum_fields:
            normalized_name = unicodedata.normalize("NFD", project_sum_fields["fields"]["summary"])
            ascii_name = normalized_name.encode("ascii", "ignore").decode("utf-8")
            new_project = ascii_name.replace("-> ", "").replace(" ", "-").lower()
            print(f"Project name changed from {project:s} to {new_project:s}")
            task["project"] = new_project
        else:
            print(f"Could not find jira epic {project:s}.")


def set_priority(task: dict):
    """
    Set priority based on jira priority. The mapping between the priorities in
    use at T-Mobile and taskwarrior's priorities is: Prio1 -> 'H', Prio2 ->
    'M', Prio3 or Prio4 -> '', Prio5 -> 'L'.

    TODO: Make the mapping configurable.
    """
    if jirapriority := task.get("jirapriority"):
        if jirapriority == "Prio1":
            print("Setting priority to 'H'")
            task["priority"] = "H"
        elif jirapriority == "Prio2":
            print("Setting priority to 'M'")
            task["priority"] = "M"
        elif jirapriority == "Prio5":
            print("Setting priority to 'L'")
            task["priority"] = "L"
        else:
            print("No priority set")
            task["priority"] = ""


def set_waiting(task: dict, old_task: dict | None = None):
    """
    Set wait time of the task that has jirastatus set to 'Waiting' or 'Code
    review'. Otherwise, ensure there is no wait date in the future.

    For 'Waiting' tasks, wait date is set 2 days in the future while for 'Code
    review', it is set one day in the future.
    """
    jirastatus = task.get("jirastatus")
    if jirastatus in ["Waiting", "Code review"]:
        wait_date = task.get("wait")
        if not wait_date or datetime.now().astimezone() >= taskdate_to_datetime(wait_date):
            dt = timedelta(days=2) if jirastatus == "Waiting" else timedelta(days=1)
            waiting_datetime = datetime.now() + dt
            waiting_datetime = waiting_datetime.replace(hour=23, minute=59, second=59)
            print(f"Setting wait date to {waiting_datetime.strftime('%Y-%m-%d %H:%M:%S'):s}")
            task["wait"] = datetime_to_taskdate(waiting_datetime)
    else:
        # The second if-condition is already ensured by the on-modify script
        if old_task and jirastatus != old_task.get("jirastatus") and task.get("wait") == old_task.get("wait"):
            wait_date = task.get("wait")
            if wait_date and datetime.now().astimezone() < taskdate_to_datetime(wait_date):
                print("Removing wait date on the task.")
                task.pop("wait")


def resolve_subtasks(task: dict):
    """
    If the task has subtasks, set those subtasks as dependencies of this task.

    This function also checks that if the subtasks are in the taskwarrior db,
    they are inheriting this task's project.
    """
    if subtasks := task.get("jirasubtasks"):
        subtasks = subtasks.split(",")
        sub_uuids = tasks_by_jids(subtasks, get_uuids=True)
        if sub_uuids:
            print(f"Adding dependencies of {','.join((uuid.split('-')[0] for uuid in sub_uuids))}")
            task["depends"] = sub_uuids

            project = task.get("project", "")
            for uuid in sub_uuids:
                sub_project = run_task_cmd(["_get", f"{uuid}.project"])
                if sub_project != project:
                    print(f"Copying project {project} to subtask {uuid.split('-')[0]}.")
                    run_task_cmd([uuid, "modify", f"project:{project}"])


def resolve_parent(task: dict):
    """
    If the task has a parent, inherit its project.

    This function also checks that if the parent is in the taskwarrior db, it
    has this task as its dependency.
    """
    if parent := task.get("jiraparent"):
        if parent_ids := tasks_by_jids(parent):
            parent_id = parent_ids[0]

            parent_data = get_task_data(parent_id)[0]
            parent_proj = parent_data.get("project")
            if task.get("project") != parent_proj:
                print(f"Inheritting parent project {parent_proj}")
                task["project"] = parent_proj
            
            parent_depends = parent_data.get("depends")
            if not parent_depends:
                parent_depends = []
            if task["uuid"] not in parent_depends:
                print(f"Adding dependency of {task['uuid'].split('-')[0]} to task {parent_id}.")
                run_task_cmd([parent_id, "modify", f"depends:{task['uuid']}"])


def set_estimate(task: dict):
    """
    Use jiraestimate to set estimate UDA attribute.
    """
    if jiraestimate := task.get("jiraestimate"):
        dt = timedelta(hours=jiraestimate)
        task["estimate"] = timedelta_to_isostring(dt)
