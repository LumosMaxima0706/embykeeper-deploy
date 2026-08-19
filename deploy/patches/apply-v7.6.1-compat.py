from pathlib import Path


api_path = Path("/opt/venv/lib/python3.8/site-packages/embykeeper/emby/api.py")
cli_path = Path("/opt/venv/lib/python3.8/site-packages/embykeeper/cli.py")

api = api_path.read_text(encoding="utf-8")
request_error_marker = 'raise EmbyStatusError(f"访问失败: 异常 HTTP 代码 {resp.status_code} (URL = {url})")'
if api.count(request_error_marker) != 1:
    raise SystemExit("unexpected v7.6.1 request error source marker")
api = api.replace(
    request_error_marker,
    'raise EmbyStatusError(f"访问失败: 异常 HTTP 代码 {resp.status_code} (URL = [URL_REDACTED])")',
    1,
)
connect_error_marker = 'raise EmbyConnectError(f\'连接到 "{url}" 重试超限\')'
if api.count(connect_error_marker) != 1:
    raise SystemExit("unexpected v7.6.1 connect error source marker")
api = api.replace(
    connect_error_marker,
    'raise EmbyConnectError("连接到 [URL_REDACTED] 重试超限")',
    1,
)
optional_probe = '''        resp = await self._request(
            method="GET",
            path=f"/Videos/{iid}/AdditionalParts",
            params=dict(
                Fields="PrimaryImageAspectRatio,UserData,CanDelete",
                IncludeItemTypes="Playlist,BoxSet",
                Recursive=True,
                SortBy="SortName",
            ),
        )

'''
if api.count(optional_probe) != 1:
    raise SystemExit("unexpected v7.6.1 AdditionalParts source marker")
api_path.write_text(api.replace(optional_probe, "", 1), encoding="utf-8")

cli = cli_path.read_text(encoding="utf-8")
pool_marker = "        pool = AsyncTaskPool()\n"
if cli.count(pool_marker) != 1 or "        streams = []\n" in cli:
    raise SystemExit("unexpected v7.6.1 stream cleanup source marker")
cli_path.write_text(
    cli.replace(pool_marker, pool_marker + "        streams = []\n", 1),
    encoding="utf-8",
)
