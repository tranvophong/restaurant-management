using System.ComponentModel.DataAnnotations;

namespace ServeSys.API.Modules.Identity.DTOs;

public class RegisterRequest
{
    [Required]
    [EmailAddress]
    public string Email { get; set; } = string.Empty;

    [Required]
    public string Username { get; set; } = string.Empty;

    [Required]
    public string FullName { get; set; } = string.Empty;

    [Required]
    public string Password { get; set; } = string.Empty;
}
