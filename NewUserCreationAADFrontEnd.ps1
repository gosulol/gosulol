#Front Loading AuthZand AuthN


#Import-Module AzureAD
#Import-Module MSOLService
#Import-Module ExchangeOnline Services

Connect-AzureAD
Connect-ExchangeOnline
Connect-MSOLService

 

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

 

#The XAML Form - Captures input of user details

 

[XML]$XAML =

 

@'

 

<Window xmlns=http://schemas.microsoft.com/winfx/2006/xaml/presentation Width="800" Height="400">

<Grid Margin="-14,-66,-30,-40">

<Grid.RowDefinitions><RowDefinition Height="422*"/>

<RowDefinition Height="23*"/>

<RowDefinition Height="22*"/>

</Grid.RowDefinitions>

<TextBox HorizontalAlignment="Left" VerticalAlignment="Top" Height="23" Width="120" TextWrapping="Wrap" Margin="108,71,0,0" Name="FrstName"/>

<Label HorizontalAlignment="Left" VerticalAlignment="Top" Content="First Name" Margin="39,82,0,0" Name="FirstName"/>

<Label HorizontalAlignment="Left" VerticalAlignment="Top" Content="Last Name" Margin="251,74,0,0"/>

<TextBox HorizontalAlignment="Left" VerticalAlignment="Top" Height="23" Width="120" TextWrapping="Wrap" Margin="317,68,0,0" Name="LstName"/>

<Label HorizontalAlignment="Left" VerticalAlignment="Top" Content="Job Title" Margin="53,131,0,0"/>

<Label HorizontalAlignment="Left" VerticalAlignment="Top" Content="Department" Margin="36,165,0,0"/>

<Label HorizontalAlignment="Left" VerticalAlignment="Top" Content="Office" Margin="64,201,0,0"/>

<Label HorizontalAlignment="Left" VerticalAlignment="Top" Content="Mobile" Margin="60,243,0,0"/>

<Label HorizontalAlignment="Left" VerticalAlignment="Top" Content="City" Margin="74,281,0,0"/>

<Label HorizontalAlignment="Left" VerticalAlignment="Top" Content="State" Margin="67,325,0,0"/>

<TextBox HorizontalAlignment="Left" VerticalAlignment="Top" Height="15" Width="120" TextWrapping="Wrap" Margin="116,161,0,0" Name="Dpt"/>

<TextBox HorizontalAlignment="Left" VerticalAlignment="Top" Height="15" Width="120" TextWrapping="Wrap" Margin="116,197,0,0" Name="Off"/>

<TextBox HorizontalAlignment="Left" VerticalAlignment="Top" Height="15" Width="120" TextWrapping="Wrap" Margin="117,233,0,0" Name="Mb"/>

<TextBox HorizontalAlignment="Left" VerticalAlignment="Top" Height="15" Width="120" TextWrapping="Wrap" Margin="116,271,0,0" Name="Cty"/>

<Image HorizontalAlignment="right" Height="100" VerticalAlignment="Top" Width="100" Margin="67, 201, 50, 50" Name="D3Logo" Source="C:\Users\xxxx/xxxx.jpg"/>

<Label HorizontalAlignment="Left" VerticalAlignment="Top" Content="Written by Jordan Ricketts 7-02-24" Margin="590,393,0,0"/>

<TextBox HorizontalAlignment="left" VerticalAlignment="Top" Height="23" Width="120" TextWrapping="Wrap" Margin="334,318,0,0" Name="Mgr"/>

<Label HorizontalAlignment="Left" VerticalAlignment="Top" Content="Manager" Margin="275,323,0,0"/>

<Label HorizontalAlignment="Left" VerticalAlignment="Top" Content="Country" Margin="55,360,0,0"/>

<TextBox HorizontalAlignment="Left" VerticalAlignment="Top" Height="15" Width="120" TextWrapping="Wrap" Margin="117,349,0,0" Name="Cntry" Grid.Row="0" Grid.Column="0"/>

