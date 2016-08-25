function Save-Git() {
    $pushed = $Info.result.pushed
    if (!$Info.pushed) { "Git: no package is pushed to chocolatey, skipping"; return }

    ""
    "Executing git pull"
    git checkout master
    git pull

    "Commiting updated packages to git repository"
    $pushed | % { git add $_.PackageName }
    git commit -m "UPDATE BOT: $($Info.pushed) packages updated"

    "Pushing git changes"
    git push
}
