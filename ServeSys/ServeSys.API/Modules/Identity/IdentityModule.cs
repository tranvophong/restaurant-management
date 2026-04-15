using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using ServeSys.API.Modules.Identity.Data;
using ServeSys.API.Modules.Identity.Entities;
using ServeSys.API.Modules.Identity.Helpers;
using ServeSys.API.Modules.Identity.Interfaces;
using ServeSys.API.Modules.Identity.Services;

namespace ServeSys.API.Modules.Identity;

public static class IdentityModule
{
    public static IServiceCollection AddIdentityModule(this IServiceCollection services, IConfiguration configuration)
    {
        // Cấu hình EF Core DbContext
        services.AddDbContext<IdentityDbContext>(options =>
            options.UseSqlServer(configuration.GetConnectionString("DefaultConnection")));

        // Cấu hình ASP.NET Core Identity
        services.AddIdentityCore<User>(options =>
        {
            // Tùy chỉnh Password
            options.Password.RequireDigit = true;
            options.Password.RequiredLength = 6;
            options.Password.RequireNonAlphanumeric = false;
            options.Password.RequireUppercase = false;
            options.Password.RequireLowercase = false;
        })
        .AddEntityFrameworkStores<IdentityDbContext>();

        // Đăng ký Services
        services.RegisterIdentityServices();

        // 2. Cấu hình JWT Authentication
        var jwtKey = configuration["Jwt:Key"];
        var jwtIssuer = configuration["Jwt:Issuer"];
        var jwtAudience = configuration["Jwt:Audience"];

        services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
            .AddJwtBearer(options =>
            {
                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidateLifetime = true,
                    ValidateIssuerSigningKey = true,
                    ValidIssuer = jwtIssuer,
                    ValidAudience = jwtAudience,
                    IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey ?? string.Empty))
                };
            });

        return services;
    }

    public static IServiceCollection RegisterIdentityServices(this IServiceCollection services)
    {
        services.AddScoped<IIdentityService, IdentityService>();
        services.AddScoped<JwtTokenHelper>();
        return services;
    }
}
