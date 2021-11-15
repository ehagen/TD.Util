function New-SecureStringStorage([ValidateNotNullOrEmpty()]$String)
{
    return [SecureStringStorage]::New($String)
}