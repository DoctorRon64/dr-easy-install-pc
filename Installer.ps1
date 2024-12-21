# Load required assemblies
Add-Type -AssemblyName PresentationFramework

# Define categories and apps
$categories = @{
    "Web Browsers"          = @{
        "Firefox"     = "winget install -e --id Mozilla.Firefox"
        "Tor Browser" = "winget install -e --id TorProject.TorBrowser"
    }
    "Email Clients"         = @{
        "Thunderbird" = "winget install -e --id Mozilla.Thunderbird"
    }
    "Media Players"         = @{
        "VLC"      = "winget install -e --id VideoLAN.VLC"
        "Winamp"   = "winget install -e --id Winamp.Winamp"
        "Dopamine" = "winget install -e --id Digimezzo.Dopamine.3"
        "Spotify"  = "winget install --id=ImageLine.FLStudio -e"
    }
    "Development Tools"     = @{
        "Eclipse"         = "winget install EclipseAdoptium.Temurin.21.JDK"
        "JetBrains Rider" = "winget install -e --id JetBrains.Rider"
        "VSCode"          = "winget install -e --id Microsoft.VisualStudioCode"
        "Visual Studio"   = "winget install -e --id Microsoft.VisualStudio.2022.Community.Preview"
        "Unity Hub"       = "winget install -e --id Unity.UnityHub --version 3.4.2"
        "Node.js"         = "winget install -e --id OpenJS.NodeJS"
        "Python"          = "winget install -e --id Python.Python.3.11"
        ".NET"            = "winget install -e --id Microsoft.DotNet.SDK.7"
        "Java Runtime"    = "winget install -e --id Oracle.JavaRuntimeEnvironment"
        "Java JDK"        = "winget install -e --id Oracle.JDK.19"
    }
    "Utilities"             = @{
        "Git"             = "winget install --id Git.Git -e --source winget"
        "Fork"            = "winget install -e --id Fork.Fork"
        "Notepad++"       = "winget install -e --id Notepad++.Notepad++"
        "PowerToys"       = "winget install --id Microsoft.PowerToys --source winget"
        "WizTree"         = "winget install -e --id AntibodySoftware.WizTree"
        "Everything"      = "winget install -e --id voidtools.Everything"
        "WinRAR"          = "winget install -e --id RARLab.WinRAR"
        "7-Zip"           = "winget install -e --id 7zip.7zip"
        "PeaZip"          = "winget install -e --id Giorgiotani.Peazip"
        "Synology Files"  = "winget install -e --id Synology.DriveClient"
        "Glary Utilities" = "winget install -e --id Glarysoft.GlaryUtilities"
    }
    "Design Tools"          = @{
        "Image Glass" = "winget install -e --id DuongDieuPhap.ImageGlass"
        "Draw.io"     = "winget install -e --id JGraph.Draw"
        "Paint.net"   = "winget install -e --id dotPDNLLC.paintdotnet"
        "Blender"     = "winget install -e --id BlenderFoundation.Blender"
        "Krita"       = "winget install -e --id KDE.Krita"
        "Inkscape"    = "winget install -e --id Inkscape.Inkscape"
    }
    "Games & Entertainment" = @{
        "Steam"     = "winget install -e --id Valve.Steam"
        "Playnite"  = "winget install -e --id Playnite.Playnite"
        "Minecraft" = "winget install -e --id Mojang.MinecraftLauncher"
    }
    "Other"                 = @{
        "Sandboxie"       = "winget install -e --id Sandboxie.Plus"
        "ScreenToGif"     = "winget install -e --id NickeManarin.ScreenToGif"
        "ShareX"          = "winget install -e --id ShareX.ShareX"
        "qBittorrent"     = "winget install -e --id qBittorrent.qBittorrent"
        "Handbrake"       = "winget install -e --id HandBrake.HandBrake"
        "OBS Studio"      = "winget install -e --id OBSProject.OBSStudio"
        "Wireshark"       = "winget install -e --id WiresharkFoundation.Wireshark"
        "WireGuard"       = "winget install -e --id WireGuard.WireGuard"
        "Simplewall"      = "winget install -e --id Henry++.simplewall"
        "CrystalDiskInfo" = "winget install -e --id CrystalDewWorld.CrystalDiskInfo"
    }
}

