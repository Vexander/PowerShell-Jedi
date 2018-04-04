Configuration RunningService 
{
    param([Parameter()]$ServiceName)

    ForEach ($Sn in $ServiceName)
    {
        Service $Sn
        {
            Name = $Sn
            Ensure = 'Present'
        }
    }

}