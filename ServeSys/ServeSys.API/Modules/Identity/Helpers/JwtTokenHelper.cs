using Microsoft.IdentityModel.Tokens;
using ServeSys.API.Modules.Identity.Entities;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Security.Cryptography;

namespace ServeSys.API.Modules.Identity.Helpers
{
    public class JwtTokenHelper
    {
        private readonly IConfiguration _configuration;
        public JwtTokenHelper(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        /// <summary>
        /// Generates a JWT Token for a given user
        /// </summary>
        public (string Token, DateTime Expiration) GenerateJwtToken(User user)
        {
            var jwtKey = _configuration["Jwt:Key"] ?? string.Empty;
            var jwtIssuer = _configuration["Jwt:Issuer"];
            var jwtAudience = _configuration["Jwt:Audience"];

            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, user.Id),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                new Claim(ClaimTypes.NameIdentifier, user.Id),
                new Claim(ClaimTypes.Name, user.FullName ?? string.Empty)
            };


            double minutes = double.TryParse(_configuration["Jwt:JwtTokenExpireMinutes"], out var parsedMinutes) 
                ? parsedMinutes : 120;
            var expiration = DateTime.UtcNow.AddMinutes(minutes);

            var token = new JwtSecurityToken(
                issuer: jwtIssuer,
                audience: jwtAudience,
                claims: claims,
                expires: expiration,
                signingCredentials: credentials);

            var tokenString = new JwtSecurityTokenHandler().WriteToken(token);
            
            return (tokenString, expiration);
        }

        /// <summary>
        /// Generates a cryptographically secure random string for use as a Refresh Token
        /// </summary>
        public string GenerateRefreshToken()
        {
            var randomNumber = new byte[32];
            using var rng = RandomNumberGenerator.Create();
            rng.GetBytes(randomNumber);
            return Convert.ToBase64String(randomNumber);
        }

        public DateTime GetRefreshTokenExpiration()
        {
            double days = double.TryParse(_configuration["Jwt:RefreshTokenExpireDays"], out var parsedDays)
              ? parsedDays : 7;
            return DateTime.UtcNow.AddDays(days);
        }
    }
}
