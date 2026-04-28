namespace ServeSys.API.Modules.Identity.DTOs;

public class AuthResponse
{
    public string Token { get; set; } = string.Empty;
    public string RefreshToken { get; set; } = string.Empty;
    public DateTime Expiration { get; set; }
    public string? Email { get; set; }
    public string FullName { get; set; } = string.Empty;
}
