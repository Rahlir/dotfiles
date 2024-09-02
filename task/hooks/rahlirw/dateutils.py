from datetime import datetime, timedelta, timezone


LOCAL_ZONE = datetime.now().astimezone().tzinfo


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
