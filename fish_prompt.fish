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
  set -l rest_color (set_color normal)
  set -l success_color    (set_color $fish_pager_color_progress ^/dev/null; or set_color cyan)
  set -l error_color      (set_color $fish_color_error ^/dev/null; or set_color red --bold)
  set -l directory_color  (set_color $fish_color_quote ^/dev/null; or set_color brown)
  set -l repository_color (set_color $fish_color_cwd ^/dev/null; or set_color green)
  set logo (set_color --bold white)▲$rest_color$rest_color
  set -l ahead "↑"
  set -l behind "↓"
  set -l diverged "⥄ "
  set -l dirty "⨯"
  set -l none "◦"
  set -l dir

  if test $last_command_status -eq 0
    echo -n -s $success_color $logo $normal_color
  else
    echo -n -s $error_color $logo $normal_color
  end

  # if test "$theme_short_path" = 'yes'
  #   set dir (basename (prompt_pwd))
  # else
  #   set dir (prompt_pwd)
  # end

  if git_is_repo
    if test "$theme_short_path" = 'yes'
      set root_folder (command git rev-parse --show-toplevel ^/dev/null)
      set parent_root_folder (dirname $root_folder)
      set cwd (echo $PWD | sed -e "s|$parent_root_folder/||")
    end

    echo -n -s " " $directory_color $cwd $normal_color
    echo -n -s " " $repository_color (git_branch_name) $normal_color " "

    if git_is_touched
      echo -n -s $dirty
    else
      echo -n -s (git_ahead $ahead $behind $diverged $none)
    end
  else
    echo -n -s " " $directory_color $cwd $normal_color
  end

  # echo "$logo $dir"
end
