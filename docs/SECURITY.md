# Security

- Never commit `.env`, `config.toml`, `cache.json`, `*.session`, DB files,
  logs, certificates, private keys, tokens, cookies, or complete UUIDs.
- Enter real credentials only in the server's protected `/opt/embykeeper`
  directory. Do not pass them through EmbyProxy.
- Keep profiles disabled until site rules/TOS are reviewed.
- Do not enable registration, monitoring, messaging, water-farming, quizzes,
  CAPTCHA/GPT helpers, or bulk automation.
- Do not expose the upstream WebUI directly or reuse EmbyProxy Admin auth.
- Do not use host networking or mount the Docker socket in the baseline.
- The status exporter may emit only the five documented fields and an uppercase
  error code. It must not scrape raw logs or include host/account details.
