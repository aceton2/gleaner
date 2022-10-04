import os
from datetime import datetime

print("\n gleaning titles.. \n")
# base = 'C:\Users\Xavier\Documents\'
# baseTerm = 'DELICIAS DEL VOLGA Borrador final'

base = '/Users/Oolite/Projects'
baseTerm = 'oolite'

rootFolder = None
for name in os.listdir(base):
    if baseTerm.lower() in name.lower():
        rootFolder = f"{base}/{name}"

content = ""
for (root, dirs, files) in os.walk(rootFolder, 'top'):
    if(len(files) > 0):
        nesting = root.split('/')
        levels = (len(nesting) - len(rootFolder.split('/'))) * '*'
        folder_name = nesting[-1]
        content += f'<div class="subFolderTitle"> {levels} {folder_name} </div>'
        for file in files:
            content += f'<div class="documentTitle"> {file} </div>'

style = """
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
"""

script = """
<script> 
    function toggleDocVisibility() { 
        document.body.classList.contains('noDocNames') ? 
        document.body.classList.remove('noDocNames') : 
        document.body.classList.add('noDocNames') 
    } 
</script>
"""

html = f"""
<head>
  <title> Volga Index </title>
  {style}
</head>

<body class="noDocNames">

    <div class="indexTitleDiv"> 
    Volga Index 
    <div> generated {datetime.now()} </div>
    </div>

    <button onclick="toggleDocVisibility()">toggle docs</button>

    {content}
    {script}
</body>

</html>
"""

with open('vi.html', 'w') as vii:
    vii.write(html) 

print(' SUCCESS. index generated \n')