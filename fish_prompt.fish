function git_prompt
  set -l dirty            "✖"
  set -l none             "✔"
  set -l error_color      (set_color $fish_color_error ^/dev/null; or set_color red --bold)
  set -l success_color    (set_color $fish_color_cwd ^/dev/null; or set_color green)
  if git_is_repo
    if git_is_touched
      echo -ns "$error_color $dirty $reset_color"
    else
      echo -ns "$success_color $none $reset_color"
    end
  end
end

function dir
  set -l cwd

  if git_is_repo
    if test "$theme_short_path" = 'yes'
      set root_folder (command git rev-parse --show-toplevel ^/dev/null)
      set parent_root_folder (dirname $root_folder)
      set cwd (echo $PWD | sed -e "s|$parent_root_folder/||")
    else
      set cwd (prompt_pwd)
    end
  else
    if test "$theme_short_path" = 'yes'
      set cwd (basename (set_color --bold white prompt_pwd))
    else
      set cwd (prompt_pwd)
    end
  end

  echo $cwd
end

function fish_prompt
  set -l rest_color       (set_color normal)
  set -l logo             (set_color --bold white)▲$rest_color$rest_color

  echo -n $logo (dir)(git_prompt)
end
