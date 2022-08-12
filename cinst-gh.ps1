<# Installs package directly from Github repository
   To use with your own repo: 
     - Set the path to your packages root in $Repo
     - Create short link to this raw github script via for example goo.gl
     - Commit nupkg files in the repository along with the package source code
    
   Usage:
     - Pass repository package name as a first argument
     - Pass any cinst option after that (some may not work ofc. such as `version`)

   Example: 
     iwr https://goo.gl/SZ9c3m | iex; cinst-gh furmark --force
#>
function cinst-gh {
    $Repo = "https://github.com/majkinetor/au-packages/tree/master" 

    $name = $args[0]
    $download_page = iwr $Repo/$name -UseBasicParsing
    $url = $download_page.Links.href -like '*.nupkg'
    $p = $url -split '/' | select -last 1
    
    $raw = $Repo -replace 'github.com', 'rawgit.com' -replace 'tree/'
    iwr "$raw/$(($p -split '\.')[0])/$p" -Out $p
    $a = $args | select -Skip 1
    $cmd = "cinst $p $a"
    Write-Host $cmd; iex $cmd
    rm $p
}
