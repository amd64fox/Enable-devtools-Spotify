<p align="center">
      <a href="https://t.me/SpotxCommunity"><img src="https://raw.githubusercontent.com/amd64fox/SpotX/main/.github/Pic/Shields/SpotX_Community.svg"></a>
      <a href="https://cutt.ly/8EH6NuH"><img src="https://raw.githubusercontent.com/amd64fox/Rollback-Spotify/main/.github/Pic/Shields/excel.svg"></a>
      </p>

<center>
    <h1 align="center">Enable devtools in Spotify for Windows</h1>
</center>

<h2>What does the script do?</h2>

- <strong>Activates the main developer options in the menu</strong>
- <strong>Activates the developer menu on the right mouse click</strong>
- <strong>Activates Debug Tools</strong> 
- <strong>Activates the item for employees in the Spotify settings</strong> *(to activate run advanced Devtools)*
- <strong>After closing the client, all developer menus will be disabled</strong>

<h3>Launch type:</h3>

<details>

<summary><small>Enable only Devtools</small></summary><p>

#### Just download and run [Enable-devtools.bat](https://raw.githack.com/amd64fox/Enable-devtools-Spotify/main/Enable-devtools.bat)

or

#### Run The following command in PowerShell:

```ps1
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (iwr -useb 'https://raw.githubusercontent.com/amd64fox/Enable-devtools-Spotify/main/Enable-devtools.ps1').Content | iex
```

</details>

<details>

<summary><small>Enable advanced Devtools settings</small></summary><p>

#### Just download and run [Enable-devtools-plus.bat](https://raw.githack.com/amd64fox/Enable-devtools-Spotify/main/Enable-devtools-plus.bat)

or

#### Run The following command in PowerShell:

```ps1
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iex "& { $((iwr -useb 'https://raw.githubusercontent.com/amd64fox/Enable-devtools-Spotify/main/Enable-devtools.ps1').Content) } -dev_plus"
```

</details>
<h2>A little more</h2>

<details>
<summary><small>Screenshots</small></summary><p>
  
  | Main developer options in the menu | Developer menu on the right mouse click |
| :----: | :----: |
| ![Снимок экрана 2022-09-07 152432](https://user-images.githubusercontent.com/62529699/188879952-31daa918-5eb7-4e90-914e-99a38fb856f3.jpg) | ![Снимок экрана 2022-09-07 154755](https://user-images.githubusercontent.com/62529699/188881902-cef30290-a440-40d4-ac50-43d266cd6355.jpg)

| Debug Tools | Debug Tools |
| :----: | :----: |
| ![123](https://user-images.githubusercontent.com/62529699/228794076-0d9b158f-c3d8-411e-b095-7c0f8065b268.png) | ![Снимок экрана 2022-09-07 155426](https://user-images.githubusercontent.com/62529699/188883988-39e4bd34-1a83-4527-878f-080e9ec415be.jpg)

| Item for employees in the Spotify settings |
| :----: |
| ![Снимок экрана 2022-09-07 152114](https://user-images.githubusercontent.com/62529699/188884736-6eb16372-ea0c-43e3-8255-46e77fc38e19.jpg)


</details>

Starting from version 1.1.80.699, access to devtools was limited, this script turns on devtools forcibly.

The idea was spied [here](https://gist.github.com/PhilippIRL/97908aba3a78cc0c8d0ab4e9439bf445)