<TextBox HorizontalAlignment="Left" VerticalAlignment="Top" Height="15" Width="120" TextWrapping="Wrap" Margin="115,125,0,0" Name="JBTitle" Grid.Row="0" Grid.Column="0"/>

<Button Name="Create" Content="Create" HorizontalAlignment="Left" VerticalAlignment="Top" Width="116" Margin="611,287,0,0" Height="57" Grid.Row="0" Grid.Column="0"/>

<CheckBox HorizontalAlignment="Left" VerticalAlignment="Top" Content="Development signature" Margin="310,159,0,0" Name="DevSig" Grid.Row="0" Grid.Column="0"/>

<TextBox HorizontalAlignment="Left" VerticalAlignment="Top" Height="15" Width="120" TextWrapping="Wrap" Margin="117,309,0,0" Name="St" Grid.Row="0" Grid.Column="0"/>

<CheckBox HorizontalAlignment="Left" VerticalAlignment="Top" Content="Legal Signature" Margin="310,124,0,0" Name="LegSig" Grid.Row="0" Grid.Column="0"/>

<CheckBox HorizontalAlignment="Left" VerticalAlignment="Top" Content="E3" Margin="313,223,0,0" Name="E3Lic" Grid.Row="0" Grid.Column="0"/>

<CheckBox HorizontalAlignment="Left" VerticalAlignment="Top" Content="MDM BYOD" Margin="312,266,0,0" Name="MdmByod" Grid.Row="0" Grid.Column="0"/>

</Grid>

</Window>

 

'@

 

$XAML.Window.RemoveAttribute("x:Class")

$XAML.Window.RemoveAttribute("mc:Ignorable")

$Reader = New-Object System.Xml.XmlNodeReader $XAML

$MainForm = [Windows.Markup.XamlReader]::Load($Reader)

$Global:Click = {

    #Click event captures text box inputs for user details

    $Global:FirstName = $Mainform.FindName('FrstName').text

    $Global:LastName = $Mainform.FindName('LstName').text

    $Global:Mobile = $Mainform.FindName('MB').text

    $Global:Jobtitle = $Mainform.FindName('JbTitle').text

    $Global:Department = $Mainform.FindName('Dpt').text

    $Global:Office = $Mainform.FindName('Off').text

    $Global:City = $Mainform.FindName('Cty').text

    $Global:State = $Mainform.FindName('St').text

    $Global:Country = $Mainform.FindName('Cntry').text

    $Global:LegalSignature = $Mainform.FindName('LegSig').ischecked

    $Global:DevelopmentSignature = $Mainform.FindName('DevSig').ischecked

    $Global:E3 = $Mainform.FindName('E3Lic').ischecked

    $Global:BYOD = $Mainform.FindName('MdmByod').ischecked

    $Global:Manager = $Mainform.FindName('Mgr').text

 

    #Variables above are used to create a new PS custom Object containing User account details that are then passed to the backend

   

    $NewUserObject = [ pscustomobject]@{

        FirstName = $FirstName

        LastName = $LastName

        DisplayName = $FirstName + " " + $LastName

        UPN = $FirstName + $LastName + "@xxxx.com"

        Mobile = $Mobile

        JobTitle = $JobTitle

        Department = $Department

        Office = $Office

        Manager = $Manager

        Country = $Country

        License = $E3

        City = $City

        BYOD = $BYOD

        Company = $Company

        External = $External

        LegalSignature = $LegalSignature

        DevelopmentSignature = $DevelopmentSignature

        QLDDevelopmentSignature = $QLDDevelopmentSignature

        CustomAttribute2 = ''

        CustomAttribute3 = ''

    }

 #Loads back-end within the click event


.\AADBackEnd.ps1 $NewUserObject, $Mainform, $City

 

#(Still within click event)Closes form

$Mainform.close()

 

 }

 

#Finds the "create button in the form and associates the above click event with the create button on the form - Line below adds a click event"

 $Global:Create = $Mainform.FindName('Create')
 $Create.Add_click($Click)


 $MainForm.ShowDialog()