function fish_prompt
  set -l rest_color       (set_color normal)
  set -l logo             (set_color --bold white)▲$rest_color$rest_color
  set -l dirty            "✖"
  set -l none             "✔"
  set -l cwd

  set -l error_color      (set_color $fish_color_error ^/dev/null; or set_color red --bold)
  set -l success_color    (set_color $fish_color_cwd ^/dev/null; or set_color green)

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

    echo -ns "$logo $cwd at "(set_color --bold white) (git_branch_name) $reset_color " "

    if git_is_touched
      echo -n -s $error_color $dirty $reset_color $reset_color " "
    else
      echo -n -s $success_color (git_ahead $none) $reset_color $reset_color " "
    end
  else
    echo -ns "$logo $cwd "
  end
end
