<center>
    <h1 align="center">Enable devtools in Spotify for Windows</h1>
</center>

<h2>Requirements:</h2>

- Spotify Desktop or Microsoft Store version

> [!IMPORTANT] 
 Spotify client must already be installed and logged in

<h2>What does the script do?</h2>

- <strong>Activates the main developer options in the menu</strong>
- <strong>Activates the developer menu on the right mouse click</strong>
- <strong>Additional launch [parameters](https://github.com/amd64fox/Enable-devtools-Spotify?tab=readme-ov-file#script-parameters)</strong>                                         

> [!NOTE]
After closing the client, all developer menus will be disabled, for new versions of the client this logic has stopped working, to disable devtools just run the script again

<h2>Quick start:</h2>


#### Just download and run [Enable-devtools.bat](https://raw.githack.com/amd64fox/Enable-devtools-Spotify/main/Enable-devtools.bat)

or

#### Run The following command in PowerShell:

```ps1
iex "& {$(iwr -useb 'https://raw.githubusercontent.com/amd64fox/Enable-devtools-Spotify/main/Enable-devtools.ps1')}"
```
```ps1
iex "& {$(iwr -useb 'https://raw.githubusercontent.com/amd64fox/Enable-devtools-Spotify/main/Enable-devtools.ps1')} -extra"
```

<h2></h2>


## Script parameters:

| Parameter        | Description                                                           |    
|------------------|-----------------------------------------------------------------------|
| `-extra`         | Enable Cosmos debugger & Utils (requires additional resource loading) |
| `-console`       | Show console output                                                   |
| `-allow_pasting` | Allow pasting in devtools console                                     |
| `-minimized`     | Minimize client at start                                              |


> [!NOTE] 
[Enable-devtools-Spotify](https://gist.github.com/jetfir3/d66f491d0683e2bdbdf9f60068e9984b) (Mac & Linux) by [jetfire](https://github.com/jetfir3)
