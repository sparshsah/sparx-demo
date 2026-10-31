# git convenience helpers

git_status() {
  pwd &&
  git branch -vv &&
  git status
}

git_checkout() {
  # e.g. `git_checkout sparshsah/new-feature-branch`
  git checkout -b "$1" &&
  git push --set-upstream origin "$1"
}

git_em_down_scotty() {
  # blindly pull
  git checkout main &&
  git pull &&
  git_status
}

git_me_up_scotty() {
  # blindly push
  git status &&
  git pull --no-edit &&
  git branch &&
  git add . &&
  git status &&
  git commit -m ok &&
  git push &&
  git_status
}

git_rebase() {
  # e.g. `git_rebase sparshsah/my-feature-branch`
  git_em_down_scotty &&
  git checkout "$1" &&
  git branch sparshsah/pre-rebase-stash &&
  git rebase origin/main &&
  git push --force-with-lease &&
  git branch -D sparshsah/pre-rebase-stash &&
  git_em_down_scotty
}

_git_rebase_all() {
  # ... list all local branches
  # ... start at char 3 (to strip leading "* " or "  ")
  #     and go to end of line for each line
  # ... for each listed branch name, git_rebase it
  git branch | cut -c 3- | while read -r branch; do
    git_rebase "$branch"
  done
}

git_rebase_all() {
  _git_rebase_all &&
  echo -e "\n\n... git-rebased all"
}
