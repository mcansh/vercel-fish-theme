# function branch_is_dirty
#   local STATUS=''
#   local -a FLAGS
#   FLAGS=('--porcelain')
#   if [[ "$(command git config --get oh-my-zsh.hide-dirty)" != "1" ]]; then
#     if [[ $POST_1_7_2_GIT -gt 0 ]]; then
#       FLAGS+='--ignore-submodules=dirty'
#     fi
#     if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
#       FLAGS+='--untracked-files=no'
#     fi
#     STATUS=$(command git status ${FLAGS} 2> /dev/null | tail -n1)
#   fi
#   if [[ -n $STATUS ]]; then
#     return 0
#   else
#     return 1
#   fi
# end

# function git_prompt
#   branch=`git_current_branch`
#   if [ "$branch" = '' ]; then
#     # not a git repo
#     echo ''
#   else
#     if branch_is_dirty; then
#       echo "$GIT_PROMPT_PREFIX$GIT_PROMPT_DIRTY$branch$GIT_PROMPT_SUFFIX"
#     else
#       echo "$GIT_PROMPT_PREFIX$GIT_PROMPT_CLEAN$branch$GIT_PROMPT_SUFFIX"
#     fi
#   fi
# end


function fish_prompt
  set -l last_command_status $status
  set -l rest_color       (set_color normal)
  set -l logo             (set_color --bold white)▲$rest_color$rest_color
  set -l ahead            "↑"
  set -l behind           "↓"
  set -l diverged         "⥄ "
  set -l dirty            "✖"
  set -l none             "◦"
  set -l cwd

  set -l error_color      (set_color $fish_color_error ^/dev/null; or set_color red --bold)

  if test "$theme_short_path" = 'yes'
    set cwd (basename (set_color --bold white prompt_pwd))
  else
    set cwd (prompt_pwd)
  end

  if git_is_repo
    if test "$theme_short_path" = 'yes'
      set root_folder (command git rev-parse --show-toplevel ^/dev/null)
      set parent_root_folder (dirname $root_folder)
      set cwd (echo $PWD | sed -e "s|$parent_root_folder/||")
    end


    echo -ns "$logo $cwd$repository_color at "(set_color --bold white) (git_branch_name) $reset_color " "

    if git_is_touched
      echo -n -s "$error_color$dirty $reset_color"
    end
  end
end
