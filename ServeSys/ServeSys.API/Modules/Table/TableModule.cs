using Microsoft.EntityFrameworkCore;
using ServeSys.API.Modules.Table.Data;
using ServeSys.API.Modules.Table.Interfaces;
using ServeSys.API.Modules.Table.Services;

namespace ServeSys.API.Modules.Table;

public static class TableModule
{
    public static IServiceCollection AddTableModule(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        services.AddDbContext<TableDbContext>(options =>
            options.UseSqlServer(configuration.GetConnectionString("DefaultConnection")));

        // Đăng ký các dịch vụ liên quan đến Table
        services.RegisterTableServices();
        return services;
    }

    public static IServiceCollection RegisterTableServices(this IServiceCollection services)
    {
        services.AddScoped<IAreaService, AreaService>();
        return services;
    }

    public static async Task SeedTableModuleAsync(this WebApplication app)
    {
        using var scope = app.Services.CreateScope();
        var dbContext = scope.ServiceProvider.GetRequiredService<TableDbContext>();
        await TableModuleSeeder.SeedAsync(dbContext);
    }
}
