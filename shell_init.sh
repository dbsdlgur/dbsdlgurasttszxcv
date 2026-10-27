echo "***********************"
echo "✨ 🌟 ✨ < assets > ✨ 🌟 ✨"
echo "***********************"

# source activate envname
detect_virtualenv_upward() {
    local dir="$PWD"
    while [ "$dir" != "/" ]; do
        if [ -f "$dir/.venv/bin/activate" ]; then
            echo "$dir/.venv/bin/activate"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    return 1
}
if VENV_PATH=$(detect_virtualenv_upward); then
    source "$VENV_PATH"
    echo "🚀 using Venv / $VIRTUAL_ENV"
else
    echo "❌ No virtualenv found / $PWD"
fi

# =========================
# Django (Poetry)
# =========================
alias m='poetry run python manage.py'
alias ms='poetry run python manage.py shell'
alias msp='poetry run python manage.py shell_plus'
alias mmm='poetry run python manage.py makemigrations'
alias mm='poetry run python manage.py migrate'
alias mr='poetry run python manage.py runserver 0.0.0.0:8091'
alias mc='python manage.py collectstatic --noinput'
alias mcreatesuperuser='cd ~/backend/react/backend && python manage.py createsuperuser'
alias nrb='cd ~/backend/react/frontend && npm run build && home'

# =========================
# systemd / Services
# =========================
# ps aux | grep uwsgi / PID 확인 / USR2: graceful reload / HUP: restart
alias ssrrd='sudo systemctl daemon-reload'
alias ssrrn='sudo systemctl restart nginx'
alias ssrru='sudo systemctl restart uwsgi'
alias ssrrg='sudo systemctl restart ipnable-gunicorn.service'
alias ssrrc='sudo systemctl daemon-reload && sudo systemctl restart celery && sudo systemctl restart celerybeat'
alias stopc='sudo systemctl stop celery && sudo systemctl stop celerybeat && sudo systemctl daemon-reload'

# =========================
# Graceful Reload
# =========================
# sudo lsof -t -i tcp:8000 | xargs kill -9
alias psu='ps aux | grep uwsgi | grep -v grep | awk "NR==2{print $2}"'
alias psu2='ps aux | grep uwsgi | awk "NR==2{print \$2}"'
alias usr='sudo kill -USR2 $(psu2)'
alias gsr='sudo systemctl kill -s USR2 ipnable-gunicorn'

# =========================
# Static / Account / Frontend
# =========================
alias mc='python manage.py collectstatic --noinput'
alias mcreatesuperuser='cd ~/backend/react/backend && python manage.py createsuperuser'
alias nrb='cd ~/backend/react/frontend && npm run build && home'

# =========================
# Media / Files
# =========================
alias syncm='./scripts/sync_media_from_prod.sh'
alias rmpc="find . -name '__pycache__' -exec rm -rf {} +"
alias sync_gtoa='(cd .. && maintenance/sync_gtoa.sh)'

# =========================
# Node / NPM
# =========================
alias npmi='npm install'
alias npmr='npm run build'

# =========================
# Git
# =========================
alias gs='git status'
alias ggdd='git push origin eric && git checkout dev && git merge eric && git push origin dev && git checkout eric'
alias ggmmo='git push origin ok && git checkout dev && git merge ok && git push origin dev && git checkout master && git merge dev && git push origin master && git checkout ok'
# alias ggmm='git push origin eric && git checkout master && git merge eric && git push origin master && git checkout eric'
alias ggmme='git fetch && git checkout dev && ggpp && git checkout eric && git merge --no-edit dev && ggmm'
alias ggpp='git fetch && git pull origin master'
alias ggrm='git rm --cached .env.systemd'
alias ggca='git checkout --theirs c_admin/staticfiles/admin/admin.css' #confilct admin css
alias gdff='git diff-tree --no-commit-id --name-status -r' # commit hash용
alias gmodels='git checkout eric -- gurimapps/**/models/ gurimapps/**/migrations/'