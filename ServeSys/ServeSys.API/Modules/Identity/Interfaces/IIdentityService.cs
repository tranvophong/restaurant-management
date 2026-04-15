using ServeSys.API.Modules.Identity.DTOs;

namespace ServeSys.API.Modules.Identity.Interfaces;

public interface IIdentityService
{
    /// <summary>
    /// Authenticates a user and returns login result
    /// </summary>
    Task<AuthResult> LoginAsync(LoginRequest request);
    /// <summary>
    /// Registers a new user account
    /// </summary>
    Task<AuthResult> RegisterAsync(RegisterRequest request);
    /// <summary>
    /// Refreshes the JWT token using a refresh token
    /// </summary>
    Task<AuthResult> RefreshTokenAsync(string refreshToken);
}
