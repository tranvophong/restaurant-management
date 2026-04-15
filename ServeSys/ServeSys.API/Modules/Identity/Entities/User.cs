using Microsoft.AspNetCore.Identity;

namespace ServeSys.API.Modules.Identity.Entities;

public class User : IdentityUser
{
    public string FullName { get; set; } = string.Empty;
    public string AvatarUrl { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }
    public ICollection<RefreshToken> RefreshTokens { get; set; } = new List<RefreshToken>();
}
