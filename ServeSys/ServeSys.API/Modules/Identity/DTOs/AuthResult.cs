namespace ServeSys.API.Modules.Identity.DTOs;

public class AuthError
{
    public string Code { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
}

public class AuthResult
{
    public bool Succeeded { get; set; }
    public IEnumerable<AuthError> Errors { get; set; } = new List<AuthError>();
    public AuthResponse? Data { get; set; }
}
