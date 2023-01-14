APP_NAME = Gitea: Git with a cup of tea
RUN_MODE = prod
RUN_USER = git

[repository]
ROOT = /data/git/repositories

[repository.local]
LOCAL_COPY_PATH = /data/gitea/tmp/local-repo

[repository.upload]
TEMP_PATH = /data/gitea/uploads

[server]
APP_DATA_PATH    = /data/gitea
DOMAIN           = ${HOSTNAME}
SSH_DOMAIN       = ${HOSTNAME}
HTTP_PORT        = 3000
ROOT_URL         = http://${HOSTNAME}:3000
DISABLE_SSH      = false
SSH_PORT         = 8022
SSH_LISTEN_PORT  = 22
LFS_START_SERVER = true
LFS_JWT_SECRET   = Wi8I-Lj-ZcNN7ZYJdRbWH9cscm4uaMMAia6rqMiih4Q
OFFLINE_MODE     = false

[database]
PATH     = /data/gitea/gitea.db
DB_TYPE  = sqlite3
HOST     = localhost:3306
NAME     = gitea
USER     = root
PASSWD   = 
LOG_SQL  = false
SCHEMA   = 
SSL_MODE = disable
CHARSET  = utf8

[indexer]
ISSUE_INDEXER_PATH = /data/gitea/indexers/issues.bleve

[session]
PROVIDER_CONFIG = /data/gitea/sessions
PROVIDER        = file

[picture]
AVATAR_UPLOAD_PATH            = /data/gitea/avatars
REPOSITORY_AVATAR_UPLOAD_PATH = /data/gitea/repo-avatars
DISABLE_GRAVATAR              = false
ENABLE_FEDERATED_AVATAR       = true

[attachment]
PATH = /data/gitea/attachments

[log]
MODE      = console
LEVEL     = info
ROUTER    = console
ROOT_PATH = /data/gitea/log

[security]
INSTALL_LOCK                  = true
SECRET_KEY                    = 
REVERSE_PROXY_LIMIT           = 1
REVERSE_PROXY_TRUSTED_PROXIES = *
INTERNAL_TOKEN                = eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE2Njk5MDUxODB9.8UF7wAannjGM_OFRndaqtf96RafdkBLD7swlD2lV9Uo
PASSWORD_HASH_ALGO            = pbkdf2

[service]
DISABLE_REGISTRATION              = false
REQUIRE_SIGNIN_VIEW               = false
REGISTER_EMAIL_CONFIRM            = false
ENABLE_NOTIFY_MAIL                = false
ALLOW_ONLY_EXTERNAL_REGISTRATION  = false
ENABLE_CAPTCHA                    = false
DEFAULT_KEEP_EMAIL_PRIVATE        = false
DEFAULT_ALLOW_CREATE_ORGANIZATION = true
DEFAULT_ENABLE_TIMETRACKING       = true
NO_REPLY_ADDRESS                  = noreply.localhost

[lfs]
PATH = /data/git/lfs

[mailer]
ENABLED = false

[openid]
ENABLE_OPENID_SIGNIN = true
ENABLE_OPENID_SIGNUP = true

[repository.pull-request]
DEFAULT_MERGE_STYLE = merge

[repository.signing]
DEFAULT_TRUST_MODEL = committer

