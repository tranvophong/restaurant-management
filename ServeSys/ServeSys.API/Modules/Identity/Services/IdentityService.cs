using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Identity;
using Microsoft.IdentityModel.Tokens;
using ServeSys.API.Modules.Identity.DTOs;
using ServeSys.API.Modules.Identity.Entities;
using ServeSys.API.Modules.Identity.Interfaces;
using Microsoft.EntityFrameworkCore;
using ServeSys.API.Modules.Identity.Data;
using ServeSys.API.Modules.Identity.Helpers;

namespace ServeSys.API.Modules.Identity.Services
{
    public class IdentityService : IIdentityService
    {
        private readonly UserManager<User> _userManager;
        private readonly JwtTokenHelper _tokenHelper;
        private readonly IConfiguration _configuration;
        private readonly IdentityDbContext _context;

        public IdentityService(UserManager<User> userManager, JwtTokenHelper tokenHelper, IConfiguration configuration, IdentityDbContext context) 
        {
            _userManager = userManager;
            _tokenHelper = tokenHelper;
            _configuration = configuration;
            _context = context;
        }

        /// <summary>
        /// Registers a new user with the provided credentials
        /// </summary>
        public async Task<AuthResult> RegisterAsync(RegisterRequest request)
        {
            var user = new User
            {
                UserName = request.Username,
                Email = request.Email,
                FullName = request.FullName
            };

            var result = await _userManager.CreateAsync(user, request.Password);
            if (!result.Succeeded)
            {
                return new AuthResult
                {
                    Succeeded = false,
                    Errors = result.Errors.Select(e => new AuthError
                    {
                        Code = e.Code,
                        Description = e.Description
                    })
                };
            }

            return new AuthResult { Succeeded = true };
        }

        /// <summary>
        /// Authenticates a user by username and password
        /// </summary>
        public async Task<AuthResult> LoginAsync(LoginRequest request)
        {
            var user = await _userManager.FindByNameAsync(request.Username);
            if (user == null)
            {
                return new AuthResult
                {
                    Succeeded = false,
                    Errors = new[]
                    {
                        new AuthError { Code = "UserNotFound", Description = "Tài khoản không tồn tại." }
                    }
                };
            }

            var isPasswordValid = await _userManager.CheckPasswordAsync(user, request.Password);
            if (!isPasswordValid)
            {
                return new AuthResult
                {
                    Succeeded = false,
                    Errors = new[]
                    {
                        new AuthError { Code = "PasswordMismatch", Description = "Mật khẩu không chính xác." }
                    }
                };
            }

            var jwtResult = _tokenHelper.GenerateJwtToken(user);
            var refreshTokenString = _tokenHelper.GenerateRefreshToken();
            
            var refreshToken = new RefreshToken
            {
                Token = refreshTokenString,
                Expires = _tokenHelper.GetRefreshTokenExpiration(),
                UserId = user.Id,
                CreatedAt = DateTime.UtcNow
            };

            _context.RefreshTokens.Add(refreshToken);
            await _context.SaveChangesAsync();

            return new AuthResult
            {
                Succeeded = true,
                Data = new AuthResponse
                {
                    Token = jwtResult.Token,
                    RefreshToken = refreshToken.Token,
                    Expiration = jwtResult.Expiration,
                    Email = user.Email,
                    FullName = user.FullName
                }
            };
        }

        /// <summary>
        /// Refreshes the JWT and rotates the Refresh Token
        /// </summary>
        public async Task<AuthResult> RefreshTokenAsync(string token)
        {
            var refreshToken = await _context.RefreshTokens
                .Include(rt => rt.User)
                .FirstOrDefaultAsync(rt => rt.Token == token);

            if (refreshToken == null || !refreshToken.IsActive)
            {
                return new AuthResult
                {
                    Succeeded = false,
                    Errors = new[] { new AuthError { Code = "InvalidToken", Description = "Refresh token không hợp lệ hoặc đã hết hạn." } }
                };
            }

            var user = refreshToken.User;
            var jwtResult = _tokenHelper.GenerateJwtToken(user);
            var newRefreshTokenString = _tokenHelper.GenerateRefreshToken();
            
            var newRefreshToken = new RefreshToken
            {
                Token = newRefreshTokenString,
                Expires = _tokenHelper.GetRefreshTokenExpiration(),
                UserId = user.Id,
                CreatedAt = DateTime.UtcNow
            };

            refreshToken.ReplacedByToken = newRefreshToken.Token;
            refreshToken.RevokedAt = DateTime.UtcNow;
            _context.RefreshTokens.Add(newRefreshToken);
            await _context.SaveChangesAsync();

            return new AuthResult
            {
                Succeeded = true,
                Data = new AuthResponse
                {
                    Token = jwtResult.Token,
                    RefreshToken = newRefreshToken.Token,
                    Expiration = jwtResult.Expiration,
                    Email = user.Email,
                    FullName = user.FullName
                }
            };
        }

    }
}