# Define a WPF UI for better design
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="App Installer" Height="600" Width="800" WindowStartupLocation="CenterScreen" Background="#2C2F33">
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>
        
        <TextBlock Text="App Installer" Foreground="White" FontSize="20" FontWeight="Bold" Margin="10" HorizontalAlignment="Center" Grid.Row="0"/>
        
        <TabControl x:Name="CategoryTabs" Background="#2C2F33" Foreground="white" BorderBrush="#7289DA" Grid.Row="1" Margin="10" TabStripPlacement="Top">
            <!-- Tabs will be added dynamically -->
        </TabControl>
        
        <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" Margin="10" Grid.Row="2">
            <Button Content="Select All" Width="120" Height="40" Background="#43B581" Foreground="White" FontSize="14" x:Name="SelectAllButton" Margin="10" BorderBrush="#2C2F33" BorderThickness="2" Style="{StaticResource {x:Type Button}}" />
            <Button Content="Deselect All" Width="120" Height="40" Background="#F04747" Foreground="White" FontSize="14" x:Name="DeselectAllButton" Margin="10" BorderBrush="#2C2F33" BorderThickness="2" Style="{StaticResource {x:Type Button}}" />
            <Button Content="Install Selected Apps" Width="180" Height="40" Background="#7289DA" Foreground="White" FontSize="14" x:Name="InstallButton" Margin="10" BorderBrush="#2C2F33" BorderThickness="2" Style="{StaticResource {x:Type Button}}" />
            <Button Content="Cancel" Width="100" Height="40" Background="#99AAB5" Foreground="White" FontSize="14" x:Name="CancelButton" Margin="10" BorderBrush="#2C2F33" BorderThickness="2" Style="{StaticResource {x:Type Button}}" />
        </StackPanel>
    </Grid>
</Window>
"@

# Load XAML
$reader = New-Object System.Xml.XmlNodeReader $xaml
$form = [Windows.Markup.XamlReader]::Load($reader)

# Add tabs for each category
$checkboxes = @{}
$categoryTabs = $form.FindName("CategoryTabs")
foreach ($category in $categories.Keys) {
    $tab = New-Object Windows.Controls.TabItem
    $tab.Header = $category
    $tab.Foreground = "gray"
    $tab.Background = "#4F545C"
    $tab.BorderBrush = "#2C2F33"
    $tab.BorderThickness = "1"
    
    $appPanel = New-Object Windows.Controls.StackPanel
    foreach ($app in $categories[$category].Keys) {
        $checkbox = New-Object Windows.Controls.CheckBox
        $checkbox.Content = $app
        $checkbox.Foreground = "White"
        $checkbox.Background = "#2C2F33"
        $checkbox.Margin = "10,5,0,5"
        $checkbox.BorderBrush = "#7289DA"
        $checkbox.BorderThickness = "1"
        $appPanel.Children.Add($checkbox)
        $checkboxes[$app] = $checkbox
    }
    $tab.Content = $appPanel
    $categoryTabs.Items.Add($tab)
}

# Add event handlers for buttons
$form.FindName("SelectAllButton").Add_Click({
        foreach ($checkbox in $checkboxes.Values) {
            $checkbox.IsChecked = $true
        }
    })

$form.FindName("DeselectAllButton").Add_Click({
        foreach ($checkbox in $checkboxes.Values) {
            $checkbox.IsChecked = $false
        }
    })

$form.FindName("InstallButton").Add_Click({
        $selectedApps = @{}
        foreach ($app in $checkboxes.Keys) {
            if ($checkboxes[$app].IsChecked) {
                $selectedApps[$app] = $categories.Keys.ForEach({ $categories[$_] | Get-Variable -ValueOnly })[$app]
            }
        }

        if ($selectedApps.Count -eq 0) {
            [System.Windows.MessageBox]::Show("Please select at least one app to install.", "No Apps Selected", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
        }
        else {
            foreach ($app in $selectedApps.Keys) {
                Write-Host "Installing $app..."
                Invoke-Expression $selectedApps[$app]
            }
            [System.Windows.MessageBox]::Show("Selected apps have been installed!", "Installation Complete", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
            $form.Close()
        }
    })

$form.FindName("CancelButton").Add_Click({
        $form.Close()
    })

# Show form
$form.ShowDialog() | Out-Null