
try {

# HTML Template Vars
#######################################################################################################
#######################################################################################################

$htmlList = ""

$htmlScript = @"
<script> function toggleDocVisibility() { document.body.classList.contains('noDocNames') ? document.body.classList.remove('noDocNames') : document.body.classList.add('noDocNames') } </script>
</body>
"@

$htmlHead = @"
<head>
  <title> Volga Index </title>
  <style>

    body {
        margin:auto; 
        width: 80%; 
        font-family: Sans-Serif;
    }

    button {
      border: 0;
      border-radius: 0.25rem;
      background: #483C32;
      color: #cabfb6;
      font-family: -system-ui, sans-serif;
      font-size: 0.8rem;
      line-height: 1.2;
      white-space: nowrap;
      text-decoration: none;
      padding: 0.25rem 0.5rem;
      margin: 0rem 2rem 2rem 0;
      cursor: pointer;
    }

    .noDocNames > .documentTitle {
        display: none;
    }

    .noDocNames > .subFolderTitle {
        margin: 0.3rem 0px; 
        font-size: 0.8rem;
        font-weight: normal;
    }
    
    .noDocNames > .subFolderTitle.volumeClass {
        font-weight: bold;
    }
  
    .indexTitleDiv {
        margin: 2rem 0rem;
        font-size: 1.5rem;
    }

    .indexTitleDiv > div {
        font-size: 0.8rem;
    }
  
    .subFolderTitle {
        margin: 0.5rem 0px; 
        font-weight: bold
    }

    .documentTitle { 
        margin-top: 0.33rem;
        font-size: 0.7rem;
    }
      
  </style>
</head>
"@

$currentTime = Get-Date

$htmlTitle = @"
<body class="noDocNames">


<div class="indexTitleDiv"> 
   Volga Index 
   <div> generated $currentTime </div>
</div>

<button onclick="toggleDocVisibility()">toggle docs</button>
"@


# Constants
#######################################################################################################\
#######################################################################################################

$mainDir = '/app/testFolder'
$destinationFile = '/app/VolgaIndex.html'

#$mainDir = 'C:\Users\Xavier\Documents\DELICIAS DEL VOLGA Borrador final. Versi�n definitiva'
#$destinationDir = 'C:\Users\Xavier\Desktop\VolgaIndex.html'

# Generate HTML
#######################################################################################################
#######################################################################################################

write-host "`n gleaning titles...`n"

$folders = Get-ChildItem $mainDir | Where { $_.PSIsContainer } | Select Name

ForEach($f in $folders){

 $subFolder = "$mainDir\$($f.Name)"
 $subFolderTitle = $f.Name.Substring(0, [System.Math]::Min(120, $f.Name.Length))


 ## if a title does not contain lowercase letters it is considered a volume and set to bold

 if( -Not( $subFolderTitle -cmatch '.*[a-z]') ) {
   $volumeClass = "volumeClass"
 }
 else {
   $volumeClass = ""
 }

 $htmlList = $htmlList + 
 @"  
  <div class="subFolderTitle $volumeClass"> $subFolderTitle </div>
"@

 $list = Get-ChildItem -Path $subFolder -Recurse | `
        Where-Object { $_.PSIsContainer -eq $false -and $_.Extension -ne '.srt' }

 ForEach($n in $list){
  $parsedName = $n.Name.Substring(0, $n.Name.Length - 5)
  $docTitle = $parsedName.Substring(0, [System.Math]::Min(120, $parsedName.Length))

  $htmlList = $htmlList + 
  @"
   <div class="documentTitle"> $docTitle </div>
"@

 }

}

# Write to File
#######################################################################################################
#######################################################################################################

$htmlFile = $htmlHead + $htmlTitle + $htmlList  + $htmlScript

Set-Content -Path $destinationFile -Value $htmlFile

write-host "List successfully generated"

}

catch {
 write-host "An error occured"
}
 
write-host "Press any key to terminate script.."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
