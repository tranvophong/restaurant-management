namespace ServeSys.API.Modules.Identity.Entities
{
    public class RefreshToken
    {
        public int Id { get; set; }
        public string Token { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }
        public DateTime Expires { get; set; }
        public string ReplacedByToken { get; set; } = string.Empty;
        public string UserId { get; set; } = string.Empty;
        public DateTime? RevokedAt { get; set; }
        public bool IsExpired => DateTime.UtcNow >= Expires;
        public bool IsRevoked => RevokedAt != null;
        public bool IsActive => !IsExpired && !IsRevoked && string.IsNullOrEmpty(ReplacedByToken);
        public User User { get; set; } = null!;
    }
}
