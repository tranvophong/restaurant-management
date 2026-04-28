using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ServeSys.API.Modules.Identity.DTOs;
using ServeSys.API.Modules.Identity.Interfaces;
using ServeSys.API.Modules.Shared.DTOs;
using System.Security.Claims;

namespace ServeSys.API.Modules.Identity.Controllers;

[ApiController]
[Route("api/auth")]
public class AuthController : ControllerBase
{
    private readonly IIdentityService _identityService;

    public AuthController(IIdentityService identityService)
    {
        _identityService = identityService;
    }

    /// <summary>
    /// Authenticates a user and returns a token
    /// </summary>
    [ProducesResponseType(typeof(ApiResponse<AuthResponse>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status400BadRequest)]
    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest request)
    {
        if (!ModelState.IsValid)
            return BadRequest(ApiResponse<object>.Fail("Dữ liệu không hợp lệ", ModelState));
        request.Username = request.Username.Trim();
        request.Password = request.Password.Trim();
        var result = await _identityService.LoginAsync(request);

        if (!result.Succeeded)
            return BadRequest(ApiResponse<object>.Fail("Đăng nhập thất bại", result.Errors));

        return Ok(ApiResponse<AuthResponse>.Ok(result.Data, "Đăng nhập thành công"));
    }

    /// <summary>
    /// Registers a new user account
    /// </summary>
    [ProducesResponseType(typeof(ApiResponse<AuthResponse>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status400BadRequest)]
    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] RegisterRequest request)
    {
        if (!ModelState.IsValid)
            return BadRequest(ApiResponse<object>.Fail("Dữ liệu không hợp lệ", ModelState));

        var result = await _identityService.RegisterAsync(request);

        if (!result.Succeeded)
            return BadRequest(ApiResponse<object>.Fail("Đăng ký thất bại", result.Errors));

        return Ok(ApiResponse<object>.Ok(null, "Đăng ký thành công!"));
    }

    /// <summary>
    /// Refreshes the access token using a refresh token
    /// </summary>
    [ProducesResponseType(typeof(ApiResponse<AuthResponse>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status400BadRequest)]
    [HttpPost("refresh-token")]
    public async Task<IActionResult> RefreshToken([FromBody] RefreshTokenRequest request)
    {
        if (string.IsNullOrEmpty(request.RefreshToken))
            return BadRequest(ApiResponse<object>.Fail("Refresh token không được để trống"));

        var result = await _identityService.RefreshTokenAsync(request.RefreshToken);

        if (!result.Succeeded)
            return Unauthorized(ApiResponse<object>.Fail("Làm mới token thất bại", result.Errors));

        return Ok(ApiResponse<AuthResponse>.Ok(result.Data, "Làm mới token thành công"));
    }

    [HttpGet("logout")]
    [Authorize]
    public async Task<IActionResult> Logout(CancellationToken cancellationToken)
    {
        var userId = User.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?.Value;
        if (userId == null)
            return Ok();

        await _identityService.LogoutAsync(userId, cancellationToken);
        return Ok(ApiResponse<object>.Ok(data: null, "Đăng xuất thành công"));
    }
}
