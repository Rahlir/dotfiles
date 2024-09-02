from datetime import datetime, timedelta, timezone, time


LOCAL_ZONE = datetime.now().astimezone().tzinfo
DEFAULT_TIME = time(23, 59, 59)


def taskdate_to_datetime(taskdate: str) -> datetime:
    return datetime.fromisoformat(taskdate).astimezone(LOCAL_ZONE)


def datetime_to_taskdate(dt: datetime) -> str:
    return dt.astimezone(timezone.utc).strftime('%Y%m%dT%H%M%SZ')


def timedelta_to_isostring(td: timedelta) -> str:
    hours = td.seconds // 3600
    minutes = (td.seconds % 3600) // 60
    result_str = "P"
    if td.days:
        result_str += f"{td.days:d}D"
    if hours or minutes:
        result_str += "T"
    if hours:
        result_str += f"{hours:d}H"
    if minutes:
        result_str += f"{minutes:d}M"
    return result_str


def set_default_time(old_date: datetime) -> datetime:
    return old_date.replace(
        hour=DEFAULT_TIME.hour,
        minute=DEFAULT_TIME.minute,
        second=DEFAULT_TIME.second
    )


def shift_due(task):
    due_datetime = taskdate_to_datetime(task["due"])
    if due_datetime.time() == time(0, 0, 0):  # due time is midnight
        shifted = set_default_time(due_datetime)
        task["due"] = datetime_to_taskdate(shifted)
        print(
            "Due time shifted from "
            f"{due_datetime.strftime('%H:%M:%S')} to {shifted.strftime('%H:%M:%S')}"
        )
